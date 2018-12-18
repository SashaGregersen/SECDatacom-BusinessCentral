pageextension 50022 "End Customer and Reseller 2" extends 41
{
    layout
    {
        addbefore("Sell-to Customer No.")
        {
            field("End Customer"; "End Customer")
            {
                ApplicationArea = all;
            }
        }
        addafter("End Customer")
        {
            field(Reseller; Reseller)
            {
                ApplicationArea = all;
            }
        }
        addafter("reseller")
        {
            field(Subsidiary; Subsidiary)
            {
                ApplicationArea = all;
            }
        }
        addafter(Subsidiary)
        {
            field("Financing Partner"; "Financing Partner")
            {
                ApplicationArea = all;
            }
        }

        modify(ShippingOptions)
        {
            Visible = false;
        }

        addbefore("Ship-to Code")
        {
            field("Ship-To-Code"; "Ship-To-Code")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {

    }


    var

}