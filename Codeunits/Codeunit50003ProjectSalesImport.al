codeunit 50003 "Project Sales Import"
{
    trigger OnRun()
    begin
        ImportSalesOrderFromCSV();
    end;

    var

    Local procedure ImportSalesOrderFromCSV()
    var
        TempCSVBuffer: record "CSV Buffer" temporary;
        SalesHeader: record "Sales Header";
    begin
        TempCSVBuffer.Init();
        TempCSVBuffer.LoadData('C:\Project-Sales\Projektsalg.csv', ';');

        CreateSalesHeaderFromCSV(TempCSVBuffer, SalesHeader);
        CreateSalesLineFromBid(TempCSVBuffer, SalesHeader);

        TempCSVBuffer.DeleteAll();        //delete TempCSVbuffer when finish            
    end;

    local procedure CreateSalesHeaderFromCSV(var TempCSVBuffer: record "CSV Buffer" temporary; var SalesHeader: record "Sales Header")
    var
        Dropship: Boolean;
    begin
        SalesHeader.init;
        SalesHeader."No." := '';
        SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
        SalesHeader.Insert(true);

        TempCSVBuffer.SetRange("Line No.", 2);
        if TempCSVBuffer.FindSet() then
            repeat
                case TempCSVBuffer."Field No." of
                    1:
                        SalesHeader.Validate("End Customer", TempCSVBuffer.Value);
                    2:
                        begin
                            SalesHeader.Validate("Financing Partner", TempCSVBuffer.Value);
                            SalesHeader.Modify(true);
                        end;
                    3:
                        SalesHeader.Validate(Reseller, TempCSVBuffer.Value);
                    4:
                        SalesHeader.Validate("External Document No.", TempCSVBuffer.Value);
                    5:
                        begin
                            Evaluate(Dropship, TempCSVBuffer.Value);
                            SalesHeader.Validate("Drop-Shipment", Dropship);
                        end;
                end;
                SalesHeader.Modify(true);
            until TempCSVBuffer.next = 0;
    end;

    local procedure CreateSalesLineFromBid(var TempCSVBuffer: record "CSV Buffer" temporary; Salesheader: record "Sales Header")
    var
        BidPrices: record "Bid Item Price";
        Bid: record Bid;
        NoseriesManage: Codeunit NoSeriesManagement;
        UnitPriceSell: Decimal;
        UnitPriceBuy: decimal;
        Qty: Integer;
        Quantity: Integer;
    begin
        TempCSVBuffer.SetFilter("Line No.", '<>%1', 1);
        if TempCSVBuffer.FindSet() then
            repeat
                if TempCSVBuffer."Field No." = 1 then begin
                    Bid.Init();
                    Bid.Validate("No.", NoseriesManage.GetNextNo('Bid', today, true));
                    Bid.Validate(Description, 'Project Sale');
                    Bid.Insert(true);
                    // expiry date? 

                    BidPrices.init;
                    BidPrices.Validate("Bid No.", bid."No.");

                end;
                case TempCSVBuffer."Field No." of
                    3:
                        begin
                            BidPrices.Validate("Customer No.", TempCSVBuffer.Value); // er dette reseller nummer?                       
                        end;
                    6:
                        begin
                            BidPrices.Validate("item No.", TempCSVBuffer.Value);
                        end;
                    7:
                        begin
                            Evaluate(Qty, TempCSVBuffer.Value);
                            Quantity := qty;
                        end;
                    8:
                        begin
                            Evaluate(UnitPriceSell, TempCSVBuffer.Value);
                            BidPrices.Validate("Bid Unit Sales Price", UnitPriceSell);
                        end;
                    9:
                        begin
                            Evaluate(UnitPriceBuy, TempCSVBuffer.Value);
                            BidPrices.Validate("Bid Unit Purchase Price", UnitPriceBuy);
                        end;
                    10:
                        begin
                            Bid.Validate("Vendor No.", TempCSVBuffer.value);
                        end;
                    11:
                        begin
                            Bid.Validate("Vendor Bid No.", TempCSVBuffer.Value);
                            Bid.Modify(true);
                            BidPrices.Insert(true);
                            CreateSalesLines(Salesheader, BidPrices, Quantity);
                        end;
                end;

            until TempCSVBuffer.next = 0;

    end;

    local procedure CreateSalesLines(SalesHeader: record "Sales Header"; BidPrices: record "Bid Item Price"; Qty: Integer)
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
        end;
    end;
}