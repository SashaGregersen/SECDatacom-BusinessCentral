tableextension 50045 "Ret. Receipt Line Adv. Pricing" extends "Return Receipt Line"
{
    fields
    {
        field(50000; "Bid No."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Bid."No.";
        }
        field(50001; "Bid Unit Sales Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Bid Sales Discount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50010; "Unit Purchase Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "Bid Unit Purchase Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50012; "Bid Purchase Discount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50013; "Transfer Price Markup"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50014; "KickBack Percentage"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50015; "Kickback Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50020; "Calculated Purchase Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50021; "Claimable"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50022; "Claim Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(500023; "Profit Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            ObsoleteState = Removed;
        }
        field(50023; "Profit Amount 1"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50024; "Profit Margin"; decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50025; "Purch. Price on Purchase Order"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50026; "Line Amount Excl. VAT (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50030; "IC PO No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50031; "IC PO Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50032; "IC SO No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50033; "IC SO Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50034; "Claim Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50035; "Vendor Item No."; text[60])
        {
            DataClassification = CustomerContent;
            TableRelation = item;

            trigger Onvalidate()
            var
                Item: record item;
            begin
                IF Type <> Type::Item THEN
                    EXIT;
            end;
        }
    }

}