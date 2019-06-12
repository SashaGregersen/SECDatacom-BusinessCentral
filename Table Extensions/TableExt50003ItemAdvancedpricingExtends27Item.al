tableextension 50003 "Item Adv. Pricing" extends Item
{

    fields
    {
        field(50000; "Vendor Currency"; code[10])
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50001; "Transfer Price %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(50002; "Use on Website"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Default Location"; code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }

        field(50004; "Vendor-Item-No."; Text[60])
        {
            DataClassification = CustomerContent;
            trigger onvalidate()
            var

            begin
                "Vendor Item No." := "Vendor-Item-No.";
            end;
        }

        field(50005; "Blocked from purchase"; boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "IC partner Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }

    }

    Fieldgroups
    {
        addlast(DropDown; "Vendor-Item-No.")
        {

        }
    }

}