pageextension 50029 "End Customer and Reseller 9" extends 6660
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