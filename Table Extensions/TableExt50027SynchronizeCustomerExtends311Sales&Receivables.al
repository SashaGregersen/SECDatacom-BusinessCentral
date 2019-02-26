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

        field(66050; "Cygate Endpoint"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
    }

    var

}