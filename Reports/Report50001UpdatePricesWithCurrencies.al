report 50001 "Update Prices with Currencies"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem(DataItemName; "Item")
        {
            trigger OnPreDataItem();
            var

            begin
                LocalCurrency := '';
                AdvancedPriceManage.FindPriceCurrencies('', true, CurrencyTemp);

            end;

            trigger OnAfterGetRecord();
            var
                AdvancedPriceManage: Codeunit "Advanced Price Management";
                VendCurr: Code[10];
                DiffrFromVendorCurr: Code[10];
                salesprice2: record "Sales Price";
            begin
                repeat
                    CurrencyTemp.SetRange(Code, "Vendor Currency");
                    if not CurrencyTemp.Find() then
                        exit;
                    VendCurr := "Vendor Currency";
                    Salesprice.SetRange("Item No.", "No.");
                    Salesprice.SetRange("Currency Code", "Vendor Currency");
                    If Salesprice.FindSet() then
                        repeat
                            salesprice2 := Salesprice;
                            salesprice2.SetRecFilter();
                            salesprice2.SetFilter("Currency Code", '<>%1', salesprice."Currency Code");
                            if salesprice2.FindSet() then
                                repeat
                                    IF LocalCurrency <> VendCurr then
                                        if salesprice2."Currency Code" = LocalCurrency then
                                            AdvancedPriceManage.ExchangeAmtLCYToFCYAndFCYToLCY(salesprice2, VendCurr)
                                        else
                                            AdvancedPriceManage.ExchangeAmtFCYToFCY(Salesprice, salesprice2);

                                    IF LocalCurrency = VendCurr then
                                        AdvancedPriceManage.ExchangeAmtLCYToFCY(Salesprice2, VendCurr);
                                until salesprice2.Next() = 0;
                        until Salesprice.Next() = 0;
                until next = 0;
            end;


        }
    }
    var
        CurrencyTemp: Record Currency temporary;
        Salesprice: record "Sales Price";
        GLSetup: Record "General Ledger Setup";
        LocalCurrency: code[10];
        AdvancedPriceManage: Codeunit "Advanced Price Management";
}



