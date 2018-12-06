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
                        Salesprice.SetRange("Item No.", "No.");
                        If Salesprice.FindSet() then
                            repeat
                                if Salesprice."Currency Code" = "Vendor Currency" then
                                    exit;

                                IF GLSetup."LCY Code" <> "Vendor Currency" then begin
                                    if Salesprice."Currency Code" = GLSetup."LCY Code" then
                                        AdvancedPriceManage.ExchangeAmtFCYToLCY(Salesprice, CurrencyTemp);
                                end else begin
                                    if Salesprice."Currency Code" <> GLSetup."LCY Code" then begin
                                        VendCurr := "Vendor Currency";
                                        AdvancedPriceManage.ExchangeAmtFCYToFCY(Salesprice, VendCurr);
                                    end;
                                end;

                                IF GLSetup."LCY Code" = "Vendor Currency" then begin
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
        ExceptThisOne: code[20];
        GLSetup: Record "General Ledger Setup";


}



