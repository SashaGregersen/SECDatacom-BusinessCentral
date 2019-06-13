page 50010 "Item Disc. Group Percentages"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Item Disc. Group Percentages";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Start Date"; "Start Date")
                {
                    ApplicationArea = All;
                }
                field("Purchase From Vendor No."; "Purchase From Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Purchase Discount Percentage"; "Purchase Discount Percentage")
                {
                    ApplicationArea = All;
                }
                field("Customer Markup Percentage"; "Customer Markup Percentage")
                {
                    ApplicationArea = All;
                }
                field("Transfer Price Percentage"; "Transfer Price Percentage")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

}