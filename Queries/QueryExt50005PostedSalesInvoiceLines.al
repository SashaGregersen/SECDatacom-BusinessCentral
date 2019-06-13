query 50005 "PostedSalesInvoiceLines"
{
    Caption = 'PostedSalesInvoiceLines';

    elements
    {
        dataitem(Sales_Invoice_Line; "Sales Invoice Line")
        {
            column(Document_No_; "Document No.")
            {
            }
            Column(Line_No_; "Line No.")
            {
            }
            Column(Type; Type)
            {
            }
            Column(No_; "No.")
            {
            }
            column(Description; Description)
            {
            }
            column(Quantity; Quantity)
            {
            }
            column(Unit_Cost__LCY_; "Unit Cost (LCY)")
            {
            }
            column(Line_Amount; "Line Amount") { }
            column(Shortcut_Dimension_1_Code; "Shortcut Dimension 1 Code")
            {

            }
            column(Order_No_; "Order No.")
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(Item_Category_Code; "Item Category Code")
            {

            }
            column(Bid_No_; "Bid No.")
            {

            }
            column(Bid_Unit_Sales_Price; "Bid Unit Sales Price")
            {
            }
            column(Bid_Sales_Discount; "Bid Sales Discount")
            {
            }
            column(Unit_Purchase_Price; "Unit Purchase Price")
            {

            }
            column(Bid_Unit_Purchase_Price; "Bid Unit Purchase Price")
            {

            }
            column(Bid_Purchase_Discount; "Bid Purchase Discount")
            {

            }
            column(Transfer_Price_Markup; "Transfer Price Markup")
            {

            }
            column(KickBack_Percentage; "KickBack Percentage")
            {

            }
            column(Kickback_Amount; "Kickback Amount")
            {

            }
            column(Calculated_Purchase_Price; "Calculated Purchase Price")
            {

            }
            column(Claim_Amount; "Claim Amount")
            {

            }
            column(Claimable; Claimable)
            {

            }
            column(Profit_Amount; "Profit Amount 1")
            {

            }
            column(Profit_Amount_LCY; "Profit Amount LCY") { }
            column(Line_Amount_Excl__VAT__LCY_; "Line Amount Excl. VAT (LCY)")
            {
            }

            dataitem(Sales_Invoice_Header; "Sales Invoice Header")
            {
                DataItemLink = "No." = Sales_Invoice_Line."Document No.";
                column(End_Customer; "End Customer")
                {

                }
                Column(Reseller; Reseller)
                {

                }
                Column(Currency_Code; "Currency Code")
                {

                }
                dataitem(Item; "Item")
                {
                    DataItemLink = "No." = Sales_Invoice_Line."Document No.";
                    column(Vendor_Item_No_; "Vendor Item No.") { }
                }


            }

        }

    }
}
