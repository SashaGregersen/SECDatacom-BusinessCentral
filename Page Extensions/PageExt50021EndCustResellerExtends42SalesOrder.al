pageextension 50021 "End Customer and Reseller" extends 42
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
        
    }
    
    var
        myInt : Integer;
}