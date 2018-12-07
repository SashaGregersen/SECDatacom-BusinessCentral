tableextension 50008 "Purch. Inv. Line Bid" extends "Purch. Inv. Line"
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