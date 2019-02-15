codeunit 50012 "Import Serial Numbers"
{
    procedure ImportSerialNumberFromSalesLine(rec: record "Sales Line")
    var
        TempCSVBuffer: record "CSV Buffer" temporary;
        FileMgtImport: codeunit "File Management Import";
        Item: Record item;
        ItemNo: code[20];
        VendorNo: code[20];
    begin
        TempCSVBuffer.init;
        FileMgtImport.SelectFileFromFileShare(TempCSVBuffer);

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
                                if Item.FindFirst() then
                                    ItemNo := Item."No."
                                else
                                    Error('The item %1 does not exists as a vendor item no. or vendor no is incorrect', TempCSVBuffer.Value);
                            end else
                                Error('Vendor Item No. is missing in line %1', TempCSVBuffer."Line No.");
                        end;
                    3:
                        begin
                            if TempCSVBuffer.value <> '' then
                                InsertSerialNumbers(rec, TempCSVBuffer.Value, ItemNo)
                            else
                                Error('Serial No. is missing in line %1', TempCSVBuffer."Line No.");
                        end;
                end;
            until TempCSVBuffer.next = 0;


        Message('Serial numbers were imported');
    end;

    local procedure InsertSerialNumbers(SalesLine: record "Sales Line"; SerialNo: code[50]; ItemNo: code[20]);
    var
        Salesline2: record "Sales Line";
        ReservationEntry: record "Reservation Entry";
        Reservationentry2: record "Reservation Entry";
        ReserveEngineMgt: Codeunit "Reservation Engine Mgt.";
        TempReservationEntry: record "Reservation Entry" temporary;
    begin
        Salesline2.Init;
        SalesLine2.SetRange("Document No.", SalesLine."Document No.");
        SalesLine2.SetRange("Document Type", SalesLine."Document Type");
        SalesLine2.SetRange(Type, SalesLine.Type::Item);
        SalesLine2.SetRange("No.", ItemNo);
        if Salesline2.Findset() then begin
            repeat
                Salesline2.CalcFields("Reserved Quantity");
                if Salesline2."Reserved Quantity" <> 0 then begin
                    ReservationEntry.SetRange("Item No.", ItemNo);
                    ReservationEntry.SetRange("Source ID", SalesLine2."Document No.");
                    ReservationEntry.SetRange("Source Type", 37);
                    ReservationEntry.SetRange("Source Subtype", SalesLine2."Document Type");
                    ReservationEntry.SetRange("Source Ref. No.", Salesline2."Line No.");
                    ReservationEntry.SetRange("Reservation Status", ReservationEntry."Reservation Status"::Reservation);
                    ReservationEntry.SetRange("Item Tracking", ReservationEntry."Item Tracking"::None); // vil altid være none 
                    ReservationEntry.SetRange(Binding, ReservationEntry.Binding::" ");
                    if ReservationEntry.FindFirst() then
                        repeat
                            TempReservationEntry.Init();
                            TempReservationEntry.TransferFields(ReservationEntry);
                            if TempReservationEntry.Insert(true) then
                                ReserveEngineMgt.CancelReservation(ReservationEntry)
                            else
                                InsertReservationEntryWithSerialNumber(TempReservationEntry, SerialNo);
                        until ReservationEntry.next = 0
                    else
                        Error('You cannot import serial numbers to Item %1,/because it is not on stock', ItemNo);
                end else begin
                    Error('There are no reserved items for sales line no. %1./Please reserve items before importing serial numbers', Salesline2."Line No.")
                end;
            until Salesline2.next = 0;

            InsertReservationEntryWithSerialNumber(TempReservationEntry, SerialNo);
        end;
    end;

    local procedure InsertReservationEntryWithSerialNumber(TempReservationEntry: record "Reservation Entry" temporary; SerialNo: code[50])
    var
        ReservationEntry: record "Reservation Entry";
        EntryNo: Integer;
    begin
        if TempReservationEntry.FindSet() then
            repeat

                EntryNo := 0;
                ReservationEntry.FindLast();
                EntryNo := ReservationEntry."Entry No." + 1;
                ReservationEntry.Init();
                // se om der findes en copy eller transferfields funktion til nedenstående som ikke tager entry no
                ReservationEntry.Validate("Entry No.", EntryNo);
                ReservationEntry.Validate(Positive, TempReservationEntry.Positive);
                ReservationEntry.Validate("Item No.", TempReservationEntry."Item No.");
                ReservationEntry.Validate("Location Code", TempReservationEntry."Location Code");
                //ReservationEntry.Validate("Quantity (Base)", TempReservationEntry."Quantity (Base)"); skal altid sættes til 1/-1
                ReservationEntry.Validate("Reservation Status", TempReservationEntry."Reservation Status");
                ReservationEntry.Validate("Source Type", TempReservationEntry."Source Type");
                ReservationEntry.Validate("Source Subtype", TempReservationEntry."Source Subtype");
                ReservationEntry.Validate("Source ID", TempReservationEntry."Source ID");
                ReservationEntry.Validate("Created By", UserId());
                ReservationEntry.Validate("Creation Date", WorkDate());
                ReservationEntry.Validate("Source Ref. No.", TempReservationEntry."Source Ref. No.");
                ReservationEntry.Validate("Expected Receipt Date", TempReservationEntry."Expected Receipt Date");
                ReservationEntry.Validate("Shipment Date", TempReservationEntry."Shipment Date");
                ReservationEntry.Validate("Item Tracking", ReservationEntry."Item Tracking"::"Serial No.");
                ReservationEntry.Validate("Serial No.", SerialNo);
                ReservationEntry.Insert(true);

            until TempReservationEntry.next = 0
        else
            exit;
    end;
}