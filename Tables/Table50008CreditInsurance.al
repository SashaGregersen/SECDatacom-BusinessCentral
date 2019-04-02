table 50008 "Credit Insurance"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Customer No."; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(50004; "Insured Risk"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "UnInsured Risk"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Atradius No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Customer No.")
        {
            Clustered = true;
        }
    }
}