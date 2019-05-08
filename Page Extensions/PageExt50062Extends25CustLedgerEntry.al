pageextension 50062 CustomerLedgerEntry extends "Customer Ledger Entries"
{
    layout
    {
        addafter("Customer Name")
        {
            field("Customer Posting Group"; "Customer Posting Group")
            {
                ApplicationArea = all;
            }
        }
    }
}