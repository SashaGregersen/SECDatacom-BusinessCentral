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
        UpdateInventory: Codeunit "Update Inventory";
        AdvPriceMgt: Codeunit "Advanced Price Management";
    begin
        If not runtrigger then
            EXIT;
        AdvPriceMgt.CreateListPriceVariant(Rec);
        InventorySetup.get;
        IF InventorySetup."Synchronize Item" = FALSE then
            Exit;
        UpdateInventory.SynchronizeInventoryToCompany(rec);
    end;

    [EventSubscriber(ObjectType::table, database::"Item", 'OnAfterModifyEvent', '', true, true)]
    local procedure ItemOnAfterModify(var Rec: Record "Item"; runtrigger: Boolean)
    var
        InventorySetup: Record "Inventory Setup";
        UpdateInventory: Codeunit "Update Inventory";
    begin
        If not runtrigger then
            EXIT;
        InventorySetup.get;
        IF InventorySetup."Synchronize Item" = FALSE then
            Exit;
        UpdateInventory.SynchronizeInventoryToCompany(rec);
    end;
}


