table 50000 "Bid"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Bid List";
    DrillDownPageId = "Bid List";
    DataCaptionFields =;


    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }

        field(2; "Vendor No."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No.";
        }
        field(3; "Vendor Bid No."; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Expiry Date"; date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "One Time Bid"; boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(6; Description; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(7; Claimable; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Project Sale"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }

    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Vendor no.", "Vendor Bid No.", "Expiry Date")
        {

        }
    }
    var
        BidPrices: Record "Bid Item Price";
        SalesSetup: record "Sales & Receivables Setup";
        NoSeriesManage: Codeunit NoSeriesManagement;

    trigger OnInsert();
    begin
        IF "No." = '' then begin
            SalesSetup.Get();
            SalesSetup.TestField("Bid No. Series");
            Validate("No.", NoseriesManage.GetNextNo('Bid', today, true));
        end;
    end;

    trigger OnModify();
    begin
    end;

    trigger OnDelete();
    begin
        BidPrices.SetRange("Bid No.", "No.");
        if BidPrices.Count > 0 then
            Error('You cannot delete the bid as there are prices assoicated with it.')
    end;

    trigger OnRename();
    begin
    end;

    procedure AddItemtoBid(itemNo: code[20]; SalesDiscPct: Decimal; PurchaseDiscPct: Decimal)
    var
        Item: Record Item;
        ListPrice: Record "Sales Price";
        BidItemPrice: Record "Bid Item Price";
        AdvPricemgt: Codeunit "Advanced Price Management";
        CurrencyTemp: Record Currency temporary;
    begin
        If not Item.Get(itemNo) then
            exit;
        if not AdvPricemgt.FindListPriceForitem(Item."No.", Item."Vendor Currency", ListPrice) then
            exit;
        BidItemPrice.Init();
        BidItemPrice."Bid No." := Rec."No.";
        BidItemPrice."item No." := Item."No.";
        BidItemPrice."Currency Code" := item."Vendor Currency";
        BidItemPrice."Unit List Price" := ListPrice."Unit Price";
        if SalesDiscPct <> 0 then
            BidItemPrice.validate("Bid Sales Discount Pct.", SalesDiscPct);
        if PurchaseDiscPct <> 0 then
            BidItemPrice.Validate("Bid Purchase Discount Pct.", PurchaseDiscPct);
        BidItemPrice.Insert(true);

        AdvPricemgt.FindPriceCurrencies(Item."Vendor Currency", item."Vendor Currency" <> '', CurrencyTemp);
        if CurrencyTemp.FindSet() then
            repeat
                if AdvPricemgt.FindListPriceForitem(Item."No.", CurrencyTemp.Code, ListPrice) then begin
                    BidItemPrice.Init();
                    BidItemPrice."Bid No." := Rec."No.";
                    BidItemPrice."item No." := Item."No.";
                    BidItemPrice."Currency Code" := CurrencyTemp.Code;
                    BidItemPrice."Unit List Price" := ListPrice."Unit Price";
                    if SalesDiscPct <> 0 then
                        BidItemPrice.validate("Bid Sales Discount Pct.", SalesDiscPct);
                    if PurchaseDiscPct <> 0 then
                        BidItemPrice.Validate("Bid Purchase Discount Pct.", PurchaseDiscPct);
                    BidItemPrice.Insert(true);
                end;
            until CurrencyTemp.Next() = 0;
    end;

}