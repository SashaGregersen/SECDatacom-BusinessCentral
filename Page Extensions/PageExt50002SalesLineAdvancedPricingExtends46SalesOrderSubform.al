pageextension 50002 "Sales Line Bid" extends "Sales Order Subform"
{


    layout
    {
        addafter("Unit Price")
        {
            field("Unit List Price"; "Unit List Price")
            {
                ApplicationArea = all;
            }
        }
        addafter("Line Discount %")
        {
            Field("Reseller Discount"; "Reseller Discount")
            {
                ApplicationArea = All;
            }
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
            field("Description 2"; "Description 2")
            {
                ApplicationArea = All;
            }
        }

        modify("Drop Shipment")
        {
            Visible = false;
        }

        addafter("No.")
        {
            field("Vendor Item No."; "Vendor Item No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
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
                    SalesLine: record "Sales Line";
                begin
                    if type <> type::Item then
                        Error('Can only be used on items');
                    SalesHeader.get("Document Type", "Document No.");
                    Item.Get("No.");
                    OneTimeBid.SetCustomerNo(SalesHeader.Reseller);
                    OneTimeBid.SetItemNo("No.");
                    OneTimeBid.SetVendorNo(Item."Vendor No.");
                    OneTimeBid.SetSalesLineFilter(Rec);
                    OneTimeBid.SetTableView(Rec);
                    OneTimeBid.Run();
                end;
            }
        }
    }




}