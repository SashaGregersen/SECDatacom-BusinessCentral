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
        if TempItemLedgerEntry.FindSet() then
            repeat
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                SalesLine.SetRange("No.", TempItemLedgerEntry."Item No.");
                if SalesLine.FindSet() then
                    repeat
                        if TempItemLedgerEntry.Get(TempItemLedgerEntry."Entry No.") then begin
                            Salesline.CalcFields("Reserved Quantity");
                            if (Salesline."Reserved Quantity" <> 0) then
                                FindReservationEntries(TempItemLedgerEntry, SalesLine);
                        end;
                    until SalesLine.next = 0;

            until TempItemLedgerEntry.next = 0;

        if TempItemLedgerEntry.Count() > 0 then
            Error('There are not enough items to assign all serial numbers')
        else
            Message('All serial numbers imported');
    end;

    local procedure FindReservationEntries(var TempItemLedgerEntry: record "Item Ledger Entry" temporary; SalesLine: Record "Sales Line")
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
                if TempItemLedgerEntry.Get(TempItemLedgerEntry."Entry No.") then begin
                    if ReservationEntry.Quantity = -1 then
                        InsertReservationWithSerialNo(ReservationEntry, TempItemLedgerEntry)
                    else begin
                        SplitReservationEntry(ReservationEntry, TempItemLedgerEntry, SalesLine, TempReservationEntry);
                        ReserveEngineMgt.CancelReservation(ReservationEntry);
                        UpdateReservationEntryWithSerialNo(TempReservationEntry, TempItemLedgerEntry);
                    end;
                end;
            until ReservationEntry.next = 0;
        end;
    end;

    local procedure InsertReservationWithSerialNo(var ReservationEntry: Record "Reservation Entry"; var TempItemLedgerEntry: record "Item Ledger Entry" temporary)
    var
        PositiveReservationEntry: record "Reservation Entry";
    begin
        PositiveReservationEntry.Get(ReservationEntry."Entry No.", Not ReservationEntry.Positive);
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
        NumberOfLoops: integer;
        ReserveEngineMgt: Codeunit "Reservation Engine Mgt.";
        NewReservationEntry: record "Reservation Entry";
        EntryNo: integer;
        LastReservationEntry: record "Reservation Entry";
        PositiveReservationEntry: record "Reservation Entry";
    begin
        PositiveReservationEntry.Get(ReservationEntry."Entry No.", Not ReservationEntry.Positive);
        if PositiveReservationEntry."Serial No." = '' then begin
            if (NumberOfLoops < PositiveReservationEntry.Quantity) and (NumberOfLoops <> PositiveReservationEntry.Quantity) then
                repeat
                    EntryNo := 0;
                    LastReservationEntry.FindLast();
                    EntryNo := LastReservationEntry."Entry No." + 1;
                    NewReservationEntry.Init;
                    NewReservationEntry.Validate("Entry No.", EntryNo);
                    NewReservationEntry.TransferFields(PositiveReservationEntry, false);
                    NewReservationEntry.Validate(Positive, true);
                    NewReservationEntry.Validate("Quantity (Base)", 1);
                    NewReservationEntry.Insert(true);
                    InsertTempReserEntry(NewReservationEntry, TempReservationEntry);
                    NewReservationEntry.Init;
                    NewReservationEntry.Validate("Entry No.", EntryNo);
                    NewReservationEntry.TransferFields(ReservationEntry, false);
                    NewReservationEntry.Validate(Positive, false);
                    NewReservationEntry.Validate("Quantity (Base)", -1);
                    NewReservationEntry.Insert(true);
                    InsertTempReserEntry(NewReservationEntry, TempReservationEntry);
                    NumberOfLoops := NumberOfLoops + 1;
                until NumberOfLoops = PositiveReservationEntry.Quantity;
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