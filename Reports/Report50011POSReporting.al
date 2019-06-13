report 50011 "POS Reporting"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = false;
    UseRequestPage = true;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/POSReport2.rdl';
    Caption = 'POS Report';

    dataset
    {
        dataitem(Sales_Invoice_Line; "Sales Invoice Line")
        {
            RequestFilterHeading = 'Line Filters';
            RequestFilterFields = "Posting Date";

            column(Document_Type; DocumentType)
            {

            }
            column(VAR_id; VARIDInt)
            {

            }
            column(Shipment_No; ShipmentNo)
            {

            }
            column(Shipment_Date; "Shipment Date")
            {

            }
            /* column(IC_Partner_Code; "IC Partner Code")
            {

            } */
            column(IC_Partner_Code; ICPartnerCode)
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
                //tages fra bid eller salgslinjen
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
                //udregnet vha. (unit purch price - bid unit purch price) / unit purch price    
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

            dataitem("Sales Invoice Header"; "Sales Invoice Header")
            {
                DataItemLink = "No." = field ("Document No.");
                RequestFilterHeading = 'Header Filters';

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
                column(Ship_to_Phone; "Phone No.")
                {

                }
                column(Ship_to_Email; "Email")
                {

                }
                column(ResellerName2; ResellerName2)
                {

                }
                column(ResellerAddress; ResellerAddress)
                {

                }
                column(ResellerAddress2; ResellerAddress2)
                {

                }
                column(ResellerCity; ResellerCity)
                {

                }
                column(ResellerPostCode; ResellerPostCode)
                {

                }
                column(ResellerCountryRegion; ResellerCountryRegion)
                {

                }
                column(ResellerCounty; ResellerCounty)
                {

                }
                column(ResellerContact; ResellerContact)
                {

                }
                column(ResellerContactEmail; ResellerContactEmail)
                {

                }
                column(ResellerContactPhone; ResellerContactPhone)
                {

                }
                column(EndCustName2; ResellerName2)
                {

                }
                column(EndCustAddress; ResellerAddress)
                {

                }
                column(EndCustAddress2; ResellerAddress2)
                {

                }
                column(EndCustCity; ResellerCity)
                {

                }
                column(EndCustPostCode; ResellerPostCode)
                {

                }
                column(EndCustCountryRegion; ResellerCountryRegion)
                {

                }
                column(EndCustCounty; ResellerCounty)
                {

                }
                column(EndCustContact; ResellerContact)
                {

                }
                column(EndCustContactEmail; ResellerContactEmail)
                {

                }
                column(EndCustContactPhone; ResellerContactPhone)
                {

                }
                dataitem(Copyloop; Integer)
                {

                    column(SerialNo; SerialNo)
                    {

                    }

                    trigger OnPreDataItem()
                    var
                        ValueEntry: record "Value Entry";
                    begin
                        if TempItemLedgEntrySales.Count = 0 then
                            SetRange(Number, 0)
                        else
                            SetRange(Number, 1, TempItemLedgEntrySales.count());
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
                        SetEndCustResellerSalesInv();
                        if Number = 0 then begin
                            qty := Sales_Invoice_Line.Quantity;
                            CurrReport.skip;
                        end;
                        if TempItemLedgEntrySales.findfirst then begin
                            qty := 1;
                            SerialNo := TempItemLedgEntrySales."Serial No.";
                            UpdatePurchInfoSerialNumbersSalesInv(TempItemLedgEntrySales);
                            TempItemLedgEntrySales.Delete();
                        end;
                    end;

                }

            }
            trigger OnPreDataItem()
            var

            begin
                GlSetup.Get();
                if VendorCode <> '' then
                    SetVendorFilter();
                DocumentType := 'Invoice';
                PostDate := format(Sales_Invoice_Line.GetFilter("Posting Date"));
            end;

            trigger OnAfterGetRecord()
            var
                Item: Record item;
                VARID: record "VAR";
                ItemLedgEntrySales: record "Item Ledger Entry";
                ItemLedgEntryPurchase: record "Item Ledger Entry";
                PurchRcptLine: record "Purch. Rcpt. Line";
                PurchInvHeader: record "Purch. Inv. Header";
                PostedSalesShipment: Record "Sales Shipment Header";
                ValueEntry: record "Value Entry";
                ValueEntry2: record "Value Entry";
                PurchInvLine: record "Purch. Inv. Line";
                PurchLine: record "Purchase Line";
                PurchHeader: record "Purchase Header";
                SalesInvHeader: record "Sales Invoice Header";
                Customer: Record Customer;
            begin
                ClearValues();
                if Sales_Invoice_Line.Type <> Sales_Invoice_Line.type::Item then
                    CurrReport.skip;
                SalesInvHeader.get(Sales_Invoice_Line."Document No.");
                if (Subsidiary <> SalesInvHeader.Subsidiary) and (Subsidiary <> '') then
                    CurrReport.skip;
                if SalesInvHeader.Subsidiary <> '' then begin
                    Customer.get(Subsidiary);
                    ICPartnerCode := Customer."IC Partner Code";
                end;
                item.get(Sales_Invoice_Line."No.");
                VendorItemNo := item."Vendor-Item-No.";
                VARID.SetRange("Customer No.", "Sales Invoice Header".Reseller);
                VARID.SetRange("Vendor No.", item."Vendor No.");
                if VARID.FindFirst() then
                    VARIDInt := VARID."VAR id";

                SetPricesSalesInv(Item);

                clear(TempItemLedgEntrySales);
                POSReportExport.RetrieveEntriesFromPostedInv(TempItemLedgEntrySales, Sales_Invoice_Line.RowID1()); //find serial numbers

                if TempItemLedgEntrySales.Count() < 1 then begin // find purch info for lines w/o serial numbers
                    clear(ItemLedgEntryPurchase);
                    FindShipmentNo();
                    ValueEntry.setrange("Document Type", 2);
                    ValueEntry.setrange("Document No.", Sales_Invoice_Line."Document No.");
                    ValueEntry.setrange("Document Line No.", Sales_Invoice_Line."Line No.");
                    if ValueEntry.FindFirst() then begin
                        ItemLedgEntrySales.get(ValueEntry."Item Ledger Entry No.");
                        POSReportExport.FindAppliedEntry(ItemLedgEntrySales, ItemLedgEntryPurchase);
                        if ItemLedgEntryPurchase."Entry No." = 0 then
                            exit;
                        if (ItemLedgEntryPurchase."Entry Type" <> ItemLedgEntryPurchase."Entry Type"::Purchase) and
                        (ItemLedgEntryPurchase."Entry Type" <> ItemLedgEntryPurchase."Entry Type"::Sale) then begin
                            PurchOrderNo := format(ItemLedgEntryPurchase."Entry Type");
                            PurchOrderPostDate := ItemLedgEntryPurchase."Posting Date";
                        end else begin
                            if PurchRcptLine.get(ItemLedgEntryPurchase."Document No.", ItemLedgEntryPurchase."Document Line No.") then begin
                                PurchInvLine.setrange("Order No.", PurchRcptLine."Order No.");
                                PurchInvLine.setrange("Order Line No.", PurchRcptLine."Order Line No.");
                                if PurchInvLine.FindFirst() then begin //purchase invoice
                                    PurchInvHeader.get(PurchInvLine."Document No.");
                                    PurchOrderNo := PurchInvLine."Document No.";
                                    PurchOrderPostDate := PurchInvLine."Posting Date";
                                    PurchCostPrice := PurchInvLine."Unit Cost";
                                end else begin
                                    PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
                                    PurchLine.SetRange("Document No.", PurchRcptLine."Order No.");
                                    PurchLine.setrange("Line No.", PurchRcptLine."Order Line No.");
                                    if PurchLine.FindFirst() then begin //purchase order                                                                        
                                        PurchHeader.get(PurchLine."Document Type", PurchLine."Document No.");
                                        PurchOrderNo := PurchLine."Document No.";
                                        PurchOrderPostDate := PurchHeader."Posting Date";
                                        PurchCostPrice := PurchLine."Unit Cost";
                                    end;
                                end;
                                // Find PurchCostPrice on purchase
                                if (PurchCostPrice <> 0) and (BidUnitPurchasePrice <> 0) then
                                    CostPercentage := (PurchCostPrice - BidUnitPurchasePrice) / PurchCostPrice; //er der en købskostpris procent når der ikke er bid?

                            end;
                        end;
                    end;
                end;
            end;

        }
        dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
        {
            DataItemTableView = sorting ("Document No.");

            column(Document_Type2; DocumentType)
            {

            }
            column(VAR_id2; VARIDInt)
            {

            }
            column(Shipment_No2; ShipmentNo)
            {

            }
            column(Shipment_Date2; "Shipment Date")
            {

            }
            column(IC_Partner_Code2; ICPartnerCode2)
            {

            }
            column(Vendor_Code2; "Shortcut Dimension 1 Code")
            {

            }
            column(Posting_Date2; "Posting Date")
            {

            }
            column(Item_No2; "No.")
            {

            }
            column(Vendor_Item_No_2; VendorItemNo)
            {

            }
            column(Description2; Description)
            {

            }
            column(Bid_No_2; VendorBidNo)
            {

            }
            column(Unit_List_Price2; UnitListPrice)
            {
                //tages fra bid eller salgslinjen i vendor currency 
            }
            column(Bid_Purchase_Discount_Pct_2; BidPurchaseDiscountPct)
            {
                //tages fra bid
            }
            column(Bid_Unit_Purchase_Price2; BidUnitPurchasePrice)
            {
                //tages fra bid
            }
            column(Currency2; Currency)
            {
                //tages fra bid eller vendor currency
            }
            column(PurchCostPrice2; PurchCostPrice)
            {
                //hentes fra købslinjen
            }
            column(Cost_Percentage2; CostPercentage)
            {
                //udregnet vha. (unit purch price - bid unit purch price) / unit purch price    
            }
            column(Quantity2; Qty)
            {

            }
            column(Return_Shipment_No; PurchOrderNo)
            {

            }
            column(Return_Shipment_Posting_Date; PurchOrderPostDate)
            {

            }

            dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
            {
                DataItemLink = "No." = field ("Document No.");
                DataItemTableView = sorting ("No.");

                column(Document_No2; "No.")
                {

                }
                column(External_Document_No2; "External Document No.")
                {

                }
                column(Return_Order_No_; "Return Order No.")
                {

                }
                column(Reseller2; ResellerName)
                {

                }
                column(End_Customer2; EndCustomerName)
                {

                }
                column(Ship_to_Name2; "Ship-to Name")
                {

                }
                column(Ship_to_Name_2_2; "Ship-to Name 2")
                {

                }
                column(Ship_to_Address2; "Ship-to Address")
                {

                }
                column(Ship_to_Address_2_2; "Ship-to Address 2")
                {

                }
                column(Ship_to_City2; "Ship-to City")
                {

                }
                column(Ship_to_Post_Code2; "Ship-to Post Code")
                {

                }
                column(Ship_to_Country_Region_Code2; "Ship-to Country/Region Code")
                {

                }
                column(Ship_to_County2; "Ship-to County")
                {

                }
                column(Ship_to_Contact2; "Ship-to Contact")
                {

                }
                column(Ship_to_Phone2; "Phone No.")
                {

                }
                column(Ship_to_Email2; "Email")
                {

                }

                column(ResellerName2_2; ResellerName2)
                {

                }
                column(ResellerAddress1; ResellerAddress)
                {

                }
                column(ResellerAddress2_2; ResellerAddress2)
                {

                }
                column(ResellerCity2; ResellerCity)
                {

                }
                column(ResellerPostCode2; ResellerPostCode)
                {

                }
                column(ResellerCountryRegion2; ResellerCountryRegion)
                {

                }
                column(ResellerCounty2; ResellerCounty)
                {

                }
                column(ResellerContact2; ResellerContact)
                {

                }
                column(ResellerContactEmail2; ResellerContactEmail)
                {

                }
                column(ResellerContactPhone2; ResellerContactPhone)
                {

                }
                column(EndCustName2_2; ResellerName2)
                {

                }
                column(EndCustAddress1; ResellerAddress)
                {

                }
                column(EndCustAddress2_2; ResellerAddress2)
                {

                }
                column(EndCustCity2; ResellerCity)
                {

                }
                column(EndCustPostCode2; ResellerPostCode)
                {

                }
                column(EndCustCountryRegion2; ResellerCountryRegion)
                {

                }
                column(EndCustCounty2; ResellerCounty)
                {

                }
                column(EndCustContact2; ResellerContact)
                {

                }
                column(EndCustContactEmail2; ResellerContactEmail)
                {

                }
                column(EndCustContactPhone2; ResellerContactPhone)
                {

                }
                dataitem(Copyloop2; Integer)
                {
                    DataItemTableView = sorting (number);

                    column(SerialNo2; SerialNo)
                    {

                    }

                    trigger OnPreDataItem()
                    var
                        ValueEntry: record "Value Entry";
                    begin
                        if TempItemLedgEntrySales.Count = 0 then
                            SetRange(Number, 0)
                        else
                            SetRange(Number, 1, TempItemLedgEntrySales.count());
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
                        SetEndCustResellerCreditMemo();
                        if Number = 0 then begin
                            qty := "Sales Cr.Memo Line".Quantity;
                            CurrReport.skip;
                        end;
                        if TempItemLedgEntrySales.findfirst then begin
                            qty := 1;
                            SerialNo := TempItemLedgEntrySales."Serial No.";
                            UpdatePurchInfoSerialNumbersCreditMemo(TempItemLedgEntrySales);
                            TempItemLedgEntrySales.Delete();
                        end;
                    end;
                }
            }
            trigger OnPreDataItem()
            var
            begin
                GlSetup.Get();
                if VendorCode <> '' then
                    SetVendorFilter();
                DocumentType := 'Credit Memo';
                SetFiltersFromSalesInvoice();
            end;

            trigger OnAfterGetRecord()
            var
                Item: Record item;
                VARID: record "VAR";
                ItemLedgEntrySales: record "Item Ledger Entry";
                ItemLedgEntryPurchase: record "Item Ledger Entry";
                ReturnShipmentLine: record "Return Shipment Line";
                ValueEntry: record "Value Entry";
                ValueEntry2: record "Value Entry";
                ReturnShipmentHeader: record "Return Shipment Header";
                PurchLine: record "Purchase Line";
                PurchHeader: record "Purchase Header";
                CreditMemoHeader: record "Sales Cr.Memo Header";
                Customer: Record customer;
            begin
                ClearValues();
                if "Sales Cr.Memo Line".Type <> "Sales Cr.Memo Line".type::Item then
                    CurrReport.skip;
                CreditMemoHeader.get("Sales Cr.Memo Line"."Document No.");
                if (Subsidiary <> CreditMemoHeader.Subsidiary) and (Subsidiary <> '') then
                    CurrReport.skip;
                if CreditMemoHeader.Subsidiary <> '' then begin
                    Customer.get(Subsidiary);
                    ICPartnerCode2 := Customer."IC Partner Code";
                end;
                item.get("Sales Cr.Memo Line"."No.");
                VendorItemNo := item."Vendor-Item-No.";
                VARID.SetRange("Customer No.", "Sales Cr.Memo Header".Reseller);
                VARID.SetRange("Vendor No.", item."Vendor No.");
                if VARID.FindFirst() then
                    VARIDInt := VARID."VAR id";

                SetPricesCreditMemo(Item);

                clear(TempItemLedgEntrySales);
                POSReportExport.RetrieveEntriesFromPostedInv(TempItemLedgEntrySales, "Sales Cr.Memo Line".RowID1()); //find serial numbers

                ValueEntry.setrange("Document Type", ValueEntry."Document Type"::"Sales Credit Memo");
                ValueEntry.setrange("Document No.", "Sales Cr.Memo Line"."Document No.");
                ValueEntry.setrange("Document Line No.", "Sales Cr.Memo Line"."Line No.");
                if ValueEntry.FindFirst() then begin
                    ItemLedgEntrySales.get(ValueEntry."Item Ledger Entry No.");
                    ShipmentNo := ItemLedgEntrySales."Document No.";
                end;
            end;
        }

    }


    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Dimensions")
                {
                    field(VendorCode; VendorCode)
                    {
                        Caption = 'Vendor Code';
                    }
                }
                Group("IC Partner")
                {
                    field(Subsidiary; Subsidiary)
                    {
                        Caption = 'IC Partner';
                        trigger OnLookup(var text: Text): Boolean
                        var
                            ICPartner: record "IC Partner";
                        begin
                            if not ICPartner.Get(Subsidiary) then
                                Clear(Subsidiary);
                            IF page.RunModal(page::"IC Partner List", ICPartner, ICPartner.Code) = Action::LookupOK then
                                Subsidiary := ICPartner."Customer No.";
                        end;
                    }

                }
            }
        }
    }

    procedure SetEndCustResellerSalesInv()
    var
        Customer: record Customer;
        Contact: record Contact;
    begin
        if Customer.get("Sales Invoice Header".Reseller) then
            ResellerName := Customer.Name;
        if Customer.get("Sales Invoice Header"."End Customer") then
            EndCustomerName := Customer.name;
        //if not "Sales Invoice Header"."Drop-Shipment" then begin
        if Customer.get("Sales Invoice Header"."End Customer") then begin
            //ResellEndCustName := Customer.name;
            EndCustName2 := Customer."Name 2";
            EndCustAddress := Customer.Address;
            EndCustAddress2 := Customer."Address 2";
            EndCustCity := Customer.City;
            EndCustPostCode := Customer."Post Code";
            EndCustCounty := Customer.County;
            EndCustCountryRegion := Customer."Country/Region Code";
            EndCustContact := Customer.Contact;
            if EndCustContact <> '' then begin
                Contact.get(EndCustContact);
                EndCustContactPhone := Contact."Phone No.";
                EndCustContactEmail := Contact."E-Mail";
            end;
        end;
        //end else begin
        if Customer.get("Sales Invoice Header".Reseller) then begin
            ResellerName2 := Customer."Name 2";
            ResellerAddress := Customer.Address;
            ResellerAddress2 := Customer."Address 2";
            ResellerCity := Customer.City;
            ResellerPostCode := Customer."Post Code";
            ResellerCounty := Customer.County;
            ResellerCountryRegion := Customer."Country/Region Code";
            if "Sales Invoice Header"."Sell-to Contact No." <> '' then begin
                Contact.get("Sales Invoice Header"."Sell-to Contact No.");
                ResellerContact := Contact.Name;
                ResellerContactPhone := Contact."Phone No.";
                ResellerContactEmail := Contact."E-Mail";
            end;
        end;
        //end;
    end;

    procedure SetEndCustResellerCreditMemo()
    var
        Customer: record Customer;
        Contact: record contact;
    begin
        if Customer.get("Sales Cr.Memo Header".Reseller) then
            ResellerName := Customer.Name;
        if Customer.get("Sales Cr.Memo Header"."End Customer") then
            EndCustomerName := Customer.name;
        //if not "Sales Cr.Memo Header"."Drop-Shipment" then begin
        if Customer.get("Sales Cr.Memo Header"."End Customer") then begin
            //ResellEndCustName := Customer.name;
            EndCustName2 := Customer."Name 2";
            EndCustAddress := Customer.Address;
            EndCustAddress2 := Customer."Address 2";
            EndCustCity := Customer.City;
            EndCustPostCode := Customer."Post Code";
            EndCustCounty := Customer.County;
            EndCustCountryRegion := Customer."Country/Region Code";
            if "Sales Cr.Memo Header"."End Customer Contact" <> '' then begin
                Contact.get("Sales Cr.Memo Header"."End Customer Contact");
                EndCustContact := Contact.Name;
                EndCustContactPhone := contact."Phone No.";
                EndCustContactEmail := Contact."E-Mail";
            end;
        end;
        //end else begin
        if Customer.get("Sales Cr.Memo Header".Reseller) then begin
            //ResellEndCustName := Customer.name;
            ResellerName2 := Customer."Name 2";
            ResellerAddress := Customer.Address;
            ResellerAddress2 := Customer."Address 2";
            ResellerCity := Customer.City;
            ResellerPostCode := Customer."Post Code";
            ResellerCounty := Customer.County;
            ResellerCountryRegion := Customer."Country/Region Code";
            if "Sales Cr.Memo Header"."Sell-to Contact No." <> '' then begin
                Contact.get("Sales Cr.Memo Header"."Sell-to Contact No.");
                ResellerContact := Contact.Name;
                ResellerContactPhone := Contact."Phone No.";
                ResellerContactEmail := Contact."E-Mail";
            end;
        end;
        //end;
    end;

    local procedure SetVendorFilter()
    var

    begin
        Sales_Invoice_Line.SetFilter("Shortcut Dimension 1 Code", VendorCode);
        "Sales Cr.Memo Line".SetFilter("Shortcut Dimension 1 Code", VendorCode);
    end;

    local procedure SetFiltersFromSalesInvoice()
    begin
        "Sales Cr.Memo Line".SetFilter("Posting Date", PostDate);
    end;

    local procedure SetPricesSalesInv(Item: record Item)
    var
        BidItemPrices: record "Bid Item Price";
        Bid: record bid;
    begin
        if bid.get(Sales_Invoice_Line."Bid No.") then begin
            VendorBidNo := bid."Vendor Bid No.";
            if BidItemPrices.get(Sales_Invoice_Line."Bid No.", Sales_Invoice_Line."No.", Sales_Invoice_Line."Sell-to Customer No.", item."Vendor Currency") then begin
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
            UnitListPrice := Sales_Invoice_Line."Unit List Price VC";
        end;
    end;

    local procedure SetPricesCreditMemo(Item: record Item)
    var
        BidItemPrices: record "Bid Item Price";
        Bid: record bid;
    begin
        if bid.get("Sales Cr.Memo Line"."Bid No.") then begin
            VendorBidNo := bid."Vendor Bid No.";
            if BidItemPrices.get("Sales Cr.Memo Line"."Bid No.", "Sales Cr.Memo Line"."No.", "Sales Cr.Memo Line"."Sell-to Customer No.", item."Vendor Currency") then begin
                UnitListPrice := BidItemPrices."Unit List Price";
                BidPurchaseDiscountPct := BidItemPrices."Bid Purchase Discount Pct.";
                Currency := BidItemPrices."Currency Code";
                BidUnitPurchasePrice := BidItemPrices."Bid Unit Purchase Price";
            end else begin
                BidItemPrices.setrange("Bid No.", "Sales Cr.Memo Line"."Bid No.");
                BidItemPrices.setrange("item No.", "Sales Cr.Memo Line"."No.");
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
            UnitListPrice := "Sales Cr.Memo Line"."Unit List Price VC";
        end;
    end;


    local procedure ClearValues()
    begin
        clear(VARIDInt);
        Clear(ShipmentNo);
        clear(PurchOrderNo);
        Clear(PurchOrderPostDate);
        Clear(PurchCostPrice);
        Clear(CostPercentage);
        clear(UnitListPrice);
        clear(BidPurchaseDiscountPct);
        Clear(Currency);
        clear(BidPurchaseDiscountPct);
        Clear(BidUnitPurchasePrice);
    end;

    local procedure UpdatePurchInfoSerialNumbersSalesInv(TempItemLedEntrySales: record "Item Ledger Entry" temporary)
    var
        TempItemLedgEntryPurchase: record "Item Ledger Entry" temporary;
        PurchRcptLine: record "Purch. Rcpt. Line";
        PurchInvHeader: record "Purch. Inv. Header";
        PostedSalesShipment: Record "Sales Shipment Header";
        ValueEntry: record "Value Entry";
        PurchInvLine: record "Purch. Inv. Line";
        PurchLine: record "Purchase Line";
        PurchHeader: record "Purchase Header";
    begin
        PostedSalesShipment.get(TempItemLedgEntrySales."Document No.");
        ShipmentNo := PostedSalesShipment."No.";
        POSReportExport.FindAppliedEntry(TempItemLedgEntrySales, TempItemLedgEntryPurchase);
        ValueEntry.SetRange("Item Ledger Entry No.", TempItemLedgEntryPurchase."Entry No.");
        ValueEntry.setrange("Document Type", 6); //purchase invoice
        if ValueEntry.FindFirst() then begin
            if PurchInvLine.get(ValueEntry."Document No.", ValueEntry."Document Line No.") then begin
                PurchInvHeader.get(PurchInvLine."Document No.");
                PurchOrderNo := PurchInvLine."Order No.";
                PurchOrderPostDate := PurchInvLine."Posting Date";
                PurchCostPrice := PurchInvLine."Unit Cost";
            end else begin
                ValueEntry.SetRange("Document Type", 5); // purchase receipt
                if ValueEntry.FindFirst() then
                    if PurchRcptLine.get(ValueEntry."Document No.", ValueEntry."Document Line No.") then begin
                        PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
                        PurchLine.SetRange("Document No.", PurchRcptLine."Order No.");
                        PurchLine.setrange("Line No.", PurchRcptLine."Order Line No.");
                        if PurchLine.FindFirst() then begin //purchase order                                                            
                            PurchHeader.get(PurchLine."Document Type", PurchLine."Document No.");
                            PurchOrderNo := PurchLine."Document No.";
                            PurchOrderPostDate := PurchHeader."Posting Date";
                            PurchCostPrice := PurchLine."Unit Cost";
                        end;
                    end;
            end;

            // Find PurchCostPrice på købslinjen 
            if (PurchCostPrice <> 0) and (BidUnitPurchasePrice <> 0) then
                CostPercentage := (PurchCostPrice - BidUnitPurchasePrice) / PurchCostPrice;
        end;
    end;

    local procedure UpdatePurchInfoSerialNumbersCreditMemo(TempItemLedEntrySales: record "Item Ledger Entry" temporary)
    var
        ItemLedgerEntryPurch: record "Item Ledger Entry";
        PurchRcptLine: record "Purch. Rcpt. Line";
        PurchInvLine: record "Purch. Inv. Line";
        PurchLine: record "Purchase Line";
        PurchHeader: record "Purchase Header";
    begin
        ItemLedgerEntryPurch.setrange("Document Type", ItemLedgerEntryPurch."Document Type"::"Purchase Receipt");
        ItemLedgerEntryPurch.setrange("Serial No.", TempItemLedgEntrySales."Serial No.");
        if ItemLedgerEntryPurch.FindFirst() then begin
            if PurchRcptLine.get(ItemLedgerEntryPurch."Document No.", ItemLedgerEntryPurch."Document Line No.") then begin
                PurchInvLine.setrange("Order No.", PurchRcptLine."Order No.");
                PurchInvLine.SetRange("Order Line No.", PurchRcptLine."Order Line No.");
                if PurchInvLine.findfirst then begin
                    PurchOrderNo := PurchInvLine."Order No.";
                    PurchCostPrice := PurchInvLine."Direct Unit Cost";
                    PurchOrderPostDate := PurchInvLine."Posting Date";
                end else begin
                    if PurchLine.GET(Purchline."Document Type"::Order, PurchRcptLine."Order No.", PurchRcptLine."Order Line No.") then begin
                        PurchHeader.get(PurchLine."Document Type", Purchline."Document No.");
                        PurchOrderNo := PurchLine."Document No.";
                        PurchCostPrice := PurchLine."Direct Unit Cost";
                        PurchOrderPostDate := PurchHeader."Posting Date";
                    end;
                end;
                if (PurchCostPrice <> 0) and (BidUnitPurchasePrice <> 0) then
                    CostPercentage := (PurchCostPrice - BidUnitPurchasePrice) / PurchCostPrice;
            end;
        end;

    end;

    local procedure FindShipmentNo()
    var
        SalesShipLine: record "Sales Shipment Line";
    begin
        SalesShipLine.setrange("Order No.", Sales_Invoice_Line."Order No.");
        SalesShipLine.setrange("Order Line No.", Sales_Invoice_Line."Order Line No.");
        if SalesShipLine.FindFirst() then
            ShipmentNo := SalesShipLine."Document No.";
    end;

    var
        VendorCode: code[20];
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
        CostPercentage: Decimal;
        VARIDInt: Code[20];
        PurchOrderNo: code[20];
        PurchOrderPostDate: Date;
        PurchCostPrice: decimal;
        ListPrice: Decimal;
        //ResellEndCustName: text[50];
        ResellerName2: text[50];
        ResellerAddress: text[50];
        ResellerAddress2: text[50];
        ResellerCity: text[30];
        ResellerPostCode: code[20];
        ResellerCounty: text[30];
        ResellerCountryRegion: code[10];
        ResellerContact: text[50];
        ResellerContactPhone: text[30];
        ResellerContactEmail: text[80];
        EndCustName2: text[50];
        EndCustAddress: text[50];
        EndCustAddress2: text[50];
        EndCustCity: text[30];
        EndCustPostCode: code[20];
        EndCustCounty: text[30];
        EndCustCountryRegion: code[10];
        EndCustContact: text[50];
        EndCustContactPhone: text[30];
        EndCustContactEmail: text[80];
        GlSetup: record "General Ledger Setup";
        DocumentType: text[20];
        PostDate: text;
        ICPartnerCode: Text;
        ICPartnerCode2: text;
        Subsidiary: code[20];


}
