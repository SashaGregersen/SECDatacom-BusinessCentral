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
    local procedure ItemOnAfterModify(var Rec: Record "Item"; runtrigger: Boolean)
    var
        InventorySetup: Record "Inventory Setup";
        SyncMasterData: Codeunit "Synchronize Master Data";
        AdvPriceMgt: Codeunit "Advanced Price Management";
    begin
        If not runtrigger then
            EXIT;
        if Rec."Item Disc. Group" <> '' then
            AdvPriceMgt.UpdateItemPurchaseDicountsFromItemDiscGroup(Rec);
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

    [EventSubscriber(ObjectType::table, database::"Item", 'OnAfterValidateEvent', 'Item Disc. Group', true, true)]
    local procedure ItemOnAfterValidateItemDiscGroup(var Rec: Record "Item")
    var
        ItemDiscGroup: Record "Item Discount Group";
        ItemDiscPct: Record "Item Disc. Group Percentages";
        Vendor: Record Vendor;
    begin
        if not ItemDiscGroup.Get(Rec."Item Disc. Group") then
            exit;
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
}