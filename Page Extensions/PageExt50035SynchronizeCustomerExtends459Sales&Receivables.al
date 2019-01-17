pageextension 50035 "Synchronize Customer" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Create Item from Description")
        {
            field("Synchronize Customer"; "Synchronize Customer")
            {
                ApplicationArea = all;
            }

        }
        addafter("Direct Debit Mandate Nos.")
        {
            field("Bid Bo. Series"; "Bid No. Series")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {

    }

    var

}