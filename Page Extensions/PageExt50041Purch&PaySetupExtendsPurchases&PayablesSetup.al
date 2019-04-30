pageextension 50041 "POS Report" extends "Purchases & Payables Setup"
{
    layout
    {
        addafter("Ignore Updated Addresses")
        {
            field("Claims Charge No."; "Claims Charge No.")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {

    }

}