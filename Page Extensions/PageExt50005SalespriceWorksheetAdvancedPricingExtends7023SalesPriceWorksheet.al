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

        }
    }

}