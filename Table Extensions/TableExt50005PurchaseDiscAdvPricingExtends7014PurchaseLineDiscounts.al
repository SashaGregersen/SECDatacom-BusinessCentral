tableextension 50005 "Pur. Discount Adv. Pricing" extends "Purchase Line Discount"
{
    fields
    {
        /*         field(50000;"List Price";Boolean)
                {
                    DataClassification = ToBeClassified;
                }
                field(50001;"SEC Discount";Decimal)
                {
                    DataClassification = ToBeClassified;
                }
                field(50002;"Customer Discount %";Decimal)
                {
                    DataClassification = ToBeClassified;
                } */
        field(50003; "Customer Markup"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

}