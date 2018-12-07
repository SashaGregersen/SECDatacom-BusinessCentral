tableextension 50007 "Purch. Rcpt. Line Bid" extends "Purch. Rcpt. Line"
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