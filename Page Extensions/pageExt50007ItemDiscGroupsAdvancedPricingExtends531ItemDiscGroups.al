pageextension 50007 "Item Dsc. Group Adv. Pricing" extends "Item Disc. Groups"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("Sales &Line Discounts")
        {
            action("Update prices")
            {
                image = PriceAdjustment;
                trigger OnAction();
                var
                    AdvpriceMgt: Codeunit "Advanced Price Management";
                begin
                    AdvpriceMgt.CalcSalesPricesForItemDiscGroup(Code);
                End;

            }
            action("Update Transfer Price Percentage")
            {
                image = TransferFunds;
                trigger OnAction();
                var
                    Item: Record Item;
                begin
                    item.SetRange("Item Disc. Group", Rec.Code);
                    report.RunModal(Report::"Update Transfer Price %", true, false, Item);
                End;
            }
        }

    }

    var
        myInt: Integer;
}