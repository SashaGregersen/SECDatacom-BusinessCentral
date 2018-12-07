report 50001 "Update Prices with Currencies"
{
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem(DataItemName; "Item")
        {
            trigger OnPreDataItem();
            var

            begin
                if not GLSetup.get then
                    exit;
                If GLSetup."LCY Code" = '' then
                    exit;
                LocalCurrency := '';
                AdvancedPriceManage.FindPriceCurrencies('', false, CurrencyTemp);

            end;

            trigger OnAfterGetRecord();
            var
                AdvancedPriceManage: Codeunit "Advanced Price Management";
                VendCurr: Code[10];
                DiffrFromVendorCurr: Code[10];
                salesprice2: record "Sales Price";
            begin
                SetRange("No.", '70061');
                if findfirst then
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
                                /*  IF LocalCurrency <> VendCurr then
                                     if Salesprice."Currency Code" = LocalCurrency then
                                         AdvancedPriceManage.ExchangeAmtLCYToFCYAndFCYToLCY(Salesprice, CurrencyTemp, VendCurr)
                                     else
                                         AdvancedPriceManage.ExchangeAmtFCYToFCY(Salesprice, VendCurr);

                                 IF LocalCurrency = VendCurr then
                                     AdvancedPriceManage.ExchangeAmtLCYToFCY(Salesprice, CurrencyTemp); */
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



