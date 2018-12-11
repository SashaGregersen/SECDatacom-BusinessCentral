tableextension 50003 "Item Adv. Pricing" extends Item
{

    fields
    {
        field(50000; "Vendor Currency"; code[10])
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50001; "Transfer Price %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(50002; "Use on Website"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    var

}