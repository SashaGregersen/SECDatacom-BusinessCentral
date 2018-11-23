pageextension 50022 "End Customer and Reseller 2" extends 41
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