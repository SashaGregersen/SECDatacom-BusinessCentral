codeunit 50015 "IC Sync Default Dimension"
{
    TableNo = "Default Dimension";

    trigger OnRun()
    begin
        if not rec.Insert(false) then
            rec.Modify(false);
    end;
}