codeunit 50059 "Bid Event Handler"
{
    SingleInstance = true;
    EventSubscriberInstance = StaticAutomatic;

    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post", 'OnAfterPostSalesLines', '', true, true)]
    local procedure OnAfterPostSalesDocOnPostSalesHeader(VAR SalesHeader: Record "Sales Header"; VAR SalesShipmentHeader: Record "Sales Shipment Header"; VAR SalesInvoiceHeader: Record "Sales Invoice Header"; VAR SalesCrMemoHeader: Record "Sales Cr.Memo Header"; VAR ReturnReceiptHeader: Record "Return Receipt Header"; WhseShip: Boolean; WhseReceive: Boolean; VAR SalesLinesProcessed: Boolean; CommitIsSuppressed: Boolean)
    var
        Bid: Record Bid;
        Vendor: Record Vendor;
        ClaimsVendor: Record Vendor;
        PurchSetup: Record "Purchases & Payables Setup";
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        ItemChargeAssignment: Record "Item Charge Assignment (Purch)";
        SalesShipLine: Record "Sales Shipment Line";
        SalesInvLine: Record "Sales Invoice Line";
        DoPostPurchaseheader: Boolean;
        PurchPost: Codeunit "Purch.-Post";
        LineNo: Integer;
    begin
        //Only works for invoicing at the moment - add support for credit memos later
        exit; //TEST without this


        if not PurchSetup.Get() then
            exit;
        if PurchSetup."Claims Charge No." = '' then
            exit;
        SalesInvLine.SetRange("Document No.", SalesInvoiceHeader."No.");
        SalesInvLine.SetFilter(Quantity, '<>0');
        SalesInvLine.SetRange(Claimable, true);
        SalesInvLine.SetFilter("Claim Amount", '<>0');
        DoPostPurchaseheader := false;
        if SalesInvLine.FindSet() then
            repeat
                if not Bid.Get(SalesInvLine."Bid No.") then
                    exit;
                if not Vendor.Get(bid."Vendor No.") then
                    exit;
                if not ClaimsVendor.Get(Vendor."Claims Vendor") then
                    Error('Sales Invoice %1 uses Bid %2 from Vendor %3. Please add a value in the Claims Vendor field on Vendor %3', SalesInvoiceHeader."No.", SalesInvLine."Bid No.", Vendor."No.");
                SalesShipLine.SetRange("Order No.", SalesInvLine."Order No.");
                SalesShipLine.SetRange("Order Line No.", SalesInvLine."Order Line No.");
                SalesShipLine.SetFilter("Claim Document No.", '');
                if SalesShipLine.FindSet(true, false) then begin
                    PurchHeader.Init();
                    PurchHeader.Validate("Document Type", PurchHeader."Document Type"::"Credit Memo");
                    PurchHeader.validate("Posting Date", SalesHeader."Posting Date");
                    PurchHeader.Validate("Buy-from Vendor No.", ClaimsVendor."No.");
                    PurchHeader."Vendor Cr. Memo No." := SalesinvoiceHeader."No.";
                    PurchHeader.insert(true);
                    PurchLine.Init();
                    PurchLine.Validate("Document Type", PurchHeader."Document Type");
                    PurchLine.Validate("Document No.", PurchHeader."No.");
                    PurchLine.Validate("Line No.", SalesInvLine."Line No.");
                    PurchLine.Insert(true);
                    PurchLine.Validate(Type, PurchLine.Type::"Charge (Item)");
                    PurchLine.Validate("No.", PurchSetup."Claims Charge No.");
                    PurchLine.Validate(Quantity, 1);
                    PurchLine.Validate("Direct Unit Cost", SalesInvLine."Claim Amount");
                    PurchLine.Modify(true);
                    LineNo := 0;
                    repeat
                        ItemChargeAssignment.Init();
                        ItemChargeAssignment."Document Line No." := PurchLine."Line No.";
                        ItemChargeAssignment."Document No." := PurchLine."Document No.";
                        ItemChargeAssignment."Document Type" := PurchLine."Document Type";
                        LineNo := LineNo + 10000;
                        ItemChargeAssignment."Line No." := LineNo;
                        ItemChargeAssignment."Applies-to Doc. Line No." := SalesShipLine."Line No.";
                        ItemChargeAssignment."Applies-to Doc. No." := SalesShipLine."Document No.";
                        ItemChargeAssignment."Applies-to Doc. Type" := ItemChargeAssignment."Applies-to Doc. Type"::"Sales Shipment";
                        ItemChargeAssignment.Validate("Item Charge No.", PurchLine."No.");
                        ItemChargeAssignment.Validate("Item No.", SalesShipLine."No.");
                        ItemChargeAssignment.Validate("Unit Cost", SalesShipLine."Claim Amount");
                        ItemChargeAssignment.Validate("Qty. to Assign", 1);
                        ItemChargeAssignment.Insert(true);
                        SalesShipLine."Claim Document No." := PurchHeader."No.";
                        SalesShipLine.Modify(false);
                    until SalesShipLine.Next() = 0;
                    DoPostPurchaseheader := true;
                end;
            until SalesShipLine.Next() = 0;
        /*         if DoPostPurchaseheader then begin
                    PurchPost.SetPreviewMode(false);
                    PurchPost.SetSuppressCommit(false);
                    PurchPost.Run(PurchHeader);
                end; */
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Shipment Line", 'OnAfterInitFromSalesLine', '', true, true)]
    local procedure UpdateBidOnSalesShptLine(SalesShptHeader: Record "Sales Shipment Header"; SalesLine: Record "Sales Line"; var SalesShptLine: Record "Sales Shipment Line")
    var
        myInt: Integer;
    begin
        if SalesLine."Qty. to Ship" <> SalesLine.Quantity then
            SalesShptLine."Claim Amount" := round((SalesLine."Qty. to Ship" / SalesLine.Quantity) * SalesShptLine."Claim Amount");
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Invoice Line", 'OnAfterInitFromSalesLine', '', true, true)]
    local procedure UpdateBidOnSalesInvLine(VAR SalesInvLine: Record "Sales Invoice Line"; SalesInvHeader: Record "Sales Invoice Header"; SalesLine: Record "Sales Line")
    var
        myInt: Integer;
    begin
        if SalesLine."Qty. to Invoice" <> SalesLine.Quantity then
            SalesinvLine."Claim Amount" := round((SalesLine."Qty. to Invoice" / SalesLine.Quantity) * SalesinvLine."Claim Amount");
    end;
}