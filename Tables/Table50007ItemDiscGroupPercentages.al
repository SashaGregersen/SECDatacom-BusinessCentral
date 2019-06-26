table 50007 "Item Disc. Group Percentages"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item Disc. Group Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Discount Group".Code;
        }
        field(2; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Purchase From Vendor No."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No.";
        }
        field(11; "Purchase Discount Percentage"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(12; "Transfer Price Percentage"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(13; "Customer Markup Percentage"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Item Disc. Group Code", "Start Date")
        {
            Clustered = true;
        }
    }

    var
        AdvPriceMgt: codeunit "Advanced Price Management";

    trigger OnInsert()
    begin
        if Rec."Transfer Price Percentage" <> 0 then
            AdvPriceMgt.UpdateTransferPrices("Item Disc. Group Code", "Transfer Price Percentage");
        if ("Purchase Discount Percentage" <> 0) or ("Customer Markup Percentage" <> 0) then
            AdvPriceMgt.UpdatePurchaseDicountsForItemDiscGroup("Item Disc. Group Code", "Purchase Discount Percentage", "Customer Markup Percentage", "Start Date", "Purchase From Vendor No.");
    end;

    trigger OnModify()
    begin
        if Rec."Transfer Price Percentage" <> xRec."Transfer Price Percentage" then
            AdvPriceMgt.UpdateTransferPrices("Item Disc. Group Code", Rec."Transfer Price Percentage");
        if (Rec."Purchase Discount Percentage" <> xRec."Purchase Discount Percentage") or (Rec."Customer Markup Percentage" <> xRec."Customer Markup Percentage") then
            AdvPriceMgt.UpdatePurchaseDicountsForItemDiscGroup("Item Disc. Group Code", "Purchase Discount Percentage", "Customer Markup Percentage", "Start Date", "Purchase From Vendor No.");
    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}