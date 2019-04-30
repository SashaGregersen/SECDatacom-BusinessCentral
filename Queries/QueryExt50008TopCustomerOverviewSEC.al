query 50008 "Top Customer Overview SEC"
{
    Caption = 'Top Customer Overview SEC';

    elements
    {
        dataitem(Customer; "Customer")
        {
            column(Name; Name)
            {
            }
            column(No; "No.")
            {
            }
            column(Sales_LCY; "Sales (LCY)")
            {
            }
            column(Profit_LCY; "Profit (LCY)")
            {
            }
            column(Country_Region_Code; "Country/Region Code")
            {
            }
            column(City; City)
            {
            }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code")
            {
            }
            column(Global_Dimension_2_Code; "Global Dimension 2 Code")
            {
            }
            column(Salesperson_Code; "Salesperson Code")
            {
            }
            filter(Owning_Company; "Owning Company")
            {
            }
            dataitem(Salesperson_Purchaser; "Salesperson/Purchaser")
            {
                DataItemLink = Code = Customer."Salesperson Code";
                column(SalesPersonName; Name)
                {
                }
                dataitem(CountryRegion; "Country/Region")
                {
                    DataItemLink = Code = Customer."Country/Region Code";
                    column(CountryRegionName; Name)
                    {
                    }
                }
            }

        }

    }
    trigger OnBeforeOpen()
    begin
        CurrQuery.SetFilter(Owning_Company, CompanyName);
    end;

}
