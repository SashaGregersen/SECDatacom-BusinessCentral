pageextension 50002 "Sales Line Bid" extends "Sales Order Subform"
{


    layout
    {
        addafter("Line Discount %")
        {
            field("Bid No."; "Bid No.")
            {
                ApplicationArea = All;
            }
            field("Bid Unit Sales Price"; "Bid Unit Sales Price")
            {
                ApplicationArea = All;
            }
            field("Bid Sales Discount"; "Bid Sales Discount")
            {
                ApplicationArea = All;
            }
            field("Unit Purchase Price"; "Unit Purchase Price")
            {
                ApplicationArea = All;
            }
            field("Bid Unit Purchase Price"; "Bid Unit Purchase Price")
            {
                ApplicationArea = All;
            }
            field("Bid Purchase Discount"; "Bid Purchase Discount")
            {
                ApplicationArea = All;
            }
            field("Transfer Price Markup"; "Transfer Price Markup")
            {
                ApplicationArea = All;
            }
            field("KickBack Percentage"; "KickBack Percentage")
            {
                ApplicationArea = All;
            }
            field("Kickback Amount"; "Kickback Amount")
            {
                ApplicationArea = All;
            }
            field("Calculated Purchase Price"; "Calculated Purchase Price")
            {
                ApplicationArea = All;
            }
            field(Claimable; Claimable)
            {
                ApplicationArea = All;
            }
            field("Claim Amount"; "Claim Amount")
            {
                ApplicationArea = All;
            }
            field("Profit Amount"; "Profit Amount")
            {
                ApplicationArea = All;
            }
            field("Profit Margin"; "Profit Margin")
            {
                ApplicationArea = All;
            }
        }

        modify("Drop Shipment")
        {
            Visible = false;
        }
    }

    actions
    {
        addbefore(GetPrice)
        {
            action(Newbid)
            {
                Caption = 'New Bid';
                Image = New;
                ApplicationArea = all;

                trigger OnAction()
                var
                    SalesHeader: record "Sales Header";
                    OneTimeBid: Report "One Time Bid";
                    Item: Record item;
                begin
                    if type <> type::Item then
                        Error('Can only be used on items');
                    SalesHeader.get("Document Type", "Document No.");
                    Item.Get("No.");
                    OneTimeBid.SetCustomerNo(SalesHeader.Reseller);
                    OneTimeBid.SetItemNo("No.");
                    OneTimeBid.SetVendorNo(Item."Vendor No.");
                    OneTimeBid.SetTableView(Rec);
                    OneTimeBid.Run();
                end;
            }
            action(AddTransActionType)
            {
                Caption = 'Add Transaction Type';
                Image = ChangeDimensions;
                ApplicationArea = all;

                trigger OnAction()
                var
                    SalesOrderHandler: Codeunit "Sales Order Event Handler";
                begin
                    SalesOrderHandler.AddTransactionTypeToSalesDocument(Rec);
                end;
            }
        }
    }




}