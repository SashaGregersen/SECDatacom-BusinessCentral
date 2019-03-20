codeunit 50019 "IC Sync Delete Item"
{
    TableNo = Item;

    trigger OnRun()
    begin
        rec.Delete(true);
    end;
}