pageextension 50069 "Vendor Item 7" extends "Warranty Ledger Entries"
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