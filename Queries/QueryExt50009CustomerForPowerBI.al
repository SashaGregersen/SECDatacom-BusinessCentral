query 50009 CustomerForPowerBI
{
    QueryType = Normal;

    elements
    {
        dataitem(Customer; "Customer")
        {
            column(Name; Name) { }
            column(No; "No.") { }
            column(Address; "Address") { }
            column(Address_2; "Address 2") { }
            column(City; "City") { }
            column(Post_Code; "Post Code") { }
            column(Country_Region_Code; "Country/Region Code") { }
            column(Contact; "Contact") { }
            column(Customer_Type; "Customer Type") { }
            column(IC_Partner_Code; "IC Partner Code") { }
            column(Phone_No_; "Phone No.") { }
            column(Salesperson_Code; "Salesperson Code") { }
            column(VAT_Registration_No_; "VAT Registration No.") { }
            column(Customer_Posting_Group; "Customer Posting Group") { }
            column(Payment_Terms_Code; "Payment Terms Code") { }
            column(Currency_Code; "Currency Code") { }
            column(Blocked; Blocked) { }
            column(Owning_Company; "Owning Company") { }
        }
    }
}