page 50017 "Sales Posting Options"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Sales Header";

    layout
    {
        area(Content)
        {
            group(Dates)
            {
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; "Due Date")
                {
                    ApplicationArea = All;
                }
                field("Shipment Date"; "Shipment Date")
                {
                    ApplicationArea = All;
                }
            }
            group(Options)
            {
                field(PostOption; PostOption)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    var
        PostOption: Option "Ship","Post","Ship&Post";
}