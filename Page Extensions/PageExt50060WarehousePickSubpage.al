pageextension 50060 WarehousePickSubpage extends "Whse. Pick Subform"
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