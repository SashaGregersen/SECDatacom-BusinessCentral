query 50012 "CustomerInsurance"
{
    Caption = 'CustomerInsurance';

    elements
    {
        dataitem(Customer; Customer)
        {
            column(No_; "No.")
            {
            }
            column(Country_Region_Code; "Country/Region Code")
            {
            }

            dataitem(Credit_Insurance; "Credit Insurance")
            {
                DataItemLink = "Customer No." = Customer."No.";
                column(Atradius_No_; "Atradius No.")
                {
                }
                column(Insured_Risk; "Insured Risk")
                {
                }

            }
        }
    }
}