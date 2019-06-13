codeunit 50053 "Vendor Item No Event Handler"
{
    SingleInstance = true;
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::table, database::"Purchase Line", 'OnAfterInsertEvent', '', true, true)]

    local procedure OnAfterInsertPurchaseLineEvent(var rec: record "Purchase Line"; runtrigger: Boolean)
    var
        Item: record item;
    begin
        If not runtrigger then
            EXIT;
        if rec.type = rec.type::Item then
            if item.get(rec."No.") then begin
                rec.validate("Vendor-Item-No", item."Vendor-Item-No.");
                rec.Modify(true);
            end;
    end;

    [EventSubscriber(ObjectType::table, database::"Purchase Line", 'OnAfterModifyEvent', '', true, true)]

    local procedure OnAfterModifyPurchaseLineEvent(var rec: record "Purchase Line"; runtrigger: Boolean)
    var
        Item: record item;
    begin
        If not runtrigger then
            EXIT;
        if rec.type = rec.type::Item then
            if item.get(rec."No.") then begin
                rec.validate("Vendor-Item-No", item."Vendor-Item-No.");
                rec.Modify(false);
            end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Item Vendor", 'OnAfterValidateEvent', 'Item No.', true, true)]
    local procedure OnAfterModifyVendorItemNoOnItemVendorEvent(var Rec: record "Item Vendor")
    var
        Item: Record item;
    begin
        if item.get(rec."Item No.") then begin
            rec.validate("Vendor-Item-No.", item."Vendor-Item-No.");
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Requisition Line", 'OnAfterInsertEvent', '', true, true)]
    local procedure OnAfterInsertReqLineEvent(var Rec: record "Requisition Line"; runtrigger: Boolean)
    var
        Item: record item;
    begin
        if rec.type = rec.type::Item then
            if item.get(rec."No.") then begin
                rec.validate("Vendor-Item-No", item."Vendor-Item-No.");
                rec.Modify(true);
            end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Requisition Line", 'OnAfterValidateEvent', 'No.', true, true)]
    local procedure OnAfterModifyReqLineEvent(var Rec: record "Requisition Line")
    var
        Item: Record Item;
    begin
        if rec.type = rec.type::Item then
            if item.get(rec."No.") then begin
                rec.validate("Vendor-Item-No", item."Vendor-Item-No.");
            end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Stockkeeping Unit", 'OnAfterValidateEvent', 'Item No.', true, true)]
    local procedure OnAfterModifyStockkepingUnitEvent(var Rec: record "Stockkeeping Unit")
    var
        Item: Record item;
    begin
        if item.get(rec."Item No.") then begin
            rec.validate("Vendor-Item-No", item."Vendor-Item-No.");
            rec.Modify(true);
        end;
    end;

    [EventSubscriber(ObjectType::table, database::"Service Item Line", 'OnAfterValidateEvent', 'Service Item No.', true, true)]

    local procedure OnAfterInsertServiceItemLineEvent(var rec: record "Service Item Line")
    var
        Item: record Item;
        ServiceItem: Record "Service Item";
    begin
        if Serviceitem.get(rec."Service Item No.") then begin
            rec.validate("Vendor-Item-No", serviceitem."Vendor-Item-No");
            rec.Modify(true);
        end;
    end;

    [EventSubscriber(ObjectType::table, database::"Service Item Line", 'OnAfterValidateEvent', 'Service Item No.', true, true)]

    local procedure OnAfterModifyServiceItemLineEvent(var rec: record "Service Item Line")
    var
        ServiceItem: Record "Service item";
        Item: Record Item;
    begin
        if Serviceitem.get(rec."Service Item No.") then begin
            rec.validate("Vendor-Item-No", serviceitem."Vendor-Item-No");
            rec.Modify(true);
        end;
    end;

    [EventSubscriber(ObjectType::table, database::"Warranty Ledger Entry", 'OnAfterInsertEvent', '', true, true)]

    local procedure OnAfterModifyWarrantyLedgerEntryEvent(var rec: record "Warranty Ledger Entry"; runtrigger: Boolean)
    var
        ServiceItem: Record "Service Item";
        Item: Record item;
    begin
        if not runtrigger then
            exit;
        if Serviceitem.get(rec."Service Item No. (Serviced)") then begin
            rec.validate("Vendor-Item-No", serviceitem."Vendor-Item-No");
            rec.Modify(true);
        end;
    end;


}