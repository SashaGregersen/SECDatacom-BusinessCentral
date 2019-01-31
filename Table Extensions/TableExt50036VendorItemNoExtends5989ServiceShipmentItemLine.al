tableextension 50036 "Vendor Item No ServiceShipment" extends "Service Shipment Item Line"
{
    fields
    {
        field(50000; "Vendor-Item-No"; text[60])
        {
            DataClassification = ToBeClassified;
        }
    }

}