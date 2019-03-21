query 50005 "POS Report"
{
    QueryType = Normal;

    elements
    {
        dataitem(SalesInvoice; "Sales Invoice Header")
        {
            column(Document_No; "No.")
            {

            }
            column(External_Document_No; "External Document No.")
            {

            }
            column(Sales_Order_No; "Pre-Assigned No.")
            {

            }
            column(Currency_Code; "Currency Code")
            {

            }

            dataitem(Sales_Invoice_Line; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = SalesInvoice."No.";

                column(IC_Partner_Code; "IC Partner Code")
                {

                }
                column(Vendor_Code; "Shortcut Dimension 1 Code")
                {

                }

                column(Posting_Date; "Posting Date")
                {

                }
                column(Item_No; "No.")
                {

                }
                column(Description; Description)
                {

                }
                column(Quantity; Quantity)
                {

                }
                column(Unit_Cost; "Unit Cost")
                {

                }

                column(Unit_Cost__LCY; "Unit Cost (LCY)")
                {

                }

                column(Amount; Amount)
                {

                }
                column(Bid_No; "Bid No.")
                {

                }
                column(Shipment_No; "Shipment No.")
                {

                }

                dataitem(Item; Item)
                {
                    DataItemLink = "No." = Sales_Invoice_Line."No.";
                    column(Vendor_Item_No_; "Vendor Item No.")
                    {

                    }

                    Dataitem(Reseller; Customer)
                    {
                        DataItemLink = "No." = SalesInvoice.Reseller;
                        column(Reseller_Name; Name)
                        {

                        }
                        column(Reseller_Address; Address)
                        {

                        }
                        column(Reseller_Address_2; "Address 2")
                        {

                        }
                        column(Resller_Post_Code; "Post Code")
                        {

                        }
                        column(Reseller_City; City)
                        {

                        }
                        column(Reseller_Country_Region_Code; "Country/Region Code")
                        {

                        }
                        column(Reseller_County; County)
                        {

                        }
                        column(Reseller_Contact; Contact)
                        {

                        }
                        column(Reseller_Phone_No; "Phone No.")
                        {

                        }
                        column(Reseller_VAT_Registration_No; "VAT Registration No.")
                        {

                        }

                        dataitem(End_Customer; Customer)
                        {
                            DataItemLink = "No." = SalesInvoice."End Customer";
                            column(End_Customer_Name; Name)
                            {

                            }
                            column(End_Customer_Address; Address)
                            {

                            }
                            column(End_Customer_Address_2; "Address 2")
                            {

                            }
                            column(End_Customer_Post_Code; "Post Code")
                            {

                            }
                            column(End_Customer_City; City)
                            {

                            }
                            column(End_Customer_Country_Region_Code; "Country/Region Code")
                            {

                            }
                            column(End_Customer_County; County)
                            {

                            }
                            column(End_Customer_Phone_No; "Phone No.")
                            {

                            }
                            column(End_Customer_E_Mail; "E-Mail")
                            {

                            }


                        }

                    }
                }

            }

        }
    }

    var


    trigger OnBeforeOpen()
    begin

    end;
}