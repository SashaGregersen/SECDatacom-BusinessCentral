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
    begin
        if not PurchSetup.Get() then
            exit;
        if PurchSetup."Claims Charge No." = '' then
            exit;
        SalesShipLine.SetRange("Document No.", SalesShipmentHeader."No.");
        if SalesShipLine.FindSet() then
            repeat
                if not SalesShipLine.Claimable then
                    exit;
                if SalesShipLine."Claim Amount" = 0 then
                    exit;
                if not Bid.Get(SalesshipLine."Bid No.") then
                    exit;
                if not Vendor.Get(bid."Vendor No.") then
                    exit;
                if not ClaimsVendor.Get(Vendor."Claims Vendor") then
                    exit;
                PurchHeader.Init();
                PurchHeader.Validate("Document Type", PurchHeader."Document Type"::"Credit Memo");
                PurchHeader.validate("Posting Date", SalesHeader."Posting Date");
                PurchHeader.Validate("Buy-from Vendor No.", ClaimsVendor."No.");
                PurchHeader.insert(true);
                PurchLine.Init();
                PurchLine.Validate("Document Type", PurchHeader."Document Type");
                PurchLine.Validate("Document No.", PurchHeader."No.");
                PurchLine.Validate("Line No.", 10000);
                PurchLine.Insert(true);
                PurchLine.Validate(Type, PurchLine.Type::"Charge (Item)");
                PurchLine.Validate("No.", PurchSetup."Claims Charge No.");
                PurchLine.Validate(Quantity, 1);
                PurchLine.Validate("Direct Unit Cost", SalesshipLine."Claim Amount");
                PurchLine.Insert(true);
                ItemChargeAssignment.Init();
                ItemChargeAssignment."Document Line No." := PurchLine."Line No.";
                ItemChargeAssignment."Document No." := PurchLine."Document No.";
                ItemChargeAssignment."Document Type" := PurchLine."Document Type";
                ItemChargeAssignment."Line No." := PurchLine."Line No.";
                ItemChargeAssignment."Applies-to Doc. Line No." := SalesShipLine."Line No.";
                ItemChargeAssignment."Applies-to Doc. No." := SalesShipLine."Document No.";
                ItemChargeAssignment."Applies-to Doc. Type" := ItemChargeAssignment."Applies-to Doc. Type"::"Sales Shipment";
                ItemChargeAssignment.Validate("Item Charge No.", PurchLine."No.");
                ItemChargeAssignment.Validate("Item No.", SalesShipLine."No.");
                ItemChargeAssignment.Validate("Unit Cost", PurchLine."Direct Unit Cost");
                ItemChargeAssignment.Validate("Qty. to Assign", 1);
                ItemChargeAssignment.Insert(true);
            until SalesShipLine.Next() = 0;
    end;

}