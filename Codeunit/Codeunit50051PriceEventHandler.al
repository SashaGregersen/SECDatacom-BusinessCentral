codeunit 50051 "Price Event Handler"
{
    SingleInstance = true;
    EventSubscriberInstance = StaticAutomatic;

    var
        AdvPriceMgt: Codeunit "Advanced Price Management";

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterUpdateAmounts', '', true, true)]
    local procedure SalesLineOnAfterUpdateAmounts(var SalesLine: Record "Sales Line")
    var

    begin
        if SalesLine."Unit Purchase Price" = 0 then
            AdvPriceMgt.UpdateSalesLineWithPurchPrice(SalesLine);
        SalesLine.CalcAdvancedPrices;
        UpdateLineAmountLCY(SalesLine);
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterUpdateUnitPrice', '', true, true)]
    local procedure OnAfterUpdateUnitPrice(VAR SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line"; CalledByFieldNo: Integer; CurrFieldNo: Integer)
    var
        CurrencyExcRate: record "Currency Exchange Rate";
        Factor: decimal;
        salesheader: record "Sales Header";
        PriceEventHandler: Codeunit "Price Event Handler";
        Item: Record item;
    begin
        Salesheader.get(SalesLine."Document Type", SalesLine."Document No.");
        Item.get(SalesLine."No.");
        if salesheader."Currency Code" <> '' then begin
            SalesLine.validate("Line Amount Excl. VAT (LCY)", CurrencyExcRate.ExchangeAmtFCYToLCY(salesheader."Posting Date", salesheader."Currency Code", SalesLine.Amount, salesheader."Currency Factor"));
            PriceEventHandler.UpdateListPriceAndDiscount(SalesLine, Item)
        end else begin
            SalesLine.validate("Line Amount Excl. VAT (LCY)", SalesLine."Line Amount");
            PriceEventHandler.UpdateListPriceAndDiscount(SalesLine, item);
        end;
        SalesLine.CalcAdvancedPrices;
        UpdateLineAmountLCY(SalesLine);
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Unit price', true, true)]

    local procedure OnAfterValidateUnitPriceEvent(Var rec: record "Sales Line")
    var
        CurrencyExcRate: record "Currency Exchange Rate";
        Factor: decimal;
        salesheader: record "Sales Header";
        Item: Record item;
        PriceEventHandler: Codeunit "Price Event Handler";
    begin
        UpdateLineAmountLCY(rec);
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterAssignItemValues', '', true, true)]
    local procedure SalesLineOnAfterAssignItemValues(var SalesLine: Record "Sales Line"; Item: Record Item)
    var
        SalesLineDiscountTemp: Record "Sales Line Discount" temporary;
        PriceGroupLink: Record "Price Group Link";
        FoundGroup: Boolean;
        CustKickbackPct: Record "Customer Kickback Percentage";
    begin
        if AdvPriceMgt.FindPriceGroupsFromItem(Item, SalesLineDiscountTemp) then begin
            PriceGroupLink.SetRange("Customer No.", SalesLine."Sell-to Customer No.");
            if PriceGroupLink.FindSet then begin
                repeat
                    SalesLineDiscountTemp.SetRange("Sales Code", PriceGroupLink."Customer Discount Group Code");
                    if SalesLineDiscountTemp.FindFirst then begin
                        SalesLine."Customer Disc. Group" := SalesLineDiscountTemp."Sales Code";
                        SalesLine."Customer Price Group" := SalesLine."Customer Disc. Group";
                        FoundGroup := true;
                    end;
                until (PriceGroupLink.Next = 0) or (FoundGroup);
            end;
        end;
        if AdvPriceMgt.FindCustomerKickbackPct(item."No.", SalesLine."Sell-to Customer No.", CustKickbackPct) then
            SalesLine.Validate("KickBack Percentage", CustKickbackPct."Kickback Percentage");
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Release Sales Document", 'OnBeforeReleaseSalesDoc', '', true, true)]
    local procedure SalesHeaderOnBeforeReleaseSalesDoc(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean)
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindSet then begin
            repeat
                if SalesLine."Bid Unit Sales Price" <> 0 then
                    SalesLine.TestField("Bid No.");
                if SalesLine."Bid Unit Purchase Price" <> 0 then
                    SalesLine.TestField("Bid No.");
            until SalesLine.Next = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Price", 'OnAfterInsertEvent', '', true, true)]
    local procedure SalesPriceOnAfterInsert(var Rec: Record "Sales Price"; RunTrigger: Boolean)
    begin
        if not Runtrigger then
            exit;
        if Rec.IsTemporary() then
            exit;
        Rec."Allow Line Disc." := false;
        Rec.Modify(false);
        AdvPriceMgt.CloseOldSalesPrices(Rec);
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Price", 'OnAfterModifyEvent', '', true, true)]
    local procedure SalesPriceOnAfterModify(var Rec: Record "Sales Price"; Runtrigger: Boolean)
    begin
        if not Runtrigger then
            exit;
        if Rec.IsTemporary() then
            exit;
        Rec."Allow Line Disc." := false;
        Rec.Modify(false);
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line Discount", 'OnAfterModifyEvent', '', true, true)]
    local procedure SalesLineDiscountOnAfterModify(var Rec: Record "Sales Line Discount"; RunTrigger: Boolean)
    var
        DiscontGroupFilters: Record "Sales Line Discount";
        SalesPriceWorksheet: Record "Sales Price Worksheet";
        ImplementPrices: Report "Implement Price Change";
    begin
        if not Runtrigger then
            exit;
        if Rec.IsTemporary() then
            exit;
        DiscontGroupFilters.SetRange(Type, DiscontGroupFilters.type::"Item Disc. Group");
        DiscontGroupFilters.SetRange(Code, Rec.Code);
        DiscontGroupFilters.SetRange("Sales Type", rec."Sales Type");
        DiscontGroupFilters.SetRange("Sales Code", Rec."Sales Code");
        AdvPriceMgt.CalcGroupPricesFromGroupDiscounts(DiscontGroupFilters);
        SalesPriceWorksheet.SetRange("Sales Type", rec."Sales Type");
        SalesPriceWorksheet.SetRange("Sales Code", Rec."Sales Code");
        ImplementPrices.InitializeRequest(true);
        ImplementPrices.SetTableView(SalesPriceWorksheet);
        ImplementPrices.UseRequestPage(false);
        ImplementPrices.Run();
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Line Discount", 'OnAfterModifyEvent', '', true, true)]
    local procedure PurchaseLineDiscountOnAfterModify(var Rec: Record "Purchase Line Discount"; xRec: Record "Purchase Line Discount"; RunTrigger: Boolean)
    var
        PurchasePrice: Record "Purchase Price";
        ListPrice: Record "Sales Price";
    begin
        if not RunTrigger then
            exit;
        if Rec.IsTemporary() then
            exit;
        if AdvPriceMgt.FindListPriceForitem(Rec."Item No.", Rec."Currency Code", ListPrice) then
            AdvPriceMgt.CreateUpdatePurchasePricesFromListPrice(Rec, ListPrice);
        AdvPriceMgt.CreateUpdateSalesMarkupPrices(Rec);
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Line Discount", 'OnAfterInsertEvent', '', true, true)]
    local procedure PurchaseLineDiscountOnAfterInsert(var Rec: Record "Purchase Line Discount"; RunTrigger: Boolean)
    var
        PurchasePrice: Record "Purchase Price";
        ListPrice: Record "Sales Price";
    begin
        If not RunTrigger then
            exit;
        if Rec.IsTemporary() then
            exit;
        if AdvPriceMgt.FindListPriceForitem(Rec."Item No.", Rec."Currency Code", ListPrice) then
            AdvPriceMgt.CreateUpdatePurchasePricesFromListPrice(Rec, ListPrice);
        AdvPriceMgt.CreateUpdateSalesMarkupPrices(Rec);
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Price", 'OnAfterInsertEvent', '', true, true)]
    local procedure PurchasePriceOnAfterInsert(var Rec: Record "Purchase Price"; RunTrigger: Boolean)
    var
        PurchaseDisc: Record "Purchase Line Discount";
    begin
        if not RunTrigger then
            Exit;
        if Rec.IsTemporary() then
            exit;
        AdvPriceMgt.CloseOldPurchasePrices(Rec);
        AdvPriceMgt.CreateSalesPriceFromPurchasePriceMarkup(Rec);
        AdvPriceMgt.CreatePricesForICPartners(Rec."Item No.", Rec."Vendor No.");
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Price", 'OnAfterModifyEvent', '', true, true)]
    local procedure PurchasePriceOnAfterModify(var Rec: Record "Purchase Price"; var xrec: Record "Purchase Price"; RunTrigger: Boolean)
    var
        PurchaseDisc: Record "Purchase Line Discount";
    begin
        If not RunTrigger then
            exit;
        if Rec.IsTemporary() then
            exit;
        AdvPriceMgt.CreateSalesPriceFromPurchasePriceMarkup(Rec);
        AdvPriceMgt.CreatePricesForICPartners(Rec."Item No.", Rec."Vendor No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Purch. Price Calc. Mgt.", 'OnAfterFindPurchLineDisc', '', true, true)]
    local procedure PurchPriceCalcMgtOnAfterFindPurchLineDisc(VAR ToPurchaseLineDiscount: Record "Purchase Line Discount"; VAR FromPurchaseLineDiscount: Record "Purchase Line Discount"; ItemNo: Code[20]; QuantityPerUoM: Decimal; Quantity: Decimal; ShowAll: Boolean)
    var
        PurchaseDisc: Record "Purchase Line Discount";
    begin
        if ToPurchaseLineDiscount.FindSet(true, false) then
            repeat
                ToPurchaseLineDiscount."Line Discount %" := 0;
                ToPurchaseLineDiscount.Modify(false);
            until ToPurchaseLineDiscount.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Price Worksheet", 'OnAfterValidateEvent', 'Item No.', true, true)]
    local procedure SalesPriceWorksheetOnAfterValidateItemNo(var Rec: Record "Sales Price Worksheet")
    var
        Item: Record Item;
    begin
        if Item.Get(Rec."Item No.") then
            Rec.Validate("Unit of Measure Code", Item."Sales Unit of Measure");
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Price Worksheet", 'OnNewRecordEvent', '', true, true)]
    local procedure SalesPriceWorksheetOnNewRecord(var Rec: Record "Sales Price Worksheet"; BelowxRec: Boolean; var xRec: Record "Sales Price Worksheet")
    begin
        Rec.Validate("Starting Date", Today());
    end;

    procedure UpdateListPriceAndDiscount(var SalesLine: Record "Sales Line"; Item: record Item)
    var
        SalesHeader: Record "Sales Header";
        ListPrice: record "Sales Price";
        ListPrice2: record "Sales Price";
        Advpricemgt: Codeunit "Advanced Price Management";
    begin
        SalesHeader.get(SalesLine."Document Type", SalesLine."Document No.");
        if Advpricemgt.FindListPriceForitem(SalesLine."No.", SalesHeader."Currency Code", ListPrice) then
            SalesLine.validate("Unit List Price", ListPrice."Unit Price")
        else
            SalesLine.Validate("Unit List Price", 0);
        if (ListPrice."Unit Price" <> 0) and (SalesLine."Unit Price" <> 0) then
            SalesLine.validate("Reseller Discount", UpdateResellerDiscount(SalesLine, ListPrice));

        if Advpricemgt.FindListPriceForitem(SalesLine."No.", Item."Vendor Currency", ListPrice2) then
            SalesLine.validate("Unit List Price VC", ListPrice2."Unit Price")
        else
            SalesLine.Validate("Unit List Price VC", 0);
    end;

    local procedure UpdateResellerDiscount(SalesLine: record "Sales Line"; Listprice: record "Sales Price"): Decimal
    begin
        exit(((Listprice."Unit Price" - SalesLine."Unit Price") / Listprice."Unit Price") * 100);
    end;

    procedure UpdateProfitAmountLCY(var salesLine: record "Sales Line")
    var
        SalesHeader: record "sales header";
        CurrencyExcRate: record "Currency Exchange Rate";
    begin
        if salesLine."Profit Amount" <> 0 then begin
            Salesheader.get(SalesLine."Document Type", SalesLine."Document No.");
            if salesheader."Currency Code" <> '' then begin
                SalesLine.validate("Profit Amount LCY", CurrencyExcRate.ExchangeAmtFCYToLCY(salesheader."Posting Date", salesheader."Currency Code", SalesLine."Profit Amount", salesheader."Currency Factor"));
            end else begin
                SalesLine.validate("Profit Amount LCY", SalesLine."Profit Amount");
            end;
        end;
    end;

    local procedure UpdateLineAmountLCY(Var SalesLine: record "Sales Line")
    var
        CurrencyExcRate: record "Currency Exchange Rate";
        Factor: decimal;
        salesheader: record "Sales Header";
        Item: Record item;
        PriceEventHandler: Codeunit "Price Event Handler";
    begin
        if Item.get(SalesLine."No.") then begin
            Salesheader.get(SalesLine."Document Type", SalesLine."Document No.");
            if salesheader."Currency Code" <> '' then begin
                Factor := CurrencyExcRate.GetCurrentCurrencyFactor(salesheader."Currency Code");
                SalesLine.validate("Line Amount Excl. VAT (LCY)", CurrencyExcRate.ExchangeAmtFCYToLCY(Today(), salesheader."Currency Code", SalesLine.Amount, Factor));
                PriceEventHandler.UpdateListPriceAndDiscount(SalesLine, item);
            end else begin
                SalesLine.validate("Line Amount Excl. VAT (LCY)", salesheader.Amount);
                PriceEventHandler.UpdateListPriceAndDiscount(SalesLine, item);
            end;
        end;
    end;
}