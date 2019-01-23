tableextension 50020 CustomerType extends 18
{
    fields
    {
        field(50000; "Customer Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "End Customer","Reseller","Manufacturer","Financing Partner";
            InitValue = "Reseller";
        }
        field(50001; "Prefered Shipment Address"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Ship-to Address".code;
        }
        field(50003; "Owning Company"; Text[35])
        {
            DataClassification = ToBeClassified;
            TableRelation = Company.Name;
            Editable = true;
        }


    }

    var

}