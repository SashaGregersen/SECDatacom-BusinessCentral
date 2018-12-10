page 50003 "Customer Kickback Percentages"
{
    PageType = List;
    SourceTable = "Customer Kickback Percentage";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Item Disc. Group Code"; "Item Disc. Group Code")
                {
                    ApplicationArea = All;
                }
                field("Kickback Percentage"; "Kickback Percentage")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Update Sales orders")
            {
                ApplicationArea = All;

                trigger OnAction();
                begin
                    Message('Under construction');
                end;
            }
        }
    }
}