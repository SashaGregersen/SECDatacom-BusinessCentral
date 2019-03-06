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
                If customer.get(Rec."End Customer") then
                    if customer."Customer Type" <> customer."Customer Type"::"End Customer" then
                        error('Not an end-customer');
                if "Drop-Shipment" then begin
                    Clear("Ship-To-Code");
                    if ShipToAdress.get(Customer."No.", Customer."Prefered Shipment Address") then begin
                        SetShipToAddress(ShipToAdress.Name, ShipToAdress."Name 2", ShipToAdress.Address, ShipToAdress."Address 2", ShipToAdress.City, ShipToAdress."Post Code", shiptoadress.County, shiptoadress."Country/Region Code");
                        rec.Validate("Ship-to Contact", ShipToAdress.Contact);
                        rec.validate("Ship-To-Code", shiptoadress.Code);
                    end else begin
                        SetShipToAddress(Customer.Name, Customer."Name 2", Customer.Address, Customer."Address 2", Customer.City, Customer."Post Code", Customer.County, Customer."Country/Region Code");
                        rec.Validate("Ship-to Contact", Customer.Contact);
                    end;
                end;
            end;

            trigger Onlookup();
            var
                Customer: Record Customer;
            begin
                if not Customer.get("End Customer") then
                    clear("End Customer");
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
                shiptoadress: record "Ship-to Address";
            begin
                If customer.get(Rec.Reseller) then
                    if customer."Customer Type" <> customer."Customer Type"::Reseller then
                        error('Not a reseller')
                    else
                        if Subsidiary = '' then begin
                            validate("Sell-to Customer No.", customer."No.");
                            validate("Sell-to-Customer-Name", customer.Name);
                            if (rec."Drop-Shipment" = false) and (rec."Prefered Shipment Address" <> '') then begin
                                shiptoadress.get(customer."No.", customer."Prefered Shipment Address");
                                SetShipToAddress(ShipToAdress.Name, ShipToAdress."Name 2", ShipToAdress.Address, ShipToAdress."Address 2", ShipToAdress.City, ShipToAdress."Post Code", shiptoadress.County, shiptoadress."Country/Region Code");
                                rec.Validate("Ship-to Contact", ShipToAdress.Contact);
                                rec.validate("Ship-To-Code", shiptoadress.Code);
                            end;
                        end;
            end;

            trigger Onlookup();
            var
                Customer: Record Customer;
            begin
                if not Customer.Get(Reseller) then
                    Clear(Reseller);
                Customer.SetRange("Customer Type", customer."Customer Type"::Reseller);
                IF page.RunModal(page::"Customer List", Customer, customer."No.") = Action::LookupOK then
                    Validate("Reseller", Customer."No.");
            end;

        }
        field(50002; "Prefered Shipment Address"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Ship-to Address".code;
            // slet felt
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
                        error('Not an IC Partner')
                    else begin
                        validate("Sell-to Customer No.", Subsidiary);
                        validate("Bill-to Customer No.", Subsidiary);
                        validate("sell-to-Customer-Name", customer.Name);
                    end;
                end;
            end;

            trigger Onlookup();
            var
                Customer: Record Customer;
                ICpartner: Record "IC Partner";
                ICPartner2: record "IC Partner";
                ICPartnerList: page "ic partner list";
            begin
                if Rec.Subsidiary <> '' then begin
                    ICPartner2.SetRange("Customer No.", Rec.Subsidiary);
                    ICPartner2.FindFirst();
                    ICpartner.Get(ICPartner2.Code);
                end;
                IF page.RunModal(page::"IC Partner List", ICpartner, ICpartner.Code) = Action::LookupOK then
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
                if Reseller = '' then
                    Error('You have to select a Reseller before a Financing Partner');
                If customer.get(Rec."Financing Partner") then
                    if customer."Customer Type" = customer."Customer Type"::"Financing Partner" then begin
                        validate("Bill-to Customer No.", customer."No.");
                        validate("Bill-to Address", Customer.Address);
                        validate("Bill-to Address 2", Customer."Address 2");
                        validate("Bill-to City", Customer.City);
                        Validate("Bill-to Country/Region Code", customer."Country/Region Code");
                        validate("Bill-to Post Code", customer."Post Code");
                        validate("Bill-to County", customer.County);
                    end else
                        error('Not a Financing Partner');
            end;

            trigger Onlookup();
            var
                Customer: Record Customer;
            begin
                if not Customer.Get("Financing Partner") then
                    Clear("Financing Partner");
                Customer.SetRange("Customer Type", customer."Customer Type"::"Financing Partner");
                IF page.RunModal(page::"Customer List", Customer, Customer."No.") = Action::LookupOK then
                    Validate("Financing Partner", Customer."No.");
            end;

        }
        field(50005; "Drop-Shipment"; boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                ShipToAdress: record "Ship-to Address";
                Customer: record customer;
            begin
                if "Drop-Shipment" = true then begin
                    Customer.get(rec."End Customer");
                    Clear("Ship-To-Code");
                    if ShipToAdress.get(Customer."No.", Customer."Prefered Shipment Address") then begin
                        SetShipToAddress(ShipToAdress.Name, ShipToAdress."Name 2", ShipToAdress.Address, ShipToAdress."Address 2", ShipToAdress.City, ShipToAdress."Post Code", shiptoadress.County, shiptoadress."Country/Region Code");
                        rec.Validate("Ship-to Contact", ShipToAdress.Contact);
                        rec.validate("Ship-To-Code", shiptoadress.Code);
                    end else begin
                        SetShipToAddress(Customer.Name, Customer."Name 2", Customer.Address, Customer."Address 2", Customer.City, Customer."Post Code", Customer.County, Customer."Country/Region Code");
                        rec.Validate("Ship-to Contact", Customer.Contact);
                    end;
                end else begin
                    Customer.Get(rec."Sell-to Customer No.");
                    Clear("Ship-To-Code");
                    if ShipToAdress.get(Customer."No.", Customer."Prefered Shipment Address") then begin
                        SetShipToAddress(ShipToAdress.Name, ShipToAdress."Name 2", ShipToAdress.Address, ShipToAdress."Address 2", ShipToAdress.City, ShipToAdress."Post Code", shiptoadress.County, shiptoadress."Country/Region Code");
                        rec.Validate("Ship-to Contact", ShipToAdress.Contact);
                        rec.validate("Ship-To-Code", shiptoadress.Code);
                    end else begin
                        SetShipToAddress(rec."Sell-to Customer Name", rec."Sell-to Customer Name 2", rec."Sell-to Address", rec."Sell-to Address 2", rec."Sell-to City", rec."Sell-to Post Code", rec."Sell-to County", rec."Sell-to Country/Region Code");
                        rec.Validate("Ship-to Contact", rec."Sell-to Contact");
                    end;
                end;
            end;
        }

        field(50006; "Ship-To-Code"; code[10])
        {
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                ShipToAdress: record "Ship-to Address";
            begin
                if "Drop-Shipment" = true then begin
                    if not ShipToAdress.Get(rec."End Customer", "Ship-To-Code") then
                        Clear("Ship-To-Code");
                    ShipToAdress.SetRange("Customer No.", "End Customer");
                    IF page.RunModal(page::"Ship-to Address List", ShipToAdress, ShipToAdress.Code) = Action::LookupOK then begin
                        SetShipToAddress(ShipToAdress.Name, ShipToAdress."Name 2", ShipToAdress.Address, ShipToAdress."Address 2", ShipToAdress.City, ShipToAdress."Post Code", shiptoadress.County, shiptoadress."Country/Region Code");
                        rec.Validate("Ship-to Contact", ShipToAdress.Contact);
                        rec.validate("Ship-To-Code", ShipToAdress.Code);
                        rec.Modify(true);
                    end;
                end else begin
                    if not ShipToAdress.Get(rec.Reseller, "Ship-To-Code") then
                        Clear("Ship-To-Code");
                    ShipToAdress.SetRange("Customer No.", "Sell-to Customer No.");
                    IF page.RunModal(page::"Ship-to Address List", ShipToAdress, ShipToAdress.Code) = Action::LookupOK then begin
                        SetShipToAddress(ShipToAdress.Name, ShipToAdress."Name 2", ShipToAdress.Address, ShipToAdress."Address 2", ShipToAdress.City, ShipToAdress."Post Code", shiptoadress.County, shiptoadress."Country/Region Code");
                        rec.Validate("Ship-to Contact", ShipToAdress.Contact);
                        rec.validate("Ship-To-Code", ShipToAdress.Code);
                        rec.Modify(true);
                    end;
                end;
            end;

            trigger OnValidate()
            var
                ShipToAdress: record "Ship-to Address";
                Customer: Record customer;
            begin
                if ("Drop-Shipment") then begin
                    Customer.Get("End Customer");
                    ShipToAdress.Get(Customer."No.", "Ship-To-Code");
                end else begin
                    Customer.Get("Sell-to Customer No.");
                    ShipToAdress.Get("Sell-to Customer No.", "Ship-To-Code");
                end;
            end;
        }

        field(50007; "Sell-to-Customer-Name"; text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50008; "Suppress Prices on Printouts"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

    }


}
