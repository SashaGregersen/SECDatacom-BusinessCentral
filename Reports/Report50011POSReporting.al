report 50011 "POS Reporting"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    UseRequestPage = false;


    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
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
            column(Reseller; Reseller)
            {

            }
            column(End_Customer; "End Customer")
            {

            }
            column(Ship_to_Name; "Ship-to Name")
            {

            }
            column(Ship_to_Name_2; "Ship-to Name 2")
            {

            }
            column(Ship_to_Address; "Ship-to Address")
            {

            }
            column(Ship_to_Address_2; "Ship-to Address 2")
            {

            }
            column(Ship_to_City; "Ship-to City")
            {

            }
            column(Ship_to_Post_Code; "Ship-to Post Code")
            {

            }
            column(Ship_to_Country_Region_Code; "Ship-to Country/Region Code")
            {

            }
            column(Ship_to_County; "Ship-to County")
            {

            }
            column(Ship_to_Contact; "Ship-to Contact")
            {

            }
            // indsæt phone + email på kontakt hvis nye felter skal på 
            column(ResellEndCustName; ResellEndCustName)
            {

            }
            column(ResellEndCustName2; ResellEndCustName2)
            {

            }
            column(ResellEndCustAddress; ResellEndCustAddress)
            {

            }
            column(ResellEndCustAddress2; ResellEndCustAddress2)
            {

            }
            column(ResellEndCustCity; ResellEndCustCity)
            {

            }
            column(ResellEndCustPostCode; ResellEndCustPostCode)
            {

            }
            column(ResellEndCustCountryRegion; ResellEndCustCountryRegion)
            {

            }
            column(ResellEndCustCounty; ResellEndCustCounty)
            {

            }
            column(ResellEndCustContact; ResellEndCustContact)
            {

            }
            column(ResellEndCustContactEmail; ResellEndCustEmail)
            {

            }
            column(ResellEndCustContactPhone; ResellEndCustPhone)
            {

            }

            dataitem(Sales_Invoice_Line; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = field ("No.");

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
                column(ListPrice; Listprice)
                {

                }
                column(Bid_No; "Bid No.")
                {

                }
                column(Shipment_No; "Shipment No.")
                {

                }
                column(Shipment_Date; "Shipment Date")
                {

                }
                dataitem(Item; Item)
                {
                    DataItemLink = "No." = field ("No.");
                    column(Vendor_Item_No_; "Vendor Item No.")
                    {

                    }

                    column(Vendor_Currency; "Vendor Currency")
                    {

                    }
                    dataitem("Item Disc. Group Percentages"; "Item Disc. Group Percentages")
                    {
                        DataItemLink = "Item Disc. Group Code" = field ("Item Disc. Group");

                        column(Purchase_Discount_Percentage; "Purchase Discount Percentage")
                        {
                            // hvordan finder vi den rigtige %
                        }
                    }
                    dataitem("VAR"; "VAR")
                    {
                        DataItemLink = "Vendor No." = field ("Vendor No.");

                        column(VAR_id; "VAR id")
                        {

                        }

                    }

                }
                dataitem("Item Ledger Entry"; "Item Ledger Entry")
                {
                    DataItemLink = "Item No." = field ("No."), "Posting Date" = field ("Posting Date");

                    column(Serial_No_; "Serial No.")
                    {

                    }
                    column(PurchOrderNo; PurchOrderNo)
                    {

                    }
                    column(PurchOrderPostDate; PurchOrderPostDate)
                    {

                    }
                    column(PurchCostPrice; PurchCostPrice)
                    {

                    }
                    column(PurchCostPriceLCY; PurchCostPriceLCY)
                    {

                    }

                }
                dataitem("Bid Item Price"; "Bid Item Price")
                {
                    DataItemLink = "Bid No." = field ("Bid No.");

                    column(Bid_Purchase_Discount_Pct_; "Bid Purchase Discount Pct.")
                    {

                    }
                }

            }

            trigger OnPreDataItem()
            var
                Customer: record Customer;
                PurchInvHeader: record "Purch. Inv. Header";
                ItemLedgEntry: Record "Item Ledger Entry";
                PurchInvLine: Record "Purch. Inv. Line";
                VARID: record "VAR";
            begin
                if "Sales Invoice Header"."Drop-Shipment" then begin
                    Customer.get("Reseller");
                    ResellEndCustName := Customer.name;
                    ResellEndCustName2 := Customer."Name 2";
                    ResellEndCustAddress := Customer.Address;
                    ResellEndCustAddress2 := Customer."Address 2";
                    ResellEndCustCity := Customer.City;
                    ResellEndCustPostCode := Customer."Post Code";
                    ResellEndCustCounty := Customer.County;
                    ResellEndCustCountryRegion := Customer."Country/Region Code";
                    ResellEndCustContact := Customer.Contact;
                end else begin
                    Customer.get("End Customer");
                    ResellEndCustName := Customer.name;
                    ResellEndCustName2 := Customer."Name 2";
                    ResellEndCustAddress := Customer.Address;
                    ResellEndCustAddress2 := Customer."Address 2";
                    ResellEndCustCity := Customer.City;
                    ResellEndCustPostCode := Customer."Post Code";
                    ResellEndCustCounty := Customer.County;
                    ResellEndCustCountryRegion := Customer."Country/Region Code";
                    ResellEndCustContact := Customer.Contact;
                    ResellEndCustPhone := Customer."Phone No.";
                    ResellEndCustEmail := Customer."E-Mail";
                end;

                "VAR".setrange("Customer No.", "Sales Invoice Header".Reseller);

                "Item Ledger Entry".setrange("Document No.", Sales_Invoice_Line."Shipment No.");
                "Item Ledger Entry".setRange("Document Type", 1);
                "Item Ledger Entry".setrange("Document Line No.", Sales_Invoice_Line."Shipment Line No.");
                //"Item Ledger Entry".setFilter("Serial No.", '<>%1', ' ');
                if "Item Ledger Entry".FindFirst() then begin
                    ItemLedgEntry.SetRange("Serial No.", "Item Ledger Entry"."Serial No.");
                    ItemLedgEntry.SetRange("Entry Type", 1);
                    if ItemLedgEntry.FindFirst() then begin
                        PurchInvHeader.Get(ItemLedgEntry."Document No.");
                        PurchOrderNo := PurchInvHeader."No.";
                        PurchOrderPostDate := PurchInvHeader."Posting Date";
                        PurchInvLine.get(PurchInvHeader."No.", ItemLedgEntry."Document Line No.");
                        PurchCostPrice := PurchInvLine."Unit Cost";
                        PurchCostPriceLCY := PurchInvLine."Unit Cost (LCY)";
                    end;
                end;
            end;

            trigger OnAfterGetRecord()
            var

            begin
                CurrReport.Break();
            end;

            trigger OnPostDataItem()
            var

            begin

            end;

        }
        /* dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {

        } */
    }

    var
        PurchOrderNo: code[20];
        PurchOrderPostDate: Date;
        PurchCostPrice: decimal;
        PurchCostPriceLCY: decimal;
        ListPrice: Decimal;
        ResellEndCustName: text[50];
        ResellEndCustName2: text[50];
        ResellEndCustAddress: text[50];
        ResellEndCustAddress2: text[50];
        ResellEndCustCity: text[30];
        ResellEndCustPostCode: code[20];
        ResellEndCustCounty: text[30];
        ResellEndCustCountryRegion: code[10];
        ResellEndCustContact: text[50];
        ResellEndCustPhone: text[30];
        ResellEndCustEmail: text[80];

}