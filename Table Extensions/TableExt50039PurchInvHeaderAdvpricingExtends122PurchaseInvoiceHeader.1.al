tableextension 50039 "Purch. Inv. Hdr. Adv. Pricing" extends "Purch. Inv. Header"
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
        field(50002; "End Customer Contact"; code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50003; "Reseller Contact"; code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

}
