report 50001 "Update Prices with Currencies"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(DataItemName; "Item")
        {
            trigger OnPreDataItem();
            var
                CreatePurchaseDiscounts: codeunit "Advanced Price Management";
                ExceptThisOne: code[20];
                CurrencyTemp: Record Currency temporary;

            begin
                ExceptThisOne := "Vendor Currency";
                CreatePurchaseDiscounts.FindPriceCurrencies(ExceptThisOne, false, CurrencyTemp);
            end;

            trigger OnAfterGetRecord();
            var

            begin
                GLSetup.GET;
                Salesprice.SetRange("Item No.", "No.");
                If Salesprice.FindSet() then repeat
                                                 IF GLSetup."LCY Code" <> ExceptThisOne then begin
                                                     if Salesprice."Currency Code" = GLSetup."LCY Code" then begin
                                                         Salesprice."Unit Price" := CurrencyExcRate.ExchangeAmtFCYToLCY(Salesprice."Starting Date", Salesprice."Currency Code", Salesprice."Unit Price", CurrencyTemp."Currency Factor");
                                                         Salesprice."Starting Date" := Today;
                                                         Salesprice.Modify(true);
                                                     end;
                                                 end else begin
                                                     if Salesprice."Currency Code" <> GLSetup."LCY Code" then begin
                                                         Salesprice."Unit Price" := CurrencyExcRate.ExchangeAmtFCYToFCY(Salesprice."Starting Date", ExceptThisOne, Salesprice."Currency Code", Salesprice."Unit Price");
                                                         Salesprice."Starting Date" := Today;
                                                         Salesprice.Modify(true);
                                                     end;
                                                 end;

                                                 IF GLSetup."LCY Code" = ExceptThisOne then begin
                                                     Salesprice."Unit Price" := CurrencyExcRate.ExchangeAmtLCYToFCY(Salesprice."Starting Date", Salesprice."Currency Code", Salesprice."Unit Price", CurrencyTemp."Currency Factor");
                                                     Salesprice."Starting Date" := Today;
                                                     Salesprice.Modify(true);
                                                 end;

                    until Salesprice.next = 0;
            end;


        }
    }
    var
        CurrencyTemp: Record Currency temporary;
        Salesprice: record "Sales Price";
        ExceptThisOne: code[20];
        Currency: Record Currency;
        GLSetup: Record "General Ledger Setup";
        CurrencyExcRate: Record "Currency Exchange Rate";

}



