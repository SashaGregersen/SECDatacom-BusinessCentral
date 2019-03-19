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
        ICPartner: Record "IC Partner";
        ICSyncMgt: Codeunit "IC Sync Management";
        ItemTemp: Record Item temporary;
    begin
        Clear(ItemTemp);
        If SalesPriceWorksheet.FindSet() then
            repeat
                CreateListprices(SalesPriceWorksheet);                              //Lav listepriser inkl. købspriser baseret på listepriser
                if Item.Get(SalesPriceWorksheet."Item No.") then begin
                    ItemTemp := Item;
                    if not ItemTemp.Insert(false) then;
                end;
                ICSyncMgt.UpdatePricesInOtherCompanies(SalesPriceWorksheet);       //lav salgspriser i andre selskaber 
            until SalesPriceWorksheet.Next() = 0;
        if ItemTemp.FindSet() then
            repeat
                CreatePricesForItemFromItemDiscountGroups(ItemTemp);               //lav priser basesert på sales discounts for hver vare 
                if ItemTemp."Vendor No." <> '' then
                    CreatePricesForICPartners(ItemTemp."No.", ItemTemp."Vendor No.");  //lav transfer priser for partnere og flyt tdem til andre selskaber
            until ItemTemp.Next() = 0;
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
            CreateUpdatePurchasePricesFromListPrice(PurchaseLineDiscount, SalesPrice);
            CreateUpdateSalesMarkupPrices(PurchaseLineDiscount);
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
                    InsertUpdatePurchaseDiscount(ItemTemp."No.", VendorNo, StartingDate, Vendor."Currency Code", DiscPct, CustomerMarkup);
                until ItemTemp.next = 0;
            end;
        end;
    end;

    procedure UpdateItemPurchaseDicountsFromItemDiscGroup(Item: Record Item)
    var
        ItemDiscGroup: Record "Item Discount Group";
        ItemDiscPct: Record "Item Disc. Group Percentages";
        Vendor: Record Vendor;
    begin
        if not ItemDiscGroup.Get(item."Item Disc. Group") then
            exit;
        ItemDiscPct.SetRange("Item Disc. Group Code", ItemDiscGroup.Code);
        ItemDiscPct.SetAscending("Start Date", false);
        if not ItemDiscPct.FindLast() then
            exit;
        if not Vendor.get(ItemDiscPct."Purchase From Vendor No.") then
            exit;
        InsertUpdatePurchaseDiscount(Item."No.", Vendor."No.", ItemDiscPct."Start Date", Vendor."Currency Code", ItemDiscPct."Purchase Discount Percentage", ItemDiscPct."Customer Markup Percentage");
    end;

    local procedure InsertUpdatePurchaseDiscount(ItemNo: Code[20]; VendorNo: Code[20]; StartingDate: Date; CurrCode: Code[20]; DiscPct: Decimal; CustMarkup: Decimal)
    var
        PurchaseDiscount: Record "Purchase Line Discount";
    begin
        PurchaseDiscount.Init;
        PurchaseDiscount."Item No." := ItemNo;
        PurchaseDiscount."Vendor No." := VendorNo;
        PurchaseDiscount."Minimum Quantity" := 0;           //Note: should be changed to a var!
        PurchaseDiscount."Unit of Measure Code" := 'PCS';   //Note: should be changed to a var!
        PurchaseDiscount."Starting Date" := StartingDate;
        PurchaseDiscount."Currency Code" := CurrCode;
        PurchaseDiscount."Line Discount %" := DiscPct;
        PurchaseDiscount."Customer Markup" := CustMarkup;
        if not PurchaseDiscount.Insert(true) then
            PurchaseDiscount.Modify(true);
    end;

    procedure CreateUpdatePurchasePricesFromListPrice(PurchaseLineDiscount: Record "Purchase Line Discount"; ListPrice: Record "Sales Price");
    var
        PurchasePrice: Record "Purchase Price";
    begin
        if not FindLatestPurchasePrice(PurchaseLineDiscount."Item No.", PurchaseLineDiscount."Vendor No.", PurchaseLineDiscount."Currency Code", ListPrice."Starting Date", PurchasePrice) then begin
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

    local procedure FindLatestPurchasePrice(ItemNo: code[20]; VendorNo: code[20]; CurrCode: code[20]; NotBeforeDate: Date; var PurchasePrice: Record "Purchase Price"): Boolean
    begin
        PurchasePrice.SetRange("Item No.", ItemNo);
        PurchasePrice.SetRange("Vendor No.", VendorNo);
        PurchasePrice.SetRange("Currency Code", CurrCode);
        if NotBeforeDate <> 0D then
            PurchasePrice.SetFilter("Starting Date", '%1..', NotBeforeDate);
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
        if PurchaseLineDiscount."Customer Markup" = 0 then begin
            ConvertListPrices(PurchaseLineDiscount."Item No.");
            exit;
        end;

        if FindLatestPurchasePrice(PurchaseLineDiscount."Item No.", PurchaseLineDiscount."Vendor No.", PurchaseLineDiscount."Currency Code", PurchaseLineDiscount."Starting Date", PurchasePrice) then begin
            Salesprice.Init();
            Salesprice."Sales Type" := Salesprice."Sales Type"::"All Customers";
            Salesprice."Currency Code" := PurchasePrice."Currency Code";
            Salesprice."Starting Date" := PurchasePrice."Starting Date";
            Salesprice."Ending Date" := PurchasePrice."Ending Date";
            Salesprice."Item No." := PurchasePrice."Item No.";
            Salesprice."Unit of Measure Code" := PurchasePrice."Unit of Measure Code";
            Salesprice."Minimum Quantity" := PurchasePrice."Minimum Quantity";
            Salesprice."Unit Price" := round(PurchasePrice."Direct Unit Cost" / ((100 - PurchaseLineDiscount."Customer Markup") / 100));
            if not Salesprice.Insert(true) then
                Salesprice.Modify(true);

            clear(Salesprice);
            Salesprice.SetRange("Item No.", PurchasePrice."Item No.");
            Salesprice.SetRange("Sales Type", Salesprice."Sales Type"::"All Customers");
            Salesprice.SetFilter("Variant Code", '<>LISTPRICE');
            FindPriceCurrencies(PurchaseLineDiscount."Currency Code", PurchaseLineDiscount."Currency Code" <> '', CurrencyTemp);
            if CurrencyTemp.FindFirst then begin
                repeat
                    Clear(Suggestprices);
                    Suggestprices.InitializeRequest2(SalesPrice."Sales Type"::"All Customers", '', PurchasePrice."Starting Date", PurchasePrice."Ending Date",
                                                    CurrencyTemp.Code, PurchasePrice."Unit of Measure Code", true, 0, 1, '');
                    Suggestprices.SetTableView(SalesPrice);
                    Suggestprices.UseRequestPage(false);
                    Suggestprices.Run;
                until CurrencyTemp.next = 0;
            end;
            SalesPriceWorksheet.SetRange("Item No.", PurchasePrice."Item No.");
            Clear(ImplementPrices);
            ImplementPrices.SetTableView(SalesPriceWorksheet);
            ImplementPrices.InitializeRequest(true);
            ImplementPrices.UseRequestPage(false);
            ImplementPrices.Run();
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

    procedure CreatePricesForICPartners(ItemNo: Code[20]; VendorNo: Code[20])
    //contains some code reduse from CreateUpdateSalesMarkupPrices - should be refactored
    var
        CurrencyTemp: Record Currency temporary;
        PurchasePrice: Record "Purchase Price";
        Item: Record Item;
        ICPartner: Record "IC Partner";
        SalesPrice: Record "Sales Price";
        SalesPriceWorksheet: Record "Sales Price Worksheet";
        ImplementPrices: Report "Implement Price Change";
        Suggestprices: report "Suggest Sales Price on Wksh.";
        ICSyncMgt: Codeunit "IC Sync Management";
    begin

        Item.Get(ItemNo);
        if Item."Transfer Price %" = 0 then
            exit;
        if ICPartner.FindSet() then
            repeat
                if ICPartner."Customer No." <> '' then begin
                    if FindLatestPurchasePrice(ItemNo, VendorNo, Item."Vendor Currency", 0D, PurchasePrice) then begin
                        Salesprice.Init();
                        Salesprice."Sales Type" := Salesprice."Sales Type"::Customer;
                        SalesPrice."Sales Code" := ICPartner."Customer No.";
                        Salesprice."Currency Code" := PurchasePrice."Currency Code";
                        Salesprice."Starting Date" := PurchasePrice."Starting Date";
                        Salesprice."Ending Date" := PurchasePrice."Ending Date";
                        Salesprice."Item No." := PurchasePrice."Item No.";
                        Salesprice."Unit of Measure Code" := PurchasePrice."Unit of Measure Code";
                        Salesprice."Minimum Quantity" := PurchasePrice."Minimum Quantity";
                        Salesprice."Unit Price" := round(PurchasePrice."Direct Unit Cost" / ((100 - Item."Transfer Price %") / 100));
                        if not Salesprice.Insert(true) then
                            Salesprice.Modify(true);

                        clear(Salesprice);
                        Salesprice.SetRange("Item No.", PurchasePrice."Item No.");
                        Salesprice.SetRange("Sales Type", Salesprice."Sales Type"::Customer);
                        SalesPrice.SetRange("Sales Code", ICPartner."Customer No.");
                        FindPriceCurrencies(Item."Vendor Currency", Item."Vendor Currency" <> '', CurrencyTemp);
                        if CurrencyTemp.FindFirst then begin
                            repeat
                                Clear(Suggestprices);
                                Suggestprices.InitializeRequest2(SalesPrice."Sales Type"::Customer, ICPartner."Customer No.", PurchasePrice."Starting Date", PurchasePrice."Ending Date",
                                                                CurrencyTemp.Code, PurchasePrice."Unit of Measure Code", true, 0, 1, '');
                                Suggestprices.SetTableView(SalesPrice);
                                Suggestprices.UseRequestPage(false);
                                Suggestprices.Run;
                            until CurrencyTemp.next = 0;
                        end;
                        SalesPriceWorksheet.SetRange("Item No.", PurchasePrice."Item No.");
                        Clear(ImplementPrices);
                        ImplementPrices.SetTableView(SalesPriceWorksheet);
                        ImplementPrices.InitializeRequest(true);
                        ImplementPrices.UseRequestPage(false);
                        ImplementPrices.Run();
                    end;
                end;
            until ICPartner.Next() = 0;
        ICSyncMgt.CopyPurchasePricesToOtherCompanies(Item."No.");
    end;

    local procedure CreatePricesForItemFromItemDiscountGroups(Item: Record Item)
    var
        ItemDiscGroup: Record "Item Discount Group";
        SalesLineDiscount: Record "Sales Line Discount";
        CurrencyTemp: Record Currency temporary;
        ImplementPrices: report "Implement Price Change";
        SalesPriceWorksheet: Record "Sales Price Worksheet";
    begin
        if not ItemDiscGroup.Get(Item."Item Disc. Group") then
            exit;
        FindPriceCurrencies('', true, CurrencyTemp);
        SalesLineDiscount.SetRange(Type, SalesLineDiscount.Type::"Item Disc. Group");
        SalesLineDiscount.SetRange(Code, ItemDiscGroup.Code);
        if SalesLineDiscount.FindSet() then
            repeat
                CreatePricesForItem(Item."No.", SalesLineDiscount, CurrencyTemp);
            until SalesLineDiscount.Next() = 0;
        SalesPriceWorksheet.SetRange("Item No.", Item."No.");
        if not SalesPriceWorksheet.IsEmpty() then begin
            Clear(ImplementPrices);
            ImplementPrices.SetTableView(SalesPriceWorksheet);
            ImplementPrices.InitializeRequest(true);
            ImplementPrices.UseRequestPage(false);
            ImplementPrices.Run();
        end;
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
    //refactor to use FindBestPurchasePrice
    var
        Item: Record Item;
        PurchPrice: Record "Purchase Price";
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        if SalesLine.Type <> SalesLine.Type::Item then
            Exit;
        if not Item.get(SalesLine."No.") then
            exit;
        PurchPrice.SetRange("Item No.", Item."No.");
        PurchPrice.SetRange("Vendor No.", GetVendorNoForItem(item."No."));
        if SalesLine."Variant Code" <> '' then
            PurchPrice.SetRange("Variant Code", SalesLine."Variant Code");
        PurchPrice.SetFilter("Ending Date", '..%1', WorkDate);
        PurchPrice.SetRange("Currency Code", SalesLine."Currency Code");
        if PurchPrice.FindLast then begin
            SalesLine.validate("Unit Purchase Price", PurchPrice."Direct Unit Cost");
            exit;
        end;
        if Item."Vendor Currency" <> SalesLine."Currency Code" then begin
            PurchPrice.SetRange("Currency Code", Item."Vendor Currency");
            if PurchPrice.FindLast then begin
                SalesLine.validate("Unit Purchase Price", CurrExchRate.ExchangeAmount(PurchPrice."Direct Unit Cost", PurchPrice."Currency Code", SalesLine."Currency Code", SalesLine."Posting Date"));
                exit;
            end;
        end;
        PurchPrice.SetRange("Currency Code");
        if PurchPrice.FindLast then begin
            SalesLine.validate("Unit Purchase Price", CurrExchRate.ExchangeAmount(PurchPrice."Direct Unit Cost", PurchPrice."Currency Code", SalesLine."Currency Code", SalesLine."Posting Date"));
            exit;
        end;
        SalesLine.validate("Unit Purchase Price", item."Unit Cost");
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

    procedure ExchangeAmtLCYToFCY(SalesPriceLCY: record "Sales Price"; SalesPriceFCY: Record "Sales Price")
    var
        CurrencyExcRate: Record "Currency Exchange Rate";
        Factor: Decimal;
    begin
        Factor := CurrencyExcRate.GetCurrentCurrencyFactor(SalesPriceFCY."Currency Code");
        SalesPriceFCY.Validate("Unit Price", CurrencyExcRate.ExchangeAmtLCYToFCY(Today(), SalesPriceFCY."Currency Code", SalesPriceLCY."Unit Price", Factor));
        SalesPriceFCY.Modify(true);
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

    procedure CreateSalesPriceFromPurchasePriceMarkup(PurchasePrice: Record "Purchase Price")
    var
        PurchaseDisc: Record "Purchase Line Discount";
    begin
        PurchaseDisc.SetRange("Item No.", PurchasePrice."Item No.");
        PurchaseDisc.SetRange("Vendor No.", PurchasePrice."Vendor No.");
        PurchaseDisc.SetRange("Unit of Measure Code", PurchasePrice."Unit of Measure Code");
        PurchaseDisc.SetRange("Currency Code", PurchasePrice."Currency Code");
        if PurchaseDisc.FindLast() then begin
            CreateUpdateSalesMarkupPrices(PurchaseDisc);
            exit;
        end;
        PurchaseDisc.SetRange("Currency Code");
        if PurchaseDisc.FindLast() then
            CreateUpdateSalesMarkupPrices(PurchaseDisc);
    end;

    procedure CloseOldSalesPrices(SalesPrice: Record "Sales Price")
    var
        OldSalesPrice: Record "Sales Price";
        EndDate: Date;
    begin
        EndDate := CalcDate('<-1D>', SalesPrice."Starting Date");
        OldSalesPrice := SalesPrice;
        OldSalesPrice.SetRecFilter();
        OldSalesPrice.SetRange("Starting Date", 0D, EndDate);
        OldSalesPrice.SetFilter("Ending Date", '=%1', 0D);
        if OldSalesPrice.FindSet(true, false) then
            repeat
                OldSalesPrice."Ending Date" := EndDate;
                OldSalesPrice.Modify(true);
            until OldSalesPrice.Next() = 0;
    end;

    procedure CloseOldPurchasePrices(PurchasePrice: Record "Purchase Price")
    var
        OldPurchasePrice: Record "Purchase Price";
        EndDate: Date;
    begin
        EndDate := CalcDate('<-1D>', PurchasePrice."Starting Date");
        OldPurchasePrice := PurchasePrice;
        OldPurchasePrice.SetRecFilter();
        OldPurchasePrice.SetRange("Starting Date", 0D, EndDate);
        OldPurchasePrice.SetFilter("Ending Date", '=%1', 0D);
        if OldPurchasePrice.FindSet(true, false) then
            repeat
                OldPurchasePrice."Ending Date" := EndDate;
                OldPurchasePrice.Modify(true);
            until OldPurchasePrice.Next() = 0;
    end;

    procedure FindBestPurchasePrice(itemNo: Code[20]; VendorNo: Code[20]; CurrencyCode: Code[20]; VariantCode: Code[20]; var PurchasePrice: Record "Purchase Price"): Boolean
    var
        Item: Record Item;
    begin
        item.Get(itemNo);
        PurchasePrice.SetRange("Item No.", Item."No.");
        PurchasePrice.SetRange("Vendor No.", VendorNo);
        if VariantCode <> '' then
            PurchasePrice.SetRange("Variant Code", VariantCode);
        PurchasePrice.SetFilter("Ending Date", '..%1', WorkDate);
        PurchasePrice.SetRange("Currency Code", CurrencyCode);
        if PurchasePrice.FindLast then
            exit(true);
        if Item."Vendor Currency" <> CurrencyCode then begin
            PurchasePrice.SetRange("Currency Code", Item."Vendor Currency");
            if PurchasePrice.FindLast then
                exit(true);
        end;
        PurchasePrice.SetRange("Currency Code");
        if PurchasePrice.FindLast then
            exit(true);
        Clear(PurchasePrice);
        exit(false);
    end;

    procedure GetVendorNoForItem(ItemNo: Code[20]): Code[20]
    var
        Item: Record Item;
    begin
        Item.Get(ItemNo);
        if Item."IC partner Vendor No." <> '' then
            exit(Item."IC partner Vendor No.")
        else begin
            Item.TestField("Vendor No.");
            exit(Item."Vendor No.");
        end;
    end;

    local procedure ConvertListPrices(ItemNo: Code[20])
    var
        SalesListPrice: Record "Sales Price";
        SalesPrice: Record "Sales Price";
    begin

        //Item No.,Sales Type,Sales Code,Starting Date,Currency Code,Variant Code,Unit of Measure Code,Minimum Quantity
        SalesListPrice.SetRange("Item No.", ItemNo);
        SalesListPrice.SetRange("Variant Code", 'LISTPRICE');
        SalesListPrice.SetFilter("Ending Date", '%1', 0D);
        if SalesListPrice.FindSet() then
            repeat
                if SalesPrice.get(SalesListPrice."Item No.", SalesListPrice."Sales Type", SalesListPrice."Sales Code", SalesListPrice."Starting Date",
                SalesListPrice."Currency Code", '', SalesListPrice."Unit of Measure Code", SalesListPrice."Minimum Quantity") then begin
                    SalesPrice."Unit Price" := SalesListPrice."Unit Price";
                    SalesPrice.Modify(true);
                end;
            until SalesListPrice.Next() = 0;
    end;

    procedure UpdateTransferPrices(ItemDiscGroupCode: Code[20]; NewPercentage: Decimal)
    var
        Item: Record Item;
        UpdateReport: Report "Update Transfer Price %";
    begin
        UpdateReport.SetTranferPricePercentage(NewPercentage);
        if ItemDiscGroupCode <> '' then begin
            item.SetRange("Item Disc. Group", ItemDiscGroupCode);
            UpdateReport.SetTableView(Item);
        end;
        UpdateReport.UseRequestPage(false);
        UpdateReport.RunModal();
    End;
}