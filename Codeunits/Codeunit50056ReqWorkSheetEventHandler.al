codeunit 50056 "Req Worksheet Event Handler"
{
    SingleInstance = true;
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"req. wksh.-make order", 'OnAfterInsertPurchOrderLine', '', true, true)]

    local procedure OnAfterInsertPurchOrderLineEvent(VAR PurchOrderLine: Record "Purchase Line"; NextLineNo: Integer)
    var
        ReservationEntryPurch: record "Reservation Entry";
        ReservationEntrySales: record "Reservation Entry";
        Salesline: Record "Sales Line";
        EntryNo: integer;
    begin
        ReservationEntryPurch.SetRange("Source ID", PurchOrderLine."Document No.");
        ReservationEntryPurch.SetRange("Source Ref. No.", PurchOrderLine."Line No.");
        ReservationEntryPurch.SetRange("Source Type", 39);
        ReservationEntryPurch.SetRange("Source Subtype", PurchOrderLine."Document Type");
        ReservationEntryPurch.SetRange("Reservation Status", ReservationEntryPurch."Reservation Status"::Reservation);
        ReservationEntryPurch.SetRange(Binding, ReservationEntryPurch.Binding::"Order-to-Order");
        if ReservationEntryPurch.FindFirst() then begin
            ReservationEntrySales.Setrange("Entry No.", ReservationEntryPurch."Entry No.");
            ReservationEntrySales.SetRange(Positive, false);
            ReservationEntrySales.SetRange("Source Type", 37);
            ReservationEntrySales.SetRange("Source Subtype", PurchOrderLine."Document Type");
            ReservationEntrySales.SetRange("Reservation Status", ReservationEntryPurch."Reservation Status"::Reservation);
            ReservationEntrySales.SetRange(Binding, ReservationEntryPurch.Binding::"Order-to-Order");
            if ReservationEntrySales.FindFirst() then begin
                if Salesline.Get(PurchOrderLine."Document Type", ReservationEntrySales."Source ID", ReservationEntrySales."Source Ref. No.") then begin // source ID er her købsordrenummer
                    if Salesline."Purchase Price on Purchase Order" <> PurchOrderLine."Direct Unit Cost" then
                        PurchOrderLine.Validate("Direct Unit Cost", Salesline."Purchase Price on Purchase Order");
                    if PurchOrderLine."Vendor Item No." <> '' then
                        PurchOrderLine.Validate("Vendor-Item-No", PurchOrderLine."Vendor-Item-No");
                    if Salesline."Bid No." <> '' then
                        PurchOrderLine.Validate("Bid No.", Salesline."Bid No.");
                    PurchOrderLine.Modify(true);
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Requisition Line", 'OnAfterValidateEvent', 'No.', true, true)]
    local procedure OnAfterValidateEvent(var Rec: record "Requisition Line")
    var
        Item: record Item;
        SubItem: record "Item Substitution";
    begin
        if rec.Type = rec.type::Item then begin
            if Item.Get(rec."No.") then
                if Item.Blocked = true then begin
                    SubItem.SetRange("No.", Item."No.");
                    if not SubItem.IsEmpty() then begin
                        If Confirm('Item %1 is blocked from purchase\Do you wish to select a substitute item?', false) then begin
                            if page.RunModal(page::"Item Substitutions", SubItem) = action::LookupOK then begin
                                rec.Validate("No.", SubItem."Sub. Item No.");
                                Rec.Modify(true);
                            end else
                                Error('There is no substitute items available');
                        end;
                    end else begin
                        Item.CalcFields(Inventory);
                        if (Item.Inventory <= 0) then begin
                            rec."Action Message" := rec."Action Message"::Cancel;
                            rec.Modify(true);
                        end;
                    end;
                end;
        end;
    end;
}