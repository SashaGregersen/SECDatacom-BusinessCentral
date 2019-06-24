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

    var
        myInt: Integer;
}