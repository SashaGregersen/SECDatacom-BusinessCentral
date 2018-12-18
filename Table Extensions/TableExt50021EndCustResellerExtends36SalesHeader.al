tableextension 50021 "End Customer and Reseller" extends 36
{
    fields
    {
        field(50000; "End Customer"; Text[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
            trigger OnValidate();
            var
                customer: record customer;
            begin
                if rec."Drop-Shipment" = true then
                    If customer.get(Rec."End Customer") then
                        validate("Ship-to Code", customer."No.") //update ship-to felter
                    else
                        error('Not an end-customer');
            end;

            trigger Onlookup();
            var
                Customer: Record Customer;
            begin
                Customer.SetRange("Customer Type", customer."Customer Type"::"End Customer");
                IF page.RunModal(page::"Customer List", Customer, customer.Name) = Action::LookupOK then
                    Validate("End Customer", customer."No.");
            end;
        }
        field(50001; "Reseller"; Text[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
            trigger OnValidate();
            var
                customer: record customer;
            begin
                If customer.get(Rec.Reseller) then
                    validate("Sell-to Customer No.", customer."No.")
                else
                    error('Not a reseller');
            end;

            trigger Onlookup();
            var
                Customer: Record Customer;
            begin
                Customer.SetRange("Customer Type", customer."Customer Type"::Reseller);
                IF page.RunModal(page::"Customer List", Customer, customer."No.") = Action::LookupOK then
                    Validate("Reseller", Customer."No.");
            end;

        }
        field(50002; "Prefered Shipment Address"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Ship-to Address".code;
        }
        field(50003; "Subsidiary"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "customer";
            trigger OnValidate();
            var
                customer: record customer;
                ICPartner: record "IC Partner";
            begin
                If customer.get(Rec."subsidiary") then begin
                    if customer."IC Partner Code" = '' then
                        error('Not an IC Partner');
                    validate("Sell-to Customer No.", Subsidiary);
                    validate("Bill-to Customer No.", Subsidiary);
                end;
            end;

            trigger Onlookup();
            var
                Customer: Record Customer;
                ICpartner: Record "IC Partner";
            begin
                IF page.RunModal(page::"IC Partner List", icpartner) = Action::LookupOK then
                    Validate("subsidiary", ICpartner."Customer No.");
            end;
        }

        field(50004; "Financing Partner"; text[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = customer."No.";
            trigger OnValidate();
            var
                customer: record customer;
            begin
                If customer.get(Rec."Financing Partner") then
                    if customer."Customer Type" = customer."Customer Type"::"Financing Partner" then begin
                        validate("Bill-to Customer No.", customer."No.");
                    end else
                        error('Not a Financing Partner');
            end;

            trigger Onlookup();
            var
                Customer: Record Customer;
            begin
                Customer.SetRange("Customer Type", customer."Customer Type"::"Financing Partner");
                IF page.RunModal(page::"Customer List", Customer) = Action::LookupOK then
                    Validate("Financing Partner", Customer."No.");
            end;

        }
        field(50005; "Drop-Shipment"; boolean)
        {
            DataClassification = ToBeClassified;
        }
    }


}