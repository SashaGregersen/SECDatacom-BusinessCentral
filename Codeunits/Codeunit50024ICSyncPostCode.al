codeunit 50024 "IC Sync Post Code"
{
    TableNo = "Post Code";

    trigger OnRun()
    begin
        if not rec.Insert(false) then
            rec.Modify(false);
    end;
}