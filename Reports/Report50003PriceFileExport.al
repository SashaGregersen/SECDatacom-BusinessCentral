report 50003 "Price File Export"
{
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem(Item; Item)
        {
            trigger OnPreDataItem()
            var

            begin
                repeat
                    XMLport.run(50000, false, false, Item)
                until item.next = 0;
            end;


        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field("Item No"; Item."No.")
                    {
                        AssistEdit = true;
                        TableRelation = item;
                    }
                    field(Customer; Customer."No.")
                    {
                        AssistEdit = true;
                        TableRelation = customer;
                    }

                    field("Default Dimension"; DefaultDim."Dimension Value Code")
                    {
                        AssistEdit = true;
                        TableRelation = "Default Dimension";
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
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        customer: record customer;
        DefaultDim: record "Default Dimension";
}