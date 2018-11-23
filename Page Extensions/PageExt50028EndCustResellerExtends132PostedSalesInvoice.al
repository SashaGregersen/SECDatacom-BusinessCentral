pageextension 50028 "End Customer and Reseller 8" extends 132
{
    layout
    {
        addbefore("No.")
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