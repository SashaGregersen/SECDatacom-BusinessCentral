report 50017 "One Time Bid"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    UseRequestPage = true;

    dataset
    {
        dataitem(Bid; Bid)
        {
            RequestFilterFields = "Vendor Bid No.", Description;

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
            end;

            trigger OnAfterGetRecord()
            var

            begin
                validate("Vendor No.", VendorNo);

            end;

            trigger OnPostDataItem()
            var

            begin

            end;
        }
    }

    procedure SetVendorNo()
    begin

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
}