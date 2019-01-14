codeunit 50003 "Project Sales"
{
    trigger OnRun()
    begin
        ImportSalesOrderFromCSV();
    end;

    var

    Local procedure ImportSalesOrderFromCSV()
    var
        TempCSVBuffer: record "CSV Buffer";
        SalesOrder: record "Sales Header";
        Bid: record Bid;
        BidPrices: record "Bid Item Price";
        NoseriesManage: Codeunit NoSeriesManagement;
        UnitPrice: Decimal;
    begin
        TempCSVBuffer.Init();
        TempCSVBuffer.LoadData('C:\Project-Sales\Projektsalg.csv', ';');

        TempCSVBuffer.SetFilter("Line No.", '<>%1', 1);
        if TempCSVBuffer.FindSet() then
            repeat
                Bid.Init();
                Bid.Validate("No.", NoseriesManage.GetNextNo('Bid', today, true));
                Bid.Validate(Description, 'Project Sale');
                Bid.Insert();
                // expiry date?                    

                BidPrices.Init();
                BidPrices.Validate("Bid No.", bid."No.");
                BidPrices.Insert();

                case TempCSVBuffer."Field No." of
                    1:
                        BidPrices.Validate("item No.", TempCSVBuffer.Value);
                    2:
                        begin
                            Evaluate(UnitPrice, TempCSVBuffer.Value);
                            BidPrices.Validate("Unit List Price", UnitPrice);
                        end;
                    3:
                        Bid.Validate("Vendor No.", TempCSVBuffer.value);
                    4:
                        Bid.Validate("Vendor Bid No.", TempCSVBuffer.Value); // spørg Mette om hun har dette                     
                    6:
                        begin
                            Bid.Modify();
                            BidPrices.Modify();
                        end;
                end;

            until TempCSVBuffer.next = 0;
        TempCSVBuffer.DeleteAll();        //delete TempCSVbuffer when finish            
    end;
}