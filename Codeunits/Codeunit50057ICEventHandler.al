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

    local procedure UpdateSalesOrderWithInfoFromSubsidiary(LocalSalesHeader: Record "Sales Header"; LocalSalesline: Record "Sales Line"; ICInboxSalesLine: Record "IC Inbox Sales Line"; ICPartner: Record "IC Partner")
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
        LocalSalesHeader.Subsidiary := SubsidiaryCustomerNo;
        LocalSalesHeader.Reseller := SalesHeaderOtherCompany.Reseller;
        if SalesHeaderOtherCompany."End Customer" <> '' then
            LocalSalesHeader."End Customer" := SalesHeaderOtherCompany."End Customer";
        if SalesHeaderOtherCompany."End Customer Name" <> '' then
            LocalSalesHeader.validate("End Customer Name", SalesHeaderOtherCompany."End Customer Name");
        if LocalSalesHeader.Subsidiary <> '' then begin
            Customer.get(LocalSalesHeader.Subsidiary);
            LocalSalesHeader.validate("Subsidiary Name", Customer.Name);
            LocalSalesHeader.validate("Sell-to-Customer-Name", Customer.Name);
        end;
        if SalesHeaderOtherCompany."Reseller Name" <> '' then
            LocalSalesHeader.Validate("Reseller Name", SalesHeaderOtherCompany."Reseller Name");
        LocalSalesHeader.Validate("Ship directly from supplier", SalesHeaderOtherCompany."Ship directly from supplier");
        LocalSalesHeader.Validate("Drop-shipment", SalesHeaderOtherCompany."Drop-Shipment");
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

    local procedure UpdateSalesLineWithICPOInfo(ICPurchLine: Record "Purchase Line"; var LocalSalesLine: Record "Sales Line")
    begin
        LocalSalesLine."IC PO No." := ICPurchLine."Document No.";
        LocalSalesLine."IC PO Line No." := ICPurchLine."Line No.";
    end;

    local procedure UpdateSalesLineWithICSOInfo(ICSalesline: Record "sales Line"; var LocalSalesLine: Record "Sales Line")
    begin
        LocalSalesLine."IC SO No." := ICsalesLine."Document No.";
        LocalSalesLine."IC SO Line No." := ICsalesLine."Line No.";
    end;

    local procedure GetICPartner(var ICpartner: Record "IC Partner"; CustomerNo: code[20]): Boolean
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
                if POLineInOtherCompany.Get(SalesShptLine."IC PO No.", SalesShptLine."IC PO Line No.") then begin
                    POLineInOtherCompany."Qty. to Receive" := SalesShptLine.Quantity;
                    POLineInOtherCompany.Modify(false);
                end;
            until SalesShptLine.Next() = 0;
    end;

    local procedure UpdateInvoiceOnPurchaseOrderInOtherCompany(SalesInvHdrNo: Code[20]; OtherCompanyName: text[35])
    var
        SalesInvHeader: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
        POLineInOtherCompany: Record "Purchase Line";
    begin
        if not SalesInvHeader.Get(SalesInvHdrNo) then
            exit;
        SalesInvLine.SetRange("Document No.", SalesInvHeader."No.");
        POLineInOtherCompany.ChangeCompany(OtherCompanyName);
        if SalesInvLine.FindSet() then
            repeat
                if POLineInOtherCompany.Get(SalesInvLine."IC PO No.", SalesInvLine."IC PO Line No.") then begin
                    POLineInOtherCompany."Qty. to Invoice" := SalesInvLine.Quantity;
                    POLineInOtherCompany.Modify(false);
                end;
            until SalesInvLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', true, true)]
    local procedure OnAfterPostSalesDocOnPostSalesHeader(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean)
    var
        ICpartner: Record "IC Partner";
    begin
        if SalesHeader.Subsidiary <> '' then begin
            GetICPartner(ICpartner, SalesHeader.Subsidiary);
            UpdateReceiptsOnPurchaseOrderInOtherCompany(SalesShptHdrNo, ICpartner."Inbox Details");
            case SalesHeader."Document Type" of
                salesheader."Document Type"::Invoice:
                    UpdateInvoiceOnPurchaseOrderInOtherCompany(SalesInvHdrNo, ICpartner."Inbox Details");
                salesheader."Document Type"::"Credit Memo":
                    UpdateInvoiceOnPurchaseOrderInOtherCompany(SalesInvHdrNo, ICpartner."Inbox Details");
            end;
            //remeber to create the credit memo function  and update the case
        end;
    end;
}