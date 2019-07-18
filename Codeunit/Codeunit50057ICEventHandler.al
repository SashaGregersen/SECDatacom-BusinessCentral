codeunit 50057 "IC Event Handler"
{
    SingleInstance = true;
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::Codeunit, codeunit::ICInboxOutboxMgt, 'OnAfterCreateSalesLines', '', true, true)]
    local procedure OnAfterCreateSalesLinesICIOMgt(ICInboxSalesLine: Record "IC Inbox Sales Line"; var SalesLine: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
        ICPartner: Record "IC Partner";
    begin
        if not ICpartner.Get(ICInboxSalesLine."IC Partner Code") then
            exit;
        SalesHeader.get(SalesLine."Document Type", SalesLine."Document No.");
        UpdateSalesOrderWithInfofromSubsidiary(SalesHeader, SalesLine, ICInboxSalesLine, ICPartner);
    end;

    local procedure UpdateSalesOrderWithInfoFromSubsidiary(LocalSalesHeader: Record "Sales Header"; var LocalSalesline: Record "Sales Line"; ICInboxSalesLine: Record "IC Inbox Sales Line"; ICPartner: Record "IC Partner")
    var
        PurchaseLineOtherCompany: Record "Purchase Line";
        SalesLineOtherCompany: Record "Sales Line";
        SalesHeaderOtherCompany: Record "Sales Header";
    begin
        if not GetPurchaseLineFromOtherCompany(ICInboxSalesLine, PurchaseLineOtherCompany, ICPartner."Inbox Details") then
            exit;
        UpdateSalesLineWithICPOInfo(PurchaseLineOtherCompany, LocalSalesline);
        if not GetSalesLineFromOtherCompany(PurchaseLineOtherCompany, SalesLineOtherCompany, ICPartner."Inbox Details") then
            exit;
        UpdateSalesLineWithICSOInfo(SalesLineOtherCompany, LocalSalesline);
        if LocalSalesHeader.Subsidiary = '' then begin
            if GetSalesHeaderFromOtherCompany(SalesLineOtherCompany, SalesHeaderOtherCompany, ICPartner."Inbox Details") then
                CopyAdvPricingHeaderFields(LocalSalesHeader, SalesHeaderOtherCompany, ICPartner."Customer No.");
        end;
        CopyAdvPricingLineFields(LocalSalesline, SalesLineOtherCompany);
    end;

    local procedure CopyAdvPricingHeaderFields(LocalSalesHeader: Record "Sales Header"; SalesHeaderOtherCompany: Record "Sales Header"; SubsidiaryCustomerNo: code[20])
    var
        Customer: record customer;
    begin
        LocalSalesHeader."External Document No." := SalesHeaderOtherCompany."External Document No.";
        LocalSalesHeader.Subsidiary := SubsidiaryCustomerNo;
        LocalSalesHeader.Reseller := SalesHeaderOtherCompany.Reseller;
        if SalesHeaderOtherCompany."End Customer" <> '' then
            LocalSalesHeader."End Customer" := SalesHeaderOtherCompany."End Customer";
        if SalesHeaderOtherCompany."End Customer Name" <> '' then
            LocalSalesHeader.validate("End Customer Name", SalesHeaderOtherCompany."End Customer Name");
        if SalesHeaderOtherCompany."End Customer Contact" <> '' then
            LocalSalesHeader."End Customer Contact" := SalesHeaderOtherCompany."End Customer Contact";
        if SalesHeaderOtherCompany."End Customer Contact Name" <> '' then
            LocalSalesHeader."End Customer Contact Name" := SalesHeaderOtherCompany."End Customer Contact Name";
        if SalesHeaderOtherCompany."End Customer Phone No." <> '' then
            LocalSalesHeader."End Customer Phone No." := SalesHeaderOtherCompany."End Customer Phone No.";
        if SalesHeaderOtherCompany."End Customer Email" <> '' then
            LocalSalesHeader."End Customer Email" := SalesHeaderOtherCompany."End Customer Email";
        if LocalSalesHeader.Subsidiary <> '' then begin
            Customer.get(LocalSalesHeader.Subsidiary);
            LocalSalesHeader.validate("Subsidiary Name", Customer.Name);
            LocalSalesHeader.validate("Sell-to-Customer-Name", Customer.Name);
        end;
        if SalesHeaderOtherCompany."Reseller Name" <> '' then
            LocalSalesHeader.Validate("Reseller Name", SalesHeaderOtherCompany."Reseller Name");
        LocalSalesHeader."Ship directly from supplier" := SalesHeaderOtherCompany."Ship directly from supplier";
        LocalSalesHeader."Drop-shipment" := SalesHeaderOtherCompany."Drop-Shipment";
        LocalSalesHeader.SetShipToAddress(SalesHeaderOtherCompany."Ship-to Name", SalesHeaderOtherCompany."Ship-to Name 2",
        SalesHeaderOtherCompany."Ship-to Address", SalesHeaderOtherCompany."Ship-to Address 2", SalesHeaderOtherCompany."Ship-to City",
        SalesHeaderOtherCompany."Ship-to Post Code", SalesHeaderOtherCompany."Ship-to County", SalesHeaderOtherCompany."Ship-to Country/Region Code");
        LocalSalesHeader."Ship-To-Code" := SalesHeaderOtherCompany."Ship-To-Code";
        LocalSalesHeader."Ship-to Contact" := SalesHeaderOtherCompany."Ship-to Contact";
        LocalSalesHeader."Ship-to Phone No." := SalesHeaderOtherCompany."Ship-to Phone No.";
        LocalSalesHeader."Ship-to Email" := SalesHeaderOtherCompany."Ship-to Email";
        LocalSalesHeader."Ship-to Comment" := SalesHeaderOtherCompany."Ship-to Comment";
        LocalSalesHeader.Modify(false);
    end;

    local procedure CopyAdvPricingLineFields(LocalSalesLine: Record "Sales Line"; SalesLineOtherCompany: Record "Sales Line")
    begin
        //der skal noget currency ind over de her felter...
        LocalSalesLine."Bid No." := SalesLineOtherCompany."Bid No.";
        LocalSalesLine."Bid Sales Discount" := SalesLineOtherCompany."Bid Sales Discount";
        LocalSalesLine."Bid Unit Sales Price" := SalesLineOtherCompany."Bid Unit Sales Price";
        LocalSalesLine."Bid Purchase Discount" := SalesLineOtherCompany."Bid Purchase Discount";
        LocalSalesLine."Bid Unit Purchase Price" := SalesLineOtherCompany."Bid Unit Purchase Price";
    end;

    local procedure GetPurchaseLineFromOtherCompany(ICInboxSalesLine: Record "IC Inbox Sales Line"; var PurchaseLineOtherCompany: Record "Purchase Line"; OtherCompanyName: text[30]): Boolean
    begin
        PurchaseLineOtherCompany.ChangeCompany(OtherCompanyName);
        exit(PurchaseLineOtherCompany.Get(ICInboxSalesLine."Document Type" + 1, ICInboxSalesLine."Document No.", ICInboxSalesLine."Line No."));
    end;

    local procedure GetSalesLineFromOtherCompany(PurchaseLineOtherCompany: Record "Purchase Line"; var SalesLineOtherCompany: Record "Sales Line"; OtherCompanyName: text[30]): Boolean
    var
        PurchaseReservationEntry: Record "Reservation Entry";
        SalesReservationEntry: Record "Reservation Entry";
    begin
        PurchaseReservationEntry.ChangeCompany(OtherCompanyName);
        PurchaseReservationEntry.SetRange("Source Subtype", PurchaseLineOtherCompany."Document Type");
        PurchaseReservationEntry.SetRange("Source ID", PurchaseLineOtherCompany."Document No.");
        PurchaseReservationEntry.SetRange("Source Ref. No.", PurchaseLineOtherCompany."Line No.");
        PurchaseReservationEntry.SetRange("Source type", 39);
        if not PurchaseReservationEntry.FindFirst() then begin
            Clear(SalesLineOtherCompany);
            exit(false);
        end;
        SalesReservationEntry.ChangeCompany(OtherCompanyName);
        if not SalesReservationEntry.Get(PurchaseReservationEntry."Entry No.", not PurchaseReservationEntry.Positive) then begin
            Clear(SalesLineOtherCompany);
            exit(false);
        end;
        SalesLineOtherCompany.ChangeCompany(OtherCompanyName);
        if not SalesLineOtherCompany.Get(SalesReservationEntry."Source Subtype", SalesReservationEntry."Source ID", SalesReservationEntry."Source Ref. No.") then begin
            Clear(SalesLineOtherCompany);
            exit(false);
        end;
        exit(true);
    end;

    local procedure GetSalesHeaderFromOtherCompany(SalesLineOtherCompany: Record "Sales Line"; var SalesHeaderOtherCompany: Record "Sales Header"; OtherCompanyName: text[30]): Boolean
    begin
        SalesHeaderOtherCompany.ChangeCompany(OtherCompanyName);
        if not SalesHeaderOtherCompany.get(SalesLineOtherCompany."Document Type", SalesLineOtherCompany."Document No.") then begin
            Clear(SalesHeaderOtherCompany);
            exit(false);
        end;
        exit(true);
    end;

    local procedure GetPurchaseHeaderFromOtherCompany(PurchLineOtherCompany: Record "purchase Line"; var PurchHeaderOtherCompany: Record "Purchase Header"; OtherCompanyName: text[30]): Boolean
    begin
        PurchHeaderOtherCompany.ChangeCompany(OtherCompanyName);
        if not PurchHeaderOtherCompany.get(PurchLineOtherCompany."Document Type", PurchLineOtherCompany."Document No.") then begin
            Clear(PurchHeaderOtherCompany);
            exit(false);
        end;
        exit(true);
    end;

    local procedure UpdateSalesLineWithICPOInfo(ICPurchLine: Record "Purchase Line"; var LocalSalesLine: Record "Sales Line")
    begin
        LocalSalesLine."IC PO No." := ICPurchLine."Document No.";
        LocalSalesLine."IC PO Line No." := ICPurchLine."Line No.";
        LocalSalesLine.Validate("Bid No.", ICPurchLine."Bid No.");
        LocalSalesLine.Validate("Unit Price", ICPurchLine."Direct Unit Cost");
    end;

    local procedure UpdateSalesLineWithICSOInfo(ICSalesline: Record "sales Line"; var LocalSalesLine: Record "Sales Line")
    var
        Item: Record Item;
    begin
        //if item.get(LocalSalesLine."No.") then;
        LocalSalesLine."IC SO No." := ICsalesLine."Document No.";
        LocalSalesLine."IC SO Line No." := ICsalesLine."Line No.";
        LocalSalesLine.Validate("Location Code", ICSalesline."Location Code");
    end;

    procedure GetICPartner(var ICpartner: Record "IC Partner"; CustomerNo: code[20]): Boolean
    begin
        ICpartner.SetRange("Customer No.", CustomerNo);
        exit(ICpartner.FindFirst());
    end;

    local procedure UpdateReceiptsOnPurchaseOrderInOtherCompany(SalesShptHdrNo: Code[20]; OtherCompanyName: text[35])
    var
        SalesShptHeader: Record "Sales Shipment Header";
        SalesShptLine: Record "Sales Shipment Line";
        POLineInOtherCompany: Record "Purchase Line";
    begin
        if not SalesShptHeader.Get(SalesShptHdrNo) then
            exit;
        SalesShptLine.SetRange("Document No.", SalesShptHeader."No.");
        POLineInOtherCompany.ChangeCompany(OtherCompanyName);
        if SalesShptLine.FindSet() then
            repeat
                if POLineInOtherCompany.Get(POLineInOtherCompany."Document Type"::Order, SalesShptLine."IC PO No.", SalesShptLine."IC PO Line No.") then begin
                    POLineInOtherCompany."Qty. to Receive" := SalesShptLine.Quantity;
                    POLineInOtherCompany."Qty. to Invoice" := 0;
                    POLineInOtherCompany.Modify(false);
                end;
            until SalesShptLine.Next() = 0;
    end;

    local procedure TransferSerialNosFromShipmentToOtherCompany(SalesShptHdrNo: Code[20]; OtherCompanyName: text[35])
    var
        SalesShptHeader: Record "Sales Shipment Header";
        SalesShptLine: Record "Sales Shipment Line";
        ItemLedgerEntry: Record "Item Ledger Entry";
        SerialNoICExch: Record "Serial No. Intercompany Exch.";
    begin
        if not SalesShptHeader.Get(SalesShptHdrNo) then
            exit;
        SalesShptLine.SetRange("Document No.", SalesShptHeader."No.");
        SerialNoICExch.ChangeCompany(OtherCompanyName);
        if SalesShptLine.FindSet() then
            repeat
                ItemLedgerEntry.SetRange("Document No.", SalesShptLine."Document No.");
                ItemLedgerEntry.SetRange("Document Line No.", SalesShptLine."Line No.");
                ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Sales Shipment");
                ItemLedgerEntry.SetFilter("Serial No.", '<>%1', '');
                if ItemLedgerEntry.FindSet() then
                    repeat
                        SerialNoICExch.init;
                        SerialNoICExch."Order Type" := SerialNoICExch."Order Type"::"Purchase order";
                        SerialNoICExch."Order No." := SalesShptLine."IC PO No.";
                        SerialNoICExch."Line No." := SalesShptLine."IC PO Line No.";
                        SerialNoICExch."Item No." := SalesShptLine."No.";
                        SerialNoICExch."Serial No." := ItemLedgerEntry."Serial No.";
                        SerialNoICExch.Insert(false);
                    until ItemLedgerEntry.Next() = 0;
            until SalesShptLine.Next() = 0;
    end;

    local procedure UpdateShipmentsOnSalesOrderInOtherCompany(SalesShptHdrNo: Code[20]; OtherCompanyName: text[35])
    var
        SalesShptHeader: Record "Sales Shipment Header";
        SalesShptLine: Record "Sales Shipment Line";
        SOLineInOtherCompany: Record "sales Line";
    begin
        if not SalesShptHeader.Get(SalesShptHdrNo) then
            exit;
        SalesShptLine.SetRange("Document No.", SalesShptHeader."No.");
        SOLineInOtherCompany.ChangeCompany(OtherCompanyName);
        if SalesShptLine.FindSet() then
            repeat
                if SOLineInOtherCompany.Get(SOLineInOtherCompany."Document Type"::Order, SalesShptLine."IC SO No.", SalesShptLine."IC SO Line No.") then begin
                    SOLineInOtherCompany."Qty. to Ship" := SalesShptLine.Quantity;
                    SOLineInOtherCompany."Qty. to Invoice" := 0;
                    SOLineInOtherCompany.Modify(false);
                end;
            until SalesShptLine.Next() = 0;
    end;

    local procedure UpdateInvoiceOnPurchaseOrderInOtherCompany(SalesInvHdrNo: Code[20]; OtherCompanyName: text[35])
    var
        SalesInvHeader: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
        POInOtherCompany: Record "Purchase Header";
        POLineInOtherCompany: Record "Purchase Line";
    begin
        if not SalesInvHeader.Get(SalesInvHdrNo) then
            exit;
        SalesInvLine.SetRange("Document No.", SalesInvHeader."No.");
        POLineInOtherCompany.ChangeCompany(OtherCompanyName);
        if SalesInvLine.FindSet() then
            repeat
                if POLineInOtherCompany.Get(POLineInOtherCompany."Document Type"::Order, SalesInvLine."IC PO No.", SalesInvLine."IC PO Line No.") then begin
                    POLineInOtherCompany."Qty. to Invoice" := SalesInvLine.Quantity;
                    POLineInOtherCompany.Modify(false);
                    if GetPurchaseHeaderFromOtherCompany(POLineInOtherCompany, POInOtherCompany, OtherCompanyName) then begin
                        POInOtherCompany."Vendor Invoice No." := SalesInvHdrNo;
                        POInOtherCompany.Modify(false);
                    end;
                end;
            until SalesInvLine.Next() = 0;
    end;

    local procedure UpdateInvoiceOnSalesOrderInOtherCompany(SalesInvHdrNo: Code[20]; OtherCompanyName: text[35])
    var
        SalesInvHeader: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
        SOLineInOtherCompany: Record "sales Line";
        SOHeaderInOtherCompany: record "Sales Header";
    begin
        if not SalesInvHeader.Get(SalesInvHdrNo) then
            exit;
        SalesInvLine.SetRange("Document No.", SalesInvHeader."No.");
        SOLineInOtherCompany.ChangeCompany(OtherCompanyName);
        SOHeaderInOtherCompany.ChangeCompany(OtherCompanyName);
        if SalesInvLine.FindSet() then
            repeat
                if SOLineInOtherCompany.Get(SOLineInOtherCompany."Document Type"::Order, SalesInvLine."IC SO No.", SalesInvLine."IC SO Line No.") then begin
                    SOLineInOtherCompany."Qty. to Invoice" := SalesInvLine.Quantity;
                    SOLineInOtherCompany.Modify(false);
                end;
            until SalesInvLine.Next() = 0;
        if SOHeaderInOtherCompany.get(SOLineInOtherCompany."Document Type"::Order, SalesInvLine."IC SO No.") then
            SOHeaderInOtherCompany."Package Tracking No." := SalesInvHeader."Package Tracking No.";
    end;

    local procedure AddICPurchaseOrderToTempList(HeaderNo: Code[20]; OtherCompanyName: text[35]; var TempPOList: Record "Purchase Header" temporary)
    var
        SalesShptLine: Record "Sales Shipment Line";
        SalesInvLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        PurchOrderInOtherCompany: Record "Purchase Header";
    begin
        SalesshptLine.SetRange("Document No.", HeaderNo);
        if SalesshptLine.FindSet() then begin
            repeat
                PurchOrderInOtherCompany.ChangeCompany(OtherCompanyName);
                if PurchOrderInOtherCompany.get(PurchOrderInOtherCompany."Document Type"::Order, SalesshptLine."IC PO No.") then begin
                    TempPOList := PurchOrderInOtherCompany;
                    if not TempPOList.Insert(false) then;
                end;
            until SalesshptLine.Next() = 0;
            exit;
        end;
        SalesinvLine.SetRange("Document No.", HeaderNo);
        if SalesinvLine.FindSet() then begin
            repeat
                PurchOrderInOtherCompany.ChangeCompany(OtherCompanyName);
                if PurchOrderInOtherCompany.get(PurchOrderInOtherCompany."Document Type"::Order, SalesinvLine."IC PO No.") then begin
                    TempPOList := PurchOrderInOtherCompany;
                    if not TempPOList.Insert(false) then;
                end;
            until SalesinvLine.Next() = 0;
            exit;
        end;
    end;

    local procedure AddICSalesOrderToTempList(HeaderNo: Code[20]; OtherCompanyName: text[35]; var TempSOList: Record "Sales Header" temporary)
    var
        SalesShptLine: Record "Sales Shipment Line";
        SalesInvLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        SalesOrderInOtherCompany: Record "Sales Header";
    begin
        SalesshptLine.SetRange("Document No.", HeaderNo);
        if SalesshptLine.FindSet() then begin
            repeat
                SalesOrderInOtherCompany.ChangeCompany(OtherCompanyName);
                if SalesOrderInOtherCompany.get(SalesOrderInOtherCompany."Document Type"::Order, SalesshptLine."IC SO No.") then begin
                    TempSOList := SalesOrderInOtherCompany;
                    if not TempSOList.Insert(false) then;
                end;
            until SalesshptLine.Next() = 0;
            exit;
        end;
        SalesinvLine.SetRange("Document No.", HeaderNo);
        if SalesinvLine.FindSet() then begin
            repeat
                SalesOrderInOtherCompany.ChangeCompany(OtherCompanyName);
                if SalesOrderInOtherCompany.get(SalesOrderInOtherCompany."Document Type"::Order, SalesInvLine."IC SO No.") then begin
                    TempSOList := SalesOrderInOtherCompany;
                    if not TempSOList.Insert(false) then;
                end;
            until SalesinvLine.Next() = 0;
            exit;
        end;
        SalescrmemoLine.SetRange("Document No.", HeaderNo);
        if SalescrmemoLine.FindSet() then begin
            repeat
                SalesOrderInOtherCompany.ChangeCompany(OtherCompanyName);
                if SalesOrderInOtherCompany.get(SalesOrderInOtherCompany."Document Type"::Order, SalescrmemoLine."IC SO No.") then begin
                    TempSOList := SalesOrderInOtherCompany;
                    if not TempSOList.Insert(false) then;
                end;
            until SalescrmemoLine.Next() = 0;
            exit;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post", 'OnAfterFinalizePosting', '', true, true)]
    local procedure OnAfterFinalizePostingEvent(VAR SalesHeader: Record "Sales Header"; VAR SalesShipmentHeader: Record "Sales Shipment Header"; VAR SalesInvoiceHeader: Record "Sales Invoice Header"; VAR SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var ReturnReceiptHeader: Record "Return Receipt Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; CommitIsSuppressed: Boolean; PreviewMode: Boolean)
    var
        ICpartner: Record "IC Partner";
        ICSyncMgt: Codeunit "IC Sync Management";
        TempICPurchOrder: Record "Purchase Header" temporary;
        TempICSalesOrder: Record "Sales Header" temporary;
        ICPurchOrder: Record "Purchase Header";
        ICSalesOrder: Record "Sales Header";
    begin
        if SalesHeader.Subsidiary <> '' then begin
            GetICPartner(ICpartner, SalesHeader.Subsidiary);
            UpdateReceiptsOnPurchaseOrderInOtherCompany(SalesShipmentHeader."No.", ICpartner."Inbox Details");
            TransferSerialNosFromShipmentToOtherCompany(SalesShipmentHeader."No.", ICpartner."Inbox Details");
            AddICPurchaseOrderToTempList(SalesShipmentHeader."No.", ICpartner."Inbox Details", TempICPurchOrder);
            UpdateShipmentsOnSalesOrderInOtherCompany(SalesShipmentHeader."No.", ICpartner."Inbox Details");
            //NOT necessary to transfer serial nos. to SO - it is the same reservation entry as PO
            AddICSalesOrderToTempList(SalesShipmentHeader."No.", ICpartner."Inbox Details", TempICSalesOrder);
            //Add support for return orders
            if SalesInvoiceHeader."No." <> '' then begin
                UpdateInvoiceOnPurchaseOrderInOtherCompany(SalesInvoiceHeader."No.", ICpartner."Inbox Details");
                AddICPurchaseOrderToTempList(SalesInvoiceHeader."No.", ICpartner."Inbox Details", TempICPurchOrder);
                UpdateInvoiceOnSalesOrderInOtherCompany(SalesInvoiceHeader."No.", ICpartner."Inbox Details");
                AddICSalesOrderToTempList(SalesInvoiceHeader."No.", ICpartner."Inbox Details", TempICSalesOrder);
            end;
            if SalesCrMemoHeader."No." <> '' then begin
                UpdateInvoiceOnPurchaseOrderInOtherCompany(SalesCrMemoHeader."No.", ICpartner."Inbox Details"); //remember to create the credit memo function  and update the case
                AddICPurchaseOrderToTempList(SalesCrMemoHeader."No.", ICpartner."Inbox Details", TempICPurchOrder);
            end;
            Commit();
            if TempICPurchOrder.FindSet() then
                repeat
                    ICPurchOrder := TempICPurchOrder;
                    ICSyncMgt.PostPurchaseOrderInOtherCompany(ICPurchOrder, ICpartner."Inbox Details");
                until TempICPurchOrder.Next() = 0;
            if TempICSalesOrder.FindSet() then
                repeat
                    ICSalesOrder := TempICSalesOrder;
                    ICSyncMgt.PostSalesOrderInOtherCompany(ICSalesOrder, ICpartner."Inbox Details");
                until TempICPurchOrder.Next() = 0;
        end;
    end;
}