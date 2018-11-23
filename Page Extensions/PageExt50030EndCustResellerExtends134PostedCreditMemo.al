pageextension 50030 "End Customer and Reseller 10" extends 134
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