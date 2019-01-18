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
            TableRelation = Customer."No.";
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
        field(50001; "Bid Unit Sales Price"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger Onvalidate()
            begin
                if "Unit List Price" <> 0 then
                    "Bid Sales Discount Pct." := ("Bid Unit Sales Price" - "Unit List Price") / "Unit List Price" * 100
                else
                    "Bid Sales Discount Pct." := 0;
            end;
        }
        field(50002; "Bid Sales Discount Pct."; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger Onvalidate()
            begin
                if "Unit List Price" = 0 then begin
                    "Bid Sales Discount Pct." := 0;
                    exit;
                end;

                if "Bid Sales Discount Pct." <> 0 then
                    "Bid Unit Sales Price" := "Unit List Price" * ((100 + "Bid Sales Discount Pct.") / 100)
                else
                    "Bid Unit Sales Price" := "Unit List Price";
            end;
        }
        field(50011; "Bid Unit Purchase Price"; Decimal)
        {
            DataClassification = ToBeClassified;

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
        }
    }

    keys
    {
        key(PK; "Bid No.", "item No.", "Customer No.")
        {
            Clustered = true;
        }
    }

    var



    trigger OnInsert();
    var
        Bid: Record Bid;

    begin
        TestField("Bid No.");
        If Bid.Get("Bid No.") then
            Claimable := Bid.Claimable;
    end;

    trigger OnModify();
    begin
    end;

    trigger OnDelete();
    begin
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

}