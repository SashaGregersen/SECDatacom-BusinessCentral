tableextension 50041 "Purch. Rcpt. Hdr. Adv. Pricing" extends "Purch. Rcpt. Header"
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
        field(50004; "Ship-To Comment"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

}
