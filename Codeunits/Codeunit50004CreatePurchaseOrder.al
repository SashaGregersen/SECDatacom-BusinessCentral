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
        PurchHeader: record "Purchase Header";
        VendorNo: code[20];
        GlobalLineCounter: Integer;
    begin
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        if SalesLine.FindSet() then
            repeat
                Item.SetRange("No.", SalesLine."No.");
                if Item.FindFirst() then begin
                    Item.TestField("Vendor No.");
                    PurchLine.SetRange("Sales Order Line No.", SalesLine."Line No.");
                    PurchLine.SetRange("Sales Order No.", SalesHeader."No.");
                    if not PurchLine.FindFirst() then begin
                        SalesLine.CalcFields("Reserved Quantity");
                        if (SalesLine."Quantity" - SalesLine."Reserved Quantity") <> 0 then begin
                            CreatePurchHeader(SalesHeader, Item."Vendor No.", '', PurchHeader); // kan vi ikke godt have en salgsordre hvor der er forskellige vendors på
                            CreatePurchLine(PurchHeader, SalesHeader, SalesLine);
                            ReserveItemOnPurchOrder(PurchLine);
                            GlobalLineCounter := GlobalLineCounter + 1;
                        end;
                    end else begin
                        //her findes en købsordre
                        PurchLine.CalcFields("Reserved Quantity");
                        if (PurchLine.Quantity - PurchLine."Reserved Quantity") <> 0 then
                            ReserveItemOnPurchOrder(PurchLine);
                    end;
                end;
            until SalesLine.next = 0;
        if GlobalLineCounter <> 0 then
            Message('Purchase Order %1 created with %2 lines', PurchHeader."No.", GlobalLineCounter);
    end;

    procedure CreatePurchHeader(SalesHeader: record "Sales Header"; VendorNo: code[20]; CurrencyCode: code[10]; var PurchHeader: record "Purchase Header")
    var

    begin
        PurchHeader.SetRange("No.", PurchHeader."No.");
        if not PurchHeader.FindFirst() then begin
            PurchHeader.Init;
            PurchHeader.Validate("Buy-from Vendor No.", VendorNo);
            if CurrencyCode <> '' then
                PurchHeader.Validate("Currency Code", CurrencyCode);
            PurchHeader.Insert(true);
        end;
    end;

    procedure CreatePurchLine(PurchHeader: record "Purchase Header"; SalesHeader: record "sales header"; SalesLine: record "Sales Line")
    var
        PurchLine: record "Purchase Line";
    begin
        PurchLine.Init;
        PurchLine."Document No." := Purchheader."No.";
        PurchLine."Document Type" := Purchheader."Document Type";
        PurchLine.Validate("Line No.", SalesLine."Line No.");
        PurchLine.Validate(Type, SalesLine.Type);
        PurchLine.Validate("No.", SalesLine."No.");
        PurchLine.Validate(Quantity, SalesLine.Quantity);
        PurchLine.Validate("Sales Order No.", SalesHeader."No.");
        PurchLine.Validate("Sales Order Line No.", SalesLine."Line No.");
        PurchLine.Insert(true);
        PurchLine.Validate("Bid No.", SalesLine."Bid No.");
        PurchLine.Modify(true);
    end;

    procedure ReserveItemOnPurchOrder(PurchLine: record "Purchase Line")
    var
        ReservationEntry: record "Reservation Entry";
    begin

    end;

    var
}
