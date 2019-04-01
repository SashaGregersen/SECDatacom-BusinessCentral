report 50011 "POS Reporting"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = false;
    UseRequestPage = true;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/POSReport.rdl';
    Caption = 'POS Report';

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "Posting Date";

            column(Document_No; "No.")
            {

            }
            column(External_Document_No; "External Document No.")
            {

            }
            column(Sales_Order_No; "Order No.")
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
            column(VAR_id; VARIDInt)
            {

            }

            dataitem(Sales_Invoice_Line; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = field ("No.");

                column(Shipment_No; "Shipment No.")
                {

                }
                column(Shipment_Date; "Shipment Date")
                {

                }
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
                column(Bid_No; "Bid No.")
                {

                }
                column(Purch_Order_No; PurchOrderNo)
                {

                }
                column(Purch_Order_Posting_Date; PurchOrderPostDate)
                {

                }
                dataitem(Item; Item)
                {
                    DataItemLink = "No." = field ("No.");
                    column(Vendor_Item_No_; "Vendor Item No.")
                    {

                    }

                }
                dataitem("Bid Item Price"; "Bid Item Price")
                {
                    DataItemLink = "Bid No." = field ("Bid No."), "item No." = field ("No."), "Customer No." = field ("Sell-to Customer No."); // hvordan skal vi lave dette link

                    column(Unit_List_Price; "Unit List Price")
                    {

                    }
                    column(Bid_Purchase_Discount_Pct_; "Bid Purchase Discount Pct.")
                    {

                    }
                    column(Bid_Unit_Purchase_Price; "Bid Unit Purchase Price")
                    {

                    }
                    column(Bid_Unit_Purchase_Price_LCY; BidUnitPurchasePriceLCY)
                    {
                        //omregn med currency exchange rate på hovedet 
                    }
                    column(Cost_Percentage; CostPercentage)
                    {
                        //omregn vha. (unit purch pric - bid unit purch price) / unit purch price    
                    }

                    trigger OnAfterGetRecord()
                    begin
                        CostPercentage :=
                        (Sales_Invoice_Line."Unit Purchase Price" - "Bid Unit Purchase Price") /
                        Sales_Invoice_Line."Unit Purchase Price";
                        if "Sales Invoice Header"."Currency Code" <> GlSetup."LCY Code" then
                            BidUnitPurchasePriceLCY :=
                            POSReportExport.ExchangeAmtLCYToFCYAndFCYToLCY(Sales_Invoice_Line."Bid Unit Purchase Price",
                            "Sales Invoice Header"."Currency Code", "Sales Invoice Header"."Currency Factor")
                        else
                            BidUnitPurchasePriceLCY := "Bid Unit Purchase Price";
                    end;
                }

                dataitem(Copyloop; Integer)
                {

                    column(SerialNo; SerialNo)
                    {

                    }
                    column(Quantity; Qty)
                    {

                    }

                    trigger OnPreDataItem()
                    var
                        ValueEntry: record "Value Entry";
                        ItemLedgEntry: record "Item Ledger Entry";
                        TempItemLedgEntry: record "Item Ledger Entry" temporary;
                    begin
                        ValueEntry.SetRange("Document No.", Sales_Invoice_Line."Document No.");
                        ValueEntry.SetRange("Document Line No.", Sales_Invoice_Line."Line No.");
                        if ValueEntry.findfirst then begin
                            if ItemLedgEntry.get(ValueEntry."Item Ledger Entry No.") then begin //er det nødvendigt med en get her?
                                POSReportExport.RetrieveEntriesFromPostedInv(TempItemLedgEntry, Sales_Invoice_Line.RowID1());
                                Copyloop.Number := TempItemLedgEntry.count();
                                if Copyloop.Number = 1 then
                                    Qty := Sales_Invoice_Line.Quantity;
                                if Copyloop.Number > 1 then
                                    Qty := 1;
                            end;
                        end;
                    end;

                    trigger OnAfterGetRecord()
                    var
                        ValueEntry: record "Value Entry";
                        ItemLedgEntry: record "Item Ledger Entry";
                        TempItemLedgerEntry: record "Item Ledger Entry" temporary;
                        ItemLedgEntry2: record "Item Ledger Entry";
                    begin
                        TempItemLedgerEntry.DeleteAll();
                        ValueEntry.SetRange("Document No.", Sales_Invoice_Line."Document No.");
                        ValueEntry.SetRange("Document Line No.", Sales_Invoice_Line."Line No.");
                        if ValueEntry.findfirst then begin
                            if ItemLedgEntry.get(ValueEntry."Item Ledger Entry No.") then begin //er det nødvendigt med en get her?
                                if ItemLedgEntry."Serial No." <> '' then
                                    SerialNo := ItemLedgEntry."Serial No."
                                else begin
                                    POSReportExport.FindAppliedEntry(ItemLedgEntry, TempItemLedgerEntry);
                                    if ValueEntry.get(TempItemLedgerEntry."Entry No.") then begin
                                        if ItemLedgEntry2.get(ValueEntry."Item Ledger Entry No.") then begin
                                            if ItemLedgEntry2."Serial No." <> '' then
                                                SerialNo := ItemLedgEntry2."Serial No.";
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                }


            }

            trigger OnPreDataItem()
            var

            begin
                GlSetup.get();
            end;

            trigger OnAfterGetRecord()
            var
                ValueEntry: record "Value Entry";
                ItemLedgEntry: record "Item Ledger Entry";
                TempItemLedgerEntry: record "Item Ledger Entry" temporary;
                AppliedEntries: record "Item Application Entry History";
                PurchInvHeader: record "Purch. Inv. Header";
                VARID: record "VAR";
                PurchRcptHeader: record "Purch. Rcpt. Header";
            begin
                SetEndCustReseller();
                TempItemLedgerEntry.DeleteAll();
                if ValueEntry.get(Sales_Invoice_Line."Document No.") then begin
                    if ItemLedgEntry.get(ValueEntry."Item Ledger Entry No.") then begin
                        POSReportExport.FindAppliedEntry(ItemLedgEntry, TempItemLedgerEntry);
                        if PurchRcptHeader.get(TempItemLedgerEntry."Document No.") then begin
                            PurchInvHeader.get(PurchRcptHeader."Order No.");
                            PurchOrderNo := PurchInvHeader."No.";
                            PurchOrderPostDate := PurchInvHeader."Posting Date";
                        end;
                    end;
                end;

                VARID.get("Sales Invoice Header".Reseller, Item."Vendor No.");
                VARIDInt := VARID."VAR id";

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

    procedure SetEndCustReseller()
    var
        Customer: record Customer;
    begin
        if "Sales Invoice Header"."Drop-Shipment" then begin
            if Customer.get("Sales Invoice Header".Reseller) then begin
                ResellEndCustName := Customer.name;
                ResellEndCustName2 := Customer."Name 2";
                ResellEndCustAddress := Customer.Address;
                ResellEndCustAddress2 := Customer."Address 2";
                ResellEndCustCity := Customer.City;
                ResellEndCustPostCode := Customer."Post Code";
                ResellEndCustCounty := Customer.County;
                ResellEndCustCountryRegion := Customer."Country/Region Code";
                ResellEndCustContact := Customer.Contact;
            end;
        end else begin
            if Customer.get("Sales Invoice Header".Reseller) then begin
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
        end;
    end;

    var
        Qty: Decimal;
        POSReportExport: codeunit "POS Report Export";
        SerialNo: text[50];
        BidUnitPurchasePriceLCY: Decimal;
        CostPercentage: Decimal;
        VARIDInt: Integer;
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
        GlSetup: record "General Ledger Setup";

}