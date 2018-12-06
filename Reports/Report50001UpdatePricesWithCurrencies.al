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
                CreatePurchaseDiscounts: codeunit "Advanced Price Management";
            begin
                if not GLSetup.get then
                    exit;
                If GLSetup."LCY Code" = '' then
                    exit;
                LocalCurrency := '';
                CreatePurchaseDiscounts.FindPriceCurrencies(ExceptThisOne, true, CurrencyTemp);
            end;

            trigger OnAfterGetRecord();
            var
                AdvancedPriceManage: Codeunit "Advanced Price Management";
                VendCurr: Code[10];
            begin
                SetRange("No.", '70061');
                if findfirst then
                    repeat
                        VendCurr := "Vendor Currency";
                        Salesprice.SetRange("Item No.", "No.");
                        If Salesprice.FindSet() then
                            repeat
                                if Salesprice."Currency Code" = VendCurr then
                                    exit;

                                IF LocalCurrency <> VendCurr then begin
                                    if Salesprice."Currency Code" = LocalCurrency then
                                        AdvancedPriceManage.ExchangeAmtFCYToLCY(Salesprice, CurrencyTemp, VendCurr);
                                end else begin
                                    if Salesprice."Currency Code" <> LocalCurrency then begin
                                        AdvancedPriceManage.ExchangeAmtFCYToFCY(Salesprice, VendCurr);
                                    end;
                                end;

                                IF LocalCurrency = VendCurr then begin
                                    AdvancedPriceManage.ExchangeAmtLCYToFCY(Salesprice, CurrencyTemp);
                                end;

                            until Salesprice.next = 0;
                    until next = 0;
            end;


        }
    }
    var
        CurrencyTemp: Record Currency temporary;
        Salesprice: record "Sales Price";
        ExceptThisOne: code[10];
        GLSetup: Record "General Ledger Setup";
        LocalCurrency: code[10];


}



