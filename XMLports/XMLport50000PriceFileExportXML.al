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
                Textelement(SECCost)
                {
                    trigger OnBeforePassVariable()
                    begin
                        SECCostDec := Round(SECCostDec, 0.01);
                        SECcost := format(SECCostDec, 0, 9);
                    end;
                }
                textelement(CustomerPrice)
                {

                    trigger OnBeforePassVariable()
                    begin
                        CustomerPriceDec := round(CustomerPriceDec, 0.01);
                        CustomerPrice := Format(CustomerPriceDec, 0, 9);
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
                    Dimension: record Dimension;
                    DimensionValue: Record "Dimension Value";
                    DefaultDim2: record "Default Dimension";
                    DimensionValue2: Record "Dimension Value";
                    ItemExportMgt: Codeunit "Item Export Management";
                    CurrencyExchRate: Record "Currency Exchange Rate";
                    CurrencyFactor: Decimal;
                begin
                    clear(SECCost);
                    Clear(CustomerPrice);
                    Clear(SECCostDec);
                    Clear(CustomerPriceDec);
                    Clear(Maincategory);
                    Clear(Subcategory);
                    Clear(Stock);

                    if not item."Use on Website" then
                        currXMLport.Skip();

                    if DefaultDim2.get(27, item."No.", GLSetup."Global Dimension 1 Code") then
                        if DimensionValue2.Get(DefaultDim2."Dimension Code", DefaultDim2."Dimension Value Code") then
                            if DimensionValue2."Exclude from Price file" then
                                currXMLport.skip;

                    CustomerPriceDec := ItemExportMgt.FindItemPriceForCustomer(Item."No.", CustomerNo, CurrencyFilter);
                    if CustomerPriceDec = 0 then
                        currXMLport.Skip();
                    SECCostDec := ItemExportMgt.FindSECPurchasePrice(Item."No.", CurrencyFilter);

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
        GLSetup: record "General Ledger Setup";
        PriceFileExport: XmlPort "Price File Export CSV";
        PurchasePrice: record "Purchase Price";
        CustomerPriceDec: decimal;
        SECCostDec: decimal;

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
        ItemExportMgt: Codeunit "Item Export Management";
    begin
        Error('Deprecated');
        /*         SalesPrice.SetRange("Item No.", Item."No.");
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
}