codeunit 50019 "IC Sync Delete Item"
{
    TableNo = Item;

    trigger OnRun()
    var
        Item: Record Item;

    begin
        if item.Get(Rec."No.") then
            Item.Delete(false);
    end;
}