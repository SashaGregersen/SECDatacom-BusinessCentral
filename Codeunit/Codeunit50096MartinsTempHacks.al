codeunit 50096 "Temp Hacks"
{
    trigger OnRun()
    var
        Purchheader: Record "Purchase Header";
    begin
        //SetOwningCompany();
        if Purchheader.get(Purchheader."Document Type"::Order, '106060') then
            Codeunit.Run(50026, Purchheader);
    end;

    local procedure SetOwningCompany()
    var
        Customer: Record Customer;
        Window: Dialog;
    begin
        Window.Open('#1############');
        if Customer.FindSet(true, false) then
            repeat
                Window.Update(1, Customer."No.");
                Customer."Owning Company" := CompanyName();
                Customer.Modify(false);
            until Customer.Next() = 0;
        Window.Close();
        Message('Done');
    end;

    var
        myInt: Integer;
}