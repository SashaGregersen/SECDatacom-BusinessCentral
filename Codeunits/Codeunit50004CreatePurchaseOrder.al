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
                        CreatePurchHeader(SalesHeader, Item."Vendor No.", '', '', PurchHeader); // kan vi ikke godt have en salgsordre hvor der er forskellige vendors på
                        CreatePurchLine(PurchHeader, SalesHeader, SalesLine, PurchLine);
                        ReserveItemOnPurchOrder(PurchLine);
                        GlobalLineCounter := GlobalLineCounter + 1;
                    end;
                end else begin
                    SalesLine.CalcFields("Reserved Quantity");
                    if (SalesLine."Quantity" - SalesLine."Reserved Quantity") <> 0 then begin
                        CreatePurchLine(PurchHeader, SalesHeader, SalesLine, PurchLine);
                        ReserveItemOnPurchOrder(PurchLine);
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
                PurchHeader.validate("Vendor Invoice No.", VendorBidNo);
            PurchHeader.Insert(true);
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
        PurchLine.Validate(Quantity, SalesLine.Quantity);
        PurchLine.Validate("Expected Receipt Date", SalesLine."Shipment Date"); //vend med SEC         
        PurchLine.Insert(true);
        PurchLine.Validate("Direct Unit Cost", SalesLine."Purchase Price on Purchase Order");
        PurchLine.Validate("Bid No.", SalesLine."Bid No.");
        PurchLine.Modify(true);
    end;

    procedure ReserveItemOnPurchOrder(PurchLine: record "Purchase Line")
    var
        ReservMgt: Codeunit "Reservation Management";
    begin
        ReservMgt.SetPurchLine(PurchLine);
        ReservMgt.AutoReserveOneLine(32, PurchLine.Quantity, PurchLine.Quantity, '', PurchLine."Expected Receipt Date");
    end;

    var
}
