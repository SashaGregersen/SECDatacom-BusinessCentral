codeunit 50022 "Post Sales Order IC"
{
    TableNo = "Sales Header";

    trigger OnRun()
    begin
        if not SalesHeader.get(Rec."Document Type", Rec."No.") then
            Error('Sales Order %1 does not exist in company %2', rec."No.", CompanyName());
        If SalesHeader.Status = SalesHeader.Status::Released then
            ReleasesalesDoc.PerformManualReopen(SalesHeader);
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindSet(true, false) then
            repeat
                QtyToShip := SalesLine."Qty. to Ship";
                QtyToInvoice := SalesLine."Qty. to Invoice";
                SalesLine.validate("Qty. to Ship", QtyToShip);
                if QtyToShip <> 0 then
                    DoShip := true;
                SalesLine.validate("Qty. to Invoice", QtyToInvoice);
                if QtyToInvoice <> 0 then
                    DoInvoice := true;
                SalesLine.Modify(true);
            until SalesLine.Next() = 0;
        If SalesHeader.Status = SalesHeader.Status::Open then
            ReleaseSalesDoc.PerformManualRelease(SalesHeader);
        if not SalesHeader.get(Rec."Document Type", Rec."No.") then
            Error('Sales Order %1 in company %2 Could not be updated', rec."No.", CompanyName())
        else begin
            SalesHeader.Ship := DoShip;
            SalesHeader.Invoice := DoInvoice;
        end;
        PostSales.Run(SalesHeader);
    end;

    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        QtyToShip: Decimal;
        QtyToInvoice: Decimal;
        DoShip: Boolean;
        DoInvoice: Boolean;
        PostSales: Codeunit "Sales-Post";
        ReleaseSalesDoc: Codeunit "Release Sales Document";

}