tableextension 50020 CustomerType extends 18
{
    fields
    {
        field(50000; "Customer Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "End Customer","Reseller","Manufacturer","Financing Partner";
            InitValue = "Reseller";
        }
        field(50001; "Prefered Shipment Address"; code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnLookup()
            var
                ShipToAddress: record "Ship-to Address";
            begin
                ShipToAddress.SetRange("Customer No.", rec."No.");
                if page.RunModal(page::"Ship-to Address List", ShipToAddress) = Action::LookupOK then begin
                    rec.validate("Prefered Shipment Address", ShipToAddress.Code);
                    rec.Modify(true);
                end;
            end;

            trigger OnValidate()
            var
                ShipToAddress: record "Ship-to Address";
            begin
                if "Prefered Shipment Address" <> '' then
                    ShipToAddress.Get("No.", "Prefered Shipment Address");
            end;

        }
        field(50002; "Prefered Sender Address"; code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnLookup()
            var
                ShipToAddress: record "Ship-to Address";
            begin
                ShipToAddress.SetRange("Customer No.", rec."No.");
                if page.RunModal(page::"Ship-to Address List", ShipToAddress) = Action::LookupOK then begin
                    rec.validate("Prefered Sender Address", ShipToAddress.Code);
                    rec.Modify(true);
                end;
            end;

            trigger OnValidate()
            var
                ShipToAddress: record "Ship-to Address";
            begin
                if "Prefered Sender Address" <> '' then
                    ShipToAddress.Get("No.", "Prefered Sender Address");
            end;
        }
        field(50003; "Owning Company"; Text[35])
        {
            DataClassification = ToBeClassified;
            TableRelation = Company.Name;
            Editable = false;
        }

        field(50004; "Insured Risk"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                Validate("Credit Limit (LCY)", "Insured Risk" + "UnInsured Risk");
            end;
        }
        field(50005; "UnInsured Risk"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                Validate("Credit Limit (LCY)", "Insured Risk" + "UnInsured Risk");
            end;
        }
    }

}