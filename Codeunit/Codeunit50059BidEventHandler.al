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
        BidMgt: Codeunit "Bid Management";
    begin
        case SalesHeader."Document Type" of
            SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice:
                BidMgt.MakeCreditClaimsPosting(SalesHeader, SalesShipmentHeader, SalesInvoiceHeader, SalesCrMemoHeader, ReturnReceiptHeader);
            SalesHeader."Document Type"::"Return Order", SalesHeader."Document Type"::"Credit Memo":
                BidMgt.MakeDebitClaimsPosting(SalesHeader, SalesShipmentHeader, SalesInvoiceHeader, SalesCrMemoHeader, ReturnReceiptHeader);
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Shipment Line", 'OnAfterInitFromSalesLine', '', true, true)]
    local procedure UpdateBidOnSalesShptLine(SalesShptHeader: Record "Sales Shipment Header"; SalesLine: Record "Sales Line"; var SalesShptLine: Record "Sales Shipment Line")
    begin
        if SalesLine."Qty. to Ship" <> SalesLine.Quantity then
            SalesShptLine."Claim Amount" := round((SalesLine."Qty. to Ship" / SalesLine.Quantity) * SalesShptLine."Claim Amount");
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Invoice Line", 'OnAfterInitFromSalesLine', '', true, true)]
    local procedure UpdateBidOnSalesInvLine(VAR SalesInvLine: Record "Sales Invoice Line"; SalesInvHeader: Record "Sales Invoice Header"; SalesLine: Record "Sales Line")
    begin
        if SalesLine."Qty. to Invoice" <> SalesLine.Quantity then
            SalesinvLine."Claim Amount" := round((SalesLine."Qty. to Invoice" / SalesLine.Quantity) * SalesinvLine."Claim Amount");
    end;
}