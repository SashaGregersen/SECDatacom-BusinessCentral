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
                field(Claimable; Claimable)
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
            action("Import Bid Prices")
            {
                Image = ImportExcel;
                trigger OnAction()
                var
                    FilMgt: Codeunit "File Management Import";
                begin
                    FilMgt.ImportBidPricesFromCSV();
                end;
            }
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
            action("Show Only Active Bids")
            {
                Visible = not ShowingAll;

                trigger OnAction();
                begin
                    if GetFilter("Expiry Date") = '' then begin
                        SetFilter("Expiry Date", '>%1', WorkDate());
                        ShowingAll := true;
                    end ELSE begin
                        SetRange("Expiry Date");
                        ShowingAll := false;
                    end;
                    CurrPage.Update(true);
                end;
            }
            action("Show All Bids")
            {
                Visible = ShowingAll;
                trigger OnAction();
                begin
                    if GetFilter("Expiry Date") = '' then begin
                        SetFilter("Expiry Date", '>%1', WorkDate());
                        ShowingAll := true;
                    end ELSE begin
                        SetRange("Expiry Date");
                        ShowingAll := false;
                    end;
                    CurrPage.Update(true);
                end;
            }
            action("Copy To Other Companies")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    BidMgt: Codeunit "Bid Management";
                begin
                    BidMgt.CopyBidToOtherCompanies(Rec);
                end;
            }
        }
    }
    var
        ShowingAll: Boolean;
}