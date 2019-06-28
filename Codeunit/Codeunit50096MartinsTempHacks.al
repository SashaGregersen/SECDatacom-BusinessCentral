codeunit 50096 "Temp Hacks"
{
    trigger OnRun()
    var
        Purchheader: Record "Purchase Header";
        JobQueue: Record "Job Queue Entry";
    begin

        SetOwningCompanyOnContacts();
        //if Purchheader.get(Purchheader."Document Type"::Order, '106061') then
        //Codeunit.Run(50021, Purchheader);
        //TestCurrencyUpdate();
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

    Local procedure TestCurrencyUpdate()
    var
        Item: record item;
    begin
        report.run(Report::"Update Prices with Currencies", false, false, item);
    end;

    local procedure SetOwningCompanyOnContacts()
    var
        Contact: Record Contact;
        Window: Dialog;
    begin
        Window.Open('#1############');
        if Contact.FindSet(true, false) then
            repeat
                Window.Update(1, Contact."No.");
                Contact."Owning-Company" := CompanyName();
                Contact.Modify(false);
            until Contact.Next() = 0;
        Window.Close();
        Message('Done');
    end;

    var
        myInt: Integer;
}