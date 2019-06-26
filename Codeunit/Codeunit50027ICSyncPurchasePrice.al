codeunit 50027 "IC Sync Purchase price"
{
    TableNo = "Purchase Price";

    trigger OnRun()
    begin
        if not rec.Insert(true) then
            rec.Modify(true);
    end;
}