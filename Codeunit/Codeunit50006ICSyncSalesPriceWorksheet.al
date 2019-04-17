codeunit 50006 "IC Sync Sales Price Worksheet"
{
    trigger OnRun()
    begin
        AdvPriceMgt.UpdatePricesfromWorksheet();
    end;

    var
        AdvPriceMgt: Codeunit "Advanced Price Management";

}