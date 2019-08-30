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
                field("Vendor Bid No."; "Vendor Bid No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field("item No."; "item No.")
                {
                    ApplicationArea = all;
                }
                field("Vendor Item No."; "Vendor Item No.")
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
                field(Claimable; Claimable)
                {
                    ApplicationArea = all;
                }
                field("One Time Bid"; "One Time Bid")
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
                    Message('Bid No. %1 created', Bid."No.");
                end;
            }
            //>>NC 
            //Funktion til opdatering af Vendor Item No. efter tilføjet nyt felt.
            action(UpdateVendorItemNumber)
            {
                Caption = 'Update Vendor Item No.';
                ToolTip = 'Only used 1 time for updating legacy data with Vendor Item No.';

                Image = NewItem;

                trigger OnAction();
                var
                    BidPrices: Record "Bid Item Price";
                    item: Record Item;
                begin
                    BidPrices.SetFilter("item No.", '<>%1', '''');
                    If BidPrices.FindSet then begin
                        repeat
                            if item.get(BidPrices."item No.") then begin
                                BidPrices."Vendor Item No." := item."Vendor Item No.";
                                BidPrices.Modify();
                            end;
                        until bidprices.Next = 0;
                    end;
                    Message('Updated' + Format(BidPrices.Count()) + ' bid prices w. vendor item no.');

                end;
                //<<NC
            }
        }
    }

    trigger OnInsertRecord(Belowxrec: Boolean): Boolean
    begin
        rec.Mark(true);
    end;
}