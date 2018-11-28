report 50001 "Update Prices with Currencies"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(DataItemName; "Sales Price")
        {
            MaxIteration = 1;
            trigger OnAfterGetRecord();
            var
                Item: Record Item;
            begin
                IF Get("Sales Type", "Item No.", "Unit Price") then repeat
                                                                        SetRange("Item No.", Item."No.");
                                                                        If Item.FindFirst() then begin
                                                                            IF "Currency Code" <> item."Vendor Currency" then
                                                                                ;
                                                                        End;
                    until next = 0;
            end;

        }
    }


}



