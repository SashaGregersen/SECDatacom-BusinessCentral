tableextension 50013 "General Ledger Setup" extends "General Ledger Setup"
{
    fields
    {
        field(50000; "Master Company"; text[35])
        {
            DataClassification = ToBeClassified;
            TableRelation = Company.Name;
        }
    }

    var

}