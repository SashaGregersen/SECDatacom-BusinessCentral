codeunit 50050 "Item Event handler"
{
    SingleInstance = true;
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::table, database::"Item", 'OnAfterInsertEvent', '', true, true)]
    local procedure ItemOnAfterInsert(var Rec: Record "Item"; runtrigger: Boolean)
    var
        InventorySetup: Record "Inventory Setup";
        SyncMasterData: Codeunit "Synchronize Master Data";
        AdvPriceMgt: Codeunit "Advanced Price Management";
    begin
        If not runtrigger then
            EXIT;
        if rec.IsTemporary then
            exit;
        if Rec."Item Disc. Group" <> '' then
            AdvPriceMgt.UpdateItemPurchaseDicountsFromItemDiscGroup(Rec);
        AdvPriceMgt.CreateListPriceVariant(Rec);
        SyncMasterData.SetItemDefaults(Rec);

        InventorySetup.get;
        IF InventorySetup."Synchronize Item" = FALSE then
            Exit;
        SyncMasterData.SynchronizeInventoryToCompany(rec);
    end;

    [EventSubscriber(ObjectType::table, database::"Item", 'OnAfterModifyEvent', '', true, true)]
    local procedure ItemOnAfterModify(var Rec: Record "Item"; xrec: Record Item; runtrigger: Boolean)
    var
        InventorySetup: Record "Inventory Setup";
        SyncMasterData: Codeunit "Synchronize Master Data";
        AdvPriceMgt: Codeunit "Advanced Price Management";
        Item: record item;
    begin
        If not runtrigger then
            EXIT;
        if Rec.IsTemporary then
            exit;

        if Rec."Item Disc. Group" <> xrec."Item Disc. Group" then
            AdvPriceMgt.UpdateItemPurchaseDicountsFromItemDiscGroup(Rec);
        InventorySetup.get;
        IF InventorySetup."Synchronize Item" = FALSE then
            Exit;
        if Rec."Do Not Sync on Modify" then
            exit;
        SyncMasterData.SynchronizeInventoryToCompany(rec);
    end;

    [EventSubscriber(ObjectType::table, database::"Item", 'OnAfterDeleteEvent', '', true, true)]
    local procedure ItemOnAfterDelete(var Rec: Record "Item"; runtrigger: Boolean)
    var
        InventorySetup: Record "Inventory Setup";
        SyncMasterData: Codeunit "Synchronize Master Data";
        AdvPriceMgt: Codeunit "Advanced Price Management";
        Glsetup: record "General Ledger Setup";
    begin
        If not runtrigger then
            EXIT;

        SyncMasterData.DeleteItemInOtherCompany(Rec);

    end;

    [EventSubscriber(ObjectType::table, database::"Item", 'OnAfterValidateEvent', 'Vendor No.', true, true)]
    local procedure ItemOnAfterValidateVendorNo(var Rec: Record "Item")
    var
        Vendor: Record Vendor;
        Item: record item;
        ItemCard: page "Item Card";
    begin
        if Vendor.get(rec."Vendor No.") then
            Rec.Validate("Vendor Currency", Vendor."Currency Code");
        if (rec."Vendor No." <> '') and (rec."Vendor-Item-No." <> '') then begin
            item.setrange("Vendor No.", rec."Vendor No.");
            item.setrange("Vendor Item No.", rec."Vendor Item No.");
            item.setfilter("No.", '<>%1', Rec."No.");
            if item.FindFirst() then begin
                Message('The combination of Vendor No. and Vendor Item No. already exists as Business Central Item %1.  Duplicates are not supported! Please update Item %1 as required.', item."No.");
                rec.Delete(true);
                ItemCard.SetTableView(Item);
                ItemCard.Run();
            end;
        end;
    end;

    [EventSubscriber(ObjectType::table, database::"Item", 'OnAfterValidateEvent', 'Vendor-Item-No.', true, true)]
    local procedure ItemOnAfterValidateVendorItemNo(var Rec: Record "Item")
    var
        Vendor: Record Vendor;
        Item: record item;
        ItemCard: page "Item Card";
    begin
        if (rec."Vendor No." <> '') and (rec."Vendor-Item-No." <> '') then begin
            item.setrange("Vendor No.", rec."Vendor No.");
            item.setrange("Vendor-Item-No.", rec."Vendor-Item-No.");
            item.setfilter("No.", '<>%1', Rec."No.");
            if item.FindFirst() then begin
                Message('The combination of Vendor No. and Vendor Item No. already exists as Business Central Item %1.  Duplicates are not supported! Please update Item %1 as required.', item."No.");
                rec.Delete(true);
                ItemCard.SetTableView(Item);
                ItemCard.Run();
            end;
        end;
    end;

    [EventSubscriber(ObjectType::table, database::"Item", 'OnAfterValidateEvent', 'Item Disc. Group', true, true)]
    local procedure ItemOnAfterValidateItemDiscGroup(var Rec: Record "Item")
    var
        ItemDiscGroup: Record "Item Discount Group";
        ItemDiscPct: Record "Item Disc. Group Percentages";
        Vendor: Record Vendor;
    begin
        if not ItemDiscGroup.Get(Rec."Item Disc. Group") then
            exit;
        if ItemDiscGroup."Use Orginal Vendor in Subs" then
            rec.Validate("IC partner Vendor No.", '');
        ItemDiscPct.SetRange("Item Disc. Group Code", ItemDiscGroup.Code);
        ItemDiscPct.SetAscending("Start Date", false);
        if not ItemDiscPct.FindLast() then
            exit;
        if ItemDiscPct."Purchase From Vendor No." <> '' then
            rec.Validate("Vendor No.", ItemDiscPct."Purchase From Vendor No.");
        if ItemDiscPct."Transfer Price Percentage" <> 0 then
            rec.Validate("Transfer Price %", ItemDiscPct."Transfer Price Percentage");
    end;

    [EventSubscriber(ObjectType::table, database::"Item Discount Group", 'OnAfterinsertEvent', '', true, true)]
    local procedure ItemDiscountOnAfterInsertEvent(var Rec: Record "Item Discount Group"; runtrigger: Boolean)
    var
        SyncMasterData: Codeunit "Synchronize Master Data";
    begin
        if not runtrigger then
            exit;
        if rec.IsTemporary() then
            exit;
        SyncMasterData.SynchronizeItemDiscGroupToCompany(Rec);
    end;

    [EventSubscriber(ObjectType::table, database::"Item Discount Group", 'OnAfterModifyEvent', '', true, true)]
    local procedure ItemDiscountOnAfterModifyEvent(var Rec: Record "Item Discount Group"; runtrigger: Boolean)
    var
        SyncMasterData: Codeunit "Synchronize Master Data";
    begin
        if not runtrigger then
            exit;
        if rec.IsTemporary() then
            exit;
        SyncMasterData.SynchronizeItemDiscGroupToCompany(Rec);
    end;

    [EventSubscriber(ObjectType::table, database::"Item Substitution", 'OnAfterinsertEvent', '', true, true)]
    local procedure ItemSubstituionOnAfterInsertEvent(var Rec: Record "Item Substitution"; runtrigger: Boolean)
    var
        SyncMasterData: Codeunit "Synchronize Master Data";
    begin
        if not runtrigger then
            exit;
        if rec.IsTemporary() then
            exit;
        SyncMasterData.SynchronizeItemSubstituionToCompany(Rec);
    end;

    [EventSubscriber(ObjectType::table, database::"Item Substitution", 'OnAfterModifyEvent', '', true, true)]
    local procedure ItemSubstitutionOnAfterModifyEvent(var Rec: Record "Item Substitution"; runtrigger: Boolean)
    var
        SyncMasterData: Codeunit "Synchronize Master Data";
    begin
        if not runtrigger then
            exit;
        if rec.IsTemporary() then
            exit;
        SyncMasterData.SynchronizeItemSubstituionToCompany(Rec);
    end;

    [EventSubscriber(ObjectType::table, database::"Default Dimension", 'OnAfterinsertEvent', '', true, true)]
    local procedure DefaultDimOnAfterInsertEvent(var Rec: Record "Default Dimension"; runtrigger: Boolean)
    var
        SyncMasterData: Codeunit "Synchronize Master Data";
    begin
        if not runtrigger then
            exit;
        if rec.IsTemporary() then
            exit;
        if rec."Table ID" <> 27 then
            exit;
        SyncMasterData.SynchronizeDefaultDimensionToCompany(Rec);
    end;

    [EventSubscriber(ObjectType::table, database::"Default Dimension", 'OnAfterModifyEvent', '', true, true)]
    local procedure DefaultDimOnAfterModifyEvent(var Rec: Record "Default Dimension"; runtrigger: Boolean)
    var
        SyncMasterData: Codeunit "Synchronize Master Data";
    begin
        if not runtrigger then
            exit;
        if rec.IsTemporary() then
            exit;
        if rec."Table ID" <> 27 then
            exit;
        SyncMasterData.SynchronizeDefaultDimensionToCompany(Rec);
    end;

    [EventSubscriber(ObjectType::table, database::"Default Dimension", 'OnAfterDeleteEvent', '', true, true)]
    local procedure DefaultDimOnAfterDeleteEvent(var Rec: Record "Default Dimension"; runtrigger: Boolean)
    var
        SyncMasterData: Codeunit "Synchronize Master Data";
    begin
        if not runtrigger then
            exit;
        if rec.IsTemporary() then
            exit;
        if rec."Table ID" <> 27 then
            exit;
        SyncMasterData.SynchronizeDeleteDefaultDimensionToCompany(Rec);
    end;

    [EventSubscriber(ObjectType::table, database::"Item Translation", 'OnAfterinsertEvent', '', true, true)]
    local procedure ItemTranslationOnAfterInsertEvent(var Rec: Record "Item Translation"; runtrigger: Boolean)
    var
        SyncMasterData: Codeunit "Synchronize Master Data";
    begin
        if not runtrigger then
            exit;
        if rec.IsTemporary() then
            exit;
        SyncMasterData.SynchronizeItemTranslationToCompany(Rec);
    end;

    [EventSubscriber(ObjectType::table, database::"Item Translation", 'OnAfterModifyEvent', '', true, true)]
    local procedure ItemTranslationOnAfterModifyEvent(var Rec: Record "Item Translation"; runtrigger: Boolean)
    var
        SyncMasterData: Codeunit "Synchronize Master Data";
    begin
        if not runtrigger then
            exit;
        if rec.IsTemporary() then
            exit;
        SyncMasterData.SynchronizeItemTranslationToCompany(Rec);
    end;

    [EventSubscriber(ObjectType::table, database::"Extended Text Header", 'OnAfterinsertEvent', '', true, true)]
    local procedure ExtendedTextHeaderOnAfterInsertEvent(var Rec: Record "Extended Text Header"; runtrigger: Boolean)
    var
        SyncMasterData: Codeunit "Synchronize Master Data";
    begin
        if not runtrigger then
            exit;
        if rec.IsTemporary() then
            exit;
        if rec."Table Name" <> rec."Table Name"::Item then
            exit;
        SyncMasterData.SynchronizeExtendedTextHeaderToCompany(Rec);
    end;

    [EventSubscriber(ObjectType::table, database::"Extended Text Header", 'OnAfterModifyEvent', '', true, true)]
    local procedure ExtendedTextHeaderOnAfterModifyEvent(var Rec: Record "Extended Text Header"; runtrigger: Boolean)
    var
        SyncMasterData: Codeunit "Synchronize Master Data";
    begin
        if not runtrigger then
            exit;
        if rec.IsTemporary() then
            exit;
        if rec."Table Name" <> rec."Table Name"::Item then
            exit;
        SyncMasterData.SynchronizeExtendedTextHeaderToCompany(Rec);
    end;

    [EventSubscriber(ObjectType::table, database::"Extended Text Line", 'OnAfterinsertEvent', '', true, true)]
    local procedure ExtendedTextLineOnAfterInsertEvent(var Rec: Record "Extended Text Line"; runtrigger: Boolean)
    var
        SyncMasterData: Codeunit "Synchronize Master Data";
    begin
        if not runtrigger then
            exit;
        if rec.IsTemporary() then
            exit;
        if rec."Table Name" <> rec."Table Name"::Item then
            exit;
        SyncMasterData.SynchronizeExtendedTextLineToCompany(Rec);
    end;

    [EventSubscriber(ObjectType::table, database::"Extended Text Line", 'OnAfterModifyEvent', '', true, true)]
    local procedure ExtendedTextLineOnAfterModifyEvent(var Rec: Record "Extended Text Line"; runtrigger: Boolean)
    var
        SyncMasterData: Codeunit "Synchronize Master Data";
    begin
        if not runtrigger then
            exit;
        if rec.IsTemporary() then
            exit;
        if rec."Table Name" <> rec."Table Name"::Item then
            exit;
        SyncMasterData.SynchronizeExtendedTextLineToCompany(Rec);
    end;

}