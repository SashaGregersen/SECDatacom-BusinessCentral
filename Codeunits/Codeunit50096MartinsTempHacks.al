codeunit 50096 "Temp Hacks"
{
    trigger OnRun()
    begin
        SetOwningCompany('46525241');
    end;

    local procedure SetOwningCompany(CustomerNo: code[20])
    var
        Customer: Record Customer;
    begin
        Customer.Get(CustomerNo);
        Customer."Owning Company" := CompanyName();
        Customer.Modify(false);
    end;

    var
        myInt: Integer;
}