pageextension 50047 "Sales Return Receipt" extends "Posted Return Receipt Subform"
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