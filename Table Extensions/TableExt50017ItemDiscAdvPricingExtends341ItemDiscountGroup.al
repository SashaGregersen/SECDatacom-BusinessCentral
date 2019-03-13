tableextension 50017 "Item Discount Adv. Pricing" extends "Item Discount Group"
{
    //Only Update to Ondelete trigger to ensure proper cleanup from sub table
    fields
    {

    }

    trigger OnDelete()
    var
        Percentages: Record "Item Disc. Group Percentages";
    begin
        Percentages.SetRange("Item Disc. Group Code", Rec.Code);
        Percentages.DeleteAll(true);
    end;
}
