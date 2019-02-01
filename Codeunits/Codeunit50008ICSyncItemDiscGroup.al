codeunit 50008 "IC Sync Item Discount Group"
{
    TableNo = "item discount group";

    trigger OnRun()
    begin
        if not rec.Insert(true) then
            rec.Modify(true);
    end;
}