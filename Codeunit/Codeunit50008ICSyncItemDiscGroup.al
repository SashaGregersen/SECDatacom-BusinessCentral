codeunit 50008 "IC Sync Item Discount Group"
{
    TableNo = "item discount group";

    trigger OnRun()
    begin
        if not rec.Insert(false) then
            rec.Modify(false);
    end;
}