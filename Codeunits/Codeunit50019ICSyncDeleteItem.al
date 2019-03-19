codeunit 50019 "IC Sync Delete Item"
{
    TableNo = Item;

    trigger OnRun()
    begin
        if not rec.Delete(true) then
            exit;
    end;
}