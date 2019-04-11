pageextension 50009 "Item Adv. Pricing" extends "Item Card"
{
    layout
    {
        addafter("Vendor Item No.")
        {
            field("Vendor Currency"; "Vendor Currency")
            {
                ApplicationArea = All;
            }
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
            action(SalesPriceWorkSheet)
            {
                Caption = 'Sales Price Worksheet';
                Image = SalesPrices;
                ApplicationArea = All;
                RunObject = Page "Sales Price Worksheet";
                RunPageLink = "Item No." = field ("No."),
                              "Unit of Measure Code" = field ("Sales Unit of Measure"),
                              "Minimum Quantity" = const (0),
                              "Currency Code" = field ("Vendor Currency"),
                              "Sales Type" = const ("All Customers"),
                              "Variant Code" = const ('LISTPRICE'),
                              "Unit of Measure Code" = field ("Base Unit of Measure");
                //starting date = today - event trigger CU50051

                /* trigger OnAction()
                var
                    SalesPriceWksPage: Page "Sales Price Worksheet";
                    SalesPriceWks: Record "Sales Price Worksheet";
                begin
                    SalesPriceWks.setrange("Item No.", Rec."No.");
                    SalesPriceWks.SetValues(SalesPriceWks, Rec);
                    SalesPriceWksPage.SetTableView(SalesPriceWks);
                    SalesPriceWksPage.RunModal();
                end; */
            }
        }
    }
    var


}