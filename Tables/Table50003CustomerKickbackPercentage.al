table 50003 "Customer Kickback Percentage"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Customer No."; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Item Disc. Group Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Discount Group".Code;
        }
        field(5; "Kickback Percentage"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Customer No.", "Item Disc. Group Code")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}