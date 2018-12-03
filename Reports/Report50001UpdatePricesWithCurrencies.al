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
                Salesprice: record "Sales Price";
                ExceptThisOne: code[20];
                CurrencyTemp: Record Currency temporary;

            begin
                Salesprice.SetRange("Item No.", "No.");
                If Salesprice.FindSet() then begin
                    ExceptThisOne := "Vendor Currency";
                    CreatePurchaseDiscounts.FindPriceCurrencies(ExceptThisOne, false, CurrencyTemp);
                end;

            end;

            trigger OnAfterGetRecord();
            var

            begin

            end;


        }
    }
    var


}



