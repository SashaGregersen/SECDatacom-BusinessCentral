xmlport 50001 "Price File Export CSV"
{
    Direction = export;
    TextEncoding = UTF8;
    Format = VariableText;
    FieldDelimiter = '';
    FieldSeparator = ';';
    TableSeparator = '<NewLine>';

    schema
    {
        textelement(Root)
        {

            tableelement(ItemTableTitle; integer)
            {
                SourceTableView = SORTING (Number) WHERE (Number = CONST (1));
                textelement(SEC_PN)
                {
                    trigger OnBeforePassVariable()
                    begin
                        SEC_PN := 'SEC PN';
                    end;
                }
                textelement(Description)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Description := 'Description';
                    end;
                }
                textelement(Extended_Description)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Extended_Description := 'Extended Description';
                    end;
                }
                textelement(Manufacturer_SKU)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Manufacturer_SKU := 'Manufacturer SKU';
                    end;
                }
                textelement(CurrencyLbl)
                {
                    trigger OnBeforePassVariable()
                    begin
                        CurrencyLbl := 'Currency';
                    end;
                }
                Textelement(CostLbl)
                {
                    trigger OnBeforePassVariable()
                    begin
                        CostLbl := 'Cost';
                    end;
                }
                textelement(List_PriceLbl)
                {

                    trigger OnBeforePassVariable()
                    begin
                        List_PriceLbl := 'List Price';
                    end;
                }
                textelement(Manufacturer)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Manufacturer := 'Manufacturer';
                    end;
                }
                textelement(MaincategoryLbl)
                {
                    trigger OnBeforePassVariable()
                    begin
                        MaincategoryLbl := 'Maincategory';
                    end;
                }

                textelement(SubcategoryLbl)
                {
                    trigger OnBeforePassVariable()
                    begin
                        SubcategoryLbl := 'Subcategory';
                    end;
                }
                textelement(EANLbl)
                {
                    trigger OnBeforePassVariable()
                    begin
                        EANLbl := 'EAN';
                    end;
                }
                Textelement(StockLBl)
                {
                    trigger OnBeforePassVariable()
                    begin
                        StockLBl := 'Stock';
                    end;
                }
            }
            tableelement(Item; Item)
            {
                XmlName = 'Item';
                SourceTableView = SORTING ("No.");

                fieldelement(SEC_PN; Item."No.")
                {

                }
                fieldelement(Description; item.Description)
                {

                }
                fieldelement(Extended_Description; item."Description 2")
                {

                }
                fieldelement(Manufacturer_SKU; item."Vendor-Item-No.")
                {

                }
                textelement(Currency)
                {
                    trigger OnBeforePassVariable()
                    begin
                        if CurrencyFilter = '' then
                            Currency := GLSetup."LCY Code"
                        else
                            Currency := CurrencyFilter;
                    end;
                }
                Textelement(Cost)
                {
                    trigger OnBeforePassVariable()
                    begin
                        CostDec := Round(CostDec, 0.01);
                        cost := format(CostDec, 0, 1);
                    end;
                }
                textelement(List_Price)
                {

                    trigger OnBeforePassVariable()
                    begin
                        ListPriceDec := round(ListPriceDec, 0.01);
                        List_Price := Format(ListPriceDec, 0, 1);
                    end;

                }
                fieldelement(Manufacturer; item."Global Dimension 1 Code")
                {
                }
                textelement(Maincategory)
                {

                }
                textelement(Subcategory)
                {

                }

                fieldelement(EAN; item.GTIN)
                {

                }
                Textelement(Stock)
                {

                }

                trigger OnAfterGetRecord()
                var
                    SyncMasterData: Codeunit "Synchronize Master Data";
                    Item2: record Item;
                    Invt: Decimal;
                    ItemCategory: record "Item Category";
                    DefaultDim: record "Default Dimension";
                    Dimension: Record Dimension;
                    DimensionValue: Record "Dimension Value";
                    DefaultDim2: record "Default Dimension";
                    DimensionValue2: Record "Dimension Value";
                    ItemExportMgt: Codeunit "Item Export Management";
                    CurrencyExchRate: Record "Currency Exchange Rate";
                    CurrencyFactor: Decimal;
                begin
                    clear(Cost);
                    Clear(List_Price);
                    Clear(CostDec);
                    Clear(ListPriceDec);
                    Clear(Maincategory);
                    Clear(Subcategory);
                    Clear(Stock);

                    if not item."Use on Website" then
                        currXMLport.Skip();

                    if DefaultDim2.get(27, item."No.", GLSetup."Global Dimension 1 Code") then
                        if DimensionValue2.Get(DefaultDim2."Dimension Code", DefaultDim2."Dimension Value Code") then
                            if DimensionValue2."Exclude from Price file" then
                                currXMLport.skip;

                    CostDec := 0;

                    if ItemExportMgt.FindPurchasePrice(PurchasePrice, Item) then
                        if PurchasePrice."Currency Code" = CurrencyFilter then
                            CostDec := PurchasePrice."Direct Unit Cost"
                        else begin
                            CurrencyFactor := CurrencyExchRate.GetCurrentCurrencyFactor(PurchasePrice."Currency Code");
                            if CurrencyFilter = '' then
                                CostDec := CurrencyExchRate.ExchangeAmtFCYToLCY(WorkDate(), PurchasePrice."Currency Code", PurchasePrice."Direct Unit Cost", CurrencyFactor)
                            else
                                CostDec := CurrencyExchRate.ExchangeAmtFCYToFCY(WorkDate(), PurchasePrice."Currency Code", CurrencyFilter, PurchasePrice."Direct Unit Cost");
                        end;

                    ListPriceDec := ItemExportMgt.FindItemPriceForCustomer(Item."No.", CustomerNo, CurrencyFilter);
                    if ListPriceDec = 0 then
                        currXMLport.Skip();

                    if ItemCategory.Get(Item."Item Category Code") then begin
                        if ItemCategory."Overwrite Quantity" then
                            Stock := format(999)
                        else begin
                            Item2.ChangeCompany(GLSetup."Master Company");
                            if (Item2.Get(Item."No.")) then begin
                                Invt := SyncMasterData.UpdateInventoryOnItemFromLocation(Item2, GLSetup);
                                if (Invt <= 0) and Item2."Blocked from purchase" then
                                    currXMLport.skip;
                            end;
                            Stock := format(Invt);
                        end;
                    end else begin
                        Item2.ChangeCompany(GLSetup."Master Company");
                        if (Item2.Get(Item."No.")) then begin
                            Invt := SyncMasterData.UpdateInventoryOnItemFromLocation(Item2, GLSetup);
                            if (Invt <= 0) and Item2."Blocked from purchase" then
                                currXMLport.skip;
                        end;
                        Stock := format(Invt);
                    end;
                    DefaultDim.setrange("No.", item."No.");
                    DefaultDim.setrange("Table ID", 27);
                    DefaultDim.SetFilter("Dimension Code", '<>%1', GLSetup."Global Dimension 1 Code");
                    if DefaultDim.FindFirst() then begin
                        if Dimension.Get(DefaultDim."Dimension Code") then
                            MainCategory := Dimension.Name;
                        if DimensionValue.Get(DefaultDim."Dimension Code", DefaultDim."Dimension Value Code") then
                            SubCategory := DimensionValue.Name;
                    end;
                end;



            }
            tableelement(Integer; Integer)
            {
                SourceTableView = SORTING (Number) WHERE (Number = CONST (0));

            }

        }

    }

    trigger OnPreXmlPort()
    begin
        GLSetup.get;
        GLSetup.TestField("Master Company");

        if CustomerNo = '' then
            currXMLport.Skip();
    end;


    var
        CustomerNo: code[20];
        CurrencyFilter: text;
        UnitPrice: decimal;
        salesprice: record "Sales Price";
        PurchasePrice: record "Purchase Price";
        GLSetup: record "General Ledger Setup";
        CostDec: decimal;
        ListPriceDec: Decimal;

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
        Error('Deprecated');

        /* SalesPrice.SetRange("Item No.", Item."No.");
        SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::Customer);
        SalesPrice.SetRange("Sales Code", CustomerNo);
        SalesPrice.SetRange("Currency Code", CurrencyFilter);
        SalesPrice.setrange("Ending Date", 0D);
        if salesprice.FindLast() then
            exit(salesprice."Unit Price");
        SalesPrice.SetRange("Sales Code", FindDiscountGroup());
        SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::"Customer Price Group");
        if SalesPrice.FindLast() then
            exit(SalesPrice."Unit Price");
        SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::"All Customers");
        if SalesPrice.FindLast() then
            exit(SalesPrice."Unit Price"); */
    end;

    procedure FindDiscountGroup(): code[20]
    var
        PriceGroupLink: record "Price Group Link";
        Customer: record customer;
        SalesLineDiscountTemp: Record "Sales Line Discount" temporary;
        AdvancedPriceManage: Codeunit "Advanced Price Management";
    begin
        Error('Deprecated');
        /*         If AdvancedPriceManage.FindPriceGroupsFromItem(Item, SalesLineDiscountTemp) then begin
                    Customer.get(CustomerNo);
                    SalesLineDiscountTemp.SetRange("Sales Code", Customer."Customer Price Group");
                    if SalesLineDiscountTemp.FindFirst() then
                        exit(SalesLineDiscountTemp."Sales Code")
                    else
                        exit('');
                end else
                    exit(''); */
    end;

    procedure FindPurchasePrice(var PurchPrice: record "Purchase Price"; item: record Item): Decimal
    begin
        Error('Deprecated'); //Moved to CU50001

        /*         PurchPrice.setrange("Vendor No.", Item."Vendor No.");
                PurchPrice.setrange("Item No.", Item."No.");
                PurchPrice.setrange("Unit of Measure Code", item."Base Unit of Measure");
                PurchPrice.setrange("Currency Code", item."Vendor Currency");
                PurchPrice.SetRange("Ending Date", 0D);
                PurchPrice.SetFilter("Starting Date", '%1|<%2', WorkDate(), WorkDate());
                if PurchPrice.FindFirst() then
                    exit(PurchPrice."Direct Unit Cost")
                else
                    exit(0) */
    end;
}