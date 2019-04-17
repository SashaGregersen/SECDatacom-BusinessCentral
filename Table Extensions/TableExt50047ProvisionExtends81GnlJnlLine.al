tableextension 50047 "Provision" extends "Gen. Journal Line"
{
    procedure CreateNewProvision(SalesHeader: record "Sales Header")
    begin
        Validate("Document No.", SalesHeader."No.");
    end;


}