tableextension 50025 "End Customer and Reseller 5" extends 6660
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
        field(50010; "Reseller Name"; text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50011; "End Customer Name"; text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    var

}