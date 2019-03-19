codeunit 50050 "Item Event handler"
{
    SingleInstance = true;
    EventSubscriberInstance = StaticAutomatic;

    trigger OnRun()
    begin


    end;

    var

    [EventSubscriber(ObjectType::table, database::"Item", 'OnAfterInsertEvent', '', true, true)]
    local procedure ItemOnAfterInsert(var Rec: Record "Item"; runtrigger: Boolean)
    var
        InventorySetup: Record "Inventory Setup";
        SyncMasterData: Codeunit "Synchronize Master Data";
        AdvPriceMgt: Codeunit "Advanced Price Management";
    begin
        If not runtrigger then
            EXIT;
        AdvPriceMgt.CreateListPriceVariant(Rec);
        SyncMasterData.SetItemDefaults(Rec);

        InventorySetup.get;
        IF InventorySetup."Synchronize Item" = FALSE then
            Exit;
        SyncMasterData.SynchronizeInventoryToCompany(rec);
    end;

    [EventSubscriber(ObjectType::table, database::"Item", 'OnAfterModifyEvent', '', true, true)]
    local procedure ItemOnAfterModify(var Rec: Record "Item"; runtrigger: Boolean)
    var
        InventorySetup: Record "Inventory Setup";
        SyncMasterData: Codeunit "Synchronize Master Data";
    begin
        If not runtrigger then
            EXIT;
        InventorySetup.get;
        IF InventorySetup."Synchronize Item" = FALSE then
            Exit;
        SyncMasterData.SynchronizeInventoryToCompany(rec);
    end;

    [EventSubscriber(ObjectType::table, database::"Item", 'OnAfterValidateEvent', 'Vendor No.', true, true)]
    local procedure ItemOnAfterValidateVendorNo(var Rec: Record "Item")
    var
        Vendor: Record Vendor;
    begin
        if Vendor.get(rec."Vendor No.") then
            Rec.Validate("Vendor Currency", Vendor."Currency Code");
    end;

    [EventSubscriber(ObjectType::table, database::"Item Discount Group", 'OnAfterinsertEvent', '', true, true)]
    local procedure ItemDiscountOnAfterInsertEvent(var Rec: Record "Item Discount Group")
    var
        SyncMasterData: Codeunit "Synchronize Master Data";
    begin
        if rec.IsTemporary() then
            exit;
        SyncMasterData.SynchronizeItemDiscGroupToCompany(Rec);
    end;

    [EventSubscriber(ObjectType::table, database::"Item Discount Group", 'OnAfterModifyEvent', '', true, true)]
    local procedure ItemDiscountOnAfterModifyEvent(var Rec: Record "Item Discount Group")
    var
        SyncMasterData: Codeunit "Synchronize Master Data";
    begin
        if rec.IsTemporary() then
            exit;
        SyncMasterData.SynchronizeItemDiscGroupToCompany(Rec);
    end;

    [EventSubscriber(ObjectType::table, database::"Item Substitution", 'OnAfterinsertEvent', '', true, true)]
    local procedure ItemSubstituionOnAfterInsertEvent(var Rec: Record "Item Substitution")
    var
        SyncMasterData: Codeunit "Synchronize Master Data";
    begin
        if rec.IsTemporary() then
            exit;
        SyncMasterData.SynchronizeItemSubstituionToCompany(Rec);
    end;

    [EventSubscriber(ObjectType::table, database::"Item Substitution", 'OnAfterModifyEvent', '', true, true)]
    local procedure ItemSubstitutionOnAfterModifyEvent(var Rec: Record "Item Substitution")
    var
        SyncMasterData: Codeunit "Synchronize Master Data";
    begin
        if rec.IsTemporary() then
            exit;
        SyncMasterData.SynchronizeItemSubstituionToCompany(Rec);
    end;

    [EventSubscriber(ObjectType::table, database::"Default Dimension", 'OnAfterinsertEvent', '', true, true)]
    local procedure DefaultDimOnAfterInsertEvent(var Rec: Record "Default Dimension")
    var
        SyncMasterData: Codeunit "Synchronize Master Data";
    begin
        if rec.IsTemporary() then
            exit;
        if rec."Table ID" <> 27 then
            exit;
        SyncMasterData.SynchronizeDefaultDimensionToCompany(Rec);
    end;

    [EventSubscriber(ObjectType::table, database::"Default Dimension", 'OnAfterModifyEvent', '', true, true)]
    local procedure DefaultDimOnAfterModifyEvent(var Rec: Record "Default Dimension")
    var
        SyncMasterData: Codeunit "Synchronize Master Data";
    begin
        if rec.IsTemporary() then
            exit;
        if rec."Table ID" <> 27 then
            exit;
        SyncMasterData.SynchronizeDefaultDimensionToCompany(Rec);
    end;

    [EventSubscriber(ObjectType::table, database::"Item Translation", 'OnAfterinsertEvent', '', true, true)]
    local procedure ItemTranslationOnAfterInsertEvent(var Rec: Record "Item Translation")
    var
        SyncMasterData: Codeunit "Synchronize Master Data";
    begin
        if rec.IsTemporary() then
            exit;
        SyncMasterData.SynchronizeItemTranslationToCompany(Rec);
    end;

    [EventSubscriber(ObjectType::table, database::"Item Translation", 'OnAfterModifyEvent', '', true, true)]
    local procedure ItemTranslationOnAfterModifyEvent(var Rec: Record "Item Translation")
    var
        SyncMasterData: Codeunit "Synchronize Master Data";
    begin
        if rec.IsTemporary() then
            exit;
        SyncMasterData.SynchronizeItemTranslationToCompany(Rec);
    end;

    [EventSubscriber(ObjectType::table, database::"Extended Text Header", 'OnAfterinsertEvent', '', true, true)]
    local procedure ExtendedTextHeaderOnAfterInsertEvent(var Rec: Record "Extended Text Header")
    var
        SyncMasterData: Codeunit "Synchronize Master Data";
    begin
        if rec.IsTemporary() then
            exit;
        if rec."Table Name" <> rec."Table Name"::Item then
            exit;
        SyncMasterData.SynchronizeExtendedTextHeaderToCompany(Rec);
    end;

    [EventSubscriber(ObjectType::table, database::"Extended Text Header", 'OnAfterModifyEvent', '', true, true)]
    local procedure ExtendedTextHeaderOnAfterModifyEvent(var Rec: Record "Extended Text Header")
    var
        SyncMasterData: Codeunit "Synchronize Master Data";
    begin
        if rec.IsTemporary() then
            exit;
        if rec."Table Name" <> rec."Table Name"::Item then
            exit;
        SyncMasterData.SynchronizeExtendedTextHeaderToCompany(Rec);
    end;

    [EventSubscriber(ObjectType::table, database::"Extended Text Line", 'OnAfterinsertEvent', '', true, true)]
    local procedure ExtendedTextLineOnAfterInsertEvent(var Rec: Record "Extended Text Line")
    var
        SyncMasterData: Codeunit "Synchronize Master Data";
    begin
        if rec.IsTemporary() then
            exit;
        if rec."Table Name" <> rec."Table Name"::Item then
            exit;
        SyncMasterData.SynchronizeExtendedTextLineToCompany(Rec);
    end;

    [EventSubscriber(ObjectType::table, database::"Extended Text Line", 'OnAfterModifyEvent', '', true, true)]
    local procedure ExtendedTextLineOnAfterModifyEvent(var Rec: Record "Extended Text Line")
    var
        SyncMasterData: Codeunit "Synchronize Master Data";
    begin
        if rec.IsTemporary() then
            exit;
        if rec."Table Name" <> rec."Table Name"::Item then
            exit;
        SyncMasterData.SynchronizeExtendedTextLineToCompany(Rec);
    end;
}