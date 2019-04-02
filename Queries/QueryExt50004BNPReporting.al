query 50004 "BNP Reporting"
{
    QueryType = Normal;

    elements
    {
        dataitem(CustLedgEntry; "Cust. Ledger Entry")
        {
            DataItemTableFilter = Open = CONST (true);
            column(Customer_No_; "Customer No.")
            {
                Caption = 'Customer No.';
            }
            column(Document_No_; "Document No.")
            {
                Caption = 'Document No.';
            }
            column(Document_Type; "Document Type")
            {
                Caption = 'Document Type';
            }

            column(Posting_Date; "Posting Date")
            {
                Caption = 'Posting Date';
            }
            column(Due_Date; "Due Date")
            {
                Caption = 'Due Date';
            }
            column(Amount; "Amount")
            {
                Caption = 'Amount';
            }

            column(Remaining_Amount; "Remaining Amount")
            {
                Caption = 'Remaining Amount';
            }

            column(Currency_Code; "Currency Code")
            {
                Caption = 'Currency Code';
            }
            dataitem(Customer; Customer)
            {
                DataItemLink = "No." = CustLedgEntry."Customer No.";
                column(Name; Name)
                {
                    Caption = 'Customer Name';
                }

                column(Address; Address)
                {
                    Caption = 'Address';
                }

                column(Address_2; "Address 2")
                {
                    Caption = 'Address 2';
                }

                column(Post_Code; "Post code")
                {
                    Caption = 'Post Code';
                }
                column(City; "city")
                {
                    Caption = 'City';
                }
                column(Country_Region_Code; "Country/Region Code")
                {
                    Caption = 'Country/Region Code';
                }
                column(VAT_Registration_No_; "VAT Registration No.")
                {
                    Caption = 'VAT Registration No.';
                }
                column(Customer_Posting_Group; "Customer Posting Group")
                {
                    Caption = 'Customer Posting Group';
                }
                dataitem(Cust_Post_Group; "Customer Posting Group")
                {
                    DataItemLink = Code = Customer."Customer Posting Group";

                    column(BNP_Account_No_; "BNP Account No.")
                    {
                        Caption = 'BNP Account No.';
                    }
                    dataitem(BNP_Reporting_Currency; "BNP Reporting Currency")
                    {
                        DataItemLink = "Currency Code" = CustLedgEntry."Currency Code";

                        column(BNP_Agreement_No_; "BNP Agreement No.")
                        {
                            Caption = 'BNP Agreement No.';
                        }
                    }

                }

            }

        }


    }

    var
        CustName: text[50];

    trigger OnBeforeOpen()
    begin
        SetFilter(Customer_Posting_Group, SetCustPostingGroup());
    end;

    local procedure SetCustPostingGroup() Filtertext: Text
    var
        CustPostGroup: record "Customer Posting Group";
    begin
        CustPostGroup.SetFilter("BNP Account No.", '<>%1', '');
        if CustPostGroup.FindSet() then
            repeat
                Filtertext := Filtertext + CustPostGroup.Code + '|';
            until CustPostGroup.next = 0;
        Filtertext := Delchr(Filtertext, '>', '|');
    end;
}