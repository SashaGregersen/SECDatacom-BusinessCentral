report 50099 "Create List Price Variants"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            trigger onaftergetrecord()
            var
                ItemVariant: Record "Item Variant";
            begin
                ItemVariant.Init();
                ItemVariant.Code := 'LISTPRICE';
                ItemVariant."Item No." := Item."No.";
                ItemVariant.Description := 'List Price of item';
                if not ItemVariant.Insert(false) then;
            end;

            trigger OnPostDataItem()
            begin
                Message('List price variants created')
            end;
        }
    }

    var
        myInt: Integer;
}