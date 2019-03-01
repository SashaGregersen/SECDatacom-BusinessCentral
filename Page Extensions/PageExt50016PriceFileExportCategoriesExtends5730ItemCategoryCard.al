pageextension 50016 "Price File Export Categories" extends "Item Category Card"
{
    layout
    {
        addafter("Parent Category")
        {
            field("Overwrite Quantity"; "Overwrite Quantity")
            {
                ApplicationArea = all;
            }
        }
    }

}