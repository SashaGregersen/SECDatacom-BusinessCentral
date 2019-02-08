tableextension 50040 "Purch. CrMe. Hdr. Adv. Pricing" extends "Purch. Cr. Memo Hdr."
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
    }

}
