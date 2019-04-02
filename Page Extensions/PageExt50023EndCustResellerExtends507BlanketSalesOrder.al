pageextension 50023 "End Customer and Reseller 3" extends 507
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
        addbefore("End Customer")
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
        addafter("External Document No.")
        {
            field("Drop-Shipment"; "Drop-Shipment")
            {
                ApplicationArea = all;
                Caption = 'Deliver directly to end customer';
            }

            field("Ship directly from supplier"; "Ship directly from supplier")
            {
                ApplicationArea = all;
            }
        }
        modify(ShippingOptions)
        {
            Visible = false;
        }
        modify(Control4)
        {
            Visible = true;
        }
        addbefore("Ship-to Code")
        {
            field("Ship-To-Code"; "Ship-To-Code")
            {
                ApplicationArea = all;
                Caption = 'Ship-to Code';
            }
        }
        modify("Sell-to Customer No.")
        {
            Visible = false;
        }
        modify("Sell-to Customer Name")
        {
            Visible = false;
        }
        addafter("Sell-to Customer No.")
        {
            field("Sell-to-Customer-Name"; "Sell-to-Customer-Name")
            {
                ApplicationArea = all;
                Caption = 'Sell-to Customer Name';
            }
        }
    }

    actions
    {

    }

    var

}