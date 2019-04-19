codeunit 50016 "IC Sync Item Translation"
{
    TableNo = "Item Translation";

    trigger OnRun()
    begin
        if not rec.Insert(false) then
            rec.Modify(false);
    end;
}