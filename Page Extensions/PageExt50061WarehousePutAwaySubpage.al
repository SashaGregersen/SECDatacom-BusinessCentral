pageextension 50061 WarehousePutAwaySubpage extends "Whse. Put-away Subform"
{
    layout
    {
        addafter("Item No.")
        {
            field("Vendor Item No"; "Vendor Item No")
            {
                ApplicationArea = all;
            }
            field(GTIN; GTIN)
            {
                ApplicationArea = all;
            }
        }
    }
}