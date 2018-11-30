codeunit 50099 SDGTEST
{
    trigger OnRun()
    begin
        UpdatePriceWithCurr.run;
    end;

    var
        UpdatePriceWithCurr: Report "Update Prices with Currencies";
}