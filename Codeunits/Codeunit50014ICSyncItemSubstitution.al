codeunit 50014 "IC Sync Item Substitution"
{
    TableNo = "item Substitution";

    trigger OnRun()
    begin
        if not rec.Insert(false) then
            rec.Modify(false);
    end;
}