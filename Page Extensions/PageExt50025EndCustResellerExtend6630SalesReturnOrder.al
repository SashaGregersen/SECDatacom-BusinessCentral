pageextension 50025 "End Customer and Reseller 5" extends 6630
{
    layout
    {
        addbefore("Sell-to Customer No.")
        {
            field("End Customer";"End Customer")
            {
                ApplicationArea = all;
            }
        }
        addafter("End Customer")
        {
            field(Reseller;Reseller)
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
    
    var
        myInt : Integer;
}