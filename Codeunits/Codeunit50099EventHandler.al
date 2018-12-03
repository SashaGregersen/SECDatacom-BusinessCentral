codeunit 50050 "Event handler"
{
    trigger OnRun()
    begin

    end;

    var

    [EventSubscriber(ObjectType::table, database::"Item", 'OnAfterInsertEvent', '', true, true)]
    local procedure ItemOnAfterInsert(var Rec: Record "Item")
    var
        InventorySetup: Record "Inventory Setup";
        Company: Record Company;
        DKrec: Record Item;
    begin
        IF InventorySetup."Synchronize Item" = TRUE then begin
            DKrec := rec;
            IF Company.FindSet() then
                repeat
                    Rec.ChangeCompany(Company.Name);
                    Rec.TransferFields(DKrec);
                    Rec.Insert(true);
                until Company.next = 0;
        end;
    end;

    [EventSubscriber(ObjectType::table, database::"Item", 'OnAfterModifyEvent', '', true, true)]
    local procedure ItemOnAfterModify(var Rec: Record "Item")
    var
        InventorySetup: Record "Inventory Setup";
        Company: Record Company;
        DKrec: Record Item;
    begin
        IF InventorySetup."Synchronize Item" = TRUE then begin
            DKrec := rec;
            IF Company.FindSet() then
                repeat
                    Rec.ChangeCompany(Company.Name);
                    Rec.TransferFields(DKrec);
                    Rec.Modify(true);
                until Company.next = 0;
        end;
    end;
}


