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
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(2; "Vendor No."; code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";
        }
        field(3; "Vendor Bid No."; text[100])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Expiry Date"; date)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                BidPrices: Record "Bid Item Price";
            begin
                BidPrices.SetRange("Bid No.", "No.");
                BidPrices.ModifyAll("Expiry Date", "Expiry Date");
            end;
        }
        field(5; "One Time Bid"; boolean)
        {
            DataClassification = CustomerContent;
        }
        field(6; Description; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(7; Claimable; Boolean)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                BidPrices: record "Bid Item Price";
            begin
                bidprices.setrange("Bid No.", "No.");
                if bidprices.FindSet() then
                    repeat
                        bidprices.Claimable := Claimable;
                        BidPrices.Modify(true);
                    until bidprices.next = 0;
            end;
        }
        field(8; "Project Sale"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(9; Deactivate; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
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
        if "Entry No." = 0 then begin
            GetNextEntryNo(Rec);
        end;
    end;

    trigger OnModify();
    var
        Bid: record bid;
    begin
        /*  bid.setrange("Vendor Bid No.");
         if bid.FindSet() then
             repeat
                 Bid := rec;
                 bid.Modify(false);
             until bid.Next() = 0; */
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

    procedure GetNextEntryNo(var rec: record "Bid")
    var
        Bid2: record bid;
    begin
        if Bid2.FindLast() then
            rec."Entry No." := Bid2."Entry No." + 1
        else
            rec."Entry No." := 1;
        //rec.Modify(true);
    end;

}