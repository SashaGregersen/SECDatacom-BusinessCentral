pageextension 50045 "Bid on Purchase Line" extends "Purchase Order Subform"
{
    layout
    {
        addbefore("Direct Unit Cost")
        {


            Field("Bid No."; "Bid No.")
            {
                ApplicationArea = All;
            }


        }
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


}