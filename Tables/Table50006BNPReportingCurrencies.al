table 50006 "BNP Reporting Currency"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Currency Code"; code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency.Code;
            Editable = true;
        }

        field(2; "BNP Agreement No."; code[10])
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
    }

    keys
    {
        key(PK; "Currency Code")
        {
            Clustered = true;
        }
        key(Key1; "BNP Agreement No.")
        {
            ObsoleteState = Removed;
        }
    }

    var

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