tableextension 50029 "Vendor Item No Req Line" extends "Requisition Line"
{
    fields
    {
        field(50000; "Vendor-Item-No"; text[60])
        {
            DataClassification = ToBeClassified;
        }

        field(50001; "Substitute Item Exists"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }


}