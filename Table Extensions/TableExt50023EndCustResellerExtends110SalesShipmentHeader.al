tableextension 50023 "End Customer and Reseller 3" extends 110
{
    fields
    {
        field(50000; "End Customer"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Reseller"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Prefered Shipment Address"; code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    var
        myInt: Integer;
}