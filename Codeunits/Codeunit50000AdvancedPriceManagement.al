codeunit 50000 "Advanced Price Management"
{
    EventSubscriberInstance = StaticAutomatic;

    trigger OnRun();
    var

    begin

    end;

    procedure UpdatePricesfromWorksheet()
    var
        SalesPriceWorksheet: Record "Sales Price Worksheet";
        Item: Record Item;
        ItemDiscGroupTemp: Record "Item Discount Group" temporary;
    begin
        If SalesPriceWorksheet.FindSet() then
            repeat
                CreateListprices(SalesPriceWorksheet);
                if Item.Get(SalesPriceWorksheet."Item No.") then begin
                    if Item."Item Disc. Group" <> '' then begin
                        ItemDiscGroupTemp.Code := item."Item Disc. Group";
                        if not ItemDiscGroupTemp.Insert() then;
                    end;
                end;
            until SalesPriceWorksheet.Next() = 0;
        if ItemDiscGroupTemp.FindSet() then
            repeat
                CalcSalesPricesForItemDiscGroup(ItemDiscGroupTemp.Code);
            until ItemDiscGroupTemp.Next() = 0;
    end;

    procedure CreateListprices(SalesPriceWorksheet: Record "Sales Price Worksheet");
    var
        SalesPrice: Record "Sales Price";
        ImplementPrices: Report "Implement Price Change";
        Suggestprices: report "Suggest Sales Price on Wksh.";
        CurrencyTemp: Record Currency temporary;
        PurchaseLineDiscount: Record "Purchase Line Discount";

    begin
        SalesPriceWorksheet.SetRecFilter;
        ImplementPrices.SetTableView(SalesPriceWorksheet);
        ImplementPrices.InitializeRequest(true);
        ImplementPrices.UseRequestPage(false);
        ImplementPrices.Run();
        if not FindListPriceForitem(SalesPriceWorksheet."Item No.", SalesPriceWorksheet."Currency Code", SalesPrice) then
            exit;
        SalesPrice.SetRecFilter;
        if SalesPriceWorksheet."Currency Code" <> '' then begin
            Suggestprices.InitializeRequest2(SalesPrice."Sales Type"::"All Customers", '', SalesPriceWorksheet."Starting Date", SalesPriceWorksheet."Ending Date",
                                            '', '', true, 0, 1, '');
            Suggestprices.SetTableView(SalesPrice);
            Suggestprices.UseRequestPage(false);
            Suggestprices.Run;
            Clear(ImplementPrices);
            SalesPriceWorksheet.SetRange("Currency Code", '');
            ImplementPrices.SetTableView(SalesPriceWorksheet);
            ImplementPrices.InitializeRequest(true);
            ImplementPrices.UseRequestPage(false);
            ImplementPrices.Run();
        end;
        if not FindListPriceForitem(SalesPriceWorksheet."Item No.", '', SalesPrice) then
            exit;
        FindPriceCurrencies(SalesPriceWorksheet."Currency Code", false, CurrencyTemp);
        if CurrencyTemp.FindFirst then begin
            repeat
                Clear(Suggestprices);
                Suggestprices.InitializeRequest2(SalesPrice."Sales Type"::"All Customers", '', SalesPriceWorksheet."Starting Date", SalesPriceWorksheet."Ending Date",
                                                CurrencyTemp.Code, '', true, 0, 1, '');
                Suggestprices.SetTableView(SalesPrice);
                Suggestprices.UseRequestPage(false);
                Suggestprices.Run;
            until CurrencyTemp.next = 0;
        end;
        SalesPriceWorksheet.SetRange("Currency Code");
        Clear(ImplementPrices);
        ImplementPrices.SetTableView(SalesPriceWorksheet);
        ImplementPrices.InitializeRequest(true);
        ImplementPrices.UseRequestPage(false);
        ImplementPrices.Run();

        PurchaseLineDiscount.SetRange("Item No.", SalesPriceWorksheet."Item No.");
        PurchaseLineDiscount.SetRange("Currency Code", SalesPriceWorksheet."Currency Code");
        if PurchaseLineDiscount.FindLast() then begin
            FindListPriceForitem(SalesPriceWorksheet."Item No.", SalesPriceWorksheet."Currency Code", SalesPrice);
            CreateUpdatePurchasePrices(PurchaseLineDiscount, SalesPrice);
        end;
    end;

    procedure UpdatePurchaseDicountsForItemDiscGroup(itemDiscGroup: Code[20]; DiscPct: Decimal; CustomerMarkup: Decimal; StartingDate: Date; VendorNo: Code[20]);
    var
        ItemTemp: Record Item temporary;
        PurchaseDiscount: Record "Purchase Line Discount";
        Vendor: Record Vendor;
    begin
        If not Vendor.Get(VendorNo) then
            exit;
        if FindItemsInItemDiscGroup(ItemTemp, itemDiscGroup) then begin
            if ItemTemp.FindFirst then begin
                repeat
                    PurchaseDiscount.Init;
                    PurchaseDiscount."Item No." := ItemTemp."No.";
                    PurchaseDiscount."Vendor No." := VendorNo;
                    PurchaseDiscount."Minimum Quantity" := 1;           //Note: should be changed to a var!
                    PurchaseDiscount."Unit of Measure Code" := 'STK';   //Note: should be changed to a var!
                    PurchaseDiscount."Starting Date" := StartingDate;
                    PurchaseDiscount."Currency Code" := Vendor."Currency Code";
                    //PurchaseDiscount."Variant Code" := ?              Does not support variants at the moment - SEC does not use variants
                    PurchaseDiscount."Line Discount %" := DiscPct;
                    PurchaseDiscount."Customer Markup" := CustomerMarkup;
                    if not PurchaseDiscount.Insert(true) then
                        PurchaseDiscount.Modify(true);
                until ItemTemp.next = 0;
            end;
        end;
    end;

    procedure CreateUpdatePurchasePrices(PurchaseLineDiscount: Record "Purchase Line Discount"; ListPrice: Record "Sales Price");
    var
        PurchasePrice: Record "Purchase Price";
    begin
        if not FindLatestPurchasePrice(PurchaseLineDiscount."Item No.", PurchaseLineDiscount."Vendor No.", PurchaseLineDiscount."Currency Code", PurchasePrice) then begin
            PurchasePrice.Init;
            PurchasePrice.TransferFields(PurchaseLineDiscount);
            PurchasePrice.validate("Starting Date", ListPrice."Starting Date");
            PurchasePrice.Validate("Minimum Quantity", PurchaseLineDiscount."Minimum Quantity");
            PurchasePrice.Validate("Direct Unit Cost", ListPrice."Unit Price" * ((100 - PurchaseLineDiscount."Line Discount %") / 100));
            PurchasePrice.Insert(true);
        end else begin
            PurchasePrice.Validate("Direct Unit Cost", ListPrice."Unit Price" * ((100 - PurchaseLineDiscount."Line Discount %") / 100));
            PurchasePrice.Modify(true);
        end;
    end;

    local procedure FindLatestPurchasePrice(ItemNo: code[20]; VendorNo: code[20]; CurrCode: code[20]; var PurchasePrice: Record "Purchase Price"): Boolean
    begin
        PurchasePrice.SetRange("Item No.", ItemNo);
        PurchasePrice.SetRange("Vendor No.", VendorNo);
        PurchasePrice.SetRange("Currency Code", CurrCode);
        exit(PurchasePrice.FindLast());
    end;

    procedure CreateUpdateSalesMarkupPrices(PurchaseLineDiscount: Record "Purchase Line Discount")
    var
        PurchasePrice: Record "Purchase Price";
        Salesprice: Record "Sales Price";
        SalesPriceWorksheet: Record "Sales Price Worksheet";
        ImplementPrices: Report "Implement Price Change";
        Suggestprices: report "Suggest Sales Price on Wksh.";
        CurrencyTemp: Record Currency temporary;
    begin
        if FindLatestPurchasePrice(PurchaseLineDiscount."Item No.", PurchaseLineDiscount."Vendor No.", PurchaseLineDiscount."Currency Code", PurchasePrice) then begin
            Salesprice.Init();
            Salesprice."Sales Type" := Salesprice."Sales Type"::"All Customers";
            Salesprice."Currency Code" := PurchasePrice."Currency Code";
            Salesprice."Starting Date" := PurchasePrice."Starting Date";
            Salesprice."Ending Date" := PurchasePrice."Ending Date";
            Salesprice."Item No." := PurchasePrice."Item No.";
            Salesprice."Unit of Measure Code" := PurchasePrice."Unit of Measure Code";
            Salesprice."Minimum Quantity" := PurchasePrice."Minimum Quantity";
            Salesprice."Unit Price" := PurchasePrice."Direct Unit Cost" / ((100 - PurchaseLineDiscount."Customer Markup") / 100);
            if not Salesprice.Insert(false) then
                Salesprice.Modify(false);
        end;
    end;

    procedure CalcSalesPricesForItemDiscGroup(itemDiscGroup: Code[20]);
    var
        DiscontGroupFilters: Record "Sales Line Discount";
        SalesPriceWorksheet: Record "Sales Price Worksheet";
        ImplementPrices: Report "Implement Price Change";
        ItemTemp: Record Item temporary;
        SalesDiscGroup: Record "Sales Line Discount";
    begin
        DiscontGroupFilters.SetRange(Type, DiscontGroupFilters.Type::"Item Disc. Group");
        DiscontGroupFilters.SetRange(Code, itemDiscGroup);
        CalcGroupPricesFromGroupDiscounts(DiscontGroupFilters);
        if FindItemsInItemDiscGroup(ItemTemp, itemDiscGroup) then begin
            if ItemTemp.FindFirst then begin
                repeat
                    SalesPriceWorksheet.SetRange("Item No.", ItemTemp."No.");
                    Clear(ImplementPrices);
                    ImplementPrices.SetTableView(SalesPriceWorksheet);
                    ImplementPrices.InitializeRequest(true);
                    ImplementPrices.UseRequestPage(false);
                    ImplementPrices.Run();
                until ItemTemp.next = 0;
            end;
        end;
    end;

    procedure CalcGroupPricesFromGroupDiscounts(var DiscontGroupFilters: Record "Sales Line Discount");
    var
        SalesDiscountGroup: Record "Sales Line Discount";
        ItemTemp: Record Item temporary;
        CurrencyTemp: Record Currency temporary;

    begin
        FindPriceCurrencies('', true, CurrencyTemp);
        SalesDiscountGroup.CopyFilters(DiscontGroupFilters);
        if SalesDiscountGroup.FindSet then
            repeat
                if FindItemsInItemDiscGroup(ItemTemp, SalesDiscountGroup.Code) then begin
                    if ItemTemp.FindFirst then
                        repeat
                            CreatePricesForItem(ItemTemp."No.", SalesDiscountGroup, CurrencyTemp);
                        until ItemTemp.next = 0;
                end;
            until SalesDiscountGroup.next = 0;
    end;

    local procedure CreatePricesForItem(ItemNo: Code[20]; SalesDiscountGroup: Record "Sales Line Discount"; var CurrencyTemp: Record Currency temporary)
    var
        ItemListPrice: Record "Sales Price";
    begin
        if CurrencyTemp.FindFirst then
            repeat
                if FindListPriceForitem(ItemNo, CurrencyTemp.Code, ItemListPrice) then
                    InsertSalesPriceWorkSheetLine(SalesDiscountGroup, ItemListPrice);
            until CurrencyTemp.next = 0;
    end;

    local procedure InsertSalesPriceWorkSheetLine(SalesDiscountGroup: Record "Sales Line Discount"; ItemListPrice: Record "Sales Price")
    var
        SalesPriceWorksheet: Record "Sales Price Worksheet";

    begin
        SalesDiscountGroup."Starting Date" := ItemListPrice."Starting Date";
        SalesPriceWorksheet.validate("Item No.", ItemListPrice."Item No.");
        SalesPriceWorksheet.Validate("Currency Code", ItemListPrice."Currency Code");
        CreateWorksheetLineFromDiscountGroup(SalesDiscountGroup, SalesPriceWorksheet);
        if SalesPriceWorksheet."Unit of Measure Code" = '' then
            SalesPriceWorksheet."Unit of Measure Code" := ItemListPrice."Unit of Measure Code";
        SalesPriceWorksheet."New Unit Price" := ItemListPrice."Unit Price" * ((100 - SalesDiscountGroup."Line Discount %") / 100);
        if not SalesPriceWorksheet.Insert(true) then
            SalesPriceWorksheet.Modify(true);
    end;

    procedure FindListPriceForitem(ItemNo: code[20]; CurrencyCode: Code[20]; var ListPrice: record "sales price"): Boolean;
    var
        Test: Integer;
    begin
        ListPrice.SetRange("Item No.", ItemNo);
        ListPrice.SetRange("Sales Type", ListPrice."Sales Type"::"All Customers");
        ListPrice.SetRange("Currency Code", CurrencyCode);
        ListPrice.SetRange("Variant Code", 'LISTPRICE');
        exit(listprice.FindLast);
        //bør denne have et filter på, at den ikke må finde en der er efter WORKDATE?
    end;

    local procedure FindItemsInItemDiscGroup(var ItemTemp: Record Item temporary; ItemDiscGroupCode: Code[20]): Boolean;
    var
        Item: Record Item;
    begin
        Item.SetRange("Item Disc. Group", ItemDiscGroupCode);
        if Item.FindSet then begin
            repeat
                ItemTemp := Item;
                if not ItemTemp.Insert then;
            until Item.next = 0;
            exit(true);
        end else begin
            clear(ItemTemp);
            exit(false);
        end;
    end;

    local procedure CreateWorksheetLineFromDiscountGroup(DiscountGroup: Record "Sales Line Discount"; var WorkSheet: Record "Sales Price Worksheet");
    begin
        WorkSheet.Validate("Sales Type", DiscountGroup."Sales Type");
        WorkSheet.Validate("Sales Code", DiscountGroup."Sales Code");
        WorkSheet.Validate("Starting Date", DiscountGroup."Starting Date");
        WorkSheet.Validate("Minimum Quantity", DiscountGroup."Minimum Quantity");
        if DiscountGroup."Ending Date" <> 0D then
            WorkSheet.Validate("Ending Date", DiscountGroup."Ending Date");
        WorkSheet.Validate("Unit of Measure Code", DiscountGroup."Unit of Measure Code");
        WorkSheet.Validate("Variant Code", DiscountGroup."Variant Code");
    end;

    procedure UpdateSalesLineWithPurchPrice(var SalesLine: Record "Sales Line");
    var
        Item: Record Item;
        PurchPrice: Record "Purchase Price";
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        if SalesLine.Type <> SalesLine.Type::Item then
            Exit;
        if not Item.get(SalesLine."No.") then
            exit;
        PurchPrice.SetRange("Item No.", ITEM."No.");
        PurchPrice.SetRange("Vendor No.", Item."Vendor No.");
        if SalesLine."Variant Code" <> '' then
            PurchPrice.SetRange("Variant Code", SalesLine."Variant Code");
        PurchPrice.SetFilter("Ending Date", '..%1', WorkDate);
        PurchPrice.SetRange("Currency Code", SalesLine."Currency Code");
        if PurchPrice.FindLast then begin
            SalesLine.validate("Unit Purchase Price", PurchPrice."Direct Unit Cost");
            exit;
        end;
        PurchPrice.SetRange("Currency Code");
        if PurchPrice.FindLast then begin
            SalesLine.validate("Unit Purchase Price", CurrExchRate.ExchangeAmount(PurchPrice."Direct Unit Cost", PurchPrice."Currency Code", SalesLine."Currency Code", SalesLine."Posting Date"));
            exit;
        end;
        SalesLine.validate("Unit Purchase Price", item."Unit Cost");

        //Need to add UOM (and bids?)
    end;

    procedure FindPriceGroupsFromItem(Item: Record Item; var SalesLineDiscountTemp: Record "Sales Line Discount" temporary) FoundSome: boolean;
    var
        ItemDiscGroup: Record "Item Discount Group";
        SalesLineDiscount: Record "Sales Line Discount";
    begin
        if not ItemDiscGroup.Get(Item."Item Disc. Group") then
            exit(false);
        SalesLineDiscount.SetRange(Type, SalesLineDiscount.Type::"Item Disc. Group");
        SalesLineDiscount.SetRange(Code, item."Item Disc. Group");
        SalesLineDiscount.SetRange("Sales Type", SalesLineDiscount."Sales Type"::"Customer Disc. Group");
        if SalesLineDiscount.FindSet then begin
            repeat
                SalesLineDiscountTemp := SalesLineDiscount;
                if not SalesLineDiscountTemp.Insert then;
            until SalesLineDiscount.next = 0;
            exit(true)
        end else
            exit(false);
    end;

    procedure FindPriceCurrencies(ExceptThisOne: code[20]; AddLocalCurrency: boolean; var CurrencyTemp: Record Currency temporary);
    var
        Currency: Record Currency;
    begin
        Currency.SetRange("Make Prices", true);
        if Currency.FindSet then begin
            repeat
                if Currency.Code <> ExceptThisOne then begin
                    CurrencyTemp := Currency;
                    if not CurrencyTemp.Insert then;
                end;
            until Currency.next = 0;
        end;
        if AddLocalCurrency then begin
            CurrencyTemp.Init();
            CurrencyTemp.Code := '';
            if not CurrencyTemp.Insert then;
        end;
    end;

    procedure ExchangeAmtLCYToFCYAndFCYToLCY(SalesPrice: record "Sales Price"; CurrencyFactorCode: code[10])
    var
        CurrencyExcRate: Record "Currency Exchange Rate";
        Factor: Decimal;
        FromLCYToFCY: Decimal;
    begin
        Factor := CurrencyExcRate.GetCurrentCurrencyFactor(CurrencyFactorCode);
        FromLCYToFCY := CurrencyExcRate.ExchangeAmtLCYToFCY(Today(), CurrencyFactorCode, Salesprice."Unit Price", Factor);
        Salesprice.Validate("Unit Price", CurrencyExcRate.ExchangeAmtFCYToLCY(Today(), CurrencyFactorCode, FromLCYToFCY, Factor));
        Salesprice.Modify(true);
    end;

    procedure ExchangeAmtFCYToFCY(SalesPrice: Record "Sales Price"; SalesPrice2: Record "Sales Price")
    var
        CurrencyExcRate: Record "Currency Exchange Rate";
        Factor: Decimal;
        FromLCYToFCY: Decimal;
    begin
        Salesprice2.Validate("Unit Price", CurrencyExcRate.ExchangeAmtFCYToFCY(Today(), SalesPrice."Currency Code", SalesPrice2."Currency Code", SalesPrice."Unit Price"));
        SalesPrice2.Modify(true);
    end;

    procedure ExchangeAmtLCYToFCY(SalesPrice: record "Sales Price"; CurrencyFactorCode: code[10])
    var
        CurrencyExcRate: Record "Currency Exchange Rate";
        Factor: Decimal;
    begin
        Factor := CurrencyExcRate.GetCurrentCurrencyFactor(CurrencyFactorCode);
        Salesprice.Validate("Unit Price", CurrencyExcRate.ExchangeAmtLCYToFCY(Today(), CurrencyFactorCode, Salesprice."Unit Price", Factor));
        Salesprice.Modify(true);
    end;

    procedure FindCurrencyFactor(Currency: code[10]; CurrTemp: Record Currency temporary): Decimal
    var

    begin
        CurrTemp.SetRange(Code, Currency);
        If CurrTemp.FindFirst() then
            exit(CurrTemp."Currency Factor");
    end;

    procedure CreateListPriceVariant(Item: Record Item)
    var
        ItemVariant: Record "Item Variant";
    begin
        ItemVariant.Init();
        ItemVariant.Code := 'LISTPRICE';
        ItemVariant."Item No." := Item."No.";
        ItemVariant.Description := 'List Price of item';
        if not ItemVariant.Insert(false) then;
    end;

    procedure FindCustomerKickbackPct(itemNo: code[20]; CustomerNo: code[20]; var CustKickbackPct: Record "Customer Kickback Percentage"): Boolean
    var
        Item: Record Item;
    begin
        if Item.get(itemNo) then begin
            CustKickbackPct.SetRange("Customer No.", CustomerNo);
            CustKickbackPct.SetRange("Item Disc. Group Code", Item."Item Disc. Group");
            exit(CustKickbackPct.FindLast());
        end;
    end;
}