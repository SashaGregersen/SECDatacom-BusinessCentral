report 50002 "Update Transfer Price %"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            trigger OnPreDataItem()

            begin
                if GetFilter("Item Disc. Group") = '' then
                    Error('You have to filter on an Item Disc. Group');
                Window.Open('Updating item #1###############');
            end;

            trigger OnAfterGetRecord()

            begin
                Window.Update(1, "No.");
                "Transfer Price %" := Newpercentage;
                Modify(true);
            end;

            trigger OnPostDataItem()

            begin
                Window.Close();
                Message('Transfer price percentages updated for Item Disc. Group %1', GetFilter("Item Disc. Group"));
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Transfer Prices")
                {
                    field("New percentage"; Newpercentage)
                    {
                        ApplicationArea = All;

                    }
                }
            }
        }

    }

    procedure SetTranferPricePercentage(PercentageValue: Decimal)
    begin
        Newpercentage := PercentageValue;
    end;

    var
        Newpercentage: Decimal;
        Window: Dialog;
}