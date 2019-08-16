pageextension 50078 "Posted Return Shipment" extends "Posted Return Shipment Subform"
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