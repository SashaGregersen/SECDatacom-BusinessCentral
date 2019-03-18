pageextension 50026 "End Customer and Reseller 6" extends 44
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
        addbefore("Salesperson Code")
        {
            field("Suppress Prices on Printouts"; "Suppress Prices on Printouts")
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


}