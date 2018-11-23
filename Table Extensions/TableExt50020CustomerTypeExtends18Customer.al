tableextension 50020 CustomerType extends 18
{
    fields
    {
        field(50000;"Customer Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "End Customer","Reseller","Manufacturer","Financing Partner";
            InitValue = "Reseller";
        }
        

    }
    
    var
        myInt : Integer;
}