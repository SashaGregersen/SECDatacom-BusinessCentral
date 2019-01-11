xmlport 50000 "Price File Export XML"
{
    Direction = export;

    schema
    {

        textelement(Root)
        {
            tableelement(Item; Item)
            {
                XmlName = 'Item';

                fieldelement(No; Item."No.")
                {

                }
                fieldelement(Descip; item.Description)
                {

                }
                fieldelement(Descrip2; item."Description 2")
                {

                }
                fieldelement(VendItemNo; item."Vendor Item No.")
                {

                }
                fieldelement(Vendor; item."Vendor No.")
                {

                }
                fieldelement(Inventory; item.Inventory)
                {

                }
                textelement(SalesPriceUnitPrice)
                {

                    trigger OnBeforePassVariable()
                    var

                    begin
                        SalesPriceUnitPrice := Format(FindCheapestPrice(salesprice));
                    end;

                }
                textelement(CurrencyCode)
                {
                    trigger OnAfterAssignVariable()
                    var

                    begin
                        CurrencyCode := CurrencyFilter;
                    end;
                }
                tableelement(DefaultDimension; "Default Dimension")
                {
                    XmlName = 'DefaultDimension';
                    LinkTable = Item;
                    LinkFields = "No." = field ("No."), "Table ID" = const (27);

                    fieldelement(DefaultDimCode; DefaultDimension."Dimension Value Code")
                    {

                    }
                }
                trigger OnAfterGetRecord()
                var

                begin
                    SalesPrice.SetRange("Item No.", Item."No.");
                    if not salesprice.FindSet() then
                        currXMLport.Skip();
                end;
            }

        }
    }

    trigger OnPreXmlPort()
    var
        salesprice: Record "Sales Price";
    begin
        if CustomerNo = '' then
            currXMLport.Skip();
    end;


    var
        CustomerNo: code[20];
        CurrencyFilter: text;
        UnitPrice: decimal;
        salesprice: record "Sales Price";

    procedure SetCurrencyFilter(NewCurrencyFilter: Text)
    var

    begin
        CurrencyFilter := NewCurrencyFilter;

    end;

    procedure SetCustomerFilter(Customer: Record Customer)
    var

    begin

        CustomerNo := customer."No.";
    end;


    procedure FindCheapestPrice(SalesPrice: record "Sales Price"): Decimal
    var

    begin
        //find hvilken gruppe kunden er medlem af --> hvis finddiscountgroup = '' --> sales type = ALL Customers

        SalesPrice.SetRange("Item No.", Item."No.");
        SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::Customer);
        SalesPrice.SetRange("Sales Code", FindDiscountGroup());
        SalesPrice.SetRange("Currency Code", CurrencyFilter);
        if salesprice.FindLast() then
            exit(salesprice."Unit Price")
        else
            SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::"Customer Price Group");
        if SalesPrice.FindLast() then
            exit(SalesPrice."Unit Price")
        else
            SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::"All Customers");
        if SalesPrice.FindLast() then
            exit(SalesPrice."Unit Price");
    end;

    procedure FindDiscountGroup(): code[20]
    var
        PriceGroupLink: record "Price Group Link";
        SalesLineDiscountTemp: Record "Sales Line Discount" temporary;
    begin
        //sæt en temporary tabel på sales line discount med rigtige filtre         

        PriceGroupLink.SetRange("Customer No.", CustomerNo);
        if PriceGroupLink.FindSet then begin
            SalesLineDiscountTemp.SetRange("Sales Code", PriceGroupLink."Customer Discount Group Code");
            if SalesLineDiscountTemp.FindFirst() then
                exit(SalesLineDiscountTemp."Sales Code");
        end;


    end;
    /* 
    
    if AdvPriceMgt.FindPriceGroupsFromItem(Item, SalesLineDiscountTemp) then begin
            PriceGroupLink.SetRange("Customer No.", SalesLine."Sell-to Customer No.");
            if PriceGroupLink.FindSet then begin
                repeat
                    SalesLineDiscountTemp.SetRange("Sales Code", PriceGroupLink."Customer Discount Group Code");
                    if SalesLineDiscountTemp.FindFirst then begin
                        SalesLine."Customer Disc. Group" := SalesLineDiscountTemp."Sales Code";
                        SalesLine."Customer Price Group" := SalesLine."Customer Disc. Group";
                        FoundGroup := true;
                    end;
                    
                    SalesLineDiscount.SetRange(Type, SalesLineDiscount.Type::"Item Disc. Group");
        SalesLineDiscount.SetRange(Code, item."Item Disc. Group");
        SalesLineDiscount.SetRange("Sales Type", SalesLineDiscount."Sales Type"::"Customer Disc. Group");
        if SalesLineDiscount.FindSet then begin
            repeat
                SalesLineDiscountTemp := SalesLineDiscount;
                if not SalesLineDiscountTemp.Insert then;
            until SalesLineDiscount.next = 0;*/
    // vi vælger altid en kunde når vi kører rapporten - hvis ikke kunden er sat op til en discount gruppe skal den altid sætte sales type til all customers
}