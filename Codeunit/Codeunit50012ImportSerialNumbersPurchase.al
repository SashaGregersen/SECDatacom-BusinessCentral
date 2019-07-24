codeunit 50012 "Import Serial Number Purchase"
{
    procedure ImportSerialNumbers(Rec: Record "Purchase Header")
    var
        TempCSVBuffer: record "CSV Buffer" temporary;
        FileMgtImport: codeunit "File Management Import";
        TempItemLedgerEntry: record "Item Ledger Entry" temporary;
    begin
        TempCSVBuffer.init;
        FileMgtImport.SelectFileFromFileShare(TempCSVBuffer);
        InsertTempItemLedgerEntries(TempCSVBuffer, TempItemLedgerEntry);
        FindAndUpdateReservationEntries(TempItemLedgerEntry, Rec);
    end;

    local procedure InsertTempItemLedgerEntries(var TempCSVBuffer: record "CSV Buffer"; var TempItemLedgerEntry: record "Item Ledger Entry" temporary)
    var
        SalesLine: record "Sales Line";
        Item: record item;
        VendorNo: code[20];
        ItemLedgerEntry: record "Item Ledger Entry";
        EntryNo: integer;
        ItemNo: code[20];
        ItemTrackingCode: record "Item Tracking Code";
    begin
        TempCSVBuffer.SetFilter("Line No.", '<>%1', 1);
        if TempCSVBuffer.FindSet() then
            repeat
                case TempCSVBuffer."Field No." of
                    1:
                        begin
                            if TempCSVBuffer.Value <> '' then
                                VendorNo := TempCSVBuffer.Value
                            else
                                Error('Vendor No. is missing in line %1', TempCSVBuffer."Line No.");
                        end;
                    2:
                        begin
                            if TempCSVBuffer.value <> '' then begin
                                Item.SetRange("Vendor No.", VendorNo);
                                Item.SetRange("Vendor-Item-No.", TempCSVBuffer.Value);
                                if Item.FindFirst() then begin
                                    ItemTrackingCode.Get(Item."Item Tracking Code");
                                    if not ItemTrackingCode."SN Purchase Inbound Tracking" then
                                        Error('Import of serial numbers not possible for item %1 on sales order due to item tracking code %2', item."No.", ItemTrackingCode.Code);
                                    ItemNo := Item."No.";
                                end else
                                    Error('The item %1 does not exists as a vendor item no. or vendor no is incorrect', TempCSVBuffer.Value);
                            end else
                                Error('Vendor Item No. is missing in line %1', TempCSVBuffer."Line No.");
                        end;
                    3:
                        begin
                            if TempCSVBuffer.value <> '' then begin
                                if TempItemLedgerEntry.Findlast() then
                                    EntryNo := TempItemLedgerEntry."Entry No." + 1
                                else
                                    EntryNo := 1;
                                TempItemLedgerEntry.Init;
                                TempItemLedgerEntry.Validate("Entry No.", EntryNo);
                                TempItemLedgerEntry.Validate("Item No.", Item."No.");
                                TempItemLedgerEntry.Validate("Serial No.", TempCSVBuffer.Value);
                                TempItemLedgerEntry.Insert(true);
                            end else
                                Error('Serial no. is missing in line no. %1', TempCSVBuffer."Line No.");
                        end;
                end;

            until TempCSVBuffer.next = 0;
    end;

    Local procedure FindAndUpdateReservationEntries(var TempItemLedgerEntry: record "Item Ledger Entry" temporary; PurchHeader: record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.SetRange("Document No.", PurchHeader."No.");
        PurchaseLine.SetRange("Document Type", PurchHeader."Document Type");
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        if PurchaseLine.FindSet() then
            repeat
                TempItemLedgerEntry.SetRange("Item No.", PurchaseLine."No.");
                if TempItemLedgerEntry.FindFirst() then begin
                    Purchaseline.CalcFields("Reserved Quantity");
                    if (Purchaseline."Reserved Quantity" <> 0) then
                        UpdateReservationEntries(TempItemLedgerEntry, PurchaseLine);
                    if TempItemLedgerEntry.Count() > 0 then
                        CreateNewReservationEntries(TempItemLedgerEntry, PurchaseLine);
                end;
            until PurchaseLine.next = 0;

        if TempItemLedgerEntry.Count() > 0 then
            Error('There are not enough items to assign all serial numbers')
        else
            Message('All serial numbers imported');
    end;

    procedure UpdateReservationEntries(var TempItemLedgerEntry: record "Item Ledger Entry" temporary; PurchLine: Record "Purchase Line")
    var
        ReservationEntry: record "Reservation Entry";
        SerialNo: code[50];
        ReserveEngineMgt: Codeunit "Reservation Engine Mgt.";
        TempReservationEntry: record "Reservation Entry" temporary;
    begin
        ReservationEntry.SetRange("Item No.", TempItemLedgerEntry."Item No.");
        ReservationEntry.SetRange("Source ID", PurchLine."Document No.");
        ReservationEntry.SetRange("Source Subtype", PurchLine."Document Type");
        ReservationEntry.SetRange("Source Ref. No.", Purchline."Line No.");
        ReservationEntry.SetRange("Reservation Status", ReservationEntry."Reservation Status"::Reservation);
        ReservationEntry.SetRange("Item Tracking", ReservationEntry."Item Tracking"::None);
        ReservationEntry.SetRange(Binding, ReservationEntry.Binding::" ");
        ReservationEntry.SetRange("Serial No.", '');
        ReservationEntry.SetRange(Positive, true); // find kun købsreservationen
        if ReservationEntry.FindSet() then begin
            repeat
                if ReservationEntry.Quantity = 1 then
                    InsertReservationWithSerialNo(ReservationEntry, TempItemLedgerEntry)
                else begin
                    SplitReservationEntry(ReservationEntry, TempItemLedgerEntry, PurchLine, TempReservationEntry);
                    ReserveEngineMgt.CancelReservation(ReservationEntry);
                    UpdateReservationEntryWithSerialNo(TempReservationEntry, TempItemLedgerEntry);
                end;
            until ReservationEntry.next = 0;
        end;
    end;

    local procedure InsertReservationWithSerialNo(var ReservationEntry: Record "Reservation Entry"; var TempItemLedgerEntry: record "Item Ledger Entry" temporary)
    var
        NegativeReservationEntry: record "Reservation Entry";
    begin
        TempItemLedgerEntry.SetRange("Item No.", ReservationEntry."Item No.");
        if TempItemLedgerEntry.FindFirst() then begin
            NegativeReservationEntry.Get(ReservationEntry."Entry No.", Not ReservationEntry.Positive);
            if NegativeReservationEntry."Serial No." = '' then begin
                NegativeReservationEntry.Validate("Serial No.", TempItemLedgerEntry."Serial No.");
                NegativeReservationEntry.Validate("Item Tracking", NegativeReservationEntry."Item Tracking"::"Serial No.");
                NegativeReservationEntry.Modify(true);
                ReservationEntry.Validate("Serial No.", TempItemLedgerEntry."Serial No.");
                ReservationEntry.Validate("Item Tracking", ReservationEntry."Item Tracking"::"Serial No.");
                ReservationEntry.Modify(true);

                TempItemLedgerEntry.Delete();
            end;
        end;
    end;

    local procedure SplitReservationEntry(var ReservationEntry: Record "Reservation Entry"; var TempItemLedgerEntry: record "Item Ledger Entry" temporary; PurchLine: record "Purchase Line"; var TempReservationEntry: record "Reservation Entry")
    var
        OppositeReservationEntry: record "Reservation Entry";
        EntryNo: integer;
        Counter: Integer;
    begin
        if ReservationEntry."Serial No." <> '' then
            exit;
        if not OppositeReservationEntry.Get(ReservationEntry."Entry No.", not ReservationEntry.Positive) then
            exit;
        EntryNo := GetLastReservationEntryNo();
        for Counter := 1 to ReservationEntry.Quantity do begin
            EntryNo := EntryNo + 1;
            InsertTempReservationEntry(ReservationEntry, TempReservationEntry, 1, EntryNo);
            InsertTempReservationEntry(OppositeReservationEntry, TempReservationEntry, -1, EntryNo);
        end;
    end;

    local procedure InsertTempReservationEntry(ReservationEntry: record "Reservation Entry"; var TempReservationEntry: Record "Reservation Entry" temporary; NewQuantity: Decimal; NewEntryNo: Integer)
    begin
        TempReservationEntry.Init;
        TempReservationEntry.TransferFields(ReservationEntry);
        TempReservationEntry."Entry No." := NewEntryNo;
        TempReservationEntry.Validate("Quantity (Base)", NewQuantity);
        TempReservationEntry.Insert(true);
    end;

    local procedure UpdateReservationEntryWithSerialNo(var TempReservationEntry: record "Reservation Entry" temporary; var TempItemLedgerEntry: record "Item Ledger Entry" temporary)
    var
        ReservationEntry: record "Reservation Entry";
        Counter: Integer;
        EntryNo: Integer;
    begin
        Counter := 1;
        if TempReservationEntry.FindSet() then
            repeat
                if Counter mod 2 <> 0 then begin
                    TempItemLedgerEntry.SetRange("Item No.", TempReservationEntry."Item No.");
                    //TempItemLedgerEntry.FindFirst() //SDG 24-7-19
                    //>>NC.00.01 SDG 24-7-19
                    if not TempItemLedgerEntry.FindFirst() then begin
                        if TempReservationEntry.FindSet() then
                            repeat
                                ReservationEntry := TempReservationEntry;
                                ReservationEntry.Validate("Serial No.", '');
                                ReservationEntry.Validate("Item Tracking", ReservationEntry."Item Tracking"::None);
                                if not ReservationEntry.Insert(true) then begin
                                    EntryNo := GetLastReservationEntryNo();
                                    ReservationEntry."Entry No." := EntryNo + 1;
                                    ReservationEntry.Insert(true);
                                    TempReservationEntry.Delete();
                                    counter := counter + 1;
                                end;
                                TempReservationEntry.Delete();
                                counter := counter + 1;
                            until TempReservationEntry.next = 0;
                        exit;
                    end;
                    //<<NC.00.01 SDG 24-7-19
                end;
                ReservationEntry := TempReservationEntry;
                ReservationEntry.Validate("Serial No.", TempItemLedgerEntry."Serial No.");
                ReservationEntry.Validate("Item Tracking", ReservationEntry."Item Tracking"::"Serial No.");
                if not ReservationEntry.Insert(true) then begin
                    EntryNo := GetLastReservationEntryNo();
                    ReservationEntry."Entry No." := EntryNo + 1;
                    ReservationEntry.Insert(true);
                end;
                if Counter mod 2 = 0 then
                    TempItemLedgerEntry.Delete();
                TempReservationEntry.Delete();
                counter := counter + 1;
            until TempReservationEntry.next = 0;
    end;

    local procedure GetLastReservationEntryNo(): Integer;
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        If not ReservationEntry.FindLast() then
            exit(1)
        else
            exit(ReservationEntry."Entry No.")
    end;

    Local procedure CreateNewReservationEntries(var TempItemLedgerEntry: record "Item Ledger Entry" temporary; PurchLine: record "Purchase Line")
    var
        ReservationEntry: record "Reservation Entry";
        Counter: Integer;
        loop: Integer;
    begin
        ReservationEntry.SetRange("Item No.", TempItemLedgerEntry."Item No.");
        ReservationEntry.SetRange("Source ID", PurchLine."Document No.");
        ReservationEntry.SetRange("Source Ref. No.", PurchLine."Line No.");
        ReservationEntry.SetRange("Source Subtype", PurchLine."Document Type");
        ReservationEntry.SetRange("Source Ref. No.", Purchline."Line No.");
        if ReservationEntry.FindSet() then
            repeat
                Counter := Counter + 1;
            until ReservationEntry.next = 0;

        if Counter = PurchLine.Quantity then
            exit;
        if Counter = 0 then begin
            Counter := 1;
            loop := PurchLine.Quantity + 1;
        end else
            loop := PurchLine.Quantity;
        TempItemLedgerEntry.SetRange("Item No.", PurchLine."No.");
        if TempItemLedgerEntry.FindSet() then
            repeat
                if Counter mod loop <> 0 then begin
                    InsertReservationEntrySurplusFromPurchLine(PurchLine, TempItemLedgerEntry."Serial No.");
                    TempItemLedgerEntry.Delete();
                    Counter := Counter + 1;
                end;
            until TempItemLedgerEntry.next = 0;
    end;

    procedure InsertReservationEntrySurplusFromPurchLine(PurchLine: record "Purchase Line"; SerialNo: code[50])
    var
        ReservationEntry: record "Reservation Entry";

    begin
        ReservationEntry.Init;
        ReservationEntry.Validate("Entry No.", GetLastReservationEntryNo() + 1);
        ReservationEntry.Validate("Item No.", PurchLine."No.");
        ReservationEntry.Validate("Location Code", PurchLine."Location Code");
        ReservationEntry.Validate("Quantity (Base)", 1);
        ReservationEntry.Validate("Serial No.", SerialNo);
        ReservationEntry.Validate("Reservation Status", ReservationEntry."Reservation Status"::Surplus);
        ReservationEntry.Validate("Source Type", 39);
        ReservationEntry.Validate("Source Subtype", PurchLine."Document Type");
        ReservationEntry.Validate("Source ID", PurchLine."Document No.");
        ReservationEntry.Validate("Source Ref. No.", PurchLine."Line No.");
        ReservationEntry.Validate("Shipment Date", PurchLine."Expected Receipt Date");
        ReservationEntry.Validate("Created By", UserId());
        ReservationEntry.Validate("Creation Date", WorkDate());
        ReservationEntry.Validate("Item Tracking", ReservationEntry."Item Tracking"::"Serial No.");
        if not ReservationEntry.Insert(true) then begin
            ReservationEntry."Entry No." := GetLastReservationEntryNo() + 1;
            ReservationEntry.Insert(true);
        end;
    end;
}