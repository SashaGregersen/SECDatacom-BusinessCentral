pageextension 50025 "End Customer and Reseller 5" extends 6630
{
    layout
    {
        addbefore("Sell-to Customer No.")
        {
            field(Reseller; Reseller)
            {
                ApplicationArea = all;
            }
            field("End Customer"; "End Customer")
            {
                ApplicationArea = all;
            }
        }
        addafter("End Customer")
        {
            field("End Customer Name"; "End Customer Name")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("End Customer Contact"; "End Customer Contact")
            {
                ApplicationArea = all;
                Importance = Additional;
            }
            field("End Customer Contact Name"; "End Customer Contact Name")
            {
                ApplicationArea = all;
                Importance = Additional;
            }
            field("End Customer Phone No."; "End Customer Phone No.")
            {
                ApplicationArea = all;
                Importance = Additional;
            }
            field("End Customer Email"; "End Customer Email")
            {
                ApplicationArea = all;
                Importance = Additional;
            }
        }
        addafter("reseller")
        {
            field("Reseller Name"; "Reseller Name")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field(Subsidiary; Subsidiary)
            {
                ApplicationArea = all;
                Caption = 'Subsidiary No.';
            }
        }
        addafter(Subsidiary)
        {
            field("Subsidiary Name"; "Subsidiary Name")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Financing Partner"; "Financing Partner")
            {
                ApplicationArea = all;
                Caption = 'Financing Partner No.';
            }
        }
        addafter("Financing Partner")
        {
            field("Financing Partner Name"; "Financing Partner Name")
            {
                ApplicationArea = all;
                Editable = false;
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

    actions
    {
        // Add changes to page actions here
    }


    var

}