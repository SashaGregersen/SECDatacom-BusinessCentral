pageextension 50068 "Vendor Item 6" extends "Service Order Subform"
{
    layout
    {
        addafter("Vendor Item No.")
        {
            field("Vendor-Item-No"; "Vendor-Item-No")
            {
                ApplicationArea = all;
            }
        }
        modify("Vendor Item No.")
        {
            Visible = false;
        }
    }
}