codeunit 50004 "Create Purchase Order"
{
    trigger OnRun()
    begin

    end;

    Procedure CreatePurchOrderFromSalesOrder(SalesHeader: record "Sales Header")
    var
        SalesLine: record "Sales Line";
        PurchHeader: record "Purchase Header";
        GlobalLineCounter: Integer;
        PurchLine: record "Purchase Line";
        VendorNo: Code[20];
        PurchasePrice: Record "Purchase Price";
        BidPrice: Record "Bid Item Price";
        QtyToPurchase: Decimal;
        CurrencyCode: Code[20];
        Item: Record Item;
        AdvPriceMgt: Codeunit "Advanced Price Management";
        BidMgt: Codeunit "Bid Management";
        MessageTxt: Text;
    begin
        GlobalLineCounter := 0;
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange(type, SalesLine.type::Item);
        if SalesLine.FindSet() then
            repeat
                SalesLine.CalcFields("Reserved Quantity");
                QtyToPurchase := SalesLine."Quantity" - SalesLine."Reserved Quantity";
                if QtyToPurchase <> 0 then begin
                    VendorNo := AdvPriceMgt.GetVendorNoForItem(SalesLine."No.");
                    Item.Get(SalesLine."No.");
                    CurrencyCode := Item."Vendor Currency";
                    Clear(PurchasePrice);
                    if SalesLine."Bid No." <> '' then begin
                        Clear(BidPrice);
                        if not BidMgt.GetBestBidPrice(SalesLine."Bid No.", SalesLine."Sell-to Customer No.", SalesLine."No.", CurrencyCode, BidPrice) then
                            Clear(PurchasePrice)
                        else begin
                            BidMgt.MakePurchasePriceFromBidPrice(BidPrice, PurchasePrice);
                            CurrencyCode := PurchasePrice."Currency Code";
                        end;
                    end else begin
                        Item.Get(SalesLine."No.");
                        CurrencyCode := Item."Vendor Currency";
                        if AdvPriceMgt.FindBestPurchasePrice(SalesLine."No.", VendorNo, CurrencyCode, SalesLine."Variant Code", PurchasePrice) then
                            CurrencyCode := PurchasePrice."Currency Code";
                    end;

                    if PurchasePrice."Direct Unit Cost" <> 0 then begin
                        if not FindPurchaseHeader(VendorNo, CurrencyCode, PurchHeader) then
                            MessageTxt := CreatePurchHeader(SalesHeader, VendorNo, CurrencyCode, SalesLine."Bid No.", PurchHeader);
                        CreatePurchLine(PurchHeader, SalesHeader, SalesLine, PurchasePrice."Direct Unit Cost", PurchLine);
                        ReserveItemOnPurchOrder(SalesLine, PurchLine);
                        GlobalLineCounter := GlobalLineCounter + 1;
                    end;
                end;
            until SalesLine.next = 0;

        if GlobalLineCounter = 0 then
            Message('No lines created. All items are either already on purchase orders or reserved against inventory, or do not have a purchase price')
        else begin
            if MessageTxt <> '' then
                Message(MessageTxt);
            Message(StrSubstNo('%1 Purchase Lines created', GlobalLineCounter));
        end;
    end;

    procedure CreatePurchHeader(SalesHeader: record "Sales Header"; VendorNo: code[20]; CurrencyCode: code[10]; VendorBidNo: code[20]; var PurchHeader: record "Purchase Header"): Text
    var

    begin
        PurchHeader.Init;
        PurchHeader."No." := '';
        PurchHeader."Document Type" := PurchHeader."Document Type"::Order;
        PurchHeader.Insert(true);
        PurchHeader.Validate("Buy-from Vendor No.", VendorNo);
        PurchHeader.Validate("Currency Code", CurrencyCode);
        if VendorBidNo <> '' then
            PurchHeader.Validate("Vendor Shipment No.", VendorBidNo);
        if (SalesHeader."Drop-Shipment" = true) or (SalesHeader."Ship-To-Code" <> '') then begin
            PurchHeader.SetShipToAddress(SalesHeader."Ship-to Name", SalesHeader."Ship-to Name 2", SalesHeader."Ship-to Address",
            SalesHeader."Ship-to Address 2", SalesHeader."Ship-to City", SalesHeader."Ship-to Post Code",
            SalesHeader."Ship-to Country/Region Code", SalesHeader."Ship-to Country/Region Code");
        end;
        PurchHeader."End Customer" := SalesHeader."End Customer";
        PurchHeader.Reseller := SalesHeader.Reseller;
        PurchHeader.Modify(true);
        exit(StrSubstNo('Purchase Order %1 created', PurchHeader."No."));
    end;

    procedure CreatePurchLine(PurchHeader: record "Purchase Header"; SalesHeader: record "sales header"; SalesLine: record "Sales Line"; PurchasePrice: Decimal; var PurchLine: Record "Purchase Line")
    var
        BidMgt: Codeunit "Bid Management";
        BidItemPrice: Record "Bid Item Price";
        LastPurchaseLine: Record "Purchase Line";
    begin
        SalesLine.CalcFields("Reserved Quantity");
        PurchLine.Init;
        PurchLine."Document No." := Purchheader."No.";
        PurchLine."Document Type" := Purchheader."Document Type";
        lastPurchaseLine.SetRange("Document No.", Purchheader."No.");
        lastPurchaseLine.SetRange("Document Type", Purchheader."Document Type");
        if lastPurchaseLine.FindLast() then
            PurchLine.Validate("Line No.", lastPurchaseLine."Line No." + 10000)
        else
            PurchLine.Validate("Line No.", 10000);
        PurchLine.Validate(Type, SalesLine.Type);
        PurchLine.Validate("No.", SalesLine."No.");
        PurchLine.Validate("Location Code", SalesLine."Location Code");
        PurchLine.Validate(Quantity, (SalesLine.Quantity - SalesLine."Reserved Quantity"));
        PurchLine.Validate("Expected Receipt Date", SalesLine."Shipment Date"); //vend med SEC 
        if SalesLine."Bid No." <> '' then
            PurchLine.Validate("Bid No.", SalesLine."Bid No.");
        PurchLine.Validate("Direct Unit Cost", PurchasePrice);
        PurchLine.Insert(true);
    end;

    procedure ReserveItemOnPurchOrder(SalesLine: record "Sales Line"; PurchLine: record "Purchase Line")
    var
        Reservationentry: record "Reservation Entry";
        EntryNo: Integer;
    begin
        Clear(EntryNo);
        EntryNo := GetNextReservantionEntryNo();
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
        ReservationEntry.Validate("Creation Date", WorkDate());
        ReservationEntry.Validate("Source Ref. No.", SalesLine."Line No.");
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
        ReservationEntry.Validate("Creation Date", WorkDate());
        ReservationEntry.Validate("Source Ref. No.", PurchLine."Line No.");
        ReservationEntry.Validate("Expected Receipt Date", PurchLine."Expected Receipt Date");
        ReservationEntry.Validate("Shipment Date", purchLine."Planned Receipt Date");
        ReservationEntry.Insert(true);
    end;

    Local procedure NewPurchOrder(SalesLine: record "Sales Line"; SalesHeader: record "Sales Header"; ItemVendorNo: code[20]; var PurchHeader: record "Purchase Header"; var GlobalLineCount: Integer)
    var
        PurchLine: record "Purchase Line";
        Vendor: record Vendor;
    begin
        //Deprecated - to be deleted
        /*         SalesLine.CalcFields("Reserved Quantity");
                if (SalesLine."Quantity" - SalesLine."Reserved Quantity") <> 0 then begin
                    Vendor.get(ItemVendorNo);
                    CreatePurchHeader(SalesHeader, ItemVendorNo, Vendor."Currency Code", '', PurchHeader);
                    CreatePurchLine(PurchHeader, SalesHeader, SalesLine, PurchLine);
                    ReserveItemOnPurchOrder(SalesLine, PurchLine);
                    GlobalLineCount := GlobalLineCount + 1;
                end; */
    end;


    Local procedure UpdateExistingPurchOrder(Salesline: record "Sales Line"; PurchHeader: record "Purchase Header"; SalesHeader: record "Sales Header"; var GlobalLineCount: Integer)
    var
        PurchLine: record "Purchase Line";
    begin
        //Deprecated - to be deleted
        /* SalesLine.CalcFields("Reserved Quantity");
        if (SalesLine."Quantity" - SalesLine."Reserved Quantity") <> 0 then begin
            CreatePurchLine(PurchHeader, SalesHeader, SalesLine, PurchLine);
            ReserveItemOnPurchOrder(SalesLine, PurchLine);
            GlobalLineCount := GlobalLineCount + 1;
        end; */
    end;

    Local procedure CheckSalesLineForBidNo(SalesLine: record "Sales Line"): Boolean
    var

    begin
        if SalesLine."Bid No." <> '' then
            Exit(Confirm('Sales Line %1 has a Bid no. with reserved item\Do you wish to continue?', false, SalesLine."Line No."))
        else
            exit(true);
    end;



    local procedure FindPurchaseHeader(VendorNo: code[20]; CurrencyCode: Code[20]; var PurchHeader: record "Purchase Header") FoundHeader: Boolean
    begin
        PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Order);
        PurchHeader.SetRange("Buy-from Vendor No.", VendorNo);
        PurchHeader.SetRange("Currency Code", CurrencyCode);
        PurchHeader.SetRange(Status, PurchHeader.Status::Open);
        FoundHeader := PurchHeader.FindFirst();
        PurchHeader.SetRange("Document Type");
        PurchHeader.SetRange("Buy-from Vendor No.");
        PurchHeader.SetRange("Currency Code");
        PurchHeader.SetRange(Status);
    end;

    local procedure GetNextReservantionEntryNo(): Integer;
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        If not ReservationEntry.FindLast() then
            exit(1)
        else
            exit(ReservationEntry."Entry No." + 1)
    end;

}
