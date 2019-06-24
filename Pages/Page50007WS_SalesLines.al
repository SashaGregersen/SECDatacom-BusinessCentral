page 50007 "WS Sales Line"
{
    PageType = ListPart;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Sales Line";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Line No."; "Line No.")
                {
                    ApplicationArea = All;
                }
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                }
                field("Unit Price"; "Unit Price")
                {
                    ApplicationArea = All;
                }
                field("Requested Delivery Date"; "Requested Delivery Date")
                {
                    ApplicationArea = All;
                }
                field("VendorBidCode"; "Description 2")
                {
                    ApplicationArea = All;
                    CaptionML = DAN = 'VendorBidCode', ENU = 'VendorBidCode';
                }
            }
        }
    }
    var
        ShipComment: Text;

    trigger OnOpenPage()
    begin
        SetHideValidationDialog(true);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Type := Type::Item;
    end;
}