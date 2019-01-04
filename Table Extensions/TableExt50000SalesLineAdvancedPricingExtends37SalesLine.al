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
                Item: Record Item;
                BidPrices: Record "Bid Item Price";
            begin
                if item.Get("No.") then begin
                    BidPrices.SetRange("item No.", "No.");
                    BidPrices.SetRange("Currency Code", rec."Currency Code");
                    if not BidPrices.FindFirst() then
                        BidPrices.SetRange("Currency Code");
                    BidPrices.setrange("Customer No.", "Sell-to Customer No.");
                    if not BidPrices.FindFirst then
                        BidPrices.SetRange("Customer No.");
                    if Page.RunModal(50001, BidPrices) = "Action"::LookupOK then
                        validate("Bid No.", BidPrices."Bid No.");
                end
            end;

            trigger Onvalidate();
            var
                Bid: Record Bid;
                BidPrices: Record "Bid Item Price";
                CurrExchRate: Record "Currency Exchange Rate";
            begin
                if Bid.Get("Bid No.") then begin
                    BidPrices.SetRange("Bid No.", "Bid No.");
                    BidPrices.SetRange("item No.", "No.");
                    BidPrices.SetRange("Customer No.", "Sell-to Customer No.");
                    BidPrices.SetRange("Currency Code", "Currency Code");
                    if BidPrices.FindFirst then begin
                        updateBidPrices(BidPrices."Bid Unit Sales Price", BidPrices."Bid Unit Purchase Price", BidPrices.Claimable);
                    end else begin
                        BidPrices.SetRange("Customer No.");
                        if BidPrices.FindFirst then begin
                            updateBidPrices(BidPrices."Bid Unit Sales Price", BidPrices."Bid Unit Purchase Price", BidPrices.Claimable);
                        end else begin
                            BidPrices.SetRange("Currency Code");
                            if BidPrices.FindFirst then begin
                                if ("Currency Code" = BidPrices."Currency Code") then begin
                                    updateBidPrices(BidPrices."Bid Unit Sales Price", BidPrices."Bid Unit Purchase Price", BidPrices.Claimable);
                                    exit;
                                end;
                                updateBidPrices(CurrExchRate.ExchangeAmount(BidPrices."Bid Unit Sales Price", BidPrices."Currency Code", "Currency Code", "Posting Date"),
                                                CurrExchRate.ExchangeAmount(BidPrices."Bid Unit Purchase Price", BidPrices."Currency Code", "Currency Code", "Posting Date"),
                                                BidPrices.Claimable);
                            end
                        end;
                    end;
                end else begin
                    Validate("Bid Unit Sales Price", 0);
                    Validate("Bid Unit Purchase Price", 0)
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
                    Validate(Quantity); //code here that finds the original sales price without bid
            end;
        }
        field(50002; "Bid Sales Discount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "Unit Purchase Price"; Decimal)
        {
            DataClassification = ToBeClassified;
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
                if "Bid Unit Purchase Price" <> xRec."Bid Unit Purchase Price" then
                    CalcAdvancedPrices;
                if "Bid Unit Purchase Price" <> 0 then
                    Claimable := true;
            end;
        }
        field(50012; "Bid Purchase Discount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger Onvalidate()
            begin
                if "Bid Purchase Discount" <> xRec."Bid Purchase Discount" then
                    CalcAdvancedPrices;
                if "Bid Purchase Discount" <> 0 then
                    Claimable := true;
            end;

        }
        field(50013; "Transfer Price Markup"; Decimal)
        {
            DataClassification = ToBeClassified;
            //Editable = false;
            trigger Onvalidate()
            begin
                if "Transfer Price Markup" <> xRec."Transfer Price Markup" then
                    CalcAdvancedPrices;
            end;
        }
        field(50014; "KickBack Percentage"; Decimal)
        {
            DataClassification = ToBeClassified;
            //Editable = false;
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
        field(50020; "Calculated Purchase Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50021; "Claimable"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger Onvalidate();
            begin
                CalcAdvancedPrices();
            end;
        }
        field(50022; "Claim Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(500023; "Profit Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50024; "Profit Margin"; decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50025; "Purchase Price on Purchase Order"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50026; "Line Amount Excl. VAT (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            trigger OnValidate()
            var
                GLsetup: record "General Ledger Setup";
                CurrencyExcRate: record "Currency Exchange Rate";
                Factor: decimal;
            begin
                if "Currency Code" <> '' then begin
                    Factor := CurrencyExcRate.GetCurrentCurrencyFactor(rec."Currency Code");
                    rec.validate("Line Amount Excl. VAT (LCY)", CurrencyExcRate.ExchangeAmtLCYToFCY(Today(), rec."Currency Code", rec.Amount, Factor));
                end else begin
                    rec.validate("Line Amount Excl. VAT (LCY)", rec.Amount);
                end;
            end;
        }

    }
    local procedure updateBidPrices(SalesPrice: Decimal; PurchPrice: Decimal; NewClaimableValue: Boolean)
    begin
        if SalesPrice <> 0 then
            validate("Bid Unit Sales Price", SalesPrice);
        If PurchPrice <> 0 then
            Validate("Bid Unit Purchase Price", PurchPrice);
        Claimable := NewClaimableValue;
    end;


    procedure CalcAdvancedPrices();
    var
        TransferPriceAmount: Decimal;
    begin
        if ("Bid Unit Purchase Price" = 0) and ("Transfer Price Markup" = 0) and ("KickBack Percentage" = 0) then begin
            "Calculated Purchase Price" := "Unit Purchase Price" * Quantity;
            "Profit Amount" := "Line Amount" - "Calculated Purchase Price";
            if "Line Amount" <> 0 then
                "Profit Margin" := ("Profit Amount" / "Line Amount") * 100;
            "Purchase Price on Purchase Order" := "unit Purchase Price";
            Claimable := false;
            "Claim Amount" := 0;
            exit;
        end;

        if "KickBack Percentage" <> 0 then
            If "Bid Unit Purchase Price" <> 0 then
                "Kickback Amount" := ("Bid Unit Purchase Price" * Quantity) * ("KickBack Percentage" / 100)
            else
                "Kickback Amount" := ("Unit Purchase Price" * Quantity) * ("kickback percentage" / 100);

        if "Transfer Price Markup" <> 0 then
            If "Bid Unit Purchase Price" <> 0 then
                TransferPriceAmount := ("Bid Unit Purchase Price" * Quantity) * ("Transfer Price Markup" / 100)
            else
                TransferPriceAmount := ("Unit Purchase Price" * Quantity) * ("Transfer Price Markup" / 100);

        If "Bid Unit Purchase Price" <> 0 then begin
            "Calculated Purchase Price" := ("Bid Unit Purchase Price" * Quantity) + TransferPriceAmount;
            if not Claimable then
                "Purchase Price on Purchase Order" := "Bid Unit Purchase Price"
            else
                "Purchase Price on Purchase Order" := "Unit Purchase Price";
            "Claim Amount" := ("Unit Purchase Price" * Quantity) - ("Bid Unit Purchase Price" * Quantity);
        end else begin
            "Calculated Purchase Price" := ("unit Purchase Price" * Quantity) + TransferPriceAmount;
            "Purchase Price on Purchase Order" := "Unit Purchase Price";
            "Claim Amount" := 0;
        end;

        "Profit Amount" := "Line Amount" - "Calculated Purchase Price" - "Kickback Amount";
        if "Line Amount" <> 0 then
            "Profit Margin" := ("Profit Amount" / "Line Amount") * 100;

    end;

}