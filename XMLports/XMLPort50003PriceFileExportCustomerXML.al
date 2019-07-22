xmlport 50003 "Price File Export Customer XML"
{
    Direction = export;

    schema
    {
        textelement(Root)
        {
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
                    ItemExportMgt: Codeunit "Item Export Management";
                    CurrencyExchRate: Record "Currency Exchange Rate";
                    CurrencyFactor: Decimal;
                    AdvPriceMgt: codeunit "Advanced Price Management";
                begin
                    clear(Cost);
                    Clear(List_Price);
                    if not item."Use on Website" then
                        currXMLport.Skip();

                    CostDec := 0;

                    CostDec := ItemExportMgt.FindItemPriceForCustomer(Item."No.", CustomerNo, CurrencyFilter);
                    /* if ItemExportMgt.FindPurchasePrice(PurchasePrice, Item) then
                        if PurchasePrice."Currency Code" = CurrencyFilter then
                            CostDec := PurchasePrice."Direct Unit Cost"
                        else begin
                            CurrencyFactor := CurrencyExchRate.GetCurrentCurrencyFactor(PurchasePrice."Currency Code");
                            if CurrencyFilter = '' then
                                CostDec := CurrencyExchRate.ExchangeAmtFCYToLCY(WorkDate(), PurchasePrice."Currency Code", PurchasePrice."Direct Unit Cost", CurrencyFactor)
                            else
                                CostDec := CurrencyExchRate.ExchangeAmtFCYToFCY(WorkDate(), PurchasePrice."Currency Code", CurrencyFilter, PurchasePrice."Direct Unit Cost");
                        end; */
                    salesprice.Reset();
                    AdvPriceMgt.FindListPriceForitem(item."No.", CurrencyFilter, salesprice);
                    ListPriceDec := salesprice."Unit Price";
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
                        Dimension.Get(DefaultDim."Dimension Code");
                        MainCategory := Dimension.Name;
                        DimensionValue.Get(DefaultDim."Dimension Code", DefaultDim."Dimension Value Code");
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

}