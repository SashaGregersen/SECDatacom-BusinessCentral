query 50001 "Power BI Sales Lines CRM"
{
    Caption = 'Power BI Sales Lines CRM';

    elements
    {
        dataitem(Sales_Invoice_Header; "Sales Invoice Header")
        {
            column(End_Customer; "End Customer")
            {
            }

            dataitem(Sales_Invoice_Line; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = Sales_Invoice_Header."No.";
                column(Amount; "Amount")
                {

                }
            }
        }
    }
}
