codeunit 50003 "File Management Import"
{
    trigger OnRun()
    begin

    end;

    var

    procedure ImportSalesOrderFromCSV(SalesHeader: record "Sales Header")
    var
        TempCSVBuffer: record "CSV Buffer" temporary;
        BidNo: code[20];
        Salesline: Record "Sales Line";
    begin
        TempCSVBuffer.init;
        SelectFileFromFileShare(TempCSVBuffer);

        //Before import to prevent errors
        CreateItemsFromBid(TempCSVBuffer, BidNo, 0);

        Salesline.setrange("Document No.", SalesHeader."No.");
        Salesline.SetRange("Document Type", SalesHeader."Document Type");
        if Salesline.FindFirst() then begin
            TestCSVBufferFields(TempCSVBuffer);
            CreateSalesLineFromBid(TempCSVBuffer, SalesHeader, Salesline."Bid No.");
            CreatePurchaseOrderFromSalesOrder(TempCSVBuffer, SalesHeader, 0);
        end else begin
            CreateSalesHeaderFromCSV(TempCSVBuffer, SalesHeader, BidNo);
            CreateSalesLineFromBid(TempCSVBuffer, SalesHeader, BidNo);
            CreatePurchaseOrderFromSalesOrder(TempCSVBuffer, SalesHeader, 0);
        end;

        TempCSVBuffer.Reset;
        TempCSVBuffer.DeleteAll();        //delete TempCSVbuffer when finish            
    end;

    local procedure CreateSalesHeaderFromCSV(var TempCSVBuffer: record "CSV Buffer" temporary; var SalesHeader: record "Sales Header"; var BidNo: code[20])
    var
        Dropship: Boolean;
        Customer: record Customer;
        Claim: Boolean;
        Bid: record bid;
    begin
        TempCSVBuffer.SetRange("Line No.", 2);
        if TempCSVBuffer.FindSet() then
            repeat
                case TempCSVBuffer."Field No." of
                    1:
                        begin
                            Bid.Init();
                            Bid.Validate(Description, 'Project Sale');
                            Bid.Validate("Project Sale", true);
                            Bid.Insert(true);

                            if TempCSVBuffer.value = '' then
                                Error('Reseller is missing on line %1', TempCSVBuffer."Line No.");
                            SalesHeader.Validate(Reseller, TempCSVBuffer.Value);
                        end;
                    2:
                        begin
                            if TempCSVBuffer.value <> '' then
                                SalesHeader.Validate("End Customer", TempCSVBuffer.Value);
                        end;
                    3:
                        begin
                            if (salesheader.reseller <> '') and (TempCSVBuffer.Value <> '') then begin
                                SalesHeader."Bill-to Customer No." := '';
                                SalesHeader."Bill-to Contact No." := '';
                                SalesHeader.Validate("Financing Partner", TempCSVBuffer.Value);
                            end;
                        end;
                    4:
                        begin
                            if TempCSVBuffer.value <> '' then
                                SalesHeader.Validate("External Document No.", TempCSVBuffer.Value);
                        end;
                    5:
                        begin
                            if TempCSVBuffer.value <> '' then begin
                                Evaluate(Dropship, TempCSVBuffer.Value);
                                SalesHeader.Validate("Drop-Shipment", Dropship);
                            end;
                        end;
                    11:
                        begin
                            if TempCSVBuffer.value = '' then
                                Error('Vendor No. is missing on line %1', TempCSVBuffer."Line No.");
                            Bid.Validate("Vendor No.", TempCSVBuffer.value);
                        end;
                    12:
                        begin
                            if TempCSVBuffer.value <> '' then
                                Bid.Validate("Vendor Bid No.", TempCSVBuffer.Value);
                        end;
                    13:
                        begin
                            if TempCSVBuffer.value <> '' then begin
                                Evaluate(Claim, TempCSVBuffer.Value);
                                Bid.Validate(Claimable, Claim);
                            end;
                        end;
                end;
                Bid.Modify(true);
                SalesHeader.Modify(true);
                BidNo := Bid."No.";
            until TempCSVBuffer.next = 0;
    end;

    local procedure CreateSalesLineFromBid(var TempCSVBuffer: record "CSV Buffer" temporary; Salesheader: record "Sales Header"; var BidNo: code[20])
    var
        BidPrices: record "Bid Item Price";
        NoseriesManage: Codeunit NoSeriesManagement;
        UnitPriceSell: Decimal;
        UnitPriceBuy: decimal;
        Qty: Integer;
        Quantity: Integer;
        GlobalCounter: Integer;
        Item: Record Item;
        bid: Record Bid;
    begin
        TempCSVBuffer.SetFilter("Line No.", '<>%1', 1);
        if TempCSVBuffer.FindSet() then
            repeat
                if TempCSVBuffer."Field No." = 1 then begin
                    BidPrices.init;
                    BidPrices.Validate("Bid No.", BidNo);
                end;
                case TempCSVBuffer."Field No." of
                    2:
                        begin
                            BidPrices.Validate("Customer No.", TempCSVBuffer.Value);
                        end;
                    6:
                        begin
                            if TempCSVBuffer.value = '' then
                                Error('Vendor Item No. is missing on line %1', TempCSVBuffer."Line No.");
                            Bid.Get(BidNo);
                            item.SetRange("Vendor No.", bid."Vendor No.");
                            Item.Setrange("Vendor Item No.", TempCSVBuffer.Value);
                            if Item.FindFirst() then
                                BidPrices.Validate("item No.", Item."No.")
                            else
                                error('Item does not exists for vendor item no %1 or vendor no. %2', TempCSVBuffer.Value, bid."Vendor No.");
                        end;
                    7:
                        begin
                            if TempCSVBuffer.value = '' then
                                Error('Quantity is missing on line %1', TempCSVBuffer."Line No.");
                            Evaluate(Qty, TempCSVBuffer.Value);
                            Quantity := qty;
                        end;
                    8:
                        begin
                            if TempCSVBuffer.Value <> '' then begin
                                Evaluate(UnitPriceSell, TempCSVBuffer.Value);
                                BidPrices.Validate("Bid Unit Sales Price", UnitPriceSell);
                            end;
                        end;
                    9:
                        begin
                            if TempCSVBuffer.value <> '' then begin
                                Evaluate(UnitPriceBuy, TempCSVBuffer.Value);
                                BidPrices.Validate("Bid Unit Purchase Price", UnitPriceBuy);
                            end;
                        end;
                    10:
                        begin
                            if TempCSVBuffer.value <> '' then
                                BidPrices.Validate("Currency Code", TempCSVBuffer.Value);
                            BidPrices.Insert(true);
                            CreateSalesLines(Salesheader, BidPrices, Quantity, GlobalCounter);
                        end;
                end;

            until TempCSVBuffer.next = 0;
        Message('%1 lines inserted on sales order %2', GlobalCounter, SalesHeader."No.");
    end;

    local procedure CreateItemsFromBid(var TempCSVBuffer: Record "CSV Buffer" temporary; var BidNo: Code[20]; ImportType: Option ProjectImport,LinesImport);
    var
        SalesSetup: Record "Sales & Receivables Setup";
        ConfigTemplateManagement: Codeunit "Config. Template Management";
        ItemRecRef: RecordRef;
        ConfigTemplateHeader: Record "Config. Template Header";
        DimensionsTemplate: Record "Dimensions Template";
        Item: Record Item;
        bid: Record Bid;
        TempCSVBufferTemplate: Record "CSV Buffer" temporary;
        ImportTypeDiff: Integer;
    begin
        if not SalesSetup.Get then exit;

        if ImportType = ImportType::LinesImport then
            ImportTypeDiff := 5;

        TempCSVBuffer.SetFilter("Line No.", '<>%1', 1);

        TempCSVBuffer.SetRange("Field No.", 11 - ImportTypeDiff);

        if BidNo = '' then begin
            if TempCSVBuffer.FindFirst then begin
                Bid.Init();
                Bid.Validate(Description, 'Project Sale');
                Bid.Validate("Project Sale", true);
                Bid.Validate("Vendor No.", TempCSVBuffer.value);
                if ImportType = ImportType::LinesImport then
                    Bid.Insert(true);
                BidNo := Bid."No.";
            end;
        end else
            Bid.Get(BidNo);

        //Gem templates!
        TempCSVBuffer.SetRange("Field No.", 15 - ImportTypeDiff);
        if TempCSVBuffer.FindSet() then
            repeat
                TempCSVBufferTemplate.Copy(TempCSVBuffer);
                TempCSVBufferTemplate.Insert();
            until TempCSVBuffer.Next() = 0;

        //Import items
        TempCSVBuffer.SetRange("Field No.", 6 - ImportTypeDiff);
        if TempCSVBuffer.FindSet() then
            repeat
                Item.SetRange("Vendor No.", Bid."Vendor No.");
                Item.Setrange("Vendor Item No.", TempCSVBuffer.Value);
                if not Item.FindFirst() then begin
                    Clear(ConfigTemplateHeader);
                    TempCSVBufferTemplate.SetRange("Line No.", TempCSVBuffer."Line No.");
                    if TempCSVBufferTemplate.FindFirst() then
                        if ConfigTemplateHeader.Get(TempCSVBufferTemplate.Value) then;

                    if ConfigTemplateHeader.IsEmpty() then
                        if not ConfigTemplateHeader.Get(SalesSetup."Project Item Template") then
                            error('Item does not exists for vendor item no %1 or vendor no. %2', TempCSVBuffer.Value, bid."Vendor No.");

                    Clear(Item);
                    Item.Insert(true);
                    Item.Validate("Vendor No.", Bid."Vendor No.");
                    Item.Validate("Vendor Item No.", TempCSVBuffer.Value);
                    Item.Modify(true);
                    ItemRecRef.GetTable(Item);

                    ConfigTemplateManagement.UpdateRecord(ConfigTemplateHeader, ItemRecRef);
                    DimensionsTemplate.InsertDimensionsFromTemplates(ConfigTemplateHeader, Item."No.", DATABASE::Item);
                    Item.Get(Item."No.");
                end;
            until TempCSVBuffer.next = 0;

        TempCSVBufferTemplate.Reset;
        TempCSVBufferTemplate.DeleteAll();

        TempCSVBuffer.Reset;
    end;

    local procedure CreateSalesLines(SalesHeader: record "Sales Header"; BidPrices: record "Bid Item Price"; Qty: Integer; var GlobalCounter: Integer)
    var
        SalesLine: record "Sales Line";
        NextLineNo: Integer;
    begin
        SalesLine.SetRange("Document No.", Salesheader."No.");
        SalesLine.SetRange("Document Type", Salesheader."Document Type");
        if not SalesLine.FindLast() then begin
            NextLineNo := 10000;
            SalesLine.init;
        end else
            NextLineNo := SalesLine."Line No." + 10000;

        SalesLine."Document No." := Salesheader."No.";
        SalesLine."Document Type" := Salesheader."Document Type";
        SalesLine."Line No." := NextLineNo;
        SalesLine.Type := SalesLine.type::Item;
        SalesLine.Validate("No.", BidPrices."item No.");
        SalesLine.Validate(Quantity, Qty);
        SalesLine.Insert(true);
        SalesLine.Validate("Bid No.", BidPrices."Bid No.");
        if BidPrices."Bid Unit Purchase Price" = 0 then
            SalesLine.Validate("Unit Purchase Price", 0);
        SalesLine.Modify(true);
        if SalesLine."Line Discount %" <> 0 then begin
            SalesLine."Line Discount %" := 0;
            SalesLine.Modify(true);
        end;
        GlobalCounter := GlobalCounter + 1;
    end;

    local procedure CreatePurchaseOrderFromSalesOrder(Var TempCSVBuffer: record "CSV Buffer" temporary; SalesHeader: record "Sales Header"; ImportType: Option ProjectImport,LinesImport)
    var
        PurchOrder: record "Purchase Header";
        PurchFromSales: codeunit "Create Purchase Order";
        PurchLine: record "Purchase Line";
        VendorNo: code[20];
        VendorBidNo: Code[20];
        CurrencyCode: code[20];
        SalesLine: record "Sales Line";
        GlobalLineCounter: Integer;
        PurchasePrice: Record "Purchase Price";
        BidPrice: Record "Bid Item Price";
        AdvPriceMgt: Codeunit "Advanced Price Management";
        BidMgt: Codeunit "Bid Management";
        ReleasePurchDoc: Codeunit "Release Purchase Document";
        ImportTypeDiff: Integer;
    begin
        TempCSVBuffer.SetRange("Line No.", 2);
        if ImportType = ImportType::LinesImport then
            ImportTypeDiff := 5;

        if TempCSVBuffer.FindSet() then
            repeat
                case (TempCSVBuffer."Field No." + ImportTypeDiff) of
                    10:
                        begin
                            CurrencyCode := TempCSVBuffer.value;
                        end;
                    11:
                        begin
                            VendorNo := TempCSVBuffer.Value;
                        end;
                    12:
                        begin
                            VendorBidNo := TempCSVBuffer.value;
                        end;
                    14:
                        begin
                            if TempCSVBuffer.Value = '' then begin
                                PurchFromSales.CreatePurchHeader(SalesHeader, VendorNo, CurrencyCode, VendorBidNo, PurchOrder);
                                SalesLine.SetRange("Document No.", SalesHeader."No.");
                                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                                SalesLine.SetRange(Type, SalesLine.Type::Item);
                                if SalesLine.findset then
                                    repeat
                                        Clear(PurchasePrice);
                                        Clear(BidPrice);
                                        if not BidMgt.GetBestBidPrice(SalesLine."Bid No.", SalesLine."Sell-to Customer No.", SalesLine."No.", CurrencyCode, BidPrice) then
                                            Clear(PurchasePrice)
                                        else begin
                                            BidMgt.MakePurchasePriceFromBidPrice(BidPrice, PurchasePrice);
                                            CurrencyCode := PurchasePrice."Currency Code";
                                        end;

                                        PurchFromSales.CreatePurchLine(PurchOrder, SalesHeader, SalesLine, PurchasePrice."Direct Unit Cost", PurchLine);
                                        PurchFromSales.ReserveItemOnPurchOrder(SalesLine, PurchLine);
                                        GlobalLineCounter := GlobalLineCounter + 1;
                                    until SalesLine.next = 0;
                            end else begin
                                PurchOrder.get(PurchOrder."Document Type"::Order, TempCSVBuffer.Value);
                                if PurchOrder."Buy-from Vendor No." = '' then begin
                                    PurchOrder.validate("Buy-from Vendor No.", VendorNo);
                                    PurchOrder.Modify(true);
                                end;
                                if PurchOrder."Currency Code" = '' then begin
                                    PurchOrder.Validate("Currency Code", CurrencyCode);
                                    PurchOrder.Modify(true);
                                end;
                                if PurchOrder."Vendor Shipment No." = '' then begin
                                    PurchOrder.validate("Vendor Shipment No.", VendorBidNo);
                                    PurchOrder.Modify(true);
                                end;
                                SalesLine.SetRange("Document No.", SalesHeader."No.");
                                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                                SalesLine.SetRange(Type, SalesLine.Type::Item);
                                if SalesLine.findset then begin
                                    repeat
                                        Clear(PurchasePrice);
                                        Clear(BidPrice);
                                        if not BidMgt.GetBestBidPrice(SalesLine."Bid No.", SalesLine."Sell-to Customer No.", SalesLine."No.", CurrencyCode, BidPrice) then
                                            Clear(PurchasePrice)
                                        else begin
                                            BidMgt.MakePurchasePriceFromBidPrice(BidPrice, PurchasePrice);
                                            CurrencyCode := PurchasePrice."Currency Code";
                                        end;

                                        SalesLine.CalcFields("Reserved Quantity");
                                        if SalesLine."Reserved Quantity" = 0 then begin
                                            PurchFromSales.CreatePurchLine(PurchOrder, SalesHeader, SalesLine, PurchasePrice."Direct Unit Cost", PurchLine);
                                            PurchFromSales.ReserveItemOnPurchOrder(Salesline, PurchLine);
                                            GlobalLineCounter := GlobalLineCounter + 1;
                                        end;
                                    until SalesLine.next = 0;
                                    Message('%1 lines inserted on purchase order %2', GlobalLineCounter, PurchOrder."No.");
                                end;
                            end;
                        end;
                end;
            until TempCSVBuffer.next = 0;
    end;

    procedure SelectFileFromFileShare(Var TempCSVBUffer: record "CSV Buffer" temporary)
    var
        WindowTitle: text;
        FileName: text;
        FileMgt: Codeunit "File Management";
    begin
        WindowTitle := 'Select file';
        Filename := FileMgt.OpenFileDialog(WindowTitle, '', '');
        TempCSVBuffer.Init();
        TempCSVBuffer.LoadData(FileName, ';');
    end;

    procedure TestCSVBufferFields(TempCSVBuffer: record "CSV Buffer" temporary)
    var

    begin
        case TempCSVBuffer."Field No." of
            14:
                begin
                    if TempCSVBuffer.value = '' then
                        error('Purchase order number is missing in Excel sheet');
                end;
        end;
    end;

    procedure ImportSalesLinesFromCSV(SalesHeader: record "Sales Header")
    var
        TempCSVBuffer: record "CSV Buffer" temporary;
        Bid: Record Bid;
        BidNo: Code[20];
        Salesline: Record "Sales Line";
        Claim: Boolean;
        BidPrices: Record "Bid Item Price";
        Item: Record Item;
        Qty: Decimal;
        NoseriesManage: Codeunit NoSeriesManagement;
        UnitPriceSell: Decimal;
        UnitPriceBuy: decimal;
        Quantity: Integer;
        GlobalCounter: Integer;
    begin
        TempCSVBuffer.init;
        SelectFileFromFileShare(TempCSVBuffer);

        //Before import to prevent errors        
        CreateItemsFromBid(TempCSVBuffer, BidNo, 1);
        Bid.Get(BidNo);

        if Bid."Vendor Bid No." = '' then begin
            TempCSVBuffer.SetFilter("Line No.", '<>%1', 1);

            TempCSVBuffer.SetRange("Field No.", 7);
            if TempCSVBuffer.FindFirst then
                Bid.Validate("Vendor Bid No.", TempCSVBuffer.Value);

            TempCSVBuffer.SetRange("Field No.", 8);
            if TempCSVBuffer.FindFirst then begin
                if TempCSVBuffer.value <> '' then begin
                    Evaluate(Claim, TempCSVBuffer.Value);
                    Bid.Validate(Claimable, Claim);
                end;
            end;
            Bid.Modify(true);
        end;

        TempCSVBuffer.SetFilter("Field No.", '%1..%2', 1, 5);
        if TempCSVBuffer.FindSet() then
            repeat
                if TempCSVBuffer."Field No." = 1 then begin
                    BidPrices.init;
                    BidPrices.Validate("Bid No.", BidNo);
                    BidPrices.Validate("Customer No.", SalesHeader."End Customer");
                end;
                case TempCSVBuffer."Field No." of
                    1:
                        begin
                            if TempCSVBuffer.value = '' then
                                Error('Vendor Item No. is missing on line %1', TempCSVBuffer."Line No.");
                            Bid.Get(BidNo);
                            Item.SetRange("Vendor No.", bid."Vendor No.");
                            Item.Setrange("Vendor Item No.", TempCSVBuffer.Value);
                            if Item.FindFirst() then
                                BidPrices.Validate("item No.", Item."No.")
                            else
                                error('Item does not exists for vendor item no %1 or vendor no. %2', TempCSVBuffer.Value, bid."Vendor No.");
                        end;
                    2:
                        begin
                            if TempCSVBuffer.value = '' then
                                Error('Quantity is missing on line %1', TempCSVBuffer."Line No.");
                            Evaluate(Qty, TempCSVBuffer.Value);
                            Quantity := qty;
                        end;
                    3:
                        begin
                            if TempCSVBuffer.Value <> '' then begin
                                Evaluate(UnitPriceSell, TempCSVBuffer.Value);
                                BidPrices.Validate("Bid Unit Sales Price", UnitPriceSell);
                            end;
                        end;
                    4:
                        begin
                            if TempCSVBuffer.value <> '' then begin
                                Evaluate(UnitPriceBuy, TempCSVBuffer.Value);
                                BidPrices.Validate("Bid Unit Purchase Price", UnitPriceBuy);
                            end;
                        end;
                    5:
                        begin
                            if TempCSVBuffer.value <> '' then
                                BidPrices.Validate("Currency Code", TempCSVBuffer.Value);
                            BidPrices.Insert(true);
                            CreateSalesLines(Salesheader, BidPrices, Quantity, GlobalCounter);
                        end;
                end;
            until TempCSVBuffer.next = 0;

        TempCSVBuffer.Reset;

        CreatePurchaseOrderFromSalesOrder(TempCSVBuffer, SalesHeader, 1); //Opret køb

        TempCSVBuffer.DeleteAll();        //delete TempCSVbuffer when finish            
    end;

    procedure ImportItems()
    var
        TempCSVBuffer: record "CSV Buffer" temporary;
        ConfigTemplateHeader: Record "Config. Template Header";
        Item: Record Item;
        DimCodeArr: array[4] of Code[20];
        DimSetEntry: Record "Dimension Set Entry" temporary;
    begin
        TempCSVBuffer.init;
        SelectFileFromFileShare(TempCSVBuffer);

        TempCSVBuffer.SetFilter("Line No.", '%1', 1);
        TempCSVBuffer.SetRange("Field No.", 12, 15);
        if TempCSVBuffer.FindSet then
            repeat
                DimCodeArr[TempCSVBuffer."Field No." - 11] := TempCSVBuffer.Value;
            until TempCSVBuffer.Next() = 0;

        TempCSVBuffer.SetRange("Field No.");
        TempCSVBuffer.SetFilter("Line No.", '<>%1', 1);
        if TempCSVBuffer.FindSet() then
            repeat
                case TempCSVBuffer."Field No." of
                    1:
                        begin
                            CreateItem(Item, ConfigTemplateHeader, DimSetEntry);
                            Item.Description := TempCSVBuffer.Value;
                        end;
                    2:
                        begin
                            Item."Description 2" := TempCSVBuffer.Value;
                        end;
                    3:
                        begin
                            ConfigTemplateHeader.Get(TempCSVBuffer.Value)
                        end;
                    4:
                        begin
                            Item."Global Dimension 1 Code" := TempCSVBuffer.Value;
                        end;
                    5:
                        begin
                            Item."Item Disc. Group" := TempCSVBuffer.Value;
                        end;
                    6:
                        begin
                            Item."Vendor No." := TempCSVBuffer.Value;
                        end;
                    7:
                        begin
                            //Field 32 pt. da denne opdaterer 50004
                            Item."Vendor Item No." := TempCSVBuffer.Value;
                        end;
                    8:
                        begin
                            if Evaluate(Item."Net Weight", TempCSVBuffer.Value) then;
                        end;
                    9:
                        begin
                            if Evaluate(Item."Transfer Price %", TempCSVBuffer.Value) then;
                        end;
                    10:
                        begin
                            if Evaluate(Item."Use on Website", TempCSVBuffer.Value) then;
                        end;
                    11:
                        begin
                            Item."Default Location" := TempCSVBuffer.Value;
                        end;
                    else begin
                            if TempCSVBuffer.Value <> '' then begin

                                DimSetEntry.Init();
                                DimSetEntry."Dimension Set ID" := 0;
                                DimSetEntry.Validate("Dimension Code", DimCodeArr[TempCSVBuffer."Field No." - 11]);
                                DimSetEntry.Validate("Dimension Value Code", TempCSVBuffer.Value);
                                DimSetEntry.Insert(true);
                            end;
                        end;
                end;
            until TempCSVBuffer.next = 0;
        CreateItem(Item, ConfigTemplateHeader, DimSetEntry);
        DimSetEntry.Reset();
        DimSetEntry.DeleteAll();

        TempCSVBuffer.Reset;
        TempCSVBuffer.DeleteAll();        //delete TempCSVbuffer when finish            
    end;

    local Procedure CreateItem(var tmpItem: Record Item; var ConfigTemplateHeader: Record "Config. Template Header"; var DimSetEntry: Record "Dimension Set Entry")
    var
        Item: Record Item;
        ConfigTemplateManagement: Codeunit "Config. Template Management";
        ItemRecRef: RecordRef;
        DimensionsTemplate: Record "Dimensions Template";
        DefDim: Record "Default Dimension";
    begin
        if not DimSetEntry.IsTemporary() then
            exit; //DimSetEntry SKAL være temporer

        if (tmpItem.Description = '') then
            exit;

        Item.SetRange("Vendor No.", tmpItem."Vendor No.");
        Item.Setrange("Vendor Item No.", tmpItem."Vendor Item No.");
        if Item.FindFirst() then
            Error('Combination of Vendor %1 and Vendor Item No. %2 already exists', tmpItem."Vendor No.", tmpItem."Vendor Item No.");

        Clear(Item);
        Item.Insert(true);
        Item.Validate(Description, tmpItem.Description);
        Item.Validate("Description 2", tmpItem."Description 2");
        Item.Validate("Vendor No.", tmpItem."Vendor No.");
        Item.Validate("Vendor Item No.", tmpItem."Vendor Item No.");
        Item.Validate("Item Disc. Group", tmpItem."Item Disc. Group");
        Item.Validate("Net Weight", tmpItem."Net Weight");
        Item.Validate("Transfer Price %", tmpItem."Transfer Price %");
        Item.Validate("Use on Website", tmpItem."Use on Website");
        Item.Validate("Default Location", tmpItem."Default Location");
        Item.Validate("Global Dimension 1 Code", tmpItem."Global Dimension 1 Code");
        Item.Modify(true);

        ItemRecRef.GetTable(Item);

        ConfigTemplateManagement.UpdateRecord(ConfigTemplateHeader, ItemRecRef);
        DimensionsTemplate.InsertDimensionsFromTemplates(ConfigTemplateHeader, Item."No.", DATABASE::Item);

        if DimSetEntry.FindSet() then
            repeat
                if DimSetEntry."Dimension Value Code" <> '' then begin
                    DefDim.Reset();
                    DefDim.SetRange("Table ID", Database::Item);
                    DefDim.SetRange("No.", Item."No.");
                    DefDim.SetRange("Dimension Code", DimSetEntry."Dimension Code");

                    if not DefDim.FindFirst() then begin
                        DefDim.Init;
                        DefDim.Validate("Table ID", Database::Item);
                        DefDim.Validate("No.", Item."No.");
                        DefDim.Validate("Dimension Code", DimSetEntry."Dimension Code");
                        DefDim.Insert(true);
                    end;
                    DefDim.Validate("Dimension Value Code", DimSetEntry."Dimension Value Code");
                    DefDim.Modify(true);
                end;
            until DimSetEntry.Next() = 0;

        //Nulstil så vi ved det er næste record
        Clear(ConfigTemplateHeader);
        Clear(tmpItem);
        Clear(DimSetEntry);
        DimSetEntry.DeleteAll();
    end;
}