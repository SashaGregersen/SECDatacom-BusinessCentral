codeunit 50025 "IC Update Serial Nos. on PO"
{
    TableNo = "Purchase Header";

    trigger OnRun()
    var
        SerialExchange: Record "Serial No. Intercompany Exch.";
    begin
        if not PurchHeader.get(Rec."Document Type", Rec."No.") then
            Error('Purchase Order %1 does not exist in company %2', rec."No.", CompanyName());
        //If PurchHeader.Status = PurchHeader.Status::Released then
        //    ReleasePurchDoc.PerformManualReopen(PurchHeader);
        PurchLine.SetRange("Document No.", PurchHeader."No.");
        if PurchLine.FindSet() then
            repeat
                SerialExchange.SetRange("Order Type", SerialExchange."Order Type"::"Purchase order");
                SerialExchange.SetRange("Order No.", PurchLine."Document No.");
                SerialExchange.SetRange("Line No.", PurchLine."Line No.");
                if SerialExchange.FindSet() then
                    repeat
                        CreateItemLedgerEntryTemp(SerialExchange);
                        SerialNoOnPO.UpdateReservationEntries(TempItemLedgerEntry, PurchLine);
                    until SerialExchange.Next() = 0;
            until PurchLine.Next() = 0;
        //If PurchHeader.Status = PurchHeader.Status::Open then
        //    ReleasePurchDoc.PerformManualRelease(PurchHeader);
    end;

    local procedure CreateItemLedgerEntryTemp(SerialExchange: Record "Serial No. Intercompany Exch.")
    var
        myInt: Integer;
    begin
        TempItemLedgerEntry.Init;
        TempItemLedgerEntry.Validate("Item No.", SerialExchange."Item No.");
        TempItemLedgerEntry.Validate("Serial No.", SerialExchange."Serial No.");
        TempItemLedgerEntry.Insert(true);
    end;

    var
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        SerialNoOnPO: Codeunit "Import Serial Number Purchase";
        TempItemLedgerEntry: Record "Item Ledger Entry" temporary;
        ReleasePurchDoc: Codeunit "Release Purchase Document";

}