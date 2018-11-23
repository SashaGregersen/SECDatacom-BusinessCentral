tableextension 50026 "Credit Limit" extends 23
{
    fields
    {
        field(50000;"Credit Limit Amount";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50001;"Credit Limit Currency";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency;
        }
    }
    
    var
        myInt : Integer;
}