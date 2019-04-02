pageextension 50019 "BNP Reporting" extends "Customer Posting Groups"
{
    layout
    {
        addafter("Credit Rounding Account")
        {
            field("BNP Account No."; "BNP Account No.")
            {
                ApplicationArea = all;
            }
        }
    }

}