pageextension 50071 "PostedSalesInvoiceSubform" extends "Posted Sales Invoice Subform"
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
            field("Profit Amount"; "Profit Amount 1")
            {
                ApplicationArea = All;
            }
            field("Profit Margin"; "Profit Margin")
            {
                ApplicationArea = All;
            }
        }

    }
}