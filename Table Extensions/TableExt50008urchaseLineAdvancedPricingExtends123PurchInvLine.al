tableextension 50008 "Purch. Inv. Line Bid" extends "Purch. Inv. Line"
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

        field(50001; "Vendor-Item-No"; text[60])
        {
            DataClassification = ToBeClassified;
        }

    }

}