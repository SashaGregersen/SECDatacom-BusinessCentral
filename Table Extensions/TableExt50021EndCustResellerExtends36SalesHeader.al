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
                If customer.get(Rec."Sell-to Customer No.") then
                    If customer."Customer Type" = customer."Customer Type"::"End Customer" then begin
                        validate("End Customer", customer."No.");
                    end;
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
                If customer.get(Rec."Sell-to Customer No.") then
                    if customer."Customer Type" = customer."Customer Type"::Reseller then begin
                        validate("reseller", customer."No.");
                    end;
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
        field(50003; "Subsidiary"; Text[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "IC Partner";
            trigger OnValidate();
            var
                customer: record customer;
                ICPartner: record "IC Partner";
            begin
                If customer.get(Rec."Sell-to Customer No.") then
                    if ICPartner.get(customer."IC Partner Code") then
                        validate(Subsidiary, ICPartner.Code);
            end;

            trigger Onlookup();
            var
                Customer: Record Customer;
                ICpartner: Record "IC Partner";
            begin
                Customer.get("Sell-to Customer No.");
                ICpartner.SetRange(code, Customer."IC Partner Code");
                IF page.RunModal(page::"IC Partner List", icpartner, icpartner.Code) = Action::LookupOK then
                    Validate("subsidiary", ICpartner.Code);
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
                If customer.get(Rec."Sell-to Customer No.") then
                    if customer."Customer Type" = customer."Customer Type"::"Financing Partner" then begin
                        validate("Financing Partner", customer."No.");
                    end;
            end;

            trigger Onlookup();
            var
                Customer: Record Customer;
            begin
                Customer.SetRange("Customer Type", customer."Customer Type"::"Financing Partner");
                IF page.RunModal(page::"Customer List", Customer, customer."No.") = Action::LookupOK then
                    Validate("Financing Partner", Customer."No.");
            end;

        }
        field(50005; "Drop-Shipment"; boolean)
        {
            DataClassification = ToBeClassified;
        }
    }


}