tableextension 50014 "Vendor Item No." extends "Sales Price Worksheet"
{
    fields
    {
        field(50000; "Vendor Item No."; text[60])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
    }


}