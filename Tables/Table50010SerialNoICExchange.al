table 50010 "Serial No. Intercompany Exch."
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Order Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Sales Order","Return Order","Purchase order","Return Receipt";
        }
        field(5; "Order No."; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(7; "Item No."; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(8; "Serial No."; code[50])
        {
            DataClassification = ToBeClassified;

        }

    }

    keys
    {
        key(PK; "Order Type", "Order No.", "Line No.", "Item No.", "Serial No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
    end;


}