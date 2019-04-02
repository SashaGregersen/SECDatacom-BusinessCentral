pageextension 50041 "POS Report" extends "Purchases & Payables Setup"
{
    layout
    {
        addafter("Ignore Updated Addresses")
        {
            field("POS File Location"; "POS File Location")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {

    }

}