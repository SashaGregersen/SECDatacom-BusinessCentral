page 50000 "Bid List"
{
    PageType = List;
    SourceTable = Bid;
    DataCaptionFields = "No.", "Vendor no.", "Vendor Bid No.", "Expiry Date";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor No."; "Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor Bid No."; "Vendor Bid No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Expiry Date"; "Expiry Date")
                {
                    ApplicationArea = All;
                }
                field("One Time Bid"; "One Time Bid")
                {
                    ApplicationArea = All;
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
            action("Show Prices")
            {
                trigger OnAction();
                var
                    BidPrices: Record "Bid item Price";
                begin
                    BidPrices.SetRange("Bid No.", "No.");
                    page.RunModal(50001, BidPrices);
                end;
            }
        }
    }
}