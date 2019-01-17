codeunit 50003 "Project Sales Import"
{
    trigger OnRun()
    begin

    end;

    var

    procedure ImportSalesOrderFromCSV(SalesHeader: record "Sales Header")
    var
        TempCSVBuffer: record "CSV Buffer" temporary;
        Bid: record Bid;
    begin
        TempCSVBuffer.Init();
        TempCSVBuffer.LoadData('C:\Project-Sales\Projektsalg.csv', ';');

        CreateSalesHeaderFromCSV(TempCSVBuffer, SalesHeader, Bid);
        CreateSalesLineFromBid(TempCSVBuffer, SalesHeader, Bid);
        CreatePurchaseOrder(TempCSVBuffer, SalesHeader);

        TempCSVBuffer.DeleteAll();        //delete TempCSVbuffer when finish            
    end;

    local procedure CreateSalesHeaderFromCSV(var TempCSVBuffer: record "CSV Buffer" temporary; var SalesHeader: record "Sales Header"; var Bid: record Bid)
    var
        Dropship: Boolean;
        Customer: record Customer;
        Claim: Boolean;
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
                            // expiry date? 
                            if TempCSVBuffer.value <> '' then
                                SalesHeader.Validate("End Customer", TempCSVBuffer.Value);
                        end;
                    2:
                        begin
                            if TempCSVBuffer.value = '' then
                                Error('%1 is missing on line %2', TempCSVBuffer."Field No.", TempCSVBuffer."Line No.");
                            SalesHeader.Validate(Reseller, TempCSVBuffer.Value);
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
                            if TempCSVBuffer.value = '' then
                                Error('%1 is missing on line %2', TempCSVBuffer."Field No.", TempCSVBuffer."Line No.");
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
                                Error('%1 is missing on line %2', TempCSVBuffer."Field No.", TempCSVBuffer."Line No.");
                            Bid.Validate("Vendor No.", TempCSVBuffer.value);
                        end;
                    12:
                        begin
                            if TempCSVBuffer.value = '' then
                                Error('%1 is missing on line %2', TempCSVBuffer."Field No.", TempCSVBuffer."Line No.");
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
            until TempCSVBuffer.next = 0;
    end;

    local procedure CreateSalesLineFromBid(var TempCSVBuffer: record "CSV Buffer" temporary; Salesheader: record "Sales Header"; var Bid: record Bid)
    var
        BidPrices: record "Bid Item Price";
        NoseriesManage: Codeunit NoSeriesManagement;
        UnitPriceSell: Decimal;
        UnitPriceBuy: decimal;
        Qty: Integer;
        Quantity: Integer;
        GlobalCounter: Integer;
    begin
        TempCSVBuffer.SetFilter("Line No.", '<>%1', 1);
        if TempCSVBuffer.FindSet() then
            repeat
                if TempCSVBuffer."Field No." = 1 then begin
                    BidPrices.init;
                    BidPrices.Validate("Bid No.", bid."No.");
                end;
                case TempCSVBuffer."Field No." of
                    2:
                        begin
                            BidPrices.Validate("Customer No.", TempCSVBuffer.Value);
                        end;
                    6:
                        begin
                            if TempCSVBuffer.value = '' then
                                Error('%1 is missing on line %2', TempCSVBuffer."Field No.", TempCSVBuffer."Line No.");
                            BidPrices.Validate("item No.", TempCSVBuffer.Value);
                        end;
                    7:
                        begin
                            if TempCSVBuffer.value = '' then
                                Error('%1 is missing on line %2', TempCSVBuffer."Field No.", TempCSVBuffer."Line No.");
                            Evaluate(Qty, TempCSVBuffer.Value);
                            Quantity := qty;
                        end;
                    8:
                        begin
                            if TempCSVBuffer.value = '' then
                                Error('%1 is missing on line %2', TempCSVBuffer."Field No.", TempCSVBuffer."Line No.");
                            Evaluate(UnitPriceSell, TempCSVBuffer.Value);
                            BidPrices.Validate("Bid Unit Sales Price", UnitPriceSell);
                        end;
                    9:
                        begin
                            if TempCSVBuffer.value = '' then
                                Error('%1 is missing on line %2', TempCSVBuffer."Field No.", TempCSVBuffer."Line No.");
                            Evaluate(UnitPriceBuy, TempCSVBuffer.Value);
                            BidPrices.Validate("Bid Unit Purchase Price", UnitPriceBuy);
                        end;
                    10:
                        begin
                            if TempCSVBuffer.value = '' then
                                Error('%1 is missing on line %2', TempCSVBuffer."Field No.", TempCSVBuffer."Line No.");
                            BidPrices.Validate("Currency Code", TempCSVBuffer.Value);
                            BidPrices.Insert(true);
                            CreateSalesLines(Salesheader, BidPrices, Quantity, GlobalCounter);
                        end;
                end;

            until TempCSVBuffer.next = 0;
        Message('Sales order %1 created with %2 lines', SalesHeader."No.", GlobalCounter);
    end;

    local procedure CreateSalesLines(SalesHeader: record "Sales Header"; BidPrices: record "Bid Item Price"; Qty: Integer; var GlobalCounter: Integer)
    var
        SalesLine: record "Sales Line";
        NextLineNo: Integer;
    begin
        SalesLine.SetRange("Document No.", Salesheader."No.");
        SalesLine.SetRange("Document Type", Salesheader."Document Type");
        if not SalesLine.FindLast() then begin
            SalesLine.init;
            SalesLine."Document No." := Salesheader."No.";
            SalesLine."Document Type" := Salesheader."Document Type";
            SalesLine."Line No." := 10000;
            SalesLine.Type := SalesLine.type::Item;
            SalesLine.Validate("No.", BidPrices."item No.");
            SalesLine.Validate(Quantity, Qty);
            SalesLine.Insert(true);
            SalesLine.Validate("Bid No.", BidPrices."Bid No.");
            SalesLine.Modify(true);
            GlobalCounter := 1;
        end else begin
            NextLineNo := SalesLine."Line No." + 10000;
            SalesLine.init;
            SalesLine."Document No." := Salesheader."No.";
            SalesLine."Document Type" := Salesheader."Document Type";
            SalesLine."Line No." := NextLineNo;
            SalesLine.Type := SalesLine.type::Item;
            SalesLine.Validate("No.", BidPrices."item No.");
            SalesLine.Validate(Quantity, Qty);
            SalesLine.Insert(true);
            SalesLine.Validate("Bid No.", BidPrices."Bid No.");
            SalesLine.Modify(true);
            GlobalCounter := GlobalCounter + 1;
        end;
    end;

    local procedure CreatePurchaseOrder(TempCSVBuffer: record "CSV Buffer" temporary; SalesHeader: record "Sales Header")
    var

    begin
        TempCSVBuffer.SetRange("Line No.", 2);
        if TempCSVBuffer.FindSet() then
            repeat
                case TempCSVBuffer."Field No." of
                    14:
                        begin
                            //if TempCSVBuffer.Value <> '' then
                            //Kald funktion der opretter købsordre baseret på salgsordre med købsordre nummer fra excelark
                            //kald funktion der opretter ny købsordre
                        end;
                end;

            until TempCSVBuffer.next = 0;
    end;

}