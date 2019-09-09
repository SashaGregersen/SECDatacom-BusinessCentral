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
        MessageTxt: Text[250];
        TempPurchHeader: Record "Purchase Header" temporary;
        ReleasePurchDoc: Codeunit "Release Purchase Document";
        Bid: Record Bid;
        CurrExchRate: Record "Currency Exchange Rate";
        SalesReceive: record "Sales & Receivables Setup";
    begin
        SalesReceive.get;
        GlobalLineCounter := 0;
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange(type, SalesLine.type::Item);
        SalesLine.setfilter("No.", '<>%1', SalesReceive."Freight Item");
        if SalesLine.FindSet() then
            repeat
                if SalesLine.Quantity <> SalesLine."Qty. Shipped (Base)" then begin //SDG 16-08-2019
                    Item.Get(SalesLine."No."); //SDG 22-07-19
                    if item.Type = item.type::Inventory then begin //SDG 22-07-19
                        SalesLine.CalcFields("Reserved Quantity");
                        QtyToPurchase := SalesLine."Quantity" - SalesLine."Reserved Quantity" - SalesLine."Qty. Shipped (Base)";
                        if QtyToPurchase <> 0 then begin
                            VendorNo := AdvPriceMgt.GetVendorNoForItem(SalesLine."No.");
                            //Item.Get(SalesLine."No."); //SDG 22-07-19
                            case SalesHeader."Purchase Currency Method" of
                                SalesHeader."Purchase Currency Method"::"Local Currency":
                                    CurrencyCode := '';
                                SalesHeader."Purchase Currency Method"::"Vendor Currency":
                                    CurrencyCode := Item."Vendor Currency";
                                SalesHeader."Purchase Currency Method"::"Same Currency":
                                    CurrencyCode := SalesHeader."Purchase Currency Code";
                            end;

                            Clear(PurchasePrice);
                            if SalesLine."Bid No." <> '' then begin
                                Clear(BidPrice);
                                if not BidMgt.GetBestBidPrice(SalesLine."Bid No.", SalesLine."Sell-to Customer No.", SalesLine."No.", CurrencyCode, BidPrice) then
                                    Clear(PurchasePrice)
                                else begin
                                    BidMgt.MakePurchasePriceFromBidPrice(BidPrice, PurchasePrice, SalesLine);
                                end;
                            end else begin
                                AdvPriceMgt.FindBestPurchasePrice(SalesLine."No.", VendorNo, CurrencyCode, SalesLine."Variant Code", PurchasePrice);
                            end;
                            if PurchasePrice."Currency Code" <> CurrencyCode then begin
                                PurchasePrice."Direct Unit Cost" := CurrExchRate.ExchangeAmount(PurchasePrice."Direct Unit Cost",
                                                                                                PurchasePrice."Currency Code",
                                                                                                CurrencyCode, WorkDate());
                                PurchasePrice."Currency Code" := CurrencyCode;
                            end;

                            //if PurchasePrice."Direct Unit Cost" <> 0 then begin //check på <> 0 bør fjernes
                            if not FindTempPurchaseHeader(VendorNo, CurrencyCode, TempPurchHeader) then begin
                                MessageTxt := MessageTxt + CreatePurchHeader(SalesHeader, VendorNo, CurrencyCode, GetVendorBidNo(SalesLine."Bid No."), PurchHeader) + '/';
                                TempPurchHeader := PurchHeader;
                                TempPurchHeader.Insert(false);
                            end else
                                PurchHeader.Get(TempPurchHeader."Document Type", TempPurchHeader."No.");
                            CreatePurchLine(PurchHeader, SalesHeader, SalesLine, PurchasePrice."Direct Unit Cost", PurchLine);
                            ReserveItemOnPurchOrder(SalesLine, PurchLine);
                            GlobalLineCounter := GlobalLineCounter + 1;
                            //end;
                        end;
                    end; //SDG 22-07-19
                end; //SDG 16-08-2019
            until SalesLine.next = 0;

        if TempPurchHeader.FindSet() then
            repeat
                PurchHeader.Get(TempPurchHeader."Document Type", TempPurchHeader."No.");
                ReleasePurchDoc.ReleasePurchaseHeader(PurchHeader, false);
            until TempPurchHeader.Next() = 0;

        if GlobalLineCounter = 0 then
            Message('No lines created. All items are either already on purchase orders or reserved against inventory, or do not have a purchase price')
        else begin
            if MessageTxt <> '' then begin
                MessageTxt := DelChr(MessageTxt, '>', '/');
                Message(MessageTxt);
            end;
            Message(StrSubstNo('%1 Purchase Lines created', GlobalLineCounter));
        end;
    end;

    procedure CreatePurchHeader(SalesHeader: record "Sales Header"; VendorNo: code[20]; CurrencyCode: code[10]; VendorBidNo: Text[100]; var PurchHeader: record "Purchase Header"): Text
    var
        Customer: record customer;
        CompanyInfo: record "Company Information";
    begin
        PurchHeader.Init;
        PurchHeader."No." := '';
        PurchHeader."Document Type" := PurchHeader."Document Type"::Order;
        PurchHeader.Insert(true);
        PurchHeader.Validate("Buy-from Vendor No.", VendorNo);
        PurchHeader.Validate("Currency Code", CurrencyCode);
        /* if VendorBidNo <> '' then
            PurchHeader.Validate("Vendor Shipment No.", COPYSTR(VendorBidNo, 1, 35)); */ // Not used
        if (SalesHeader."Ship directly from supplier") then begin
            PurchHeader.SetShipToAddress(SalesHeader."Ship-to Name", SalesHeader."Ship-to Name 2",
            SalesHeader."Ship-to Address", SalesHeader."Ship-to Address 2", SalesHeader."Ship-to City",
            SalesHeader."Ship-to Post Code", SalesHeader."Ship-to County", SalesHeader."Ship-to Country/Region Code");
            PurchHeader.validate("Ship-to Contact", SalesHeader."Ship-to Contact");
            PurchHeader.validate("Ship-To Comment", SalesHeader."Ship-to Comment");
        end else begin
            if SalesHeader.Subsidiary <> '' then begin
                CompanyInfo.get();
                PurchHeader.SetShipToAddress(CompanyInfo.Name, CompanyInfo."Ship-to Name 2", CompanyInfo."Ship-to Address",
                CompanyInfo."Ship-to Address 2", CompanyInfo."Ship-to City", CompanyInfo."Ship-to Post Code",
                CompanyInfo."Ship-to County", CompanyInfo."Ship-to Country/Region Code");
                PurchHeader.validate("Ship-to Contact", CompanyInfo."Ship-to Contact");
                PurchHeader.validate("Ship-To Comment", SalesHeader."Ship-to Comment");
            end;
        end;
        PurchHeader."End Customer" := SalesHeader."End Customer";
        PurchHeader.Reseller := SalesHeader.Reseller;
        PurchHeader."End Customer Contact No." := SalesHeader."End Customer Contact";
        PurchHeader."Reseller Contact No." := SalesHeader."Sell-to Contact No.";
        SetDefaultPurchaser(PurchHeader);
        PurchHeader.Modify(true);
        exit(StrSubstNo('Purchase Order %1 created', PurchHeader."No."));
    end;

    LOCAL procedure SetDefaultPurchaser(var PurchHeader: record "Purchase Header")
    var
        Usersetup: record "User Setup";
        SalespersonPurchaser: record "Salesperson/Purchaser";
    begin
        IF NOT UserSetup.GET(USERID) THEN
            EXIT;

        IF UserSetup."Salespers./Purch. Code" <> '' THEN
            IF SalespersonPurchaser.GET(UserSetup."Salespers./Purch. Code") THEN
                IF NOT SalespersonPurchaser.VerifySalesPersonPurchaserPrivacyBlocked(SalespersonPurchaser) THEN
                    PurchHeader.VALIDATE("Purchaser Code", UserSetup."Salespers./Purch. Code");
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
        PurchLine.Validate(Quantity, (SalesLine.Quantity - SalesLine."Reserved Quantity" - SalesLine."Qty. Shipped (Base)"));
        PurchLine.Validate("Expected Receipt Date", SalesLine."Shipment Date");
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
        ReservationEntry.Validate("Quantity (Base)", (-SalesLine."Quantity (Base)" + SalesLine."Reserved Qty. (Base)") + SalesLine."Qty. Shipped (Base)");
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

    Local procedure CheckSalesLineForBidNo(SalesLine: record "Sales Line"): Boolean
    var

    begin
        if SalesLine."Bid No." <> '' then
            Exit(Confirm('Sales Line %1 has a Bid no. with reserved item\Do you wish to continue?', false, SalesLine."Line No."))
        else
            exit(true);
    end;

    local procedure FindPurchaseHeader(VendorNo: code[20]; CurrencyCode: Code[20]; var PurchHeader: record "Purchase Header") FoundHeader: Boolean
    //Not used right now - keeping it because we might need it again
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

    local procedure FindTempPurchaseHeader(VendorNo: code[20]; CurrencyCode: Code[20]; var TempPurchHeader: record "Purchase Header" temporary) FoundHeader: Boolean
    begin
        TempPurchHeader.SetRange("Document Type", TempPurchHeader."Document Type"::Order);
        TempPurchHeader.SetRange("Buy-from Vendor No.", VendorNo);
        TempPurchHeader.SetRange("Currency Code", CurrencyCode);
        TempPurchHeader.SetRange(Status, TempPurchHeader.Status::Open);
        FoundHeader := TempPurchHeader.FindFirst();
        TempPurchHeader.SetRange("Document Type");
        TempPurchHeader.SetRange("Buy-from Vendor No.");
        TempPurchHeader.SetRange("Currency Code");
        TempPurchHeader.SetRange(Status);
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

    local procedure GetVendorBidNo(BidNo: Code[20]): Text[100]
    var
        Bid: record "Bid";
    begin
        if Bid.get(BidNo) then
            exit(Bid."Vendor Bid No.")
        else
            exit(BidNo);
    end;

}
