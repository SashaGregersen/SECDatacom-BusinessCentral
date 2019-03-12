tableextension 50017 "Item Discount Adv. Pricing" extends "Item Discount Group"
{
    //no longer used - delete at when not inconvienienced
    fields
    {
        field(50000; "Purchase From Vendor No."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No.";
            ObsoleteState = Pending;

        }
        field(50001; "Purchase Discount Percentage"; Decimal)
        {
            DataClassification = ToBeClassified;
            ObsoleteState = Pending;

        }
        field(50002; "Transfer Price Percentage"; Decimal)
        {
            DataClassification = ToBeClassified;
            ObsoleteState = Pending;

        }
        field(50003; "Customer Markup Percentage"; Decimal)
        {
            DataClassification = ToBeClassified;
            ObsoleteState = Pending;

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
