report 50017 "One Time Bid"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    UseRequestPage = true;

    dataset
    {

        dataitem("Sales Line"; "Sales Line")
        {
            dataitem(Bid; Bid)
            {
                DataItemLink = "No." = field ("Bid No.");
                RequestFilterFields = "Vendor Bid No.", Description, Claimable;

                dataitem("Bid Item Price"; "Bid Item Price")
                {
                    DataItemLink = "Bid No." = field ("No.");
                    RequestFilterFields = "Bid Purchase Discount Pct.", "Bid Unit Purchase Price";

                }
                trigger OnPreDataItem()
                var
                    Claim: Boolean;
                    BidPurchDiscPct: Decimal;
                    BidUnitPurchPrice: Decimal;
                begin
                    Bid.init;
                    "No." := '';
                    validate("Vendor No.", VendorNo);
                    Validate("One Time Bid", true);
                    validate("Vendor Bid No.", GetFilter("Vendor Bid No."));
                    validate(Description, GetFilter(Description));
                    if getfilter(Claimable) <> '' then begin
                        Evaluate(Claim, getfilter(Claimable));
                        validate(Claimable, Claim);
                    end;
                    Insert(true);
                    "Bid Item Price".init;
                    "Bid Item Price".validate("Bid No.", Bid."No.");
                    "Bid Item Price".validate("item No.", ItemNo);
                    "Bid Item Price".validate("Customer No.", CustomerNo);
                    if "Bid Item Price".GetFilter("Bid Purchase Discount Pct.") <> '' then begin
                        Evaluate(BidPurchDiscPct, "Bid Item Price".GetFilter("Bid Purchase Discount Pct."));
                        "Bid Item Price".validate("Bid Purchase Discount Pct.", BidPurchDiscPct);
                    end;
                    if "Bid Item Price".GetFilter("Bid Unit Purchase Price") <> '' then begin
                        Evaluate(BidUnitPurchPrice, "Bid Item Price".GetFilter("Bid Unit Purchase Price"));
                        "Bid Item Price".validate("Bid Unit Purchase Price", BidUnitPurchPrice);
                    end;
                    "Bid Item Price".Insert(true);
                end;

                trigger OnPostDataItem()
                var

                begin
                    "Sales Line".validate("Bid No.", Bid."No.");
                    "Sales Line".Modify(true);
                end;
            }
        }

    }

    procedure SetVendorNo(NewVendorNo: code[20])
    var

    begin
        VendorNo := NewVendorNo;
    end;

    procedure SetItemNo(NewItemNo: code[20])
    var

    begin
        ItemNo := NewItemNo;
    end;

    procedure SetCustomerNo(NewCustomerNo: code[20])
    var

    begin
        CustomerNo := NewCustomerNo;
    end;

    var
        VendorNo: code[20];
        ItemNo: code[20];
        CustomerNo: code[20];
}