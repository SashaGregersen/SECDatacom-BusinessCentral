tableextension 50014 "Vendor Item No." extends "Sales Price Worksheet"
{
    //NC.00.01 SDG Change to add new list price 
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
        If "Vendor Item No." = '' then
            exit;  //don't try to find item unless we have a vendor item no.
        if "Vendor Item No." <> '' then
            Item.SetRange("Vendor-Item-No.", "Vendor Item No.");
        if "Vendor No." <> '' then
            Item.SetRange("Vendor No.", "Vendor No.");
        if Item.FindFirst() then
            Validate("Item No.", Item."No.")
        else
            Validate("Item No.", '');
    end;

    procedure CreateNewListPriceFromItem(Item: Record Item; InsertRec: Boolean)
    begin
        Validate("Sales Type", "Sales Type"::"All Customers");
        //Validate("Item No.", Item."No."); //SDG 27-05-19
        if (item."Vendor-Item-No." <> '') and (item."Vendor No." <> '') then begin //SDG 31-07-2019
            Validate("Vendor No.", Item."Vendor No."); //SDG 27-05-19
            Validate("Vendor Item No.", Item."Vendor-Item-No."); //SDG 27-05-19
        end else //SDG 31-07-2019
            Validate("Item No.", Item."No."); //SDG 31-07-2019
        Validate("Variant Code", 'LISTPRICE');
        Validate("Unit of Measure Code", Item."Base Unit of Measure");
        Validate("Minimum Quantity", 0);
        Validate("Currency Code", Item."Vendor Currency");
        Validate("Starting Date", Today());
        if InsertRec then
            if Insert(true) then;
    end;
}