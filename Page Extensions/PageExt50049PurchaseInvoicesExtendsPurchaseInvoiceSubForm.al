pageextension 50049 "Purchase Invoices" extends "Purch. Invoice Subform"
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