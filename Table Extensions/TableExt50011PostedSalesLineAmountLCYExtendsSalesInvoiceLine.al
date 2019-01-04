tableextension 50011 "Posted Sales Line Amount LCY" extends "Sales Invoice Line"
{
    fields
    {
        field(50026; "Line Amount Excl. VAT (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }
    var

}