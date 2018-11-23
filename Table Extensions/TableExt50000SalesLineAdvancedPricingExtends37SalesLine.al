tableextension 50000 "Sales Line Bid" extends "Sales Line"
{
    fields
    {
        field(50000;"Bid No.";code [20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Bid."Bid No.";

            trigger OnLookUp();
            var
                Item : Record Item;
                Bid : Record Bid;
                TempBid : Record Bid temporary;
                BidPrices : Record "Bid Prices";
            begin
                if item.Get("No.") then begin
                    BidPrices.SetRange("item No.","No.");
                    BidPrices.setrange("Customer No.","Sell-to Customer No.");
                    if not BidPrices.FindFirst then 
                       BidPrices.SetRange("Customer No.");
                    if BidPrices.FindSet then repeat
                        if Bid.Get(BidPrices."Bid No.") then begin
                            TempBid := Bid;
                            if not TempBid.Insert then;
                        end;
                    Until BidPrices.Next = 0;    
                    if Page.RunModal(50000,TempBid) = "Action"::LookupOK then 
                        validate("Bid No.",TempBid."Bid No.");
                end    
            end;

            trigger Onvalidate();
            var
                Bid : Record Bid;
                BidPrices : Record "Bid Prices";
            begin
                if Bid.Get("Bid No.") then begin
                    BidPrices.SetRange("Bid No.","Bid No.");
                    BidPrices.SetRange("item No.","No.");
                    BidPrices.SetRange("Customer No.","Sell-to Customer No.");
                    if BidPrices.FindFirst then begin
                        if BidPrices."Bid Unit Sales Price" <> 0 then 
                            validate("Bid Unit Sales Price",BidPrices."Bid Unit Sales Price");
                        If BidPrices."Bid Unit Purchase Price" <> 0 then
                            Validate("Bid Unit Purchase Price",BidPrices."Bid Unit Purchase Price");
                        Claimable := BidPrices.Claimable;    
                    end else begin
                        BidPrices.SetRange("Customer No.");
                        if BidPrices.FindFirst then begin
                            if BidPrices."Bid Unit Sales Price" <> 0 then 
                                validate("Bid Unit Sales Price",BidPrices."Bid Unit Sales Price");
                            If BidPrices."Bid Unit Purchase Price" <> 0 then
                                Validate("Bid Unit Purchase Price",BidPrices."Bid Unit Purchase Price");
                            Claimable := BidPrices.Claimable;    
                        end 
                    end;
                end else begin
                    Validate("Bid Unit Sales Price",0);
                    Validate("Bid Unit Purchase Price",0)
                end; 
            end;
        }
        field(50001;"Bid Unit Sales Price";Decimal)
        {
            DataClassification = ToBeClassified;
            
            trigger onvalidate();

            begin
                if "Bid Unit Sales Price" <> 0 then
                    validate("Unit Price","Bid unit Sales Price")
                else
                    Validate(Quantity); //code here that finds the original sales price without bid
            end;
        }
        field(50002;"Bid Sales Discount";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50010;"Unit Purchase Price"; Decimal)
        {
            DataClassification = ToBeClassified;
                        trigger Onvalidate()
            begin
                if "Unit Purchase Price" <> xRec."Unit Purchase Price" then 
                    CalcAdvancedPrices;    
            end;
        }
        field(50011;"Bid Unit Purchase Price";Decimal)
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
        field(50012;"Bid Purchase Discount";Decimal)
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
        field(50013;"Transfer Price Markup";Decimal)
        {
            DataClassification = ToBeClassified;
            //Editable = false;
            trigger Onvalidate()
            begin
                if "Transfer Price Markup" <> xRec."Transfer Price Markup" then 
                    CalcAdvancedPrices;    
            end;
        }
        field(50014;"KickBack Percentage";Decimal)
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
        field(50015;"Kickback Amount";Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50020;"Calculated Purchase Price";Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger Onvalidate();
            var
                myInt : Integer;
            begin
                //the price calculation goes here? or perhaps in a function that updates this field?
            end;
        }
        field(50021;"Claimable";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50022;"Claim Amount";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(500023;"Profit Amount";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50024;"Profit Margin";decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50025;"Purchase Price on Purchase Order";Decimal)
        {
            DataClassification = ToBeClassified;
        }

    }
    
        
    procedure CalcAdvancedPrices();
    var
        TransferPriceAmount : Decimal;
    begin
        if ("Bid Unit Purchase Price" = 0) and ("Transfer Price Markup" = 0) and ("Kickback Amount" = 0) then begin 
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
                "Kickback Amount" := ("Bid Unit Purchase Price" * Quantity) * ("KickBack Percentage"/100)
            else
                "Kickback Amount" := ("Unit Purchase Price" * Quantity) * ("kickback percentage"/100);
             
        if "Transfer Price Markup" <> 0  then
            If "Bid Unit Purchase Price" <> 0 then
                TransferPriceAmount := ("Bid Unit Purchase Price" * Quantity) * ("Transfer Price Markup"/100)
            else
                TransferPriceAmount := ("Unit Purchase Price" * Quantity) * ("Transfer Price Markup"/100);

        If "Bid Unit Purchase Price" <> 0 then begin
            "Calculated Purchase Price" := ("Bid Unit Purchase Price" * Quantity) + TransferPriceAmount;
            "Purchase Price on Purchase Order" := "Bid Unit Purchase Price";
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