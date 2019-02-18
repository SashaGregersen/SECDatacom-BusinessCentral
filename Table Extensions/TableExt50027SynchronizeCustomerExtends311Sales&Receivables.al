tableextension 50027 "Synchronize Customer" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; "Synchronize Customer"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(50001; "Bid No. Series"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }

        field(50002; "Freight Item"; code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    var

}