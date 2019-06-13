codeunit 50025 "IC Sync VAR ID"
{
    TableNo = "VAR";

    trigger OnRun()
    begin
        if not rec.Insert(false) then
            rec.Modify(false);
    end;
}