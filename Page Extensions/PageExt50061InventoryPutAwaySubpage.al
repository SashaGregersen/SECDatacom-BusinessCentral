pageextension 50061 InventoryPutAwaySubpage extends "Invt. Put-away Subform"
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