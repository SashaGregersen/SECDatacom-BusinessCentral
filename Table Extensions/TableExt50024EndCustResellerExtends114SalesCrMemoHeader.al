tableextension 50024 "End Customer and Reseller 4" extends 114
{
    fields
    {
        field(50000; "End Customer"; Text[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50001; "Reseller"; Text[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;

        }
        field(50003; "Subsidiary"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50004; "Financing Partner"; text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50005; "Drop-Shipment"; boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50007; "Sell-to-Customer-Name"; text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50008; "Suppress Prices on Printouts"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    var

}