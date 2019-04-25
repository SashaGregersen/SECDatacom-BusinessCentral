table 50011 "Request Parameters"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Report Id"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; "User Id"; code[100])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Parameters"; blob)
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(PK; "Report Id", "User ID")
        {
            Clustered = true;
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