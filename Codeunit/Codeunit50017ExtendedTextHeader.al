codeunit 50017 "IC Sync Extended Text Header"
{
    TableNo = "Extended text header";

    trigger OnRun()
    begin
        if not rec.Insert(false) then
            rec.Modify(false);
    end;
}