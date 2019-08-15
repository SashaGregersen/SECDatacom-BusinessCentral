tableextension 50000 "Sales Line Bid" extends "Sales Line"
{
    fields
    {
        field(50000; "Bid No."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Bid."No.";

            trigger OnLookUp();
            var
                BidPrices: Record "Bid Item Price";
                Bid: Record Bid;
                CurrExchRate: Record "Currency Exchange Rate";
            begin
                CalcFields("Posting Date");
                BidPrices.GetPricesForItem("Document No.", "No.", "Currency Code", "Sell-to Customer No.", "Posting Date", BidPrices);
                if Page.RunModal(50001, BidPrices) = "Action"::LookupOK then begin
                    Bid.Get(BidPrices."Bid No.");
                    if bid.Deactivate then
                        Error('The bid is deactivated and cannot be used');
                    "Bid No." := Bid."No.";
                    if ("Currency Code" = BidPrices."Currency Code") then
                        updateBidPrices(BidPrices, Bid.Claimable, Bid."Project Sale")
                    else begin
                        BidPrices."Bid Unit Sales Price" := CurrExchRate.ExchangeAmount(BidPrices."Bid Unit Sales Price", BidPrices."Currency Code", "Currency Code", "Posting Date");
                        BidPrices."Bid Unit Purchase Price" := CurrExchRate.ExchangeAmount(BidPrices."Bid Unit Purchase Price", BidPrices."Currency Code", "Currency Code", "Posting Date");
                        updateBidPrices(BidPrices, Bid.Claimable, Bid."Project Sale");
                    end;
                end;
                /* if "Bid No." = '' then
                    "Bid No." := ''; */
            end;

            trigger Onvalidate();
            var
                Bid: Record Bid;
                BidPrices: Record "Bid Item Price";
                CurrExchRate: Record "Currency Exchange Rate";
            begin
                if "Bid No." = '' then begin
                    Validate("Bid Unit Sales Price", 0);
                    Validate("Bid Unit Purchase Price", 0);
                    "Unit Cost" := 0;
                    UpdateAmounts();
                end else begin
                    if Bid.Get("Bid No.") then begin
                        BidPrices.SetRange("Bid No.", "Bid No.");
                        BidPrices.SetRange("item No.", "No.");
                        BidPrices.SetRange("Customer No.", "Sell-to Customer No.");
                        BidPrices.SetRange("Currency Code", "Currency Code");
                        if BidPrices.FindFirst then begin
                            updateBidPrices(BidPrices, BidPrices.Claimable, Bid."Project Sale");
                        end else begin
                            BidPrices.SetRange("Customer No.");
                            if BidPrices.FindFirst then begin
                                updateBidPrices(BidPrices, BidPrices.Claimable, Bid."Project Sale");
                            end else begin
                                BidPrices.SetRange("Currency Code");
                                if BidPrices.FindFirst then begin
                                    if ("Currency Code" = BidPrices."Currency Code") then begin
                                        updateBidPrices(BidPrices, BidPrices.Claimable, Bid."Project Sale");
                                        exit;
                                    end;
                                    if not Bid."Project Sale" then begin
                                        BidPrices."Bid Unit Sales Price" := CurrExchRate.ExchangeAmount(BidPrices."Bid Unit Sales Price", BidPrices."Currency Code", "Currency Code", "Posting Date");
                                        BidPrices."Bid Unit Purchase Price" := CurrExchRate.ExchangeAmount(BidPrices."Bid Unit Purchase Price", BidPrices."Currency Code", "Currency Code", "Posting Date");
                                        updateBidPrices(BidPrices, BidPrices.Claimable, Bid."Project Sale");
                                    end;
                                end
                            end;
                        end;
                    end else begin
                        Validate("Bid Unit Sales Price", 0);
                        Validate("Bid Unit Purchase Price", 0);
                        "Unit Cost" := 0;
                        UpdateAmounts();
                    end;
                end;
            end;
        }
        field(50001; "Bid Unit Sales Price"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger onvalidate();

            begin
                if "Bid Unit Sales Price" <> 0 then
                    validate("Unit Price", "Bid unit Sales Price")
                else
                    if "Bid Unit Sales Price" <> xRec."Bid Unit Sales Price" then
                        Validate(Quantity); //code here that finds the original sales price without bid
            end;
        }
        field(50002; "Bid Sales Discount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            trigger Onvalidate()
            var

            begin
                if "Bid Sales Discount" = 100 then
                    validate("Unit Price", 0);
            end;
        }
        field(50010; "Unit Purchase Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            trigger Onvalidate()
            begin
                if "Unit Purchase Price" <> xRec."Unit Purchase Price" then
                    CalcAdvancedPrices;
            end;
        }
        field(50011; "Bid Unit Purchase Price"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger Onvalidate()
            begin
                CalcAdvancedPrices;
            end;
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
            trigger Onvalidate()
            begin
                if "Transfer Price Markup" <> xRec."Transfer Price Markup" then
                    CalcAdvancedPrices;
            end;
        }
        field(50014; "KickBack Percentage"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            trigger Onvalidate()
            begin
                If "KickBack Percentage" = 0 then
                    "Kickback Amount" := 0;
                if "KickBack Percentage" <> xRec."KickBack Percentage" then
                    CalcAdvancedPrices;
            end;
        }
        field(50015; "Kickback Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50019; "Reseller Discount"; Decimal)
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
            Editable = false;

            trigger Onvalidate();
            begin
                if ("Unit Purchase Price" = 0) and Claimable then
                    Error('You cannot claim when the Unit Purchase Price is zero (0)');
                CalcAdvancedPrices();
            end;
        }
        field(50022; "Claim Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50023; "Profit Amount"; Decimal)
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
            ObsoleteState = Pending;
        }
        field(50026; "Line Amount Excl. VAT (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50027; "Unit List Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50028; "Unit List Price VC"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50029; "Profit Amount LCY"; Decimal)
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
        /* field(50035; "Vendor Item No."; text[60])
        {
            DataClassification = CustomerContent;
            TableRelation = item;

            trigger Onvalidate()
            var
                Item: record item;
            begin
                IF Type <> Type::Item THEN
                    EXIT;

                if "Vendor Item No." = '' then
                    validate("No.", '');

                if item.get("No.") then
                    Validate("Vendor Item No.", item."Vendor-Item-No.");
            end;
        } */
    }

    procedure updateBidPrices(BidPrices: Record "Bid Item Price"; NewClaimableValue: Boolean; IsProjectSales: Boolean)
    begin
        //if BidPrices."Bid Unit Sales Price" <> "Bid Unit Sales Price" then
        validate("Bid Unit Sales Price", BidPrices."Bid Unit Sales Price");
        If IsProjectSales and (BidPrices."Bid Unit Sales Price" = 0) then begin
            Validate("Unit Price", 0);
        end;
        //"Bid Sales Discount" := BidPrices."Bid Sales Discount Pct.";
        validate("Bid Sales Discount", BidPrices."Bid Sales Discount Pct.");
        Claimable := NewClaimableValue;
        Validate("Bid Unit Purchase Price", BidPrices."Bid Unit Purchase Price");
        "Bid Purchase Discount" := BidPrices."Bid Purchase Discount Pct.";

    end;

    procedure CalcAdvancedPrices();
    var
        TransferPriceAmount: Decimal;
        PriceEventHandler: Codeunit "Price Event Handler";
    begin
        //if (rec."Bid Unit Purchase Price" = 0) and (rec."Transfer Price Markup" = 0) and (rec."KickBack Percentage" = 0) then begin //SDG 15-07-19
        if (rec."Bid No." = '') and (rec."Transfer Price Markup" = 0) and (rec."KickBack Percentage" = 0) then begin //SDG 15-07-19
            rec."Calculated Purchase Price" := rec."Unit Purchase Price" * rec.Quantity;
            "Profit Amount" := rec."Line Amount" - rec."Calculated Purchase Price";
            if rec."Line Amount" <> 0 then
                rec."Profit Margin" := (rec."Profit Amount" / rec."Line Amount") * 100;
            //"Purchase Price on Purchase Order" := "unit Purchase Price";
            Claimable := false;
            "Claim Amount" := 0;
            PriceEventHandler.UpdateProfitAmountLCY(Rec);
            exit;
        end;

        if "KickBack Percentage" <> 0 then
            /* If "Bid Unit Sales Price" <> 0 then
                "Kickback Amount" := ("Bid Unit Sales Price" * Quantity) * ("KickBack Percentage" / 100)
            else
                "Kickback Amount" := ("Unit Price" * Quantity) * ("kickback percentage" / 100); */
                "Kickback Amount" := "Line Amount" * ("KickBack Percentage" / 100); //SDG 03-06-19

        if "Transfer Price Markup" <> 0 then
            If "Bid Unit Purchase Price" <> 0 then
                TransferPriceAmount := ("Bid Unit Purchase Price" * Quantity) * ("Transfer Price Markup" / 100)
            else
                TransferPriceAmount := ("Unit Purchase Price" * Quantity) * ("Transfer Price Markup" / 100);

        //If "Bid Unit Purchase Price" <> 0 then begin //SDG 15-07-19
        If "Bid No." <> '' then begin //SDG 15-07-19
            "Calculated Purchase Price" := ("Bid Unit Purchase Price" * Quantity) + TransferPriceAmount;
            //if not Claimable then            //    
            //    "Purchase Price on Purchase Order" := "Bid Unit Purchase Price"
            //else
            //    "Purchase Price on Purchase Order" := "Unit Purchase Price";
            if ("Unit Purchase Price" <> 0) and Claimable then
                "Claim Amount" := ("Unit Purchase Price" * Quantity) - ("Bid Unit Purchase Price" * Quantity)
            else
                "Claim Amount" := 0;
        end else begin
            "Calculated Purchase Price" := ("unit Purchase Price" * Quantity) + TransferPriceAmount;
            //"Purchase Price on Purchase Order" := "Unit Purchase Price";
            "Claim Amount" := 0;
        end;

        "Profit Amount" := "Line Amount" - "Calculated Purchase Price" - "Kickback Amount";
        if "Line Amount" <> 0 then
            "Profit Margin" := ("Profit Amount" / "Line Amount") * 100;

        PriceEventHandler.UpdateProfitAmountLCY(Rec);
    end;

    procedure IsICOrder(): Boolean
    var
        ICPartner: Record "IC Partner";
    begin
        ICPartner.SetRange("Customer No.", "Sell-to Customer No.");
        exit(ICPartner.FindFirst());
    end;
}