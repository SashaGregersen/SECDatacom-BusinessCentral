report 50028 "Update Item Ledger Entries"
{
    UsageCategory = None;
    ProcessingOnly = true;
    Permissions = TableData "Item Ledger Entry" = rimd;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {

            trigger OnPreDataItem()
            begin
                Window.Open('#1############');
            end;

            trigger OnAfterGetRecord()
            begin
                if not (Quantity <> 1) and (Positive = true) then
                    CurrReport.Skip();
                if not ("Entry Type" = "Entry Type"::"Positive Adjmt.") or ("Entry Type" = "Entry Type"::Purchase) then
                    CurrReport.skip;

                if "Item Ledger Entry"."Serial No." = '' then begin
                    salesshipmentline.setrange("No.", "Item Ledger Entry"."Document No.");
                    salesshipmentline.setrange("Line No.", "Item Ledger Entry"."Document Line No.");
                    if salesshipmentline.findfirst then begin
                        if salesshipmentline.quantity < "Item Ledger Entry".quantity then begin
                            Window.update(1, "Entry No.");
                            "Item Ledger Entry".quantity := salesshipmentline.quantity;
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
        SalesShipmentLine: Record "Sales Shipment Line";
        ValueEntry: record "Value Entry";
}