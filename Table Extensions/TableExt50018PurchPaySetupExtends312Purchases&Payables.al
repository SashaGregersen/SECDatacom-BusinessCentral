tableextension 50018 "Purch and Pay Setup" extends "Purchases & Payables Setup"
{
    fields
    {
        field(50000; "POS File Location"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Claims Charge No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Charge";
        }
    }

}