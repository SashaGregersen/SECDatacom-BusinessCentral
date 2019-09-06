table 50013 "Error Log"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Error No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Error Text"; text[250])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Source Table"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(4; "Source No."; code[20])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Source Document Type"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Source Ref. No."; code[20])
        {
            DataClassification = CustomerContent;
        }
        field(7; "IC Source No."; code[20])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Error No.")
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

    Procedure GetLastUsedErrorLog(): Integer
    var

    begin
        if Rec.FindLast() then
            exit(rec."Error No." + 1)
        else
            exit(1);
    end;

}