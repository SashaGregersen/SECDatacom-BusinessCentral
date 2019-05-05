codeunit 50027 "IC Sync Qty To Invoice Purch"
{
    TableNo = "Purchase Line";

    trigger OnRun()
    begin
        rec.Modify(false);
    end;
}