page 50016 "Advanced Payment Method Setup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Advanced Payment Method Setup";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Customer Posting Group"; "Customer Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Payment Method Code"; "Payment Method Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}