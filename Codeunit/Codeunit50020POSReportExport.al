codeunit 50020 "POS Report Export"
{
    Permissions = TableData "item ledger entry" = rmid;

    procedure FindAppliedEntry(ItemLedgEntry: record "Item Ledger Entry"; var TempItemEntry: record "Item Ledger Entry" temporary)
    var
        ItemApplnEntry: record "Item Application Entry";
    begin
        WITH ItemLedgEntry DO
            IF Positive THEN BEGIN
                ItemApplnEntry.RESET;
                ItemApplnEntry.SETCURRENTKEY("Inbound Item Entry No.", "Outbound Item Entry No.", "Cost Application");
                ItemApplnEntry.SETRANGE("Inbound Item Entry No.", "Entry No.");
                ItemApplnEntry.SETFILTER("Outbound Item Entry No.", '<>%1', 0);
                ItemApplnEntry.SETRANGE("Cost Application", TRUE);
                IF ItemApplnEntry.FIND('-') THEN
                    REPEAT
                        InsertTempEntry(TempItemEntry, ItemApplnEntry."Outbound Item Entry No.", ItemApplnEntry.Quantity);
                    UNTIL ItemApplnEntry.NEXT = 0;
            END ELSE BEGIN
                ItemApplnEntry.RESET;
                ItemApplnEntry.SETCURRENTKEY("Outbound Item Entry No.", "Item Ledger Entry No.", "Cost Application");
                ItemApplnEntry.SETRANGE("Outbound Item Entry No.", "Entry No.");
                ItemApplnEntry.SETRANGE("Item Ledger Entry No.", "Entry No.");
                ItemApplnEntry.SETRANGE("Cost Application", TRUE);
                IF ItemApplnEntry.FIND('-') THEN
                    REPEAT
                        InsertTempEntry(TempItemEntry, ItemApplnEntry."Inbound Item Entry No.", -ItemApplnEntry.Quantity);
                    UNTIL ItemApplnEntry.NEXT = 0;
            END;
    end;

    local procedure InsertTempEntry(Var TempItemEntry: record "Item Ledger Entry" temporary; EntryNo: Integer; AppliedQty: Decimal)
    var
        ItemLedgEntry: record "Item Ledger Entry";
    begin
        ItemLedgEntry.GET(EntryNo);
        IF AppliedQty * ItemLedgEntry.Quantity < 0 THEN
            EXIT;

        IF NOT TempItemEntry.GET(EntryNo) THEN BEGIN
            TempItemEntry.INIT;
            TempItemEntry := ItemLedgEntry;
            TempItemEntry.Quantity := AppliedQty;
            TempItemEntry.INSERT;
        END ELSE BEGIN
            TempItemEntry.Quantity := TempItemEntry.Quantity + AppliedQty;
            TempItemEntry.MODIFY;
        END;
    end;

    procedure ExchangeAmtLCYToFCYAndFCYToLCY(Amount: Decimal; CurrencyFactorCode: code[10]; factor: Decimal): Decimal
    var
        CurrencyExcRate: Record "Currency Exchange Rate";
        FromLCYToFCY: Decimal;
    begin
        FromLCYToFCY := CurrencyExcRate.ExchangeAmtLCYToFCY(Today(), CurrencyFactorCode, Amount, Factor);
        exit(CurrencyExcRate.ExchangeAmtFCYToLCY(Today(), CurrencyFactorCode, FromLCYToFCY, Factor));
    end;

    procedure RetrieveEntriesFromPostedInv(var TempItemLedgEntry: record "Item Ledger Entry" temporary; InvoiceRowID: text[250])
    var
        ValueEntryRelation: record "Value Entry Relation";
        ValueEntry: record "Value Entry";
        ItemledgEntry: record "Item Ledger Entry";
        Signfactor: Integer;
    begin
        // retrieves a data set of Item Ledger Entries (Posted Invoices)
        ValueEntryRelation.SETCURRENTKEY("Source RowId");
        ValueEntryRelation.SETRANGE("Source RowId", InvoiceRowID);
        IF ValueEntryRelation.FIND('-') THEN BEGIN
            SignFactor := TableSignFactor2(InvoiceRowID);
            REPEAT
                ValueEntry.GET(ValueEntryRelation."Value Entry No.");
                ItemLedgEntry.GET(ValueEntry."Item Ledger Entry No.");
                TempItemLedgEntry := ItemLedgEntry;
                TempItemLedgEntry.Quantity := ValueEntry."Invoiced Quantity";
                IF TempItemLedgEntry."Entry Type" IN [TempItemLedgEntry."Entry Type"::Purchase, TempItemLedgEntry."Entry Type"::Sale] THEN
                    IF TempItemLedgEntry.Quantity <> 0 THEN
                        AddTempRecordToSet(TempItemLedgEntry, SignFactor);
            UNTIL ValueEntryRelation.NEXT = 0;
        END;
    end;

    local procedure TableSignFactor2(RowID: Text[250]): Integer
    var
        TableNo: integer;
    begin
        RowID := DELCHR(RowID, '<', '"');
        RowID := COPYSTR(RowID, 1, STRPOS(RowID, '"') - 1);
        IF EVALUATE(TableNo, RowID) THEN
            EXIT(TableSignFactor(TableNo));

        EXIT(1);
    end;

    local procedure TableSignFactor(TableNo: integer): Integer
    begin
        IF TableNo IN [
                       DATABASE::"Sales Line",
                       DATABASE::"Sales Shipment Line",
                       DATABASE::"Sales Invoice Line",
                       DATABASE::"Purch. Cr. Memo Line",
                       DATABASE::"Prod. Order Component",
                       DATABASE::"Transfer Shipment Line",
                       DATABASE::"Return Shipment Line",
                       DATABASE::"Planning Component",
                       DATABASE::"Posted Assembly Line",
                       DATABASE::"Service Line",
                       DATABASE::"Service Shipment Line",
                       DATABASE::"Service Invoice Line"]
        THEN
            EXIT(-1);

        EXIT(1);
    end;

    local procedure AddTempRecordToSet(var TempItemLedgEntry: record "Item Ledger Entry" temporary; SignFactor: Integer)
    var
        TempItemLedgEntry2: record "Item Ledger Entry" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
    begin

        IF SignFactor <> 1 THEN BEGIN
            TempItemLedgEntry.Quantity *= SignFactor;
            TempItemLedgEntry."Remaining Quantity" *= SignFactor;
            TempItemLedgEntry."Invoiced Quantity" *= SignFactor;
        END;
        ItemTrackingMgt.RetrieveAppliedExpirationDate(TempItemLedgEntry);
        TempItemLedgEntry2 := TempItemLedgEntry;
        TempItemLedgEntry.RESET;
        TempItemLedgEntry.SetTrackingFilter(TempItemLedgEntry2."Serial No.", TempItemLedgEntry2."Lot No.");
        TempItemLedgEntry.SETRANGE("Warranty Date", TempItemLedgEntry2."Warranty Date");
        TempItemLedgEntry.SETRANGE("Expiration Date", TempItemLedgEntry2."Expiration Date");
        IF TempItemLedgEntry.FINDFIRST THEN BEGIN
            TempItemLedgEntry.Quantity += TempItemLedgEntry2.Quantity;
            TempItemLedgEntry."Remaining Quantity" += TempItemLedgEntry2."Remaining Quantity";
            TempItemLedgEntry."Invoiced Quantity" += TempItemLedgEntry2."Invoiced Quantity";
            TempItemLedgEntry.MODIFY;
        END ELSE
            TempItemLedgEntry.INSERT;

        TempItemLedgEntry.RESET;
    end;

    var
        TempFile: file;
        Name: text[250];
        NewStream: InStream;
        ToFile: text;
        ReturnValue: Boolean;
        POSReport: Report "POS Reporting";
        RequestFilter: text;
        SalesHeader: record "Sales Header";
        RequestPageHelper: Codeunit "Request Page Parameters Helper";
        Newfilter: text;
        Existingfilters: text;
        EntityName: code[20];

}