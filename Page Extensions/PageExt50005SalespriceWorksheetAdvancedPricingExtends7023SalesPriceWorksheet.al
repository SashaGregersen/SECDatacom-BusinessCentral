pageextension 50005 "Price Wrksh. Adv. Pricing" extends "Sales Price Worksheet"
{
    layout
    {
        addafter("Item No.")
        {
            field("Vendor Item No"; "Vendor Item No.")
            {
                ApplicationArea = all;
            }
            field("Vendor No"; "Vendor No.")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter("I&mplement Price Change")
        {
            action("Update prices from Discounts")
            {
                Image = ItemGroup;
                trigger OnAction();
                var
                    AdvpricingMgt: Codeunit "Advanced Price Management";
                begin
                    AdvpricingMgt.UpdatePricesfromWorksheet();
                end;
            }
            action("Import list prices")
            {
                Image = ItemGroup;
                trigger OnAction();
                var
                    FileMgtImport: Codeunit "File Management Import";
                begin
                    FileMgtImport.ImportSalesPricesFromCSV();
                end;
            }
            action("Import cost prices")
            {
                Image = ItemGroup;
                trigger OnAction();
                var
                    FileMgtImport: Codeunit "File Management Import";
                    PurchasePricePage: Page "Purchase Prices";
                    PurchasePrice: Record "Purchase Price";
                    TempItem: record item temporary;
                    NonExistingItems: page "Non-Exisiting Items";
                begin
                    PurchasePrice.Init();
                    TempItem.DeleteAll();

                    FileMgtImport.ImportCostPricesFromCSV(PurchasePrice, TempItem);
                    PurchasePricePage.SETTABLEVIEW(PurchasePrice);
                    PurchasePricePage.RUN;
                    /* if TempItem.Count > 0 then begin
                        NonExistingItems.SetTableView(TempItem);
                        NonExistingItems.Run();
                    end; */
                    CurrPage.CLOSE
                end;
            }

        }
    }

}