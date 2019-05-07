tableextension 50044 "Invoice Split" extends "Invoice Post. Buffer"
{
    fields
    {
        field(50000; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }
}