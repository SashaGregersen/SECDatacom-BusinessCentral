tableextension 50017 "Item Discount Adv. Pricing" extends "Item Discount Group"
{
    //Only Update to Ondelete trigger to ensure proper cleanup from sub table
    fields
    {
        field(50000; "Use Orginal Vendor in Subs"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Item: record item;
            begin
                item.setrange("Item Disc. Group", Rec.Code);
                item.ModifyAll("Item Disc. Group", rec.Code, true);
            end;
        }
    }

    trigger OnDelete()
    var
        Percentages: Record "Item Disc. Group Percentages";
    begin
        Percentages.SetRange("Item Disc. Group Code", Rec.Code);
        Percentages.DeleteAll(true);
    end;
}
