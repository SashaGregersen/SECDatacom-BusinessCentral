codeunit 50015 "IC Sync Default Dimension"
{
    TableNo = "Default Dimension";

    trigger OnRun()
    begin
        if not rec.Insert(true) then
            rec.Modify(true);
    end;
}