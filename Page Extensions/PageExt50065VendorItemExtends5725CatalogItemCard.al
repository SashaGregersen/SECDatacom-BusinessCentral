pageextension 50065 "Vendor Item 3" extends "Catalog Item Card"
{
    layout
    {
        addafter("Vendor Item No.")
        {
            field("Vendor-Item-No"; "Vendor-Item-No")
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