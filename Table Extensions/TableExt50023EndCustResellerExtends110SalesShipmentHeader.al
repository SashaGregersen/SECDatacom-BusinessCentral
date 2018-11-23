tableextension 50023 "End Customer and Reseller 3" extends 110
{
    fields
    {
        field(50000;"End Customer";Text[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
            trigger Onlookup();
            var
                Customer : Record Customer;
            begin
                Customer.SetRange("Customer Type",customer."Customer Type"::"End Customer");
                IF page.RunModal(page::"Customer List",Customer) = Action::LookupOK then
                    Validate("End Customer",customer."No.");
            end;
        }
        field(50001;"Reseller";Text[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
            trigger Onlookup();
            var
                Customer : Record Customer;
            begin
                Customer.SetRange("Customer Type",customer."Customer Type"::Reseller);
                IF page.RunModal(page::"Customer List",Customer) = Action::LookupOK then
                    Validate("Reseller",Customer."No.");
            end;
        }        
    }
    
    var
        myInt : Integer;
}