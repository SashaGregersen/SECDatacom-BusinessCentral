tableextension 50006 "Purchase Line Bid" extends "Purchase Line"
{
    fields
    {
        field(50000; "Bid No."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Bid."Bid No.";
        }
        field(50021; "Claimable"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

    }

}