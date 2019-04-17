codeunit 50023 "IC Sync Ship-To Address"
{
    TableNo = "Ship-To Address";

    trigger OnRun()
    begin
        if not rec.Insert(false) then
            rec.Modify(false);
    end;
}