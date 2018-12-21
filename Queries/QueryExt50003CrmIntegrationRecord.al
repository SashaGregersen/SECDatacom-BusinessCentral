query 50003 "CRMIntegrationRecord"
{
    Caption = 'CRMIntegrationRecord';

    elements
    {
        dataitem(Customer; Customer)
        {
            column(No_; "No.")
            {
            }
            column(Id; Id)
            {

            }
            dataitem(CRM_Integration_Record; "CRM Integration Record")
            {
                DataItemLink = "Integration ID" = "Customer".Id;
                column(End_Customer_CRM_ID; "CRM ID")

                {

                }

            }
        }
    }
}