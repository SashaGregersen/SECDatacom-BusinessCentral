codeunit 50001 "Item Export Management"
{
    trigger OnRun()
    begin

    end;

    procedure FindItemPriceForCustomer(ItemNo: Code[20]; CustomerNo: Code[20]; CurrencyCode: Code[10]): Decimal
    var
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
        ToSalesPrice: Record "Sales Price" temporary;
        Item: Record Item;
    begin
        Item.get(ItemNo);
        SalesPriceCalcMgt.FindSalesPrice(ToSalesPrice, CustomerNo, '', FindCustomerDiscGroup(CustomerNo, Item), '', ItemNo, '', Item."Sales Unit of Measure", CurrencyCode, Today, false);
        SalesPriceCalcMgt.CalcBestUnitPrice(ToSalesPrice);
        exit(ToSalesPrice."Unit Price");
    end;

    local procedure FindCustomerDiscGroup(CustomerNo: Code[20]; Item: Record Item): Code[20]
    var
        AdvPriceMgt: Codeunit "Advanced Price Management";
        SalesLineDiscountTemp: Record "Sales Line Discount" temporary;
        PriceGroupLink: Record "Price Group Link";
        FoundGroup: Boolean;
        Customer: Record Customer;
    begin
        if AdvPriceMgt.FindPriceGroupsFromItem(Item, SalesLineDiscountTemp) then begin
            PriceGroupLink.SetRange("Customer No.", CustomerNo);
            if PriceGroupLink.FindSet then begin
                repeat
                    SalesLineDiscountTemp.SetRange("Sales Code", PriceGroupLink."Customer Discount Group Code");
                    if SalesLineDiscountTemp.FindFirst then
                        FoundGroup := true;
                until (PriceGroupLink.Next = 0) or (FoundGroup);
            end;
        end;
        if FoundGroup then
            exit(SalesLineDiscountTemp."Sales Code")
        else begin
            Customer.get(CustomerNo);
            exit(Customer."Customer Disc. Group")
        end;
    end;

    procedure FindSECPurchasePrice(ItemNo: Code[20]; CurrencyCode: Code[10]): Decimal
    var
        AdvPricemgt: Codeunit "Advanced Price Management";
        PurchPrice: record "Purchase Price";
        Item: Record Item;
        ExchRate: Record "Currency Exchange Rate";
    begin
        if not Item.Get(ItemNo) then
            exit(0);
        if not AdvPricemgt.FindBestPurchasePrice(ItemNo, Item."Vendor No.", CurrencyCode, '', PurchPrice) then
            exit(0);
        if PurchPrice."Currency Code" = CurrencyCode then
            exit(PurchPrice."Direct Unit Cost")
        else
            exit(ExchRate.ExchangeAmount(PurchPrice."Direct Unit Cost", PurchPrice."Currency Code", CurrencyCode, WorkDate()));
    end;

    procedure GetlistPrice(ItemNo: Code[20]; CurrencyFilter: Text; UseMarkupAsListPrice: Boolean): Decimal
    var
        SalesPrice: Record "Sales Price";
        AdvPriceMgt: Codeunit "Advanced Price Management";
    begin
        salesprice.Reset();
        salesprice.ClearMarks();
        if AdvPriceMgt.FindListPriceForitem(ItemNo, CurrencyFilter, salesprice) then
            exit(salesprice."Unit Price")
        else begin
            if UseMarkupAsListPrice then begin
                if AdvPriceMgt.FindCostMarkupPrice(ItemNo, CurrencyFilter, salesprice) then
                    exit(salesprice."Unit Price")
                else
                    exit(0);
            end else
                exit(0);
        end;
    end;

}