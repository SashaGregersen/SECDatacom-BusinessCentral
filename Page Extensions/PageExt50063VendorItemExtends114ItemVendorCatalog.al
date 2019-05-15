pageextension 50063 "Vendor Item 1" extends "Item Vendor Catalog"
{
    layout
    {
        addafter("Vendor Item No.")
        {
            field("Vendor-Item-No."; "Vendor-Item-No.")
            {
                ApplicationArea = all;
                Caption = 'Vendor Item No.';
            }
        }
        modify("Vendor Item No.")
        {
            Visible = false;
        }
    }

}