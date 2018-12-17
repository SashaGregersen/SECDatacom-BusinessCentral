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

            column(Reseller; Reseller)
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

                dataitem(Customer; Customer)
                {
                    DataItemLink = "No." = Sales_Invoice_Header."End Customer";
                    column(End_Customer_Id; Id)
                    {
                    }
                    column(Reseller_Id; Id)
                    {
                    }
                    dataitem(CRM_Integration_Record; "CRM Integration Record")
                    {
                        DataItemLink = "Integration ID" = "Customer".Id;
                        column(End_Customer_CRM_ID; "CRM ID")
                        {
                        }
                        column(Reseller_CRM_ID; "CRM ID")
                        {

                        }
                    }


                }
            }

        }
    }
}