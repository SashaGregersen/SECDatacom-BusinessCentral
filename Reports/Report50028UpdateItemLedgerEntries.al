report 50028 "Update Item Ledger Entries"
{
    UsageCategory = None;
    ProcessingOnly = true;
    Permissions = TableData "Item Ledger Entry" = rimd;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            RequestFilterFields = "Entry No.";
            trigger OnPreDataItem()
            begin
                Window.Open('#1############');
            end;

            trigger OnAfterGetRecord()
            begin
                if not (Quantity <> 1) and (Positive = true) then
                    CurrReport.Skip();
                if ("Entry Type" <> "Entry Type"::"Positive Adjmt.") then
                    if ("Entry Type" <> "Entry Type"::Purchase) then
                        CurrReport.skip;
                if ("Entry Type" <> "Entry Type"::Purchase) then
                    if ("Entry Type" <> "Entry Type"::"Positive Adjmt.") then
                        CurrReport.skip;

                if "Item Ledger Entry"."Serial No." = '' then begin
                    PurchReceiptLine.setrange("Document No.", "Item Ledger Entry"."Document No.");
                    PurchReceiptLine.setrange("Line No.", "Item Ledger Entry"."Document Line No.");
                    if PurchReceiptLine.findfirst then begin
                        if PurchReceiptLine.quantity < "Item Ledger Entry".quantity then begin
                            Window.update(1, "Entry No.");
                            "Item Ledger Entry".quantity := PurchReceiptLine.quantity;
                            "Item Ledger Entry".modify(false);
                        end;
                    end else begin
                        ValueEntry.setrange("Item Ledger Entry No.", "Entry No.");
                        valueentry.setrange("Item Ledger Entry Type", valueentry."Item Ledger Entry Type"::"Positive Adjmt.");
                        if valueentry.findfirst then
                            if ValueEntry."Invoiced Quantity" <> "Item Ledger Entry".quantity then begin
                                Window.update(1, "Entry No.");
                                "Item Ledger Entry".quantity := valueentry."Invoiced Quantity";
                                "Item Ledger Entry".modify(false);
                            end;
                    end;
                end else begin
                    Window.update(1, "Entry No.");
                    "Item Ledger Entry".Quantity := 1;
                    "Item Ledger Entry".Modify(false);
                end;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close();
                Message('Done');
            end;
        }
    }



    var
        Window: Dialog;
        PurchReceiptLine: Record "Purch. Rcpt. Line";
        ValueEntry: record "Value Entry";
}