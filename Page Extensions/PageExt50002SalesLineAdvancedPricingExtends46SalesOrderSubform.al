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
            field("Purchase Price on Purchase Order"; "Purchase Price on Purchase Order")
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
        // Add changes to page actions here
    }




}