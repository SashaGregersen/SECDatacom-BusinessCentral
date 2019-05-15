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

                begin
                    Bid.init;
                    "No." := '';
                    "Bid Item Price".init;
                end;

                trigger OnAfterGetRecord()
                var

                begin
                    validate("Vendor No.", VendorNo);
                    Validate("One Time Bid", true);
                    validate("Vendor Bid No.", "Vendor Bid No.");
                    validate(Description, Description);
                    validate(Claimable, Claimable);
                    Insert(true);
                    "Bid Item Price".validate("Bid No.", Bid."No.");
                    "Bid Item Price".validate("item No.", ItemNo);
                    "Bid Item Price".validate("item No.", CustomerNo);
                    "Bid Item Price".validate("Bid Purchase Discount Pct.", "Bid Item Price"."Bid Purchase Discount Pct.");
                    "Bid Item Price".validate("Bid Unit Purchase Price", "Bid Item Price"."Bid Unit Purchase Price");
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

    /* requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(Name; SourceExpression)
                    {
                        ApplicationArea = All;

                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    } */

    var
        VendorNo: code[20];
        ItemNo: code[20];
        CustomerNo: code[20];
}