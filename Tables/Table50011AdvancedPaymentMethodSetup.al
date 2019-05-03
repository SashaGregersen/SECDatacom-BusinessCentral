table 50011 "Advanced Payment Method Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Customer Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Customer Posting Group";
        }
        field(2; "Currency Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency;
        }
        field(3; "Payment Method Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Method";
        }
    }

    keys
    {
        key(PK; "Customer Posting Group", "Currency Code")
        {
            Clustered = true;
        }
    }
}