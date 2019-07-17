table 50001 "Bid Item Price"
{
    DataClassification = ToBeClassified;
    // The fields with 50000's numbers have those because then we can use transferfields to get them on the Sales Line
    fields
    {
        field(1; "Bid No."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Bid."No.";
            NotBlank = true;

            trigger OnLookUp()
            var
                ItemFilter: Text;
                Item: Record Item;
                Bid: Record Bid;
            begin
                ItemFilter := GetFilter("item No.");
                if ItemFilter <> '' then begin
                    Item.Get(ItemFilter);
                    if Item."IC partner Vendor No." <> '' then
                        bid.SetRange("Vendor No.", item."IC partner Vendor No.")
                    else
                        Bid.SetRange("Vendor No.", Item."Vendor No.");
                end;
                if Page.RunModal(50000, Bid) = Action::LookupOK then
                    Validate("Bid No.", Bid."No.");
            end;
        }
        field(2; "item No."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item."No.";
            NotBlank = true;

            trigger OnValidate()
            var
                Item: Record Item;
            begin
                If Item.Get("item No.") then
                    "Currency Code" := Item."Vendor Currency";
                UpdateListprice();
            end;
        }
        field(3; "Customer No."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No." WHERE ("Customer Type" = CONST (Reseller));
        }
        field(4; "Expiry Date"; date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10; "Unit List Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            trigger OnValidate()
            begin
                if "Unit List Price" <> xRec."Unit List Price" then begin
                    Validate("Bid Unit Sales Price");
                    Validate("Bid Unit Purchase Price");
                end;
            end;
        }
        field(11; "Currency Code"; code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Currency Code" <> xRec."Currency Code" then
                    UpdateListprice();
            end;
        }
        field(12; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Bid Unit Sales Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 6;

            trigger Onvalidate()
            begin
                if ("Unit List Price" <> 0) and ("Bid Unit Sales Price" <> 0) then
                    "Bid sales Discount Pct." := (1 - ("Bid Unit Sales Price" / "Unit List Price")) * 100
                else
                    "Bid sales Discount Pct." := 0;
            end;
        }
        field(50002; "Bid Sales Discount Pct."; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 6;

            trigger Onvalidate()
            begin
                if "Unit List Price" <> 0 then
                    "Bid Unit sales Price" := (1 - ("Bid sales Discount Pct." / 100)) * "Unit List Price"
                else
                    "Bid sales Discount Pct." := 0;
            end;
        }
        field(50011; "Bid Unit Purchase Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 6;

            trigger Onvalidate()
            begin
                if ("Unit List Price" <> 0) and ("Bid Unit Purchase Price" <> 0) then
                    "Bid Purchase Discount Pct." := (1 - ("Bid Unit purchase Price" / "Unit List Price")) * 100
                else
                    "Bid Purchase Discount Pct." := 0;
            end;
        }
        field(50012; "Bid Purchase Discount Pct."; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 6;

            trigger Onvalidate()
            begin
                if "Unit List Price" <> 0 then
                    "Bid Unit purchase Price" := (1 - ("Bid Purchase Discount Pct." / 100)) * "Unit List Price"
                else
                    "Bid Purchase Discount Pct." := 0;
            end;
        }
        field(50021; "Claimable"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;

        }
        field(50022; "Vendor Bid No."; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50023; "Description"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50024; "One Time Bid"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }

    }

    keys
    {
        key(PK; "Bid No.", "item No.", "Customer No.", "Currency Code")
        {
            Clustered = true;
        }
        key(EntryNo; "Entry No.")
        {

        }
    }

    var



    trigger OnInsert();
    var
        Bid: Record Bid;
        Bid2: record bid;
        Bidprices: record "Bid Item Price";
    begin
        TestField("Bid No.");
        If Bid.Get("Bid No.") then begin
            "Expiry Date" := Bid."Expiry Date";
            Claimable := Bid.Claimable;
            "Entry No." := bid."Entry No.";
            "Vendor Bid No." := bid."Vendor Bid No.";
            Description := bid."Vendor Bid No.";
            "One Time Bid" := bid."One Time Bid";
        end;
    end;

    trigger OnModify();
    var
        BidPrices: record "Bid Item Price";
        Bid: record bid;
        Bid2: record bid;
    begin
        If Bid.Get("Bid No.") then begin
            Bid2.setrange("Vendor Bid No.", bid."Vendor Bid No.");
            if bid2.FindSet() then
                repeat
                    BidPrices.setrange("Entry No.", Bid2."Entry No.");
                    BidPrices.SetFilter("Customer No.", '<>%1', '');
                    BidPrices.SetRange("item No.", rec."item No.");
                    BidPrices.setrange("Currency Code", rec."Currency Code");
                    BidPrices.setfilter("Bid No.", '<>%1', rec."Bid No.");
                    if BidPrices.FindSet() then
                        repeat
                            BidPrices.validate("Bid Unit Purchase Price", rec."Bid Unit Purchase Price");
                            BidPrices.validate("Bid Purchase Discount Pct.", rec."Bid Purchase Discount Pct.");
                            BidPrices.validate("Bid Unit Sales Price", rec."Bid Unit sales Price");
                            BidPrices.validate("Bid Sales Discount Pct.", rec."Bid Sales Discount Pct.");
                            BidPrices.Modify(false);
                        until BidPrices.next = 0;
                until bid2.next = 0;
        end;
    end;

    trigger OnDelete();
    var
        BidPrices: record "Bid Item Price";
        Bid: record bid;
        Bid2: record bid;
    begin
        If Bid.Get("Bid No.") then begin
            Bid2.setrange("Vendor Bid No.", bid."Vendor Bid No.");
            if bid2.FindSet() then
                repeat
                    BidPrices.setrange("Entry No.", Bid2."Entry No.");
                    BidPrices.SetFilter("Customer No.", '<>%1', '');
                    BidPrices.SetRange("item No.", rec."item No.");
                    BidPrices.setrange("Currency Code", rec."Currency Code");
                    BidPrices.setfilter("Bid No.", '<>%1', rec."Bid No.");
                    if BidPrices.FindSet() then
                        repeat
                            BidPrices.delete(false);
                        until BidPrices.next = 0;
                until bid2.next = 0;
        end;
    end;

    trigger OnRename();
    begin
    end;

    local procedure UpdateListprice()
    var
        ListPrice: Record "Sales Price";
        Advpricemgt: Codeunit "Advanced Price Management";
    begin
        if Advpricemgt.FindListPriceForitem("item No.", "Currency Code", ListPrice) then
            validate("Unit List Price", ListPrice."Unit Price")
        else
            validate("Unit List Price", 0);
    end;

    procedure AlreadyUsed(CalledFromSalesHeaderNo: Code[20]): Boolean
    var
        Bid: Record Bid;
        SalesLine: Record "Sales Line";
        PostedSalesLine: Record "Sales Invoice Line";
    begin
        Bid.Get(Rec."Bid No.");
        if not Bid."One Time Bid" then
            exit(false);
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetRange("No.", rec."item No.");
        SalesLine.SetRange("Bid No.", Rec."Bid No.");
        SalesLine.SetFilter("Document No.", '<>%1', CalledFromSalesHeaderNo);
        if SalesLine.FindFirst() then
            exit(true);
        PostedSalesLine.SetRange(Type, SalesLine.Type::Item);
        PostedSalesLine.SetRange("No.", rec."item No.");
        PostedSalesLine.SetRange("Bid No.", Rec."Bid No.");
        if PostedSalesLine.FindFirst() then
            exit(true);
        exit(false);
    end;

    procedure HasExpired(OnDate: Date): Boolean
    begin
        if "Expiry Date" = 0D then
            exit(false);
        exit("Expiry Date" < OnDate)
    end;

    procedure GetPricesForItem(SalesHeaderNo: code[20]; ItemNo: code[20]; CurrCode: Code[20]; CustNo: code[20]; OnDate: Date; var BidPrices: Record "Bid Item Price")
    var
        Item: record item;
    begin
        Clear(BidPrices);
        item.get(ItemNo);
        BidPrices.SetRange("item No.", ItemNo);
        BidPrices.SetRange("Currency Code", currcode);
        BidPrices.setrange("Customer No.", CustNo);
        if BidPrices.FindFirst() then
            repeat
                if (not BidPrices.AlreadyUsed(SalesHeaderNo)) and (not BidPrices.HasExpired(OnDate)) then
                    BidPrices.Mark(true);
            until BidPrices.Next() = 0;
        //>>NC.00.01 SDG 15-06-2019
        BidPrices.SetRange("Currency Code", item."Vendor Currency");
        if BidPrices.FindFirst() then
            repeat
                if (not BidPrices.AlreadyUsed(SalesHeaderNo)) and (not BidPrices.HasExpired(OnDate)) then
                    BidPrices.Mark(true);
            until BidPrices.Next() = 0;
        //<<NC.00.01 SDG 15-06-2019 
        BidPrices.setrange("Customer No.", '');
        if BidPrices.FindFirst() then
            repeat
                if (not BidPrices.AlreadyUsed(SalesHeaderNo)) and (not BidPrices.HasExpired(OnDate)) then
                    BidPrices.Mark(true);
            until BidPrices.Next() = 0;
        if BidPrices.IsEmpty() then begin
            BidPrices.SetRange("Currency Code");
            if BidPrices.FindFirst() then
                repeat
                    if (not BidPrices.AlreadyUsed(SalesHeaderNo)) and (not BidPrices.HasExpired(OnDate)) then
                        BidPrices.Mark(true);
                until BidPrices.Next() = 0;
        end;
        BidPrices.setrange("Customer No.");
        BidPrices.SetRange("Currency Code");
        BidPrices.MarkedOnly(true);
    end;


}