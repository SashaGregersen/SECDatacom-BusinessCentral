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
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterUpdateUnitPrice', '', true, true)]
    local procedure OnAfterUpdateUnitPrice(VAR SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line"; CalledByFieldNo: Integer; CurrFieldNo: Integer)
    var
        CurrencyExcRate: record "Currency Exchange Rate";
        Factor: decimal;
        salesheader: record "Sales Header";
    begin
        Salesheader.get(SalesLine."Document Type", SalesLine."Document No.");
        if salesheader."Currency Code" <> '' then begin
            SalesLine.validate("Line Amount Excl. VAT (LCY)", CurrencyExcRate.ExchangeAmtFCYToLCY(salesheader."Posting Date", salesheader."Currency Code", SalesLine.Amount, salesheader."Currency Factor"));
        end else begin
            SalesLine.validate("Line Amount Excl. VAT (LCY)", SalesLine."Line Amount");
        end;

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Unit price', true, true)]

    local procedure OnAfterValidateUnitPriceEvent(Var rec: record "Sales Line")
    var
        CurrencyExcRate: record "Currency Exchange Rate";
        Factor: decimal;
        salesheader: record "Sales Header";
    begin
        Salesheader.get(rec."Document Type", rec."Document No.");
        if salesheader."Currency Code" <> '' then begin
            Factor := CurrencyExcRate.GetCurrentCurrencyFactor(salesheader."Currency Code");
            rec.validate("Line Amount Excl. VAT (LCY)", CurrencyExcRate.ExchangeAmtFCYToLCY(Today(), salesheader."Currency Code", rec.Amount, Factor));
        end else begin
            rec.validate("Line Amount Excl. VAT (LCY)", salesheader.Amount);
        end;
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
    local procedure SalesPriceOnAfterInsert(var Rec: Record "Sales Price")
    begin
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
    local procedure SalesLineDiscountOnAfterModify(var Rec: Record "Sales Line Discount")
    var
        DiscontGroupFilters: Record "Sales Line Discount";
        SalesPriceWorksheet: Record "Sales Price Worksheet";
        ImplementPrices: Report "Implement Price Change";
    begin
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
    local procedure PurchasePriceOnAfterInsert(var Rec: Record "Purchase Price")
    var
        PurchaseDisc: Record "Purchase Line Discount";
    begin
        if Rec.IsTemporary() then
            exit;
        AdvPriceMgt.CreateSalesPriceFromPurchasePriceMarkup(Rec);
        AdvPriceMgt.CreatePricesForICPartners(Rec."Item No.", Rec."Vendor No.");
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Price", 'OnAfterModifyEvent', '', true, true)]
    local procedure PurchasePriceOnAfterModify(var Rec: Record "Purchase Price"; var xrec: Record "Purchase Price")
    var
        PurchaseDisc: Record "Purchase Line Discount";
    begin
        if Rec.IsTemporary() then
            exit;
        if Rec."Direct Unit Cost" = xrec."Direct Unit Cost" then
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

}