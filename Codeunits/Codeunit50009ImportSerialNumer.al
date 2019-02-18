codeunit 50009 "Import Serial Number"
{
    procedure ImportSerialNumbers(Rec: Record "Sales Header")
    var
        TempCSVBuffer: record "CSV Buffer" temporary;
        FileMgtImport: codeunit "File Management Import";
    begin
        TempCSVBuffer.init;
        FileMgtImport.SelectFileFromFileShare(TempCSVBuffer);
        FindReservEntryToUpdateWithSerialNo(Rec, TempCSVBuffer);
    end;

    local procedure FindReservEntryToUpdateWithSerialNo(Rec: record "Sales Header"; TempCSVBuffer: record "CSV Buffer")
    var
        SalesLine: record "Sales Line";
        Item: Record item;
        VendorNo: code[20];
        TempItemLedgerEntry: record "Item Ledger Entry" temporary;
        ItemLedgerEntry: record "Item Ledger Entry";
        EntryNo: integer;
        ItemNo: code[20];
    begin
        //insert temp item ledger entry 
        //loop salgslinjer med vare nr fra item ledger entry      

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
                                    ItemNo := Item."No.";

                                end else
                                    Error('The item %1 does not exists as a vendor item no. or vendor no is incorrect', TempCSVBuffer.Value);
                            end else
                                Error('Vendor Item No. is missing in line %1', TempCSVBuffer."Line No.");
                        end;
                    3:
                        begin
                            if TempCSVBuffer.value <> '' then begin
                                ItemLedgerEntry.Findlast();
                                EntryNo := ItemLedgerEntry."Entry No." + 1;
                                TempItemLedgerEntry.Init;
                                TempItemLedgerEntry.Validate("Entry No.", EntryNo);
                                TempItemLedgerEntry.Validate("Item No.", Item."No.");
                                TempItemLedgerEntry.Validate("Serial No.", TempCSVBuffer.Value);
                                TempItemLedgerEntry.Insert(true);
                            end else
                                Error('Serial No. is missing in line no. %1', TempCSVBuffer."Line No.");
                        end;
                end;

            until TempCSVBuffer.next = 0;


        if TempItemLedgerEntry.FindSet() then
            repeat
                SalesLine.SetRange("Document No.", rec."No.");
                SalesLine.SetRange("Document Type", rec."Document Type");
                SalesLine.SetRange("No.", TempItemLedgerEntry."Item No.");
                if SalesLine.FindSet() then
                    repeat
                        Salesline.CalcFields("Reserved Quantity");
                        if (Salesline."Reserved Quantity" <> 0) then
                            FindReservationEntries(TempCSVBuffer, SalesLine, Item);
                    until SalesLine.next = 0;
            until TempItemLedgerEntry.next = 0;
    end;

    local procedure FindReservationEntries(TempCSVBuffer: record "CSV Buffer" temporary; SalesLine: Record "Sales Line"; Item: Record Item)
    var
        ReservationEntry: record "Reservation Entry";
        SerialNo: code[50];
        ReserveEngineMgt: Codeunit "Reservation Engine Mgt.";
        TempReservationEntry: record "Reservation Entry" temporary;
    begin
        ReservationEntry.SetRange("Item No.", Item."No.");
        ReservationEntry.SetRange("Source ID", SalesLine."Document No.");
        ReservationEntry.SetRange("Source Subtype", SalesLine."Document Type");
        ReservationEntry.SetRange("Source Ref. No.", Salesline."Line No.");
        ReservationEntry.SetRange("Reservation Status", ReservationEntry."Reservation Status"::Reservation);
        ReservationEntry.SetRange("Item Tracking", ReservationEntry."Item Tracking"::None);
        ReservationEntry.SetRange(Binding, ReservationEntry.Binding::" ");
        ReservationEntry.SetRange("Serial No.", '');
        ReservationEntry.SetRange(Positive, true);
        if ReservationEntry.FindSet() then begin
            repeat
                if ReservationEntry.Quantity = 1 then begin
                    InsertReservationWithSerialNo(ReservationEntry, TempCSVBuffer);
                    ReserveEngineMgt.CancelReservation(ReservationEntry);
                end else begin
                    SplitReservationEntry(ReservationEntry, TempCSVBuffer, SalesLine, TempReservationEntry);
                    ReserveEngineMgt.CancelReservation(ReservationEntry);
                    UpdateReservationEntryWithSerialNo(TempReservationEntry, TempCSVBuffer);

                    /* TempReservationEntry.init;
                    TempReservationEntry.TransferFields(ReservationEntry);
                    TempReservationEntry.Insert(true); */
                end;
            until ReservationEntry.next = 0;

            /* if TempReservationEntry.Count() > 0 then
                SplitReservationEntry(TempReservationEntry, TempCSVBuffer, SalesLine); */
        end;
    end;

    local procedure InsertReservationWithSerialNo(var ReservationEntry: Record "Reservation Entry"; TempCSVBuffer: record "CSV Buffer")
    var
        EntryNo: integer;
        LastReservationEntry: record "Reservation Entry";
    begin
        case TempCSVBuffer."Field No." of
            3:
                begin
                    if TempCSVBuffer.value <> '' then begin
                        ReservationEntry.Validate("Serial No.", TempCSVBuffer.Value);
                        ReservationEntry.Modify(true);
                        ReservationEntry.SetRange(Positive, false);
                        if ReservationEntry.FindFirst() then begin
                            ReservationEntry.Validate("Serial No.", TempCSVBuffer.Value);
                            ReservationEntry.Modify(true);
                        end;
                    end;
                end;
        end;
    end;

    local procedure SplitReservationEntry(var ReservationEntry: Record "Reservation Entry"; TempCSVBuffer: record "CSV Buffer"; SalesLine: record "Sales Line"; var TempReservationEntry: record "Reservation Entry")
    var
        NumberOfLoops: integer;
        ReserveEngineMgt: Codeunit "Reservation Engine Mgt.";
        NewReservationEntry: record "Reservation Entry";
        EntryNo: integer;
        LastReservationEntry: record "Reservation Entry";
    begin
        if NumberOfLoops < SalesLine."Reserved Quantity" then
            repeat
                EntryNo := 0;
                LastReservationEntry.FindLast();
                EntryNo := ReservationEntry."Entry No." + 1;
                NewReservationEntry.Init;
                NewReservationEntry.Validate("Entry No.", EntryNo);
                NewReservationEntry.TransferFields(ReservationEntry);
                NewReservationEntry.Validate(Quantity, 1);
                NewReservationEntry.Insert(true);
                InsertTempReserEntry(NewReservationEntry, TempReservationEntry);
                ReservationEntry.SetRange(Positive, false);
                if ReservationEntry.FindFirst() then begin
                    EntryNo := 0;
                    LastReservationEntry.FindLast();
                    EntryNo := ReservationEntry."Entry No." + 1;
                    NewReservationEntry.Init;
                    NewReservationEntry.Validate("Entry No.", EntryNo);
                    NewReservationEntry.TransferFields(ReservationEntry);
                    NewReservationEntry.Validate(Quantity, -1);
                    NewReservationEntry.Insert(true);
                    InsertTempReserEntry(NewReservationEntry, TempReservationEntry);
                end;
                NumberOfLoops := NumberOfLoops + 1;
            until NumberOfLoops = SalesLine.Quantity;
    end;

    local procedure InsertTempReserEntry(ReservationEntry: record "Reservation Entry"; var TempReservationEntry: Record "Reservation Entry" temporary)
    var
    begin
        TempReservationEntry.Init;
        TempReservationEntry.TransferFields(ReservationEntry);
        TempReservationEntry.Insert(true);
    end;

    local procedure UpdateReservationEntryWithSerialNo(TempReservationEntry: record "Reservation Entry" temporary; TempCSVBuffer: record "CSV Buffer" temporary)
    var
        ReservationEntry: record "Reservation Entry";
    begin
        TempReservationEntry.SetRange("Serial No.", '');
        if TempReservationEntry.FindFirst() then begin
            ReservationEntry.SetRange("Entry No.", TempReservationEntry."Entry No.");
            if ReservationEntry.FindFirst() then
                case TempCSVBuffer."Field No." of
                    3:
                        begin
                            if TempCSVBuffer.value <> '' then begin
                                ReservationEntry.Validate("Serial No.", TempCSVBuffer.Value);
                                ReservationEntry.Modify(true);
                                TempReservationEntry.Validate("Serial No.", TempCSVBuffer.Value);
                                TempReservationEntry.Modify(true);
                            end;
                        end;
                end;
        end;

    end;
}