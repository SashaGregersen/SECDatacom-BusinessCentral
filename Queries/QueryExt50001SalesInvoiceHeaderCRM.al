query 50001 "PowerBISalesInvoiceHeaderCRM"
{
    Caption = 'PowerBISalesInvoiceHeaderCRM';

    elements
    {
        dataitem(Sales_Invoice_Header; "Sales Invoice Header")
        {
            column(End_Customer; "End Customer")
            {
            }
            column(Reseller; "Reseller")
            {
            }
            column(Posting_Date; "Posting Date")
            {
            }

            dataitem(Cust__Ledger_Entry; "Cust. Ledger Entry")
            {
                DataItemLink = "Entry No." = Sales_Invoice_Header."Cust. Ledger Entry No.";
                column(Original_Amt___LCY_; "Original Amt. (LCY)")
                {
                }

            }
        }
    }
}