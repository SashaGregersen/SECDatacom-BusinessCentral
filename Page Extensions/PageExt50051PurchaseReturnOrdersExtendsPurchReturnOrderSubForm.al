pageextension 50051 "Purchase Return Orders" extends "Purchase Return Order Subform"
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