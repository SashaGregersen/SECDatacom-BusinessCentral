query 50002 "PowerBISalesCreditHeaderCRM"
{
    Caption = 'PowerBISalesCreditHeaderCRM';

    elements
    {
        dataitem(Sales_Cr_Memo_Header; "Sales Cr.Memo Header")
        {
            column(End_Customer; "End Customer")
            {
            }
            column(Reseller; Reseller)
            {

            }
            column(Posting_Date; "Posting Date")
            {
            }
            dataitem(Cust__Ledger_Entry; "Cust. Ledger Entry")
            {
                DataItemLink = "Entry No." = Sales_Cr_Memo_Header."Cust. Ledger Entry No.";
                column(Original_Amt___LCY_; "Original Amt. (LCY)")
                {
                }

            }
        }
    }
}