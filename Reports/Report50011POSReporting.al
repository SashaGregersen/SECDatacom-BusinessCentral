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
            column(Reseller; ResellerName)
            {

            }
            column(End_Customer; EndCustomerName)
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

                column(VAR_id; VARIDInt)
                {

                }
                column(Shipment_No; ShipmentNo)
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
                column(Vendor_Item_No_; VendorItemNo)
                {

                }
                column(Description; Description)
                {

                }
                column(Bid_No_; VendorBidNo)
                {

                }
                column(Unit_List_Price; UnitListPrice)
                {
                    //tages fra bid
                }
                column(Bid_Purchase_Discount_Pct_; BidPurchaseDiscountPct)
                {
                    //tages fra bid
                }
                column(Bid_Unit_Purchase_Price; BidUnitPurchasePrice)
                {
                    //tages fra bid
                }
                column(Currency; Currency)
                {
                    //tages fra bid eller vendor currency
                }
                column(PurchCostPrice; PurchCostPrice)
                {
                    //skal hentes fra købslinjen
                }
                column(Cost_Percentage; CostPercentage)
                {
                    //udregnet vha. (unit purch pric - bid unit purch price) / unit purch price    
                }
                dataitem(Copyloop; Integer)
                {

                    column(SerialNo; SerialNo)
                    {

                    }
                    column(Quantity; Qty)
                    {

                    }
                    column(Purch_Order_No; PurchOrderNo)
                    {

                    }
                    column(Purch_Order_Posting_Date; PurchOrderPostDate)
                    {

                    }

                    trigger OnPreDataItem()
                    var
                        ValueEntry: record "Value Entry";
                        ItemLedgEntry: record "Item Ledger Entry";
                    begin
                        TempItemLedgEntrySales.DeleteAll();
                        ValueEntry.SetRange("Document No.", Sales_Invoice_Line."Document No.");
                        ValueEntry.SetRange("Document Line No.", Sales_Invoice_Line."Line No.");
                        if ValueEntry.FindSet() then begin
                            repeat
                                ItemLedgEntry.get(ValueEntry."Item Ledger Entry No.");
                                POSReportExport.RetrieveEntriesFromPostedInv(TempItemLedgEntrySales, Sales_Invoice_Line.RowID1());
                            until ValueEntry.next = 0;
                            Qty := Sales_Invoice_Line.Quantity;
                            SETRANGE(Number, 1, TempItemLedgEntrySales.count());
                        end;

                    end;

                    trigger OnAfterGetRecord()
                    var
                        ValueEntry: record "Value Entry";
                        ItemLedgEntry: record "Item Ledger Entry";
                        TempItemLedgEntryPurchase: record "Item Ledger Entry" temporary;
                        PurchRcptHeader: record "Purch. Rcpt. Header";
                        PurchInvHeader: record "Purch. Inv. Header";
                        PostedSalesShipment: Record "Sales Shipment Header";
                    begin
                        Qty := Sales_Invoice_Line.Quantity;
                        if TempItemLedgEntrySales.Count() >= 1 then
                            Qty := 1;
                        if TempItemLedgEntrySales.findfirst then begin
                            PostedSalesShipment.get(TempItemLedgEntrySales."Document No.");
                            ShipmentNo := PostedSalesShipment."No.";
                            SerialNo := TempItemLedgEntrySales."Serial No.";
                            POSReportExport.FindAppliedEntry(TempItemLedgEntrySales, TempItemLedgEntryPurchase);
                            if PurchRcptHeader.get(TempItemLedgEntryPurchase."Document No.") then begin
                                PurchInvHeader.SetRange("Order No.", PurchRcptHeader."Order No.");
                                PurchInvHeader.FindFirst();
                                PurchOrderNo := PurchInvHeader."No.";
                                PurchOrderPostDate := PurchInvHeader."Posting Date";
                            end;
                            TempItemLedgEntrySales.Delete();
                        end;

                    end;

                }
                trigger OnAfterGetRecord()
                var
                    BidItemPrices: record "Bid Item Price";
                    Item: Record item;
                    Bid: record bid;
                    VARID: record "VAR";
                begin
                    item.get("No.");
                    VendorItemNo := item."Vendor Item No.";
                    VARID.SetRange("Customer No.", "Sales Invoice Header".Reseller);
                    VARID.SetRange("Vendor No.", item."Vendor No.");
                    if VARID.FindFirst() then
                        VARIDInt := VARID."VAR id";

                    if bid.get("Bid No.") then begin
                        VendorBidNo := bid."Vendor Bid No.";
                        if BidItemPrices.get(Sales_Invoice_Line."Bid No.",
                        Sales_Invoice_Line."No.", Sales_Invoice_Line."Sell-to Customer No.", item."Vendor Currency")
                        then begin
                            UnitListPrice := BidItemPrices."Unit List Price";
                            BidPurchaseDiscountPct := BidItemPrices."Bid Purchase Discount Pct.";
                            Currency := BidItemPrices."Currency Code";
                            BidUnitPurchasePrice := BidItemPrices."Bid Unit Purchase Price";
                        end else begin
                            BidItemPrices.setrange("Bid No.", Sales_Invoice_Line."Bid No.");
                            BidItemPrices.setrange("item No.", Sales_Invoice_Line."No.");
                            BidItemPrices.setrange("Currency Code", item."Vendor Currency");
                            if BidItemPrices.FindFirst() then begin
                                UnitListPrice := BidItemPrices."Unit List Price";
                                BidPurchaseDiscountPct := BidItemPrices."Bid Purchase Discount Pct.";
                                Currency := BidItemPrices."Currency Code";
                                BidUnitPurchasePrice := BidItemPrices."Bid Unit Purchase Price";
                            end;
                        end;
                    end else begin
                        Currency := Item."Vendor Currency";
                        //UnitListPrice := Sales_Invoice_Line."Unit Price";
                    end;
                    if PurchCostPrice <> 0 then
                        CostPercentage := (PurchCostPrice - BidItemPrices."Bid Unit Purchase Price")
                        / PurchCostPrice;
                end;

            }

            trigger OnPreDataItem()
            var

            begin
                GlSetup.get();
                Sales_Invoice_Line.SetRange(type, Sales_Invoice_Line.type::Item);
                "Sales Invoice Header".Setfilter("No.", '%1|%2', '103075', '103057');
            end;

            trigger OnAfterGetRecord()
            var

            begin
                SetEndCustReseller();
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
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }
    }

    procedure SetEndCustReseller()
    var
        Customer: record Customer;
    begin
        if "Sales Invoice Header"."Drop-Shipment" then begin
            if Customer.get("Sales Invoice Header".Reseller) then begin
                ResellerName := Customer.Name;
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
                EndCustomerName := Customer.name;
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

    procedure SetRequestFilter(RequestFilter: text[100])
    var
    begin
        NewRequestFilter := RequestFilter;
    end;

    var
        NewRequestFilter: Text[100];
        SalesHeader: record "Sales Header";
        BidUnitPurchasePrice: Decimal;
        Currency: code[10];
        ShipmentNo: code[20];
        VendorItemNo: Text[60];
        VendorBidNo: Text[100];
        EndCustomerName: text[50];
        ResellerName: Text[50];
        BidPurchaseDiscountPct: Decimal;
        UnitListPrice: Decimal;
        TempItemLedgEntrySales: record "Item Ledger Entry" temporary;
        Qty: Decimal;
        POSReportExport: codeunit "POS Report Export";
        SerialNo: text[50];
        BidUnitPurchasePriceLCY: Decimal; //slettes
        CostPercentage: Decimal;
        VARIDInt: Integer;
        PurchOrderNo: code[20];
        PurchOrderPostDate: Date;
        PurchCostPrice: decimal;
        PurchCostPriceLCY: decimal; //slettes
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