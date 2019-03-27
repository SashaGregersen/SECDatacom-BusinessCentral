codeunit 50018 "IC Sync Extended Text Line"
{
    TableNo = "Extended Text Line";

    trigger OnRun()
    begin
        if not rec.Insert(false) then
            rec.Modify(false);
    end;
}