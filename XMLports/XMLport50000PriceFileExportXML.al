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
                Textelement(Cost)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Cost := Format(PriceFileExport.FindPurchasePrice(PurchasePrice, Item), 0, 9);
                    end;
                }
                textelement(List_Price)
                {

                    trigger OnBeforePassVariable()
                    begin
                        List_Price := Format(FindCheapestPrice(salesprice), 0, 9);
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
                begin
                    if not item."Use on Website" then
                        currXMLport.Skip();

                    SalesPrice.SetRange("Item No.", Item."No.");
                    if not salesprice.FindSet() then
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
                        MainCategory := DefaultDim."Dimension Code";
                        SubCategory := DefaultDim."Dimension Value Code";
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
        SalesPrice.SetRange("Item No.", Item."No.");
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
            exit(SalesPrice."Unit Price");
    end;

    procedure FindDiscountGroup(): code[20]
    var
        PriceGroupLink: record "Price Group Link";
        Customer: record customer;
        SalesLineDiscountTemp: Record "Sales Line Discount" temporary;
        AdvancedPriceManage: Codeunit "Advanced Price Management";
    begin
        If AdvancedPriceManage.FindPriceGroupsFromItem(Item, SalesLineDiscountTemp) then begin
            Customer.get(CustomerNo);
            SalesLineDiscountTemp.SetRange("Sales Code", Customer."Customer Price Group");
            if SalesLineDiscountTemp.FindFirst() then
                exit(SalesLineDiscountTemp."Sales Code")
            else
                exit('');
        end else
            exit('');
    end;
}