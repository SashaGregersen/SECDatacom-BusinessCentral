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
    var
        SalesPriceWksh: record "Sales Price Worksheet";
    begin
        SalesPriceWksh.Validate("Sales Type", SalesPriceWksh."Sales Type"::"All Customers");
        SalesPriceWksh.Validate("Item No.", Item."No.");
        SalesPriceWksh.Validate("Variant Code", 'LISTPRICE');
        SalesPriceWksh.Validate("Unit of Measure Code", Item."Base Unit of Measure");
        SalesPriceWksh.Validate("Minimum Quantity", 0);
        SalesPriceWksh.Validate("Currency Code", item."Vendor Currency");
        SalesPriceWksh.Validate("Starting Date", Today());
        SalesPriceWksh.Insert(true);
    end;
}