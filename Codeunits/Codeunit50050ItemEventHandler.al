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
        SyncMasterData.SetItemDefaults(Rec);
        InventorySetup.get;
        IF InventorySetup."Synchronize Item" = FALSE then
            Exit;
        SyncMasterData.SynchronizeInventoryToCompany(rec);
    end;

    [EventSubscriber(ObjectType::table, database::"Item", 'OnAfterValidateEvent', 'Vendor No.', true, true)]
    local procedure ItemOnAfterModifyVendorNo(var Rec: Record "Item")
    var
        Vendor: Record Vendor;
    begin
        if Vendor.get(rec."Vendor No.") then
            Rec.Validate("Vendor Currency", Vendor."Currency Code");
    end;
}


