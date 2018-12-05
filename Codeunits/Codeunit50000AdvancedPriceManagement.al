codeunit 50000 "Advanced Price Management"
{
    EventSubscriberInstance = StaticAutomatic;

    trigger OnRun();
    var

    begin

    end;

    procedure CreateListprices(SalesPriceWorksheet: Record "Sales Price Worksheet");
    var
        DiscontGroupFilters: Record "Sales Line Discount";
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

    procedure UpdatePurchaseDicountsForItemDiscGroup(itemDiscGroup: Code[20]; DiscPct: Decimal; VendorNo: Code[20]);
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
                    PurchaseDiscount."Starting Date" := WorkDate;
                    PurchaseDiscount."Currency Code" := Vendor."Currency Code";
                    //PurchaseDiscount."Variant Code" := ?              Does not support variants at the moment - SEC does not use variants
                    PurchaseDiscount."Line Discount %" := DiscPct;
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
        if not PurchasePrice.Get(PurchaseLineDiscount."Item No.", PurchaseLineDiscount."Vendor No.", PurchaseLineDiscount."Starting Date", PurchaseLineDiscount."Currency Code",
                                PurchaseLineDiscount."Variant Code", PurchaseLineDiscount."Unit of Measure Code", PurchaseLineDiscount."Minimum Quantity") then begin
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
        if SalesDiscountGroup.FindSet then repeat
                                               if FindItemsInItemDiscGroup(ItemTemp, SalesDiscountGroup.Code) then begin
                                                   if ItemTemp.FindFirst then repeat
                                                                                  CreatePricesForItem(ItemTemp."No.", SalesDiscountGroup, CurrencyTemp);
                                                       until ItemTemp.next = 0;
                                               end;
            until SalesDiscountGroup.next = 0;
    end;

    local procedure CreatePricesForItem(ItemNo: Code[20]; SalesDiscountGroup: Record "Sales Line Discount"; var CurrencyTemp: Record Currency temporary)
    var
        ItemListPrice: Record "Sales Price";
    begin
        if CurrencyTemp.FindFirst then repeat
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

    local procedure FindListPriceForitem(ItemNo: code[20]; CurrencyCode: Code[20]; var ListPrice: record "sales price"): Boolean;
    var
        Test: Integer;
    begin
        ListPrice.SetRange("Item No.", ItemNo);
        ListPrice.SetRange("Sales Type", ListPrice."Sales Type"::"All Customers");
        ListPrice.SetRange("Currency Code", CurrencyCode);
        exit(listprice.FindLast);
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

    local procedure UpdateSalesLineWithPurchPrice(var SalesLine: Record "Sales Line");
    var
        Item: Record Item;
        PurchPrice: Record "Purchase Price";
    begin
        if SalesLine.Type <> SalesLine.Type::Item then
            Exit;
        if not Item.get(SalesLine."No.") then
            exit;
        PurchPrice.SetRange("Item No.", ITEM."No.");
        PurchPrice.SetRange("Vendor No.", Item."Vendor No.");
        PurchPrice.SetRange("Variant Code", SalesLine."Variant Code");
        PurchPrice.SetFilter("Ending Date", '..%1', WorkDate);
        if PurchPrice.FindLast then
            SalesLine.validate("Unit Purchase Price", PurchPrice."Direct Unit Cost")
        else
            SalesLine.validate("Unit Purchase Price", item."Unit Cost");
        //Need to add currency and UOM and bids...
    end;

    local procedure FindPriceGroupsFromItem(Item: Record Item; var SalesLineDiscountTemp: Record "Sales Line Discount" temporary) FoundSome: boolean;
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

    procedure ExchangeAmtFCYToLCY(SalesPrice: record "Sales Price"; CurrTemp: record Currency temporary)
    var
        CurrencyExcRate: Record "Currency Exchange Rate";
    begin
        Salesprice."Unit Price" := CurrencyExcRate.ExchangeAmtFCYToLCY(Salesprice."Starting Date", Salesprice."Currency Code", Salesprice."Unit Price", CurrTemp."Currency Factor");
        Salesprice."Starting Date" := Today;
        Salesprice.Modify(true);
    end;

    procedure ExchangeAmtFCYToFCY(SalesPrice: record "Sales Price"; FromCurrency: Code[10])
    var
        CurrencyExcRate: Record "Currency Exchange Rate";
    begin
        Salesprice."Unit Price" := CurrencyExcRate.ExchangeAmtFCYToFCY(Salesprice."Starting Date", FromCurrency, Salesprice."Currency Code", Salesprice."Unit Price");
        Salesprice."Starting Date" := Today;
        Salesprice.Modify(true);
    end;

    procedure ExchangeAmtLCYToFCY(SalesPrice: record "Sales Price"; CurrTemp: record Currency temporary)
    var
        CurrencyExcRate: Record "Currency Exchange Rate";
    begin
        Salesprice."Unit Price" := CurrencyExcRate.ExchangeAmtLCYToFCY(Salesprice."Starting Date", Salesprice."Currency Code", Salesprice."Unit Price", CurrTemp."Currency Factor");
        Salesprice."Starting Date" := Today;
        Salesprice.Modify(true);
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterUpdateAmounts', '', true, true)]
    local procedure SalesLineOnAfterUpdateAmounts(var SalesLine: Record "Sales Line")
    begin
        if SalesLine."Unit Purchase Price" = 0 then
            UpdateSalesLineWithPurchPrice(SalesLine);
        SalesLine.CalcAdvancedPrices;
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterAssignItemValues', '', true, true)]
    local procedure SalesLineOnAfterAssignItemValues(var SalesLine: Record "Sales Line"; Item: Record Item)
    var
        SalesLineDiscountTemp: Record "Sales Line Discount" temporary;
        PriceGroupLink: Record "Price Group Link";
        FoundGroup: Boolean;
    begin
        if FindPriceGroupsFromItem(Item, SalesLineDiscountTemp) then begin
            PriceGroupLink.SetRange("Customer No.", SalesLine."Sell-to Customer No.");
            if PriceGroupLink.FindSet then begin
                repeat
                    SalesLineDiscountTemp.SetRange("Sales Code", PriceGroupLink."Customer Discount Group Code");
                    if SalesLineDiscountTemp.FindFirst then begin
                        SalesLine."Customer Disc. Group" := SalesLineDiscountTemp."Sales Code";
                        SalesLine."Customer Price Group" := SalesLine."Customer Disc. Group";
                        FoundGroup := true;
                    end;
                until (PriceGroupLink.Next = 0) or (FoundGroup);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Release Sales Document", 'OnBeforeReleaseSalesDoc', '', true, true)]
    local procedure SalesHeaderOnBeforeReleaseSalesDoc(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean)
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindSet then begin
            repeat
                if SalesLine."Bid Unit Sales Price" <> 0 then
                    SalesLine.TestField("Bid No.");
                if SalesLine."Bid Unit Purchase Price" <> 0 then
                    SalesLine.TestField("Bid No.");
            until SalesLine.Next = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line Discount", 'OnAfterModifyEvent', '', true, true)]
    local procedure SalesLineDiscountOnAfterModify(var Rec: Record "Sales Line Discount")
    var
        DiscontGroupFilters: Record "Sales Line Discount";
        SalesPriceWorksheet: Record "Sales Price Worksheet";
        ImplementPrices: Report "Implement Price Change";
    begin
        DiscontGroupFilters.SetRange(Type, DiscontGroupFilters.type::"Item Disc. Group");
        DiscontGroupFilters.SetRange(Code, Rec.Code);
        DiscontGroupFilters.SetRange("Sales Type", rec."Sales Type");
        DiscontGroupFilters.SetRange("Sales Code", Rec."Sales Code");
        CalcGroupPricesFromGroupDiscounts(DiscontGroupFilters);
        SalesPriceWorksheet.SetRange("Sales Type", rec."Sales Type");
        SalesPriceWorksheet.SetRange("Sales Code", Rec."Sales Code");
        ImplementPrices.InitializeRequest(true);
        ImplementPrices.SetTableView(SalesPriceWorksheet);
        ImplementPrices.UseRequestPage(false);
        ImplementPrices.Run();
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Line Discount", 'OnAfterModifyEvent', '', true, true)]
    local procedure PurchaseLineDiscountOnAfterModify(var Rec: Record "Purchase Line Discount"; xRec: Record "Purchase Line Discount")
    var
        PurchasePrice: Record "Purchase Price";
        ListPrice: Record "Sales Price";
    begin
        if Rec."Line Discount %" = xRec."Line Discount %" then
            exit;
        if not FindListPriceForitem(Rec."Item No.", Rec."Currency Code", ListPrice) then
            exit;
        CreateUpdatePurchasePrices(Rec, ListPrice);
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Line Discount", 'OnAfterInsertEvent', '', true, true)]
    local procedure PurchaseLineDiscountOnAfterInsert(var Rec: Record "Purchase Line Discount")
    var
        PurchasePrice: Record "Purchase Price";
        ListPrice: Record "Sales Price";
    begin
        if not FindListPriceForitem(Rec."Item No.", Rec."Currency Code", ListPrice) then
            exit;
        CreateUpdatePurchasePrices(Rec, ListPrice);
    end;

}