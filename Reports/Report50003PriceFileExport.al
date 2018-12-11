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
                        TableRelation = item;
                    }
                    field(Customer; Customer."No.")
                    {
                        TableRelation = customer;
                    }

                    field("Default Dimension"; DefaultDim."Dimension Value Code")
                    {
                        TableRelation = "Default Dimension"."Dimension Value Code" where ("Table ID" = CONST (27));
                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(x)
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