tableextension 50014 "Vendor Item No." extends "Sales Price Worksheet"
{
    fields
    {
        field(50000; "Vendor Item No."; text[60])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
    }

    /* procedure SetValues(var SalesPriceWksh: record "Sales Price Worksheet"; Item: Record Item)
    var

    begin
        SalesPriceWksh."Starting Date" := today;
        SalesPriceWksh."Variant Code" := 'LISTPRICE';
        SalesPriceWksh."Sales Type" := SalesPriceWksh."Sales Type"::"All Customers";
        SalesPriceWksh."Item No." := item."No.";
        SalesPriceWksh."Unit of Measure Code" := Item."Base Unit of Measure";
        SalesPriceWksh."Minimum Quantity" := 0;
        SalesPriceWksh."Currency Code" := item."Vendor Currency";
    end; */
}