pageextension 50021 "End Customer and Reseller" extends 42
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

            }
        }
        addafter("External Document No.")
        {
            field("Drop-Shipment"; "Drop-Shipment")
            {

            }
        }
        modify(ShippingOptions)
        {
            Visible = false;
        }
    }

    actions
    {

    }


    var

}