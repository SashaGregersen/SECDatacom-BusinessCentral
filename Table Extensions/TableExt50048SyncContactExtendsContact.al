tableextension 50048 "Sync Contact" extends 5050
{
    fields
    {
        field(50000; "Owning Company"; Text[30])
        {
            DataClassification = CustomerContent;
            TableRelation = Company.Name;
            Editable = false;
        }
    }

    var
}