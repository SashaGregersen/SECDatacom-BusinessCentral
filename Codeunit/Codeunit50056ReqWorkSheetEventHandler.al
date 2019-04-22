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
                    if Salesline."Purch. Price on Purchase Order" <> PurchOrderLine."Direct Unit Cost" then
                        PurchOrderLine.Validate("Direct Unit Cost", Salesline."Purch. Order Line No.");
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
    local procedure OnAfterValidateNoEvent(var rec: Record "Requisition Line")
    var
        Item: record Item;
        SubItem: record "Item Substitution";
    begin
        if rec.Type = rec.type::Item then
            if item.get(rec."No.") then begin
                SubItem.SetRange("No.", Item."No.");
                if not SubItem.IsEmpty() then begin
                    rec.Validate("Substitute Item Exists", true);
                end;
            end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Requisition Line", 'OnAfterInsertEvent', '', true, true)]
    local procedure OnAfterInsertEvent(var rec: Record "Requisition Line"; runtrigger: Boolean)
    var
        Item: record Item;
        SubItem: record "Item Substitution";
        ItemSub: Codeunit "Item Substitution";
    begin
        if not runtrigger then
            exit;
        if (rec."Substitute Item Exists" = true) and (rec."Action Message" = rec."Action Message"::New) then
            if item.get(rec."No.") then
                if item."Blocked from purchase" = true then
                    Message('Item %1 in line no. %2 is blocked from purchase and substitute items exist, please select a substitute item', item."No.", rec."Line No.");

    end;

    [EventSubscriber(ObjectType::codeunit, codeunit::"Req. Wksh.-Make Order", 'OnBeforeCarryOutReqLineAction', '', true, true)]
    local procedure OnAfterValidateEvent(var Requisitionline: record "Requisition Line"; var Failed: Boolean)
    var
        Item: record Item;
        SubItem: record "Item Substitution";
    begin
        if Requisitionline."Action Message" = requisitionline."Action Message"::New then begin
            if item.get(Requisitionline."No.") then begin
                if Item."Blocked from purchase" = true then begin
                    SubItem.SetRange("No.", Item."No.");
                    if not SubItem.IsEmpty() then begin
                        If not Confirm('Item %1 in line no. %2 is blocked from purchase and substitute items exist.\Do you wish to purchase the item?', false, item."No.", Requisitionline."Line No.") then begin
                            failed := true;
                            Requisitionline."Action Message" := Requisitionline."Action Message"::Cancel;
                            Requisitionline.Modify(true);
                        end;
                    end else begin
                        If not Confirm('Item %1 in line %2 is blocked from purchase and no substitute item exists\Do you wish to purchase the item?', false, Item."No.", Requisitionline."Line No.") then begin
                            failed := true;
                            Requisitionline."Action Message" := Requisitionline."Action Message"::Cancel;
                            Requisitionline.Modify(true);
                        end;
                    end;
                end;
            end;
        end;
    end;
}