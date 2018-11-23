table 50002 "Price Group Link"
{
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1;"Customer No.";code[20])
        {
            TableRelation = Customer."No.";
            DataClassification = ToBeClassified;
        }
        field(2;"Customer Discount Group Code";code [20])
        {
            TableRelation = "Customer Discount Group".Code;
            NotBlank = true;
            DataClassification = ToBeClassified;
        }
    }    
    keys
    {
        key(PK;"Customer No.","Customer Discount Group Code")
        {
            Clustered = true;
        }
    }
    
    var
        myInt : Integer;

    trigger OnInsert();
    begin
    end;

    trigger OnModify();
    begin
    end;

    trigger OnDelete();
    begin
    end;

    trigger OnRename();
    begin
    end;

}