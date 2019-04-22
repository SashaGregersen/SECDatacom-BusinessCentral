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
        field(50003; "Provision Journal Template"; code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }
        field(50004; "Provision Journal Batch"; code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name WHERE ("Journal Template Name" = FIELD ("Provision Journal Template"));
        }

        field(50100; "Project Item Template"; code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Config. Template Header".Code where ("Table ID" = const (27));
        }

        field(50101; "License Item Template"; code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Config. Template Header".Code where ("Table ID" = const (27));
        }

        field(50102; "Service Item Template"; code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Config. Template Header".Code where ("Table ID" = const (27));
        }

        field(66050; "Cygate Endpoint"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
    }


    var

}