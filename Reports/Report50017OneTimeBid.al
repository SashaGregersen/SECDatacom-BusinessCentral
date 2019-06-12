report 50017 "One Time Bid"
{
    UsageCategory = None;
    //ApplicationArea = All;
    ProcessingOnly = true;
    UseRequestPage = true;

    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {
            dataitem(Bid; Bid)
            {
                DataItemLink = "No." = field ("Bid No.");

                dataitem("Bid Item Price"; "Bid Item Price")
                {
                    DataItemLink = "Bid No." = field ("No.");

                }
                trigger OnPreDataItem()
                var

                begin
                    Bid.init;
                    "No." := '';
                    validate("Vendor No.", VendorNo);
                    Validate("One Time Bid", true);
                    validate("Vendor Bid No.", VendorBidNo);
                    validate(Description, Description);
                    validate(Claimable, Claim);
                    Insert(true);
                    "Bid Item Price".init;
                    "Bid Item Price".validate("Bid No.", Bid."No.");
                    "Bid Item Price".validate("item No.", ItemNo);
                    "Bid Item Price".validate("Customer No.", CustomerNo);
                    if BidPurchDiscount <> 0 then
                        "Bid Item Price".validate("Bid Purchase Discount Pct.", BidPurchDiscount);
                    if BidUnitPurchPrice <> 0 then
                        "Bid Item Price".validate("Bid Unit Purchase Price", BidUnitPurchPrice);
                    if BidSalesDiscount <> 0 then
                        "Bid Item Price".validate("Bid Sales Discount Pct.", BidSalesDiscount);
                    if BidUnitSalesPrice <> 0 then
                        "Bid Item Price".validate("Bid Unit Sales Price", BidUnitSalesPrice);
                    "Bid Item Price".Insert(true);
                end;

                trigger OnPostDataItem()
                var

                begin
                    "Sales Line".validate("Bid No.", Bid."No.");
                    "Sales Line".Modify(true);
                end;
            }

            trigger OnAfterGetRecord()
            var

            begin
                if ("Sales Line"."Document No." <> SalesLine2."Document No.") or ("Sales Line"."Document Type" <> SalesLine2."Document Type") or ("Sales Line"."Line No." <> SalesLine2."Line No.") then
                    CurrReport.skip;
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
                    field("Vendor Bid No."; VendorBidNo)
                    {

                    }
                    field("Description"; Description)
                    {

                    }
                    field("Claimable"; Claim)
                    {

                    }
                    field("Bid Purchase Discount"; BidPurchDiscount)
                    {

                    }
                    field("Bid Unit Purchase Price"; BidUnitPurchPrice)
                    {

                    }
                    field("Bid Sales Discount"; BidSalesDiscount)
                    {

                    }
                    field("Bid Unit Sales Price"; BidUnitSalesPrice)
                    {

                    }

                }
            }
        }
    }

    procedure SetSalesLineFilter(SalesLine: Record "Sales Line")
    var

    begin
        SalesLine2 := SalesLine;
    end;

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
        VendorBidNo: text[100];
        Description: text;
        Claim: Boolean;
        BidPurchDiscount: Decimal;
        BidUnitPurchPrice: Decimal;
        BidSalesDiscount: Decimal;
        BidUnitSalesPrice: Decimal;
        SalesLine2: record "Sales Line";


}