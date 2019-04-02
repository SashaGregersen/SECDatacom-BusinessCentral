codeunit 50053 "Vendor Item No Event Handler"
{
    SingleInstance = true;
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::Table, database::Item, 'OnAfterValidateEvent', 'Vendor Item No.', true, true)]
    local procedure OnAfterValidateVendorItemNoOnItemCardEvent(var Rec: record Item)
    var
    begin
        if rec."Vendor Item No." <> '' then begin
            Rec.Validate("Vendor-Item-No.", Rec."Vendor Item No.");
        end;
    end;

    [EventSubscriber(ObjectType::table, database::"Purchase Line", 'OnAfterInsertEvent', '', true, true)]

    local procedure OnAfterInsertPurchaseLineEvent(var rec: record "Purchase Line"; runtrigger: Boolean)
    var
        Item: record item;
    begin
        If not runtrigger then
            EXIT;
        if rec."Vendor Item No." <> '' then begin
            Rec.Validate("Vendor-Item-No", Rec."Vendor Item No.");
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
        if rec."Vendor Item No." <> '' then begin
            Rec.Validate("Vendor-Item-No", Rec."Vendor Item No.");
            rec.Modify(false);
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Item Vendor", 'OnAfterModifyEvent', '', true, true)]
    local procedure OnAfterModifyVendorItemNoOnItemVendorEvent(var Rec: record "Item Vendor"; runtrigger: Boolean)
    var
    begin
        if not runtrigger then
            exit;
        if rec."Vendor Item No." <> '' then begin
            Rec.Validate("Vendor-Item-No.", Rec."Vendor Item No.");
            rec.Modify(false);
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Requisition Line", 'OnAfterValidateEvent', 'Vendor Item No.', true, true)]
    local procedure OnAfterValidateVendorItemNoOnReqLineEvent(var Rec: record "Requisition Line")
    var
    begin
        if rec."Vendor Item No." <> '' then begin
            Rec.Validate("Vendor-Item-No", Rec."Vendor Item No.");
            rec.Modify(true);
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Requisition Line", 'OnAfterInsertEvent', '', true, true)]
    local procedure OnAfterInsertReqLineEvent(var Rec: record "Requisition Line"; runtrigger: Boolean)
    var
    begin
        if not runtrigger then
            exit;
        if rec."Vendor Item No." <> '' then begin
            Rec.Validate("Vendor-Item-No", Rec."Vendor Item No.");
            rec.Modify(true);
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Requisition Line", 'OnAfterModifyEvent', '', true, true)]
    local procedure OnAfterModifyReqLineEvent(var Rec: record "Requisition Line"; runtrigger: Boolean)
    var
    begin
        if not runtrigger then
            exit;
        if rec."Vendor Item No." <> '' then begin
            Rec.Validate("Vendor-Item-No", Rec."Vendor Item No.");
            rec.Modify(false);
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Stockkeeping Unit", 'OnAfterModifyEvent', '', true, true)]
    local procedure OnAfterModifyStockkepingUnitEvent(var Rec: record "Stockkeeping Unit"; runtrigger: Boolean)
    var
    begin
        if not runtrigger then
            exit;
        if rec."Vendor Item No." <> '' then begin
            Rec.Validate("Vendor-Item-No", Rec."Vendor Item No.");
            rec.Modify(false);
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Nonstock Item", 'OnAfterModifyEvent', '', true, true)]
    local procedure OnAfterModifyNonStockItemEvent(var Rec: record "Nonstock Item"; runtrigger: Boolean)
    var
    begin
        if not runtrigger then
            exit;
        if rec."Vendor Item No." <> '' then begin
            Rec.Validate("Vendor-Item-No", Rec."Vendor Item No.");
            rec.Modify(false);
        end;
    end;

    [EventSubscriber(ObjectType::table, database::"Service Item Line", 'OnAfterInsertEvent', '', true, true)]

    local procedure OnAfterInsertServiceItemLineEvent(var rec: record "Service Item Line"; runtrigger: Boolean)
    var

    begin
        If not runtrigger then
            EXIT;
        if rec."Vendor Item No." <> '' then begin
            Rec.Validate("Vendor-Item-No", Rec."Vendor Item No.");
            rec.Modify(true);
        end;
    end;

    [EventSubscriber(ObjectType::table, database::"Service Item Line", 'OnAfterModifyEvent', '', true, true)]

    local procedure OnAfterModifyServiceItemLineEvent(var rec: record "Service Item Line"; runtrigger: Boolean)
    var

    begin
        If not runtrigger then
            EXIT;
        if rec."Vendor Item No." <> '' then begin
            Rec.Validate("Vendor-Item-No", Rec."Vendor Item No.");
            rec.Modify(false);
        end;
    end;

    [EventSubscriber(ObjectType::table, database::"Warranty Ledger Entry", 'OnAfterInsertEvent', '', true, true)]

    local procedure OnAfterModifyWarrantyLedgerEntryEvent(var rec: record "Warranty Ledger Entry"; runtrigger: Boolean)
    var

    begin
        if not runtrigger then
            exit;
        if rec."Vendor Item No." <> '' then begin
            Rec.Validate("Vendor-Item-No", Rec."Vendor Item No.");
            rec.Modify(true);
        end;
    end;

    [EventSubscriber(ObjectType::table, database::"Service Item", 'OnAfterModifyEvent', '', true, true)]

    local procedure OnAfterValidateServiceItemEvent(var rec: record "Service Item"; runtrigger: Boolean)
    var

    begin
        if not runtrigger then
            exit;
        if rec."Vendor Item No." <> '' then begin
            Rec.Validate("Vendor-Item-No", Rec."Vendor Item No.");
            rec.Modify(false);
        end;
    end;



}