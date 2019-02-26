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

        Salesline.setrange("Document No.", SalesHeader."No.");
        Salesline.SetRange("Document Type", SalesHeader."Document Type");
        if Salesline.FindFirst() then begin
            TestCSVBufferFields(TempCSVBuffer);
            CreateSalesLineFromBid(TempCSVBuffer, SalesHeader, Salesline."Bid No.");
            CreatePurchaseOrderFromSalesOrder(TempCSVBuffer, SalesHeader);
        end else begin
            CreateSalesHeaderFromCSV(TempCSVBuffer, SalesHeader, BidNo);
            CreateSalesLineFromBid(TempCSVBuffer, SalesHeader, BidNo);
            CreatePurchaseOrderFromSalesOrder(TempCSVBuffer, SalesHeader);
        end;

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
        Item: record item;
        bid: record bid;
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

    local procedure CreatePurchaseOrderFromSalesOrder(Var TempCSVBuffer: record "CSV Buffer" temporary; SalesHeader: record "Sales Header")
    var
        PurchOrder: record "Purchase Header";
        PurchFromSales: codeunit "Create Purchase Order";
        PurchLine: record "Purchase Line";
        VendorNo: code[20];
        VendorBidNo: Code[20];
        CurrencyCode: code[20];
        SalesLine: record "Sales Line";
        GlobalCounter: Integer;
    begin
        TempCSVBuffer.SetRange("Line No.", 2);
        if TempCSVBuffer.FindSet() then
            repeat
                case TempCSVBuffer."Field No." of
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
                                if SalesLine.findset then
                                    repeat
                                        PurchFromSales.CreatePurchLine(PurchOrder, SalesHeader, SalesLine, PurchLine);
                                        PurchFromSales.ReserveItemOnPurchOrder(SalesLine, PurchLine);
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
                                if SalesLine.findset then begin
                                    repeat
                                        SalesLine.CalcFields("Reserved Quantity");
                                        if SalesLine."Reserved Quantity" = 0 then begin
                                            PurchFromSales.CreatePurchLine(PurchOrder, SalesHeader, SalesLine, PurchLine);
                                            PurchFromSales.ReserveItemOnPurchOrder(Salesline, PurchLine);
                                            GlobalCounter := GlobalCounter + 1;
                                        end;
                                    until SalesLine.next = 0;
                                    Message('%1 lines inserted on purchase order %2', GlobalCounter, PurchOrder."No.");
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

}