pageextension 50002 "Sales Line Bid" extends "Sales Order Subform"
{
    

    layout
    {
        addafter("Line Discount %")
        {
            field("Bid No.";"Bid No.")
            {
                ApplicationArea = All;
                Editable = BidFieldsEditable;
            }
            field("Bid Unit Sales Price";"Bid Unit Sales Price")
            {
                ApplicationArea = All;
                Editable = BidFieldsEditable;
            }
            field("Bid Sales Discount";"Bid Sales Discount")
            {
                ApplicationArea = All;
                Editable = BidFieldsEditable;
            }
            field("Unit Purchase Price";"Unit Purchase Price")
            {
                ApplicationArea = All;
                Editable = BidFieldsEditable;
            }
            field("Bid Unit Purchase Price";"Bid Unit Purchase Price")
            {
                ApplicationArea = All;
                Editable = BidFieldsEditable;
            }
            field("Bid Purchase Discount";"Bid Purchase Discount")
            {
                ApplicationArea = All;
                Editable = BidFieldsEditable;
            }
            field("Transfer Price Markup";"Transfer Price Markup")
            {
                ApplicationArea = All;
                Editable = BidFieldsEditable;
            }
            field("KickBack Percentage";"KickBack Percentage")
            {
                ApplicationArea = All;
                Editable = BidFieldsEditable;
            }
            field("Kickback Amount";"Kickback Amount")
            {
                ApplicationArea = All;
                Editable = BidFieldsEditable;
            }
            field("Calculated Purchase Price";"Calculated Purchase Price")
            {
                ApplicationArea = All;
            }
            field(Claimable;Claimable)
            {
                ApplicationArea = All;
                Editable = BidFieldsEditable;

            }
            field("Claim Amount";"Claim Amount")
            {
                ApplicationArea = All;
            }
            field("Profit Amount";"Profit Amount")
            {
                ApplicationArea = All;
            }
            field("Profit Margin";"Profit Margin")
            {
                ApplicationArea = All;
            }
            field("Purchase Price on Purchase Order";"Purchase Price on Purchase Order")
            {
                ApplicationArea = All;

            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
    
    var
        BidFieldsEditable : Boolean;
        SalesHeader : Record "Sales Header";

    trigger OnOpenPage();
    begin
        //if SalesHeader.Get("Document Type","Document No.") then
        //    BidFieldsEditable :=  (SalesHeader.Status = SalesHeader.Status::Open);
        BidFieldsEditable := true;
    end;    
}