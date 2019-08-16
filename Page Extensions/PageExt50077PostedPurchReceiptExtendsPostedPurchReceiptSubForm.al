pageextension 50077 "Posted Purch Receipt" extends "Posted Purchase Rcpt. Subform"
{
    layout
    {
        addafter("No.")
        {
            field("Vendor-Item-No"; "Vendor-Item-No")
            {
                Caption = 'Vendor Item No.';
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