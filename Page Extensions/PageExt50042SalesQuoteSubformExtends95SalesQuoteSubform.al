pageextension 50042 "Sales Quote Subform" extends "Sales Quote Subform"
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
            field("Reseller Discount"; "Reseller Discount")
            {
                ApplicationArea = all;
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
        }

    }

    actions
    {

    }

}