tableextension 50014 "Vendor Item No." extends "Sales Price Worksheet"
{
    fields
    {
        field(50000; "Vendor Item No."; text[60])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                UpdateItemNoFromVendorItemNo();
            end;
        }
        field(50001; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                UpdateItemNoFromVendorItemNo();
            end;
        }
    }

    local procedure UpdateItemNoFromVendorItemNo()
    var
        Item: Record Item;
    begin
        if "Vendor Item No." <> '' then
            Item.SetRange("Vendor-Item-No.", "Vendor Item No.");
        if "Vendor No." <> '' then
            Item.SetRange("Vendor No.", "Vendor No.");
        if Item.FindFirst() then
            Validate("Item No.", Item."No.")
        else
            Validate("Item No.", '');
    end;

    procedure CreateNewListPriceFromItem(Item: Record Item)
    begin
        Validate("Sales Type", "Sales Type"::"All Customers");
        Validate("Item No.", Item."No.");
        Validate("Variant Code", 'LISTPRICE');
        Validate("Unit of Measure Code", Item."Base Unit of Measure");
        Validate("Minimum Quantity", 0);
        Validate("Currency Code", item."Vendor Currency");
        Validate("Starting Date", Today());
        Insert(true);
    end;
}