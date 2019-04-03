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
                              "Minimum Quantity" = const (0), "Currency Code" = field ("Vendor Currency");
                //starting date = today
                //sales type = all customers
                //variant code  = listprice
                //item no = item no
                //unit of measure = item base unit of meaure
                //min quantity = 0
                //currency code = item."vendor currency"
                //current unit price opdateres som standard 

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

                /*
                Yes	13	Sales Type	Option		
                Yes 2	Sales Code	Code	20	
                Yes	3	Currency Code	Code	10	
                Yes	7	Price Includes VAT	Boolean		
                Yes	10	Allow Invoice Disc.	Boolean		
                Yes	11	VAT Bus. Posting Gr. (Price)	Code	20	
                Yes	7001	Allow Line Disc.	Boolean		
                */


                /*
                Yes	5	Current Unit Price	Decimal		
                Yes	20	Item Description	Text	50	
                Yes	21	Sales Description	Text	50	
                Yes	5700	Variant Code	Code	10	
                */

            }
        }
    }
    var


}