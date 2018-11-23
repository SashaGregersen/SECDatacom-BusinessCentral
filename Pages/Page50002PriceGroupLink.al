page 50002 "Price Group Links"
{
    PageType = List;
    SourceTable = "Price Group Link";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Customer Discount Group Code";"Customer Discount Group Code")
                {
                    ApplicationArea = all;
                }
            }
        }
        area(factboxes)
        {
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