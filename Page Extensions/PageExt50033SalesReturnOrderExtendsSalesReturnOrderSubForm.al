pageextension 50033 "Sales Return Orders" extends "Sales Return Order Subform"
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