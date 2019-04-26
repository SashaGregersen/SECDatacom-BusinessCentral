tableextension 50018 "Purch and Pay Setup" extends "Purchases & Payables Setup"
{
    fields
    {
        field(50001; "Claims Charge No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Charge";
        }
    }

}