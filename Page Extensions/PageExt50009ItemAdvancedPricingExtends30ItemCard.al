pageextension 50009 "Item Adv. Pricing" extends "Item Card"
{
    layout
    {
        addafter("Vendor Item No.")
        {
            field("Vendor-Item-No."; "Vendor-Item-No.")
            {
                ApplicationArea = all;
                Caption = 'Vendor Item No.';
            }
            field("Vendor Currency"; "Vendor Currency")
            {
                ApplicationArea = All;
            }
        }
        modify("Vendor Item No.")
        {
            Visible = false;
        }
        addafter("Profit %")
        {
            field("Transfer Price %"; "Transfer Price %")
            {
                ApplicationArea = All;
            }
        }
        addafter("Automatic Ext. Texts")
        {
            field("Use on Website"; "Use on Website")
            {
                ApplicationArea = all;
                caption = 'Show in E-shop/Price file';
            }
        }
        addafter("Shelf No.")
        {
            field("Default Location"; "Default Location")
            {
                ApplicationArea = all;
            }
        }
        addafter(Blocked)
        {
            field("Blocked from purchase"; "Blocked from purchase")
            {
                ApplicationArea = all;
            }
        }

    }

    actions
    {
        addafter("Set Special Discounts")
        {
            action(CreateICPrices)
            {
                Caption = 'Create IC Prices';
                Image = UpdateUnitCost;
                ApplicationArea = All;
                trigger OnAction()
                var
                    AdvPriceMgt: Codeunit "Advanced Price Management";
                begin
                    AdvPriceMgt.CreatePricesForICPartners("No.", "Vendor No.");
                end;
            }
            action(AddNewListPrice)
            {
                Caption = 'Add New List Price';
                Image = SalesPrices;
                ApplicationArea = All;

                trigger OnAction()
                var
                    SalesPriceWksPage: Page "Sales Price Worksheet";
                    SalesPriceWks: Record "Sales Price Worksheet";
                begin
                    SalesPriceWks.CreateNewListPriceFromItem(Rec, true);
                    Commit();
                    SalesPriceWks.setrange("Item No.", "No.");
                    SalesPriceWksPage.SetTableView(SalesPriceWks);
                    SalesPriceWksPage.RunModal();
                end;
            }
        }
    }
    var


}