tableextension 50021 "End Customer and Reseller" extends 36
{
    fields
    {
        field(50000; "End Customer"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
            trigger OnValidate();
            var
                customer: record customer;
                shiptoadress: record "Ship-to Address";
            begin
                If not customer.get(Rec."End Customer") then
                    error('Not an end-customer')
                else begin
                    shiptoadress.setrange("Customer No.", "End Customer");
                    if shiptoadress.FindFirst() then
                        SetShipToAddress(ShipToAdress.Name, ShipToAdress."Name 2", ShipToAdress.Address, ShipToAdress."Address 2", ShipToAdress.City, ShipToAdress."Post Code", shiptoadress.County, shiptoadress."Country/Region Code");
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
        field(50001; "Reseller"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
            trigger OnValidate();
            var
                customer: record customer;
            begin

                If not customer.get(Rec.Reseller) then
                    error('Not a reseller')
                else
                    if Subsidiary = '' then
                        validate("Sell-to Customer No.", customer."No.");

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

        field(50004; "Financing Partner"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = customer."No.";
            trigger OnValidate();
            var
                customer: record customer;
            begin
                If customer.get(Rec."Financing Partner") then
                    if customer."Customer Type" = customer."Customer Type"::"Financing Partner" then
                        validate("Bill-to Customer No.", customer."No.")
                    else
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

        field(50006; "Ship-To-Code"; code[10])
        {
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                ShipToAdress: record "Ship-to Address";
            begin
                if "Drop-Shipment" = true then begin
                    ShipToAdress.SetRange("Customer No.", "End Customer");
                    IF page.RunModal(page::"Ship-to Address List", ShipToAdress) = Action::LookupOK then
                        SetShipToAddress(ShipToAdress.Name, ShipToAdress."Name 2", ShipToAdress.Address, ShipToAdress."Address 2", ShipToAdress.City, ShipToAdress."Post Code", shiptoadress.County, shiptoadress."Country/Region Code");
                end else begin
                    ShipToAdress.SetRange("Customer No.", "Sell-to Customer No.");
                    IF page.RunModal(page::"Ship-to Address List", ShipToAdress) = Action::LookupOK then
                        SetShipToAddress(ShipToAdress.Name, ShipToAdress."Name 2", ShipToAdress.Address, ShipToAdress."Address 2", ShipToAdress.City, ShipToAdress."Post Code", shiptoadress.County, shiptoadress."Country/Region Code");
                end;
            end;
        }

        field(50007; "sell-to-Customer-Name"; code[20])
        {
            DataClassification = ToBeClassified;

            trigger Onvalidate()
            var
                customer: record customer;
            begin
                if "Sell-to Customer No." <> '' then begin
                    customer.SetRange("No.", "Sell-to Customer No.");
                    if customer.findfirst then
                        validate("sell-to-Customer-Name", customer.Name);
                end;

            end;
        }
    }


}