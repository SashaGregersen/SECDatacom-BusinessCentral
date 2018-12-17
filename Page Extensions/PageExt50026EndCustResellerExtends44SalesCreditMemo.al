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

    }

    actions
    {

    }


    var

}