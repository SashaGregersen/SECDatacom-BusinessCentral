tableextension 50078 "Sales Prices" extends "Sales Price"
{
    fields
    {
        Field(50000; "Allow Zero Price"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

}