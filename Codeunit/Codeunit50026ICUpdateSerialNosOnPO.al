codeunit 50026 "IC Update Serial Nos. on PO"
{
    TableNo = "Purchase Header";

    trigger OnRun()
    var
        SerialExchange: Record "Serial No. Intercompany Exch.";
        TempItemLedgerEntry: Record "Item Ledger Entry" temporary;
    begin
        if not PurchHeader.get(Rec."Document Type", Rec."No.") then
            Error('Purchase Order %1 does not exist in company %2', rec."No.", CompanyName());
        PurchLine.SetRange("Document No.", PurchHeader."No.");
        if PurchLine.FindSet() then
            repeat
                SerialExchange.SetRange("Order Type", SerialExchange."Order Type"::"Purchase order");
                SerialExchange.SetRange("Order No.", PurchLine."Document No.");
                SerialExchange.SetRange("Line No.", PurchLine."Line No.");
                if SerialExchange.FindSet() then
                    repeat
                        CreateItemLedgerEntryTemp(SerialExchange, TempItemLedgerEntry);
                    until SerialExchange.Next() = 0;
                if not TempItemLedgerEntry.IsEmpty then begin
                    SerialNoOnPO.UpdateReservationEntries(TempItemLedgerEntry, PurchLine);
                    SerialExchange.DeleteAll(true);
                    TempItemLedgerEntry.DeleteAll();
                end;
            until PurchLine.Next() = 0;
    end;

    local procedure CreateItemLedgerEntryTemp(SerialExchange: Record "Serial No. Intercompany Exch."; var TempItemLedgerEntry: Record "Item Ledger Entry" temporary)
    begin
        if TempItemLedgerEntry.IsEmpty then begin
            TempItemLedgerEntry.Init;
            TempItemLedgerEntry."Entry No." := 1;
        end else begin
            TempItemLedgerEntry.FindLast();
            TempItemLedgerEntry."Entry No." := TempItemLedgerEntry."Entry No." + 1;
        end;
        TempItemLedgerEntry.Validate("Item No.", SerialExchange."Item No.");
        TempItemLedgerEntry.Validate("Serial No.", SerialExchange."Serial No.");
        TempItemLedgerEntry.Insert(true);
    end;

    var
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        SerialNoOnPO: Codeunit "Import Serial Number Purchase";

        ReleasePurchDoc: Codeunit "Release Purchase Document";

}