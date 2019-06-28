tableextension 50048 "Sync Contact" extends 5050
{
    fields
    {

        field(50003; "Owning-Company"; Text[35])
        {
            DataClassification = CustomerContent;
            TableRelation = Company.Name;
            Editable = false;
        }


    }

    var
}