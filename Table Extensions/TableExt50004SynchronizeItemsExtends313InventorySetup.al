tableextension 50004 "Synchronize Item" extends "Inventory Setup"
{
    fields
    {
        field(50000; "Synchronize Item"; boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(50001; "Receive Synchronized Items"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(50002; "Price file location"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Customer Price File Location';
        }
        field(50004; "Price file location 2"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Webshop Price File Location';
        }
    }

    var

}