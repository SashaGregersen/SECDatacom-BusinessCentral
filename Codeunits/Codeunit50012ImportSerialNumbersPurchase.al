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
        if TempItemLedgerEntry.FindSet() then
            repeat
                PurchaseLine.SetRange("Document No.", PurchHeader."No.");
                PurchaseLine.SetRange("Document Type", PurchHeader."Document Type");
                PurchaseLine.SetRange("No.", TempItemLedgerEntry."Item No.");
                if PurchaseLine.FindSet() then
                    repeat
                        if TempItemLedgerEntry.Get(TempItemLedgerEntry."Entry No.") then begin
                            Purchaseline.CalcFields("Reserved Quantity");
                            if (Purchaseline."Reserved Quantity" <> 0) then
                                FindReservationEntries(TempItemLedgerEntry, PurchaseLine);
                        end;
                    until PurchaseLine.next = 0;

            until TempItemLedgerEntry.next = 0;

        if TempItemLedgerEntry.Count() > 0 then
            Error('There are not enough items to assign all serial numbers')
        else
            Message('All serial numbers imported');
    end;

    local procedure FindReservationEntries(var TempItemLedgerEntry: record "Item Ledger Entry" temporary; PurchLine: Record "Purchase Line")
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
                if TempItemLedgerEntry.Get(TempItemLedgerEntry."Entry No.") then begin
                    if ReservationEntry.Quantity = 1 then
                        InsertReservationWithSerialNo(ReservationEntry, TempItemLedgerEntry)
                    else begin
                        SplitReservationEntry(ReservationEntry, TempItemLedgerEntry, PurchLine, TempReservationEntry);
                        ReserveEngineMgt.CancelReservation(ReservationEntry);
                        UpdateReservationEntryWithSerialNo(TempReservationEntry, TempItemLedgerEntry);
                    end;
                end;
            until ReservationEntry.next = 0;
        end;
    end;

    local procedure InsertReservationWithSerialNo(var ReservationEntry: Record "Reservation Entry"; var TempItemLedgerEntry: record "Item Ledger Entry" temporary)
    var
        NegativeReservationEntry: record "Reservation Entry";
    begin
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

    local procedure SplitReservationEntry(var ReservationEntry: Record "Reservation Entry"; var TempItemLedgerEntry: record "Item Ledger Entry" temporary; PurchLine: record "Purchase Line"; var TempReservationEntry: record "Reservation Entry")
    var
        NumberOfLoops: integer;
        ReserveEngineMgt: Codeunit "Reservation Engine Mgt.";
        NewReservationEntry: record "Reservation Entry";
        EntryNo: integer;
        LastReservationEntry: record "Reservation Entry";
    begin
        if ReservationEntry."Serial No." = '' then begin
            if (NumberOfLoops < ReservationEntry.Quantity) and (NumberOfLoops <> ReservationEntry.Quantity) then
                repeat
                    EntryNo := 0;
                    LastReservationEntry.FindLast();
                    EntryNo := LastReservationEntry."Entry No." + 1;
                    NewReservationEntry.Init;
                    NewReservationEntry.Validate("Entry No.", EntryNo);
                    NewReservationEntry.TransferFields(ReservationEntry, false);
                    NewReservationEntry.Validate(Positive, true);
                    NewReservationEntry.Validate("Quantity (Base)", 1);
                    NewReservationEntry.Insert(true);
                    InsertTempReserEntry(NewReservationEntry, TempReservationEntry);
                    if ReservationEntry.Get(ReservationEntry."Entry No.", not ReservationEntry.Positive) then begin
                        NewReservationEntry.Init;
                        NewReservationEntry.Validate("Entry No.", EntryNo);
                        NewReservationEntry.TransferFields(ReservationEntry, false);
                        NewReservationEntry.Validate(Positive, false);
                        NewReservationEntry.Validate("Quantity (Base)", -1);
                        NewReservationEntry.Insert(true);
                        InsertTempReserEntry(NewReservationEntry, TempReservationEntry);
                        NumberOfLoops := NumberOfLoops + 1;
                    end;
                until NumberOfLoops = ReservationEntry.Quantity;
        end;
    end;

    local procedure InsertTempReserEntry(ReservationEntry: record "Reservation Entry"; var TempReservationEntry: Record "Reservation Entry" temporary)
    var
    begin
        TempReservationEntry.Init;
        TempReservationEntry.TransferFields(ReservationEntry);
        TempReservationEntry.Insert(true);
    end;

    local procedure UpdateReservationEntryWithSerialNo(var TempReservationEntry: record "Reservation Entry" temporary; var TempItemLedgerEntry: record "Item Ledger Entry" temporary)
    var
        ReservationEntry: record "Reservation Entry";
    begin
        if TempReservationEntry.Get(TempReservationEntry."Entry No.", TempReservationEntry.Positive) then begin
            ReservationEntry.SetRange("Entry No.", TempReservationEntry."Entry No.");
            if ReservationEntry.FindFirst() then begin
                ReservationEntry.Validate("Serial No.", TempItemLedgerEntry."Serial No.");
                ReservationEntry.Validate("Item Tracking", ReservationEntry."Item Tracking"::"Serial No.");
                ReservationEntry.Modify(true);

                if TempReservationEntry.Get(TempReservationEntry."Entry No.", not TempReservationEntry.Positive) then begin
                    ReservationEntry.SetRange("Entry No.", TempReservationEntry."Entry No.");
                    if ReservationEntry.FindFirst() then begin
                        ReservationEntry.Validate("Serial No.", TempItemLedgerEntry."Serial No.");
                        ReservationEntry.Validate("Item Tracking", ReservationEntry."Item Tracking"::"Serial No.");
                        ReservationEntry.Modify(true);

                        TempItemLedgerEntry.Delete();
                    end;
                end;

            end;

        end;
    end;
}