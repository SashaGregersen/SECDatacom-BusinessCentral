pageextension 50031 "Credit Limit" extends "Vendor Card"
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
            field("Claims Vendor"; "Claims Vendor")
            {
                ApplicationArea = All;
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