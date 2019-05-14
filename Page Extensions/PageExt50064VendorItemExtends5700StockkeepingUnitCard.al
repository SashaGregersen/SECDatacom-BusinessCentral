pageextension 50064 "Vendor Item 2" extends "Stockkeeping Unit Card"
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