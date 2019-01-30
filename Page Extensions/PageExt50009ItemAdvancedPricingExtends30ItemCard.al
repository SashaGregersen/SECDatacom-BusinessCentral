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
            }
        }
        addafter("Shelf No.")
        {
            field("Default Location"; "Default Location")
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
                Caption = 'CreateICPrices';
                Image = UpdateUnitCost;
                ApplicationArea = All;
                trigger OnAction()
                var
                    AdvPriceMgt: Codeunit "Advanced Price Management";
                begin
                    AdvPriceMgt.CreatePricesForICPartners("No.", "Vendor No.");
                end;
            }
        }
    }


}