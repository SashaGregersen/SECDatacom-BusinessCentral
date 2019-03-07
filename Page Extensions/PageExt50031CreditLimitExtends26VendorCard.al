pageextension 50031 "Credit Limit" extends 26
{
    layout
    {
        addafter("Pay-to Vendor No.")
        {
            field("Credit Limit Amount"; "Credit Limit Amount")
            {
                ApplicationArea = all;
            }
            field("Credit Limit Currency"; "Credit Limit Currency")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(ContactBtn)
        {
            action(VARInfo)
            {
                Caption = 'VAR';
                Image = Relationship;
                RunObject = Page "VAR";
                RunPageLink = "Vendor No." = field ("No.");
            }
        }
    }

    var
        myInt: Integer;
}