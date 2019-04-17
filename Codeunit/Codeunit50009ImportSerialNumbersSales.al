codeunit 50009 "Import Serial Number Sales"
{
    procedure ImportSerialNumbers(Rec: Record "Sales Header")
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
                                    if ItemTrackingCode."SN Sales Outbound Tracking" and ItemTrackingCode."SN Purchase Inbound Tracking" then
                                        Error('Import of serial numbers not possible for item %1 on sales order due to item tracking code %2', item."No.", ItemTrackingCode.Code);
                                    if ItemTrackingCode."SN Purchase Inbound Tracking" then
                                        Error('Import of serial numbers not possible for item %1 on sales order due to item tracking code %2', Item."No.", ItemTrackingCode.Code);
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

    Local procedure FindAndUpdateReservationEntries(var TempItemLedgerEntry: record "Item Ledger Entry" temporary; SalesHeader: record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Type", SalesLine.Type::Item);
        if SalesLine.FindSet() then
            repeat
                TempItemLedgerEntry.SetRange("Item No.", SalesLine."No.");
                if TempItemLedgerEntry.FindFirst() then begin
                    Salesline.CalcFields("Reserved Quantity");
                    if (Salesline."Reserved Quantity" <> 0) then
                        UpdateReservationEntries(TempItemLedgerEntry, SalesLine);
                    if TempItemLedgerEntry.Count() > 0 then
                        CreateNewReservationEntries(TempItemLedgerEntry, SalesLine);
                end;
            until SalesLine.next = 0;

        if TempItemLedgerEntry.Count() > 0 then
            Error('There are not enough items to assign all serial numbers')
        else
            Message('All serial numbers imported');
    end;

    local procedure UpdateReservationEntries(var TempItemLedgerEntry: record "Item Ledger Entry" temporary; SalesLine: Record "Sales Line")
    var
        ReservationEntry: record "Reservation Entry";
        SerialNo: code[50];
        ReserveEngineMgt: Codeunit "Reservation Engine Mgt.";
        TempReservationEntry: record "Reservation Entry" temporary;
    begin
        ReservationEntry.SetRange("Item No.", TempItemLedgerEntry."Item No.");
        ReservationEntry.SetRange("Source ID", SalesLine."Document No.");
        ReservationEntry.SetRange("Source Subtype", SalesLine."Document Type");
        ReservationEntry.SetRange("Source Ref. No.", Salesline."Line No.");
        ReservationEntry.SetRange("Reservation Status", ReservationEntry."Reservation Status"::Reservation);
        ReservationEntry.SetRange("Item Tracking", ReservationEntry."Item Tracking"::None);
        ReservationEntry.SetRange(Binding, ReservationEntry.Binding::" ");
        ReservationEntry.SetRange("Serial No.", '');
        ReservationEntry.SetRange(Positive, false); // find kun salgsreservationen
        if ReservationEntry.FindSet() then begin
            repeat
                if ReservationEntry.Quantity = -1 then
                    InsertReservationWithSerialNo(ReservationEntry, TempItemLedgerEntry)
                else begin
                    SplitReservationEntry(ReservationEntry, TempItemLedgerEntry, SalesLine, TempReservationEntry);
                    ReserveEngineMgt.CancelReservation(ReservationEntry);
                    UpdateReservationEntryWithSerialNo(TempReservationEntry, TempItemLedgerEntry);
                end;
            until ReservationEntry.next = 0;
        end;
    end;

    local procedure InsertReservationWithSerialNo(var ReservationEntry: Record "Reservation Entry"; var TempItemLedgerEntry: record "Item Ledger Entry" temporary)
    var
        PositiveReservationEntry: record "Reservation Entry";
    begin
        TempItemLedgerEntry.SetRange("Item No.", ReservationEntry."Item No.");
        TempItemLedgerEntry.FindFirst();
        PositiveReservationEntry.Get(ReservationEntry."Entry No.", not ReservationEntry.Positive);
        if PositiveReservationEntry."Serial No." = '' then begin
            PositiveReservationEntry.Validate("Serial No.", TempItemLedgerEntry."Serial No.");
            PositiveReservationEntry.Validate("Item Tracking", PositiveReservationEntry."Item Tracking"::"Serial No.");
            PositiveReservationEntry.Modify(true);
            ReservationEntry.Validate("Serial No.", TempItemLedgerEntry."Serial No.");
            ReservationEntry.Validate("Item Tracking", ReservationEntry."Item Tracking"::"Serial No.");
            ReservationEntry.Modify(true);
            TempItemLedgerEntry.Delete();
        end;
    end;

    local procedure SplitReservationEntry(var ReservationEntry: Record "Reservation Entry"; var TempItemLedgerEntry: record "Item Ledger Entry" temporary; SalesLine: record "Sales Line"; var TempReservationEntry: record "Reservation Entry")
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
        for Counter := 1 to OppositeReservationEntry.Quantity do begin
            EntryNo := EntryNo + 1;
            InsertTempReservationEntry(OppositeReservationEntry, TempReservationEntry, 1, EntryNo);
            InsertTempReservationEntry(ReservationEntry, TempReservationEntry, -1, EntryNo);
        end;
    end;

    local procedure InsertTempReservationEntry(ReservationEntry: record "Reservation Entry"; var TempReservationEntry: Record "Reservation Entry" temporary; NewQuantity: Decimal; NewEntryNo: Integer)
    var
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
        Test: integer;
        CopyEntryNo: integer;
    begin
        Counter := 1;
        Test := TempReservationEntry.Count();
        if TempReservationEntry.FindSet() then
            repeat
                if Counter mod 2 <> 0 then begin
                    TempItemLedgerEntry.SetRange("Item No.", TempReservationEntry."Item No.");
                    TempItemLedgerEntry.FindFirst();
                end;
                ReservationEntry := TempReservationEntry;
                ReservationEntry.Validate("Serial No.", TempItemLedgerEntry."Serial No.");
                ReservationEntry.Validate("Item Tracking", ReservationEntry."Item Tracking"::"Serial No.");
                if not ReservationEntry.Insert(true) then begin
                    EntryNo := GetLastReservationEntryNo();
                    ReservationEntry."Entry No." := EntryNo + 1;
                    ReservationEntry.Insert(true);
                    ReservationEntry."Entry No." := CopyEntryNo;
                    if ReservationEntry.get(ReservationEntry."Entry No.", not ReservationEntry.Positive) then begin
                        ReservationEntry."Entry No." := CopyEntryNo;
                        ReservationEntry.Modify(true);
                    end;
                end else begin
                    ReservationEntry."Entry No." := CopyEntryNo;
                    if ReservationEntry.get(ReservationEntry."Entry No.", not ReservationEntry.Positive) then begin
                        ReservationEntry."Entry No." := CopyEntryNo;
                        ReservationEntry.Modify(true);
                    end;
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

    Local procedure CreateNewReservationEntries(var TempItemLedgerEntry: record "Item Ledger Entry" temporary; SalesLine: record "Sales Line")
    var
        ReservationEntry: record "Reservation Entry";
        Counter: Integer;
        loop: integer;
    begin
        ReservationEntry.SetRange("Item No.", TempItemLedgerEntry."Item No.");
        ReservationEntry.SetRange("Source ID", SalesLine."Document No.");
        ReservationEntry.SetRange("Source Ref. No.", SalesLine."Line No.");
        ReservationEntry.SetRange("Source Subtype", SalesLine."Document Type");
        ReservationEntry.SetRange("Source Ref. No.", Salesline."Line No.");
        if ReservationEntry.FindSet() then
            repeat
                Counter := Counter + 1;
            until ReservationEntry.next = 0;

        if Counter = SalesLine.Quantity then
            exit;
        if Counter = 0 then begin
            Counter := 1;
            loop := salesLine.Quantity + 1;
        end else
            loop := salesLine.Quantity;

        TempItemLedgerEntry.SetRange("Item No.", SalesLine."No.");
        if TempItemLedgerEntry.FindSet() then
            repeat
                if Counter mod loop <> 0 then begin
                    InsertReservationEntrySurplusFromSalesLine(SalesLine, TempItemLedgerEntry."Serial No.");
                    if not ReservationEntry.Insert(true) then begin
                        ReservationEntry."Entry No." := GetLastReservationEntryNo() + 1;
                        ReservationEntry.Insert(true);
                    end;
                    TempItemLedgerEntry.Delete();
                    Counter := Counter + 1;
                end;
            until TempItemLedgerEntry.next = 0;
    end;

    procedure InsertReservationEntrySurplusFromSalesLine(SalesLine: record "Sales Line"; SerialNo: code[50])
    var
        ReservationEntry: record "Reservation Entry";
    begin
        ReservationEntry.Init;
        ReservationEntry.Validate("Entry No.", GetLastReservationEntryNo() + 1);
        ReservationEntry.Validate("Item No.", SalesLine."No.");
        ReservationEntry.Validate("Location Code", SalesLine."Location Code");
        ReservationEntry.Validate("Quantity (Base)", -1);
        ReservationEntry.Validate("Serial No.", SerialNo);
        ReservationEntry.Validate("Reservation Status", ReservationEntry."Reservation Status"::Surplus);
        ReservationEntry.Validate("Source Type", 37);
        ReservationEntry.Validate("Source Subtype", SalesLine."Document Type");
        ReservationEntry.Validate("Source ID", SalesLine."Document No.");
        ReservationEntry.Validate("Source Ref. No.", SalesLine."Line No.");
        ReservationEntry.Validate("Shipment Date", SalesLine."Shipment Date");
        ReservationEntry.Validate("Created By", UserId());
        ReservationEntry.Validate("Creation Date", WorkDate());
        ReservationEntry.Validate("Item Tracking", ReservationEntry."Item Tracking"::"Serial No.");
        if not ReservationEntry.Insert(true) then begin
            ReservationEntry."Entry No." := GetLastReservationEntryNo() + 1;
            ReservationEntry.Insert(true);
        end;
    end;
}