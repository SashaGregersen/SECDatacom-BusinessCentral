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
                If customer.get(Rec."End Customer") then begin
                    if customer."Customer Type" <> customer."Customer Type"::"End Customer" then
                        error('Not an end-customer')
                    else begin
                        rec.validate("End Customer Name", customer.name);
                        rec.validate("End Customer Contact", customer."Primary Contact No.");
                        SetDropShipment();
                    end;
                end;
                if "End Customer" = '' then begin
                    clear("End Customer Name");
                    clear("End Customer Contact");
                    Clear("End Customer Contact Name");
                    Clear("End Customer Email");
                    Clear("End Customer Phone No.");
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
                if Reseller = '' then
                    clear("Reseller Name");

                If customer.get(Rec.Reseller) then
                    if customer."Customer Type" <> customer."Customer Type"::Reseller then
                        error('Not a reseller')
                    else
                        if Subsidiary = '' then begin
                            validate("Sell-to Customer No.", customer."No.");
                            validate("Sell-to-Customer-Name", customer.Name);
                            rec.validate("Reseller Name", customer.name);
                            SetDropShipment();
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
            Editable = false;
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
                        rec.validate("Subsidiary Name", customer.name);
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
                        rec.validate("Financing Partner Name", customer.name);
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
                SetDropShipment();
            end;
        }

        field(50006; "Ship-To-Code"; code[10])
        {
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                ShipToAdress: record "Ship-to Address";
            begin
                if "Drop-Shipment" then begin
                    if not ShipToAdress.Get(rec."End Customer", "Ship-To-Code") then
                        Clear("Ship-To-Code");
                    ShipToAdress.SetRange("Customer No.", "End Customer");
                    IF page.RunModal(page::"Ship-to Address List", ShipToAdress, ShipToAdress.Code) = Action::LookupOK then begin
                        SetShipToAddress(ShipToAdress.Name, ShipToAdress."Name 2", ShipToAdress.Address, ShipToAdress."Address 2", ShipToAdress.City, ShipToAdress."Post Code", shiptoadress.County, shiptoadress."Country/Region Code");
                        rec.Validate("Ship-to Contact", ShipToAdress.Contact);
                        rec.validate("Ship-To-Code", ShipToAdress.Code);
                        rec.validate("Ship-to Phone No.", ShipToAdress."Phone No.");
                        rec.Validate("Ship-To Email", ShipToAdress."E-Mail");
                        rec.Modify(true);
                    end;
                end else begin
                    if not ShipToAdress.Get(rec.Reseller, "Ship-To-Code") then
                        Clear("Ship-To-Code");
                    ShipToAdress.SetRange("Customer No.", rec.Reseller);
                    IF page.RunModal(page::"Ship-to Address List", ShipToAdress, ShipToAdress.Code) = Action::LookupOK then begin
                        SetShipToAddress(ShipToAdress.Name, ShipToAdress."Name 2", ShipToAdress.Address, ShipToAdress."Address 2", ShipToAdress.City, ShipToAdress."Post Code", shiptoadress.County, shiptoadress."Country/Region Code");
                        rec.Validate("Ship-to Contact", ShipToAdress.Contact);
                        rec.validate("Ship-To-Code", ShipToAdress.Code);
                        rec.validate("Ship-to Phone No.", ShipToAdress."Phone No.");
                        rec.Validate("Ship-To Email", ShipToAdress."E-Mail");
                        rec.Modify(true);
                    end;
                end;
            end;

            trigger OnValidate()
            var
                ShipToAdress: record "Ship-to Address";
                Customer: Record customer;
            begin
                if "Ship-To-Code" = '' then
                    CheckDropShipmentAndSetShipToAddressOnSalesOrder(Customer);
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
        field(50009; "Ship directly from supplier"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "Reseller Name"; text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50011; "End Customer Name"; text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50012; "Subsidiary Name"; text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50013; "Financing Partner Name"; text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50014; "Ship-to Phone No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50015; "Ship-to Email"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50016; "End Customer Contact"; Text[50])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate();
            var
                Contact: record Contact;
            begin
                If ("End Customer Contact" <> '') and not Contact.get("End Customer Contact") then
                    error('Not a contact');
                Validate("End Customer Contact Name", Contact.Name);
                validate("End Customer Phone No.", Contact."Phone No.");
                Validate("End Customer Email", Contact."E-Mail");
                if "Drop-Shipment" then begin
                    Validate("Ship-to Email", "End Customer Email");
                    Validate("Ship-to Phone No.", "End Customer Phone No.");
                    Validate("Ship-to Contact", "End Customer Contact Name");
                end;
            end;

            trigger Onlookup();
            var
                Contact: record Contact;
            begin
                Clear(Contact);
                if not Contact.Get("End Customer Contact") then
                    Clear("End Customer Contact");
                LookupContact("End Customer", Contact."No.", Contact);
                IF page.RunModal(page::"Contact List", Contact, Contact."No.") = Action::LookupOK then begin
                    Validate("End Customer Contact", Contact."No.");
                end;
            end;
        }
        field(50017; "End Customer Phone No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50018; "End Customer Email"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50019; "End Customer Contact Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }

        field(50020; "SEC Shipping Advice"; Option)
        {
            Caption = 'Shipping Advice';
            OptionMembers = Partial,Complete;
        }

    }
    procedure SetShipToAddressOnSalesOrder(Customer: record customer)
    var
        ShipToAdress: record "Ship-to Address";
    begin
        if ShipToAdress.get(Customer."No.", Customer."Prefered Shipment Address") then begin
            SetShipToAddress(ShipToAdress.Name, ShipToAdress."Name 2", ShipToAdress.Address, ShipToAdress."Address 2", ShipToAdress.City, ShipToAdress."Post Code", shiptoadress.County, shiptoadress."Country/Region Code");
            rec.Validate("Ship-to Contact", ShipToAdress.Contact);
            rec.validate("Ship-To-Code", shiptoadress.Code);
            rec.Validate("Ship-to Phone No.", ShipToAdress."Phone No.");
            rec.Validate("Ship-To Email", ShipToAdress."E-Mail");
        end else begin
            SetShipToAddress(Customer.Name, customer."Name 2", customer.Address, Customer."Address 2", customer.City, Customer."Post Code", customer.County, customer."Country/Region Code");
            rec.Validate("Ship-to Contact", Customer.Contact);
            rec.validate("Ship-to Phone No.", Customer."Phone No.");
            rec.Validate("Ship-To Email", Customer."E-Mail");
        end;
    end;

    procedure CheckDropShipmentAndSetShipToAddressOnSalesOrder(Customer: record customer)
    var
        ShipToAdress: record "Ship-to Address";
    begin
        if "Drop-Shipment" then begin
            Customer.get(rec."End Customer");
            Clear("Ship-To-Code");
            SetShipToAddress(Customer.Name, Customer."Name 2", Customer.Address, Customer."Address 2", Customer.City, Customer."Post Code", Customer.County, Customer."Country/Region Code");
            rec.Validate("Ship-to Contact", Customer.Contact);
            rec.validate("Ship-to Phone No.", Customer."Phone No.");
            rec.Validate("Ship-to Email", Customer."E-Mail");
        end else begin
            Customer.Get(rec.Reseller);
            Clear("Ship-To-Code");
            SetShipToAddress(Customer.Name, customer."Name 2", customer.Address, Customer."Address 2", customer.City, Customer."Post Code", customer.County, customer."Country/Region Code");
            rec.Validate("Ship-to Contact", Customer.Contact);
            rec.validate("Ship-to Phone No.", Customer."Phone No.");
            rec.Validate("Ship-to Email", Customer."E-Mail");
        end;
    end;

    procedure SetDropShipment()
    var
        ShipToAdress: record "Ship-to Address";
        Customer: record customer;
    begin
        if "Drop-Shipment" then begin
            Customer.get(rec."End Customer");
            Clear("Ship-To-Code");
            SetShipToAddressOnSalesOrder(Customer);
        end else begin
            Customer.Get(rec.Reseller);
            Clear("Ship-To-Code");
            SetShipToAddressOnSalesOrder(Customer);
        end;
    end;

    local procedure LookupContact(CustomerNo: code[20]; ContactNo: code[20]; var Contact: record Contact)
    var
        ContactBusinessRelation: record "Contact Business Relation";
    begin
        IF ContactBusinessRelation.FindByRelation(ContactBusinessRelation."Link to Table"::Customer, CustomerNo) THEN
            Contact.SETRANGE("Company No.", ContactBusinessRelation."Contact No.")
    end;

}
