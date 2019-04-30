tableextension 50046 "Design Payment Method" extends "Payment Method"
{
    fields
    {
        field(50000; "Invoice Text"; Blob)
        {
            DataClassification = ToBeClassified;
        }
    }

}