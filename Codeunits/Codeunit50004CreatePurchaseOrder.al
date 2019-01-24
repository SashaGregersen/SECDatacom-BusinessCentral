codeunit 50004 "Create Purchase Order"
{
    trigger OnRun()
    begin

    end;

    Procedure CreatePurchOrderFromSalesOrder(SalesHeader: record "Sales Header")
    var
        SalesLine: record "Sales Line";
        Item: record Item;
        PurchLine: record "Purchase Line";
        VendorNo: code[20];
        PurchHeader: record "Purchase Header";
        GlobalLineCounter: Integer;
        PurchaseOrder: page "Purchase Order";
        ReserveQty: Decimal;
    begin
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange(type, SalesLine.type::Item);
        if SalesLine.FindSet() then
            repeat
                Item.get(SalesLine."No.");
                Item.TestField("Vendor No.");
                PurchHeader.SetRange("No.", PurchHeader."No.");
                PurchHeader.SetRange("Document Type", PurchHeader."Document Type");
                PurchHeader.SetRange("Buy-from Vendor No.", item."Vendor No.");
                if not PurchHeader.FindFirst() then begin
                    SalesLine.CalcFields("Reserved Quantity");
                    if (SalesLine."Quantity" - SalesLine."Reserved Quantity") <> 0 then begin
                        CreatePurchHeader(SalesHeader, Item."Vendor No.", '', '', PurchHeader);
                        CreatePurchLine(PurchHeader, SalesHeader, SalesLine, PurchLine);
                        ReserveItemOnPurchOrder(SalesLine, PurchLine);
                        GlobalLineCounter := GlobalLineCounter + 1;
                    end;
                end else begin
                    SalesLine.CalcFields("Reserved Quantity");
                    if (SalesLine."Quantity" - SalesLine."Reserved Quantity") <> 0 then begin
                        CreatePurchLine(PurchHeader, SalesHeader, SalesLine, PurchLine);
                        ReserveItemOnPurchOrder(SalesLine, PurchLine);
                        GlobalLineCounter := GlobalLineCounter + 1;
                    end;
                end;
            until SalesLine.next = 0;
        if GlobalLineCounter <> 0 then
            Message('Purchase Order %1 created with %2 lines', PurchHeader."No.", GlobalLineCounter);
    end;

    procedure CreatePurchHeader(SalesHeader: record "Sales Header"; VendorNo: code[20]; CurrencyCode: code[10]; VendorBidNo: code[20]; var PurchHeader: record "Purchase Header")
    var

    begin
        PurchHeader.SetRange("No.", PurchHeader."No.");
        if not PurchHeader.FindFirst() then begin
            PurchHeader.Init;
            PurchHeader."Document Type" := PurchHeader."Document Type"::Order;
            PurchHeader.Validate("Buy-from Vendor No.", VendorNo);
            if CurrencyCode <> '' then
                PurchHeader.Validate("Currency Code", CurrencyCode);
            if VendorBidNo <> '' then
                PurchHeader.Validate("Vendor Invoice No.", VendorBidNo);
            PurchHeader.Insert(true);
            if (SalesHeader."Drop-Shipment" = true) or (SalesHeader."Ship-To-Code" <> '') then begin
                PurchHeader.SetShipToAddress(SalesHeader."Ship-to Name", SalesHeader."Ship-to Name 2", SalesHeader."Ship-to Address",
                SalesHeader."Ship-to Address 2", SalesHeader."Ship-to City", SalesHeader."Ship-to Post Code",
                SalesHeader."Ship-to Country/Region Code", SalesHeader."Ship-to Country/Region Code");
                PurchHeader.Modify(true);
            end;
        end;
    end;

    procedure CreatePurchLine(PurchHeader: record "Purchase Header"; SalesHeader: record "sales header"; SalesLine: record "Sales Line"; var PurchLine: Record "Purchase Line")
    var

    begin
        PurchLine.Init;
        PurchLine."Document No." := Purchheader."No.";
        PurchLine."Document Type" := Purchheader."Document Type";
        PurchLine.Validate("Line No.", SalesLine."Line No.");
        PurchLine.Validate(Type, SalesLine.Type);
        PurchLine.Validate("No.", SalesLine."No.");
        PurchLine.Validate("Location Code", SalesLine."Location Code");
        PurchLine.Validate(Quantity, (SalesLine.Quantity - SalesLine."Reserved Quantity"));
        PurchLine.Validate("Expected Receipt Date", SalesLine."Shipment Date"); //vend med SEC         
        PurchLine.Insert(true);
        PurchLine.Validate("Direct Unit Cost", SalesLine."Purchase Price on Purchase Order");
        PurchLine.Validate("Bid No.", SalesLine."Bid No.");
        PurchLine.Modify(true);
    end;

    procedure ReserveItemOnPurchOrder(SalesLine: record "Sales Line"; PurchLine: record "Purchase Line")
    var
        Reservationentry: record "Reservation Entry";
        EntryNo: Integer;
    begin
        EntryNo := 0;
        ReservationEntry.FindLast();
        EntryNo := ReservationEntry."Entry No." + 1;
        // cancel reservation if project sale or bid 
        InsertReservationSalesLine(SalesLine, EntryNo);
        InsertReservationPurchLine(PurchLine, EntryNo);
    end;

    local procedure InsertReservationSalesLine(SalesLine: record "Sales Line"; EntryNo: Decimal)
    var
        ReservationEntry: record "Reservation Entry";
    begin
        SalesLine.CalcFields("Reserved Qty. (Base)");
        ReservationEntry.Init;
        ReservationEntry.Validate("Entry No.", EntryNo);
        ReservationEntry.Validate(Positive, false);
        ReservationEntry.Validate("Item No.", SalesLine."No.");
        ReservationEntry.Validate("Location Code", SalesLine."Location Code");
        ReservationEntry.Validate("Quantity (Base)", (-SalesLine."Quantity (Base)" + SalesLine."Reserved Qty. (Base)"));
        ReservationEntry.Validate("Reservation Status", ReservationEntry."Reservation Status"::Reservation);
        ReservationEntry.Validate("Source Type", 37);
        ReservationEntry.Validate("Source Subtype", 1);
        ReservationEntry.Validate("Source ID", SalesLine."Document No.");
        ReservationEntry.Validate("Created By", UserId());
        ReservationEntry.Validate("Creation Date", Today());
        ReservationEntry.Validate("Source Ref. No.", 10000);
        ReservationEntry.Validate("Expected Receipt Date", SalesLine."Planned Shipment Date");
        ReservationEntry.Validate("Shipment Date", SalesLine."Shipment Date");
        ReservationEntry.Insert(true);
    end;

    local procedure InsertReservationPurchLine(PurchLine: record "Purchase Line"; EntryNo: Decimal)
    var
        ReservationEntry: record "Reservation Entry";
    begin
        PurchLine.calcfields("Reserved Qty. (Base)");
        ReservationEntry.Init;
        ReservationEntry.Validate("Entry No.", EntryNo);
        ReservationEntry.Validate(Positive, true);
        ReservationEntry.Validate("Item No.", PurchLine."No.");
        ReservationEntry.Validate("Location Code", PurchLine."Location Code");
        ReservationEntry.Validate("Quantity (Base)", PurchLine."Quantity (Base)");
        ReservationEntry.Validate("Reservation Status", ReservationEntry."Reservation Status"::Reservation);
        ReservationEntry.Validate("Source Type", 39);
        ReservationEntry.Validate("Source Subtype", 1);
        ReservationEntry.Validate("Source ID", PurchLine."Document No.");
        ReservationEntry.Validate("Created By", UserId());
        ReservationEntry.Validate("Creation Date", Today());
        ReservationEntry.Validate("Source Ref. No.", 20000);
        ReservationEntry.Validate("Expected Receipt Date", PurchLine."Expected Receipt Date");
        ReservationEntry.Validate("Shipment Date", purchLine."Planned Receipt Date");
        ReservationEntry.Insert(true);
    end;
}
