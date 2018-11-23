pageextension 50001 "Advanced Purchase prices" extends "Purchase Prices"
{
    layout
    {
        addafter("Ending Date")
        {
            field("List Price";"List Price")
            {
                ApplicationArea = All;
            }
            field("SEC Discount";"SEC Discount")
            {
                ApplicationArea = All;
            }
            field("Customer Discount %";"Customer Discount %")
            {
                ApplicationArea = All;
            }
            field("Customer Markup";"Customer Markup")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addafter(CopyPrices)
        {
            action(UpdatePrices)
            {
                Caption = 'Update Prices';
                Image = UpdateUnitCost;
                trigger OnAction();
                begin
                    Message('Under Construction')
                end;

            }
        }
    }
    
    var
        myInt : Integer;
}