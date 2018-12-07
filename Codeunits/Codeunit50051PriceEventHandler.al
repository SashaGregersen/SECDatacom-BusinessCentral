codeunit 50051 "Price Event Handler"
{
    SingleInstance = true;
    EventSubscriberInstance = StaticAutomatic;

    var
        AdvPriceMgt: Codeunit "Advanced Price Management";

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterUpdateAmounts', '', true, true)]
    local procedure SalesLineOnAfterUpdateAmounts(var SalesLine: Record "Sales Line")
    begin
        if SalesLine."Unit Purchase Price" = 0 then
            AdvPriceMgt.UpdateSalesLineWithPurchPrice(SalesLine);
        SalesLine.CalcAdvancedPrices;
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterAssignItemValues', '', true, true)]
    local procedure SalesLineOnAfterAssignItemValues(var SalesLine: Record "Sales Line"; Item: Record Item)
    var
        SalesLineDiscountTemp: Record "Sales Line Discount" temporary;
        PriceGroupLink: Record "Price Group Link";
        FoundGroup: Boolean;
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

    [EventSubscriber(ObjectType::Table, database::"Sales Line Discount", 'OnAfterModifyEvent', '', true, true)]
    local procedure SalesLineDiscountOnAfterModify(var Rec: Record "Sales Line Discount")
    var
        DiscontGroupFilters: Record "Sales Line Discount";
        SalesPriceWorksheet: Record "Sales Price Worksheet";
        ImplementPrices: Report "Implement Price Change";
    begin
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
    local procedure PurchaseLineDiscountOnAfterModify(var Rec: Record "Purchase Line Discount"; xRec: Record "Purchase Line Discount")
    var
        PurchasePrice: Record "Purchase Price";
        ListPrice: Record "Sales Price";
    begin
        if Rec."Line Discount %" <> xRec."Line Discount %" then begin
            if AdvPriceMgt.FindListPriceForitem(Rec."Item No.", Rec."Currency Code", ListPrice) then
                AdvPriceMgt.CreateUpdatePurchasePrices(Rec, ListPrice);
            if rec."Customer Markup" <> 0 then
                AdvPriceMgt.CreateUpdateSalesMarkupPrices(Rec);
            exit;
        end;
        if rec."Customer Markup" <> xRec."Customer Markup" then
            AdvPriceMgt.CreateUpdateSalesMarkupPrices(Rec);
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Line Discount", 'OnAfterInsertEvent', '', true, true)]
    local procedure PurchaseLineDiscountOnAfterInsert(var Rec: Record "Purchase Line Discount")
    var
        PurchasePrice: Record "Purchase Price";
        ListPrice: Record "Sales Price";
    begin
        if not AdvPriceMgt.FindListPriceForitem(Rec."Item No.", Rec."Currency Code", ListPrice) then
            exit;
        AdvPriceMgt.CreateUpdatePurchasePrices(Rec, ListPrice);
    end;

    var
        myInt: Integer;
}