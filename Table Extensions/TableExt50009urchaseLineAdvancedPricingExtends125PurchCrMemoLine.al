tableextension 50009 "Purch. Cr. Memo Line Bid" extends "Purch. Cr. Memo Line"
{
    fields
    {
        field(50000; "Bid No."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Bid."No.";
        }
        field(50021; "Claimable"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

    }

}