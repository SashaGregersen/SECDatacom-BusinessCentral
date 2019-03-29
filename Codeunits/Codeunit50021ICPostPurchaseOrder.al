codeunit 50021 "Post Purchase Order IC"
{
    TableNo = "Purchase Header";

    trigger OnRun()
    begin
        if not PurchHeader.get(Rec."Document Type", Rec."No.") then
            Error('Purchase Order %1 does not exist in company %2', rec."No.", CompanyName());
        PurchLine.SetRange("Document No.", PurchHeader."No.");
        if PurchLine.FindSet(true, false) then
            repeat
                QtyToReceive := PurchLine."Qty. to Receive";
                QtyToInvoice := PurchLine."Qty. to Invoice";
                PurchLine.validate("Qty. to Receive", QtyToReceive);
                PurchLine.validate("Qty. to Invoice", QtyToReceive);
                PurchLine.Modify(true);
            until PurchLine.Next() = 0;
        PostPurchase.Run(PurchHeader);
    end;

    var
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        QtyToReceive: Decimal;
        QtyToInvoice: Decimal;
        PostPurchase: Codeunit "Purch.-Post";

}