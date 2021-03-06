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
            column(BidCostPercentage; bidCostPercentage)
            {
                //udregnet vha. (unit purch price - bid unit purch price) / unit purch price    
            }
            column(StandardCost; StandardCostPercentage)
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
            column(VendorNo; VendorNo)
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
                column(EndCustName2; EndCustName2)
                {

                }
                column(EndCustAddress; EndCustAddress)
                {

                }
                column(EndCustAddress2; EndCustAddress2)
                {

                }
                column(EndCustCity; EndCustCity)
                {

                }
                column(EndCustPostCode; EndCustPostCode)
                {

                }
                column(EndCustCountryRegion; EndCustCountryRegion)
                {

                }
                column(EndCustCounty; EndCustCounty)
                {

                }
                column(EndCustContact; EndCustContact)
                {

                }
                column(EndCustContactEmail; EndCustContactEmail)
                {

                }
                column(EndCustContactPhone; EndCustContactPhone)
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
                        TempItemLedgEntrySales.setfilter("Serial No.", '<>%1', '');
                        if not TempItemLedgEntrySales.FindSet() then
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

                        TempItemLedgEntrySales.setfilter("Serial No.", '<>%1', '');
                        if TempItemLedgEntrySales.FindSet() then begin
                            /* if not TempItemLedgEntrySales.findset then begin
                                //if Number = 0 then begin
                                qty := Sales_Invoice_Line.Quantity;
                                //CurrReport.skip;
                            end else begin */
                            //if TempItemLedgEntrySales.findfirst then begin
                            qty := 1;
                            SerialNo := TempItemLedgEntrySales."Serial No.";
                            UpdatePurchInfoSerialNumbersSalesInv(TempItemLedgEntrySales);
                            TempItemLedgEntrySales.Delete();
                        end;
                    end;

                }

                trigger OnAfterGetRecord()
                var

                begin
                    SetEndCustResellerSalesInv();
                end;

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
                if Sales_Invoice_Line.Quantity = 0 then
                    CurrReport.skip;
                SalesInvHeader.get(Sales_Invoice_Line."Document No.");
                if (Subsidiary <> SalesInvHeader.Subsidiary) and (Subsidiary <> '') then
                    CurrReport.skip;
                if SalesInvHeader.Subsidiary <> '' then begin
                    Customer.get(SalesInvHeader.Subsidiary);
                    ICPartnerCode := Customer."IC Partner Code";
                end;
                item.get(Sales_Invoice_Line."No.");
                VendorNo := item."Vendor No.";
                VendorItemNo := item."Vendor-Item-No.";
                VARID.SetRange("Customer No.", SalesInvHeader.Reseller);
                VARID.SetRange("Vendor No.", item."Vendor No.");
                if VARID.FindFirst() then
                    VARIDInt := VARID."VAR id";

                SetPricesSalesInv(Item);

                TempItemLedgEntrySales.DeleteAll();
                POSReportExport.RetrieveEntriesFromPostedInv(TempItemLedgEntrySales, Sales_Invoice_Line.RowID1()); //find serial numbers

                //if TempItemLedgEntrySales.Count() = 1 then begin // find purch info for lines w/o serial numbers
                //TempItemLedgEntrySales.setfilter("Serial No.", '');
                if not TempItemLedgEntrySales.FindSet() then begin
                    qty := Sales_Invoice_Line.Quantity; //TEST
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
                            StandardCostPercentage := FindPurchaseDisc(PurchasePrice, Item, PurchOrderPostDate);
                        end else begin
                            if PurchRcptLine.get(ItemLedgEntryPurchase."Document No.", ItemLedgEntryPurchase."Document Line No.") then begin
                                PurchInvLine.setrange("Order No.", PurchRcptLine."Order No.");
                                PurchInvLine.setrange("Order Line No.", PurchRcptLine."Order Line No.");
                                if PurchInvLine.FindFirst() then begin //purchase invoice
                                    PurchInvHeader.get(PurchInvLine."Document No.");
                                    PurchOrderNo := PurchInvLine."Document No.";
                                    PurchOrderPostDate := PurchInvLine."Posting Date";
                                    PurchCostPrice := PurchInvLine."Unit Cost";
                                    StandardCostPercentage := FindPurchaseDisc(PurchasePrice, Item, PurchOrderPostDate);
                                    if Sales_Invoice_Line."Bid No." = '' then
                                        Currency := PurchInvHeader."Currency Code";
                                end else begin
                                    PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
                                    PurchLine.SetRange("Document No.", PurchRcptLine."Order No.");
                                    PurchLine.setrange("Line No.", PurchRcptLine."Order Line No.");
                                    if PurchLine.FindFirst() then begin //purchase order                                                                        
                                        PurchHeader.get(PurchLine."Document Type", PurchLine."Document No.");
                                        PurchOrderNo := PurchLine."Document No.";
                                        PurchOrderPostDate := PurchHeader."Posting Date";
                                        PurchCostPrice := PurchLine."Unit Cost";
                                        StandardCostPercentage := FindPurchaseDisc(PurchasePrice, Item, PurchOrderPostDate);
                                        if Sales_Invoice_Line."Bid No." = '' then
                                            Currency := PurchHeader."Currency Code";
                                    end;
                                end;
                                // Find PurchCostPrice on purchase
                                if (PurchCostPrice <> 0) and (BidUnitPurchasePrice <> 0) then
                                    BidCostPercentage := (PurchCostPrice - BidUnitPurchasePrice) / PurchCostPrice;
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
            column(BidCost_Percentage2; BidCostPercentage)
            {
                //udregnet vha. (unit purch price - bid unit purch price) / unit purch price    
            }
            column(StandardCost2; StandardCostPercentage)
            {

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
            column(VendorNo2; VendorNo)
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
                column(EndCustAddress1; EndCustAddress)
                {

                }
                column(EndCustAddress2_2; EndCustAddress2)
                {

                }
                column(EndCustCity2; EndCustCity)
                {

                }
                column(EndCustPostCode2; EndCustPostCode)
                {

                }
                column(EndCustCountryRegion2; EndCustCountryRegion)
                {

                }
                column(EndCustCounty2; EndCustCounty)
                {

                }
                column(EndCustContact2; EndCustContact)
                {

                }
                column(EndCustContactEmail2; EndCustContactEmail)
                {

                }
                column(EndCustContactPhone2; EndCustContactPhone)
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
                        TempItemLedgEntrySales.setfilter("Serial No.", '<>%1', '');
                        if not TempItemLedgEntrySales.FindSet() then
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
                        TempItemLedgEntrySales.setfilter("Serial No.", '<>%1', '');
                        if not TempItemLedgEntrySales.findset then begin
                            //if Number = 0 then begin
                            qty := -"Sales Cr.Memo Line".Quantity;
                            CurrReport.skip;
                        end else begin
                            //if TempItemLedgEntrySales.findfirst then begin
                            qty := -1;
                            SerialNo := TempItemLedgEntrySales."Serial No.";
                            UpdatePurchInfoSerialNumbersCreditMemo(TempItemLedgEntrySales);
                            TempItemLedgEntrySales.Delete();
                        end;
                    end;
                }

                trigger OnAfterGetRecord()
                var

                begin
                    SetEndCustResellerCreditMemo();
                end;
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
                if "Sales Cr.Memo Line".Quantity = 0 then
                    CurrReport.skip;
                CreditMemoHeader.get("Sales Cr.Memo Line"."Document No.");
                if (Subsidiary <> CreditMemoHeader.Subsidiary) and (Subsidiary <> '') then
                    CurrReport.skip;
                if CreditMemoHeader.Subsidiary <> '' then begin
                    Customer.get(CreditMemoHeader.Subsidiary);
                    ICPartnerCode2 := Customer."IC Partner Code";
                end;
                item.get("Sales Cr.Memo Line"."No.");
                VendorNo := item."Vendor No.";
                VendorItemNo := item."Vendor-Item-No.";
                VARID.Reset();
                VARID.SetRange("Customer No.", CreditMemoHeader.Reseller);
                VARID.SetRange("Vendor No.", item."Vendor No.");
                if VARID.FindFirst() then
                    VARIDInt := VARID."VAR id";

                SetPricesCreditMemo(Item);

                TempItemLedgEntrySales.DeleteAll();
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
        Customer2: record customer;
        Contact: record Contact;
        Contact2: record contact;
    begin
        /* if Customer.get("Sales Invoice Header".Reseller) then
            ResellerName := Customer.Name; */
        /* if Customer.get("Sales Invoice Header"."End Customer") then
            EndCustomerName := Customer.name; */

        if Customer.get("Sales Invoice Header"."End Customer") then begin
            EndCustomerName := Customer.name;
            EndCustName2 := Customer."Name 2";
            EndCustAddress := Customer.Address;
            EndCustAddress2 := Customer."Address 2";
            EndCustCity := Customer.City;
            EndCustPostCode := Customer."Post Code";
            EndCustCounty := Customer.County;
            EndCustCountryRegion := Customer."Country/Region Code";
            if "Sales Invoice Header"."End Customer Contact" <> '' then begin
                if Contact.get("Sales Invoice Header"."End Customer Contact") then begin
                    EndCustContact := Contact.Name;
                    EndCustContactPhone := contact."Phone No.";
                    EndCustContactEmail := Contact."E-Mail";
                end;
            end;
        end;

        if Customer2.get("Sales Invoice Header".Reseller) then begin
            ResellerName := Customer2.Name;
            ResellerName2 := Customer2."Name 2";
            ResellerAddress := Customer2.Address;
            ResellerAddress2 := Customer2."Address 2";
            ResellerCity := Customer2.City;
            ResellerPostCode := Customer2."Post Code";
            ResellerCounty := Customer2.County;
            ResellerCountryRegion := Customer2."Country/Region Code";
            if "Sales Invoice Header"."Sell-to Contact No." <> '' then begin
                if Contact2.get("Sales Invoice Header"."Sell-to Contact No.") then begin
                    ResellerContact := Contact2.Name;
                    ResellerContactPhone := Contact2."Phone No.";
                    ResellerContactEmail := Contact2."E-Mail";
                end;
            end;
        end;

    end;

    procedure SetEndCustResellerCreditMemo()
    var
        Customer: record Customer;
        Customer2: record customer;
        Contact: record contact;
        Contact2: record contact;
    begin
        /* if Customer.get("Sales Cr.Memo Header".Reseller) then
            ResellerName := Customer.Name;
        if Customer.get("Sales Cr.Memo Header"."End Customer") then
            EndCustomerName := Customer.name; */

        if Customer.get("Sales Cr.Memo Header"."End Customer") then begin
            EndCustomerName := Customer.name;
            EndCustName2 := Customer."Name 2";
            EndCustAddress := Customer.Address;
            EndCustAddress2 := Customer."Address 2";
            EndCustCity := Customer.City;
            EndCustPostCode := Customer."Post Code";
            EndCustCounty := Customer.County;
            EndCustCountryRegion := Customer."Country/Region Code";
            if "Sales Cr.Memo Header"."End Customer Contact" <> '' then begin
                if Contact.get("Sales Cr.Memo Header"."End Customer Contact") then begin
                    EndCustContact := Contact.Name;
                    EndCustContactPhone := contact."Phone No.";
                    EndCustContactEmail := Contact."E-Mail";
                end;
            end;
        end;

        if Customer2.get("Sales Cr.Memo Header".Reseller) then begin

            ResellerName := Customer2.Name;
            ResellerName2 := Customer2."Name 2";
            ResellerAddress := Customer2.Address;
            ResellerAddress2 := Customer2."Address 2";
            ResellerCity := Customer2.City;
            ResellerPostCode := Customer2."Post Code";
            ResellerCounty := Customer2.County;
            ResellerCountryRegion := Customer2."Country/Region Code";
            if "Sales Cr.Memo Header"."Sell-to Contact No." <> '' then begin
                if Contact2.get("Sales Cr.Memo Header"."Sell-to Contact No.") then begin
                    ResellerContact := Contact2.Name;
                    ResellerContactPhone := Contact2."Phone No.";
                    ResellerContactEmail := Contact2."E-Mail";
                end;
            end;
        end;

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
        //clear(VendorCode);
        clear(ICPartnerCode);
        Clear(ICPartnerCode2);
        Clear(ShipmentNo);
        clear(PurchOrderNo);
        Clear(PurchOrderPostDate);
        Clear(PurchCostPrice);
        Clear(BidCostPercentage);
        clear(UnitListPrice);
        clear(VendorBidNo);
        clear(BidPurchaseDiscountPct);
        Clear(Currency);
        clear(BidPurchaseDiscountPct);
        Clear(BidUnitPurchasePrice);
        clear(SerialNo);
        clear(ResellerName);
        Clear(ResellerName2);
        clear(ResellerAddress);
        Clear(ResellerAddress2);
        Clear(ResellerCity);
        Clear(ResellerPostCode);
        Clear(ResellerCountryRegion);
        clear(ResellerCounty);
        clear(ResellerContact);
        clear(ResellerContactEmail);
        clear(ResellerContactPhone);
        clear(EndCustomerName);
        clear(EndCustName2);
        clear(EndcustAddress);
        Clear(EndcustAddress2);
        Clear(EndcustCity);
        Clear(EndcustPostCode);
        Clear(EndcustCountryRegion);
        clear(EndcustCounty);
        clear(EndCustContact);
        clear(EndCustContactEmail);
        clear(EndCustContactPhone);
        Clear(StandardCostPercentage);
        clear(VendorNo);
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
        Item: record Item;
    begin
        PostedSalesShipment.get(TempItemLedgEntrySales."Document No.");
        ShipmentNo := PostedSalesShipment."No.";
        POSReportExport.FindAppliedEntry(TempItemLedgEntrySales, TempItemLedgEntryPurchase);
        if TempItemLedgEntryPurchase."Entry No." = 0 then
            exit;
        if (TempItemLedgEntryPurchase."Entry Type" <> TempItemLedgEntryPurchase."Entry Type"::Purchase) and
        (TempItemLedgEntryPurchase."Entry Type" <> TempItemLedgEntryPurchase."Entry Type"::Sale) then begin
            PurchOrderNo := format(tempItemLedgEntryPurchase."Entry Type");
            PurchOrderPostDate := tempItemLedgEntryPurchase."Posting Date";
            StandardCostPercentage := FindPurchaseDisc(PurchasePrice, Item, PurchOrderPostDate);
            exit;
        end;
        ValueEntry.SetRange("Item Ledger Entry No.", TempItemLedgEntryPurchase."Entry No.");
        ValueEntry.setrange("Document Type", 6); //purchase invoice
        if ValueEntry.FindFirst() then begin
            if PurchInvLine.get(ValueEntry."Document No.", ValueEntry."Document Line No.") then begin
                PurchInvHeader.get(PurchInvLine."Document No.");
                PurchOrderNo := PurchInvLine."Order No.";
                PurchOrderPostDate := PurchInvLine."Posting Date";
                PurchCostPrice := PurchInvLine."Unit Cost";
                if item.get(PurchInvLine."No.") then
                    StandardCostPercentage := FindPurchaseDisc(PurchasePrice, Item, PurchOrderPostDate);
                if Sales_Invoice_Line."Bid No." = '' then
                    Currency := PurchInvHeader."Currency Code";
            end;
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
                        if item.get(PurchLine."No.") then
                            StandardCostPercentage := FindPurchaseDisc(PurchasePrice, Item, PurchOrderPostDate);
                        if Sales_Invoice_Line."Bid No." = '' then
                            Currency := PurchHeader."Currency Code";
                    end;
                end;
        end;

        // Find PurchCostPrice på købslinjen 
        if (PurchCostPrice <> 0) and (BidUnitPurchasePrice <> 0) then
            BidCostPercentage := (PurchCostPrice - BidUnitPurchasePrice) / PurchCostPrice;
    end;

    local procedure UpdatePurchInfoSerialNumbersCreditMemo(TempItemLedEntrySales: record "Item Ledger Entry" temporary)
    var
        ItemLedgerEntryPurch: record "Item Ledger Entry";
        PurchRcptLine: record "Purch. Rcpt. Line";
        PurchInvLine: record "Purch. Inv. Line";
        PurchInvHeader: record "Purch. Inv. Header";
        PurchLine: record "Purchase Line";
        PurchHeader: record "Purchase Header";
        Item: record Item;
    begin
        ItemLedgerEntryPurch.setrange("Document Type", ItemLedgerEntryPurch."Document Type"::"Purchase Receipt");
        ItemLedgerEntryPurch.setrange("Serial No.", TempItemLedgEntrySales."Serial No.");
        if ItemLedgerEntryPurch.FindFirst() then begin
            if ItemLedgerEntryPurch."Entry No." = 0 then
                exit;
            if (ItemLedgerEntryPurch."Entry Type" <> ItemLedgerEntryPurch."Entry Type"::Purchase) and
            (ItemLedgerEntryPurch."Entry Type" <> ItemLedgerEntryPurch."Entry Type"::Sale) then begin
                PurchOrderNo := format(ItemLedgerEntryPurch."Entry Type");
                PurchOrderPostDate := ItemLedgerEntryPurch."Posting Date";
                StandardCostPercentage := FindPurchaseDisc(PurchasePrice, Item, PurchOrderPostDate);
                exit;
            end;
            if PurchRcptLine.get(ItemLedgerEntryPurch."Document No.", ItemLedgerEntryPurch."Document Line No.") then begin
                PurchInvLine.setrange("Order No.", PurchRcptLine."Order No.");
                PurchInvLine.SetRange("Order Line No.", PurchRcptLine."Order Line No.");
                if PurchInvLine.findfirst then begin
                    PurchInvHeader.get(PurchInvLine."Document No.");
                    PurchOrderNo := PurchInvLine."Order No.";
                    PurchCostPrice := PurchInvLine."Direct Unit Cost";
                    PurchOrderPostDate := PurchInvLine."Posting Date";
                    if Item.get(PurchInvLine."No.") then
                        StandardCostPercentage := FindPurchaseDisc(PurchasePrice, Item, PurchOrderPostDate);
                    if "Sales Cr.Memo Line"."Bid No." = '' then
                        Currency := PurchInvHeader."Currency Code";
                end else begin
                    if PurchLine.GET(Purchline."Document Type"::Order, PurchRcptLine."Order No.", PurchRcptLine."Order Line No.") then begin
                        PurchHeader.get(PurchLine."Document Type", Purchline."Document No.");
                        PurchOrderNo := PurchLine."Document No.";
                        PurchCostPrice := PurchLine."Direct Unit Cost";
                        PurchOrderPostDate := PurchHeader."Posting Date";
                        if Item.get(PurchLine."No.") then
                            StandardCostPercentage := FindPurchaseDisc(PurchasePrice, Item, PurchOrderPostDate);
                        if "Sales Cr.Memo Line"."Bid No." = '' then
                            Currency := PurchHeader."Currency Code";
                    end;
                end;
                if (PurchCostPrice <> 0) and (BidUnitPurchasePrice <> 0) then
                    BidCostPercentage := (PurchCostPrice - BidUnitPurchasePrice) / PurchCostPrice;
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

    procedure FindPurchaseDisc(var PurchPrice: record "Purchase Price"; item: record Item; PostingDate: Date): Decimal
    var
        ItemDiscPercentage: record "Item Disc. Group Percentages";
    begin
        /* PurchPrice.setrange("Vendor No.", Item."Vendor No.");
        PurchPrice.setrange("Item No.", Item."No.");
        PurchPrice.setrange("Unit of Measure Code", item."Base Unit of Measure");
        PurchPrice.setrange("Currency Code", item."Vendor Currency");
        PurchPrice.Setfilter("Ending Date", '>%1|%2', PostingDate, 0D);
        PurchPrice.SetFilter("Starting Date", '%1|<%2', PostingDate, PostingDate);
        if PurchPrice.FindFirst() then
            exit(PurchPrice."Direct Unit Cost")
        else
            exit(0); */

        itemDiscPercentage.setrange("Item Disc. Group Code", item."Item Disc. Group");
        ItemDiscPercentage.setfilter("Start Date", '<=%1', PostingDate);
        if itemDiscPercentage.findfirst then
            exit(ItemDiscPercentage."Purchase Discount Percentage")
        else
            exit(0);
    end;

    var
        VendorCode: Text[250];
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
        BidCostPercentage: Decimal;
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
        StandardCostPercentage: Decimal;
        PurchasePrice: record "Purchase Price";

        VendorNo: code[20];


}
