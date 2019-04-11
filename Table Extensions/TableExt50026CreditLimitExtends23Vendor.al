tableextension 50026 "Credit Limit" extends Vendor
{
    fields
    {
        field(50000; "Credit Limit Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Credit Limit Currency"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency;
        }
        field(50002; "Claims Vendor"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
    }

    var

}