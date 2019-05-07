codeunit 50025 "IC Sync Qty To Invoice Sales"
{
    TableNo = "Sales Line";

    trigger OnRun()
    begin
        rec.Modify(false);
    end;
}