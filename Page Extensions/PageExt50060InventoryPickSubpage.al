pageextension 50060 InventoryPickSubpage extends "Invt. Pick Subform"
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