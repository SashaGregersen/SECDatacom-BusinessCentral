tableextension 50038 "Purch. Header Adv. Pricing" extends "Purchase Header"
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
        field(50002; "End Customer Contact No."; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50003; "Reseller Contact No."; code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

}
