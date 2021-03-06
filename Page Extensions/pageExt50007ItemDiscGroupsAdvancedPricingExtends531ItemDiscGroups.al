pageextension 50007 "Item Dsc. Group Adv. Pricing" extends "Item Disc. Groups"
{
    layout
    {
        addafter(Description)
        {
            field("Use Orginal Vendor in Subs"; "Use Orginal Vendor in Subs")
            {
                ApplicationArea = all;
                Caption = 'Use Original Vendor in Subs';
            }
        }
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
            action("Show Percentages")
            {
                image = Percentage;
                trigger OnAction();
                var
                    Percentages: Record "Item Disc. Group Percentages";
                begin
                    Percentages.SetRange("Item Disc. Group Code", Rec.Code);
                    Page.RunModal(Page::"Item Disc. Group Percentages", Percentages);
                End;
            }
        }

    }

}