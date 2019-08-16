pageextension 50046 "Posted Sales Credit Memo" extends "Posted Sales Cr. Memo Subform"
{
    layout
    {
        addafter("No.")
        {
            field("Vendor Item No."; "Vendor Item No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

}