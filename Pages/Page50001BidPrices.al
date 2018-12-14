page 50001 "Bid Prices"
{
    PageType = List;
    SourceTable = "Bid Prices";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("item No."; "item No.")
                {
                    ApplicationArea = all;
                }
                field("Customer No."; "Customer No.")
                {
                    ApplicationArea = alL;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = alL;
                }
                field("Unit List Price"; "Unit List Price")
                {
                    ApplicationArea = all;
                }
                field("Bid Unit Sales Price"; "Bid Unit Sales Price")
                {
                    ApplicationArea = all;
                }
                field("Bid Sales Discount %"; "Bid Sales Discount Pct.")
                {
                    ApplicationArea = all;
                }
                field("Bid Unit Purchase Price"; "Bid Unit Purchase Price")
                {
                    ApplicationArea = all;
                }
                field("Bid Purchase Discount %"; "Bid Purchase Discount Pct.")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ActionName)
            {
                trigger OnAction();
                begin
                end;
            }
        }
    }
}