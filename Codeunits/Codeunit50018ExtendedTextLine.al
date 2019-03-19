codeunit 50018 "IC Sync Extended Text Line"
{
    TableNo = "Extended Text Line";

    trigger OnRun()
    begin
        if not rec.Insert(true) then
            rec.Modify(true);
    end;
}