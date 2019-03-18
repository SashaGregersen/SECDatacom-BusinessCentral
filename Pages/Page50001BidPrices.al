page 50001 "Bid Prices"
{
    PageType = List;
    SourceTable = "Bid Item Price";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Bid No."; "Bid No.")
                {
                    ApplicationArea = all;
                }
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
                field("Expiry Date"; "Expiry Date")
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
            action(CreateNewBid)
            {
                Caption = 'Create New Bid';

                trigger OnAction();
                var
                    Bid: Record Bid;
                    Item: Record Item;
                begin
                    Bid.Init();
                    Bid.Insert(true);
                    if Item.Get(Rec.GetFilter("item No.")) then begin
                        Bid.Validate("Vendor No.", Item."Vendor No.");
                        Bid.Modify(true);
                    end;
                end;
            }
        }
    }

    trigger OnInsertRecord(Belowxrec: Boolean): Boolean
    begin
        rec.Mark();
    end;
}