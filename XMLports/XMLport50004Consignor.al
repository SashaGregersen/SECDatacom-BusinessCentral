xmlport 50004 "Consignor"
{

    Direction = export;
    TextEncoding = UTF8;
    Format = VariableText;
    FieldDelimiter = '';
    FieldSeparator = ';';
    TableSeparator = '<NewLine>';
    schema
    {
        textelement(SalesOrder)
        {
            tableelement(ItemTableTitle; integer)
            {
                SourceTableView = SORTING (Number) WHERE (Number = CONST (1));
                textelement(CarrierCode)
                {
                    trigger OnBeforePassVariable()
                    begin
                        CarrierCode := 'Carrier Code';
                    end;
                }
                /* textelement(Services)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Services := 'Service';
                    end;
                } */
                textelement(ActorAliasTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ActorAliasTxt := 'Actor Alias';
                    end;
                }
                textelement(OrderNumber)
                {
                    trigger OnBeforePassVariable()
                    begin
                        OrderNumber := 'OrderNumber';
                    end;
                }
                textelement(AdditionalOrderNumber)
                {
                    trigger OnBeforePassVariable()
                    begin
                        AdditionalOrderNumber := 'Additional OrderNumber';
                    end;
                }
                textelement(MessageToCarrier)
                {
                    trigger OnBeforePassVariable()
                    begin
                        MessageToCarrier := 'Message To Carrier';
                    end;
                }
                textelement(MessageToReceiver)
                {
                    trigger OnBeforePassVariable()
                    begin
                        MessageToCarrier := 'Message To Receiver';
                    end;
                }
                textelement(MessageToDriver)
                {
                    trigger OnBeforePassVariable()
                    begin
                        MessageToCarrier := 'Message To Driver';
                    end;
                }
                textelement(ReceiverRef)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ReceiverRef := 'ReceiverRef';
                    end;
                }

                textelement(ReceiverName1)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ReceiverName1 := 'Receiver Name 1';
                    end;
                }
                textelement(ReceiverName2)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ReceiverName2 := 'Receiver Name 2';
                    end;
                }
                textelement(ReceiverAttention)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ReceiverAttention := 'Receiver Attention';
                    end;
                }
                textelement(ReceiverAddress1)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ReceiverAddress1 := 'Receiver Address 1';
                    end;
                }
                textelement(ReceiverAddress2)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ReceiverAddress2 := 'Receiver Address 2';
                    end;
                }
                textelement(ReceiverPostNo)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ReceiverPostNo := 'Receiver Post No.';
                    end;
                }
                textelement(ReceiverCity)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ReceiverCity := 'Receiver City';
                    end;
                }
                textelement(ReceiverCountry)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ReceiverCountry := 'Receiver Country';
                    end;
                }
                textelement(ReceiverPhone)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ReceiverPhone := 'Receiver Phone';
                    end;
                }
                textelement(ReceiverFax)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ReceiverFax := 'Receiver Fax';
                    end;
                }
                textelement(ReceiverMobile)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ReceiverMobile := 'Receiver Mobile';
                    end;
                }
                textelement(ReceiverEmail)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ReceiverEmail := 'Receiver Email';
                    end;
                }
                textelement(VATTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        VATTxt := 'VAT';
                    end;
                }
                textelement(SenderName1Txt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        SenderName1Txt := 'Sender Name 1';
                    end;
                }
                textelement(SenderAddress1Txt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        SenderAddress1Txt := 'Sender Address 1';
                    end;
                }
                textelement(SenderAddress2Txt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        SenderAddress2Txt := 'Sender Address 2';
                    end;
                }
                textelement(SenderPostNoTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        SenderPostNoTxt := 'Sender Post No.';
                    end;
                }
                textelement(SenderCityTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        SenderCityTxt := 'Sender City';
                    end;
                }
                textelement(SenderCountryTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        SenderCountryTxt := 'Sender Country';
                    end;
                }
                textelement(NumberLineTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        NumberLineTxt := 'Number of Labels';
                    end;
                }
                textelement(GoodsTypeLineTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        GoodsTypeLineTxt := 'GoodsType';
                    end;
                }
                textelement(WeightTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        WeightTxt := 'Weight';
                    end;
                }
                /* textelement(ContentsTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ContentsTxt := 'Contents';
                    end;
                } */
                textelement(LengthTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        LengthTxt := 'Length';
                    end;
                }
                textelement(WidthTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        WidthTxt := 'Width';
                    end;
                }
                textelement(HeightTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        HeightTxt := 'Height';
                    end;
                }
                textelement(VolumeTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        VolumeTxt := 'Volume';
                    end;
                }
                textelement(NoUnitTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        NoUnitTxt := 'No. Unit';
                    end;
                }
                /* textelement(UnitOfMeasurementTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        UnitOfMeasurementtxt := 'Unit of Measurement';
                    end;
                } */
                /* textelement(DescriptionTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Descriptiontxt := 'Description';
                    end;
                } */
                /* textelement(CountryofOriginTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        CountryofOrigintxt := 'CountryofOrigin';
                    end;
                } */
                textelement(UnitValueTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        UnitValueTxt := 'Unit Value';
                    end;
                }
                textelement(CustomsInfoCurrencyTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        CustomsInfoCurrencyTxt := 'Customs Info Currency';
                    end;
                }
                /* textelement(ReasonForExportTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ReasonForExportTxt := 'Reason For Export';
                    end;
                } */
            }
            tableelement(SalesHeader; "Sales Header")
            {

                fieldelement(Carriercode; SalesHeader."Shipping Agent Code")
                {

                }
                /* fieldelement(Services; SalesHeader."Shipping Agent Service Code")
                {

                } */
                Textelement(ActorAlias)
                {
                    //Hvilken konto der skal bruges hos de forskellige transportører 
                }
                fieldelement(OrderNumber; SalesHeader."No.")
                {

                }
                textelement(PostedSalesShipNo)
                {

                }
                fieldelement(MessageToCarrier; SalesHeader."Ship-to Comment")
                {

                }
                fieldelement(MessageToReceiver; SalesHeader."Ship-to Comment")
                {

                }
                fieldelement(MessageToDriver; SalesHeader."Ship-to Comment")
                {

                }
                fieldelement(ReceiverRef; SalesHeader."External Document No.")
                {

                }

                fieldelement(ReceiverName1; SalesHeader."Ship-to Name")
                {

                }
                fieldelement(ReceiverName2; SalesHeader."Ship-to Name 2")
                {

                }
                fieldelement(ReceiverAttention; SalesHeader."Ship-to Contact")
                {

                }
                fieldelement(ReceiverAddress1; SalesHeader."Ship-to Address")
                {

                }
                fieldelement(ReceiverAddres2; SalesHeader."Ship-to Address 2")
                {

                }
                fieldelement(ReceiverPostNo; SalesHeader."Ship-to Post Code")
                {

                }
                fieldelement(ReceiverCity; SalesHeader."Ship-to City")
                {

                }
                fieldelement(ReceiverCountry; SalesHeader."Ship-to Country/Region Code")
                {

                }
                fieldelement(ReceiverPhone; SalesHeader."Ship-to Phone No.")
                {

                }
                fieldelement(ReceiverFax; SalesHeader."OIOUBL-Sell-to Contact Fax No.")
                {

                }
                fieldelement(ReceiverMobile; SalesHeader."Ship-to Phone No.")
                {

                }
                fieldelement(ReceiverEmail; SalesHeader."Ship-to Email")
                {

                }
                fieldelement(VAT; SalesHeader."VAT Registration No.")
                {

                }
                textelement(SenderName1)
                {

                }
                textelement(SenderAddress1)
                {

                }
                textelement(SenderAddress2)
                {

                }
                textelement(SenderPostNo)
                {

                }
                textelement(SenderCity)
                {

                }
                textelement(SenderCountry)
                {

                }
                textelement(NumberLine)
                {
                    //Antallet af pakker/enheder på godslinjen
                }
                fieldelement(GoodsTypeLine; SalesHeader."Shipping Agent Service Code")
                {
                    //Godstype, definerer typen på pakken/godset, fx palle, tønde, box osv.
                }
                textelement(Weight)
                {

                }
                /* textelement(Contents)
                {

                } */
                textelement(Length)
                {
                    //hentes fra ny tabel
                }
                textelement(Width)
                {
                    //hentes fra ny tabel
                }
                textelement(Height)
                {
                    //hentes fra ny tabel
                }
                textelement(Volume)
                {
                    //hentes fra ny tabel
                }
                // skal udfyldes ved afsendelse til NOK
                textelement(NoUnit)
                {

                }
                /* textelement(UnitOfMeasurement)
                {
                    // PC - Piece - hentes fra inventory setup
                } */
                /* textelement(Description)
                {
                    //beskrivelse af varer i pakke
                } */
                /* textelement(CountryofOrigin)
                {
                    //hentes fra varekortet - hvad hvis der er forskellige?
                } */
                textelement(UnitValue)
                {
                    //hentes fra ny tabel
                }
                fieldelement(CustomsInfoCurrency; SalesHeader."Currency Code")
                {
                    // salesheader currency
                }
                /* textelement(ReasonForExport)
                {

                } */
                trigger OnAfterGetRecord()
                var
                    CompanyInfo: record "Company Information";
                    ShippingAgent: record "Shipping Agent";
                    ShipAgentService: record "Shipping Agent Services";
                    ConsignorLabel: record "Consignor Label Information";
                    SalesShipmentLine: record "Sales Shipment Line";
                    SalesLine: record "Sales Line";
                    NoOfUnits: Decimal;
                    UnitValueDec: Decimal;
                begin
                    CompanyInfo.get;
                    if ShippingAgent.get(SalesHeader."Shipping Agent Code") then
                        ActorAlias := ShippingAgent."Account No.";
                    PostedSalesShipNo := NewPostedSalesShipmentNo;
                    SenderName1 := CompanyInfo."Ship-to Name";
                    SenderAddress1 := CompanyInfo."Ship-to Address";
                    SenderAddress2 := CompanyInfo."Ship-to Address 2";
                    SenderCity := CompanyInfo."Ship-to City";
                    SenderCountry := CompanyInfo."Ship-to Country/Region Code";
                    SenderPostNo := CompanyInfo."Ship-to Post Code";
                    ConsignorLabel.setrange("Sales Order No.", SalesHeader."No.");
                    if ConsignorLabel.FindFirst() then begin
                        NumberLine := format(ConsignorLabel."Number of Labels");
                        Weight := format(ConsignorLabel.Weight);
                        Length := format(ConsignorLabel.Length);
                        Height := format(ConsignorLabel.Height);
                        Width := format(ConsignorLabel.Width);
                        Volume := format(ConsignorLabel.Volume);
                        ConsignorLabel.Delete();
                    end;
                    SalesShipmentLine.setrange("Document No.", PostedSalesShipNo);
                    SalesShipmentLine.setfilter(Quantity, '<>0');
                    if SalesShipmentLine.FindSet() then
                        repeat
                            NoOfUnits := NoOfUnits + SalesShipmentLine.Quantity;
                            if SalesLine.get(SalesHeader."Document Type", SalesShipmentLine."Order No.", SalesShipmentLine."Order Line No.") then
                                UnitValueDec := UnitValueDec + (SalesLine."Unit Price" * SalesShipmentLine.Quantity);
                        until SalesShipmentLine.next = 0;

                    NoUnit := format(NoOfUnits);
                    UnitValue := format(UnitValueDec);
                end;
            }

            tableelement(Integer; Integer)
            {
                SourceTableView = SORTING (Number) WHERE (Number = CONST (0));

            }

        }

    }

    Procedure SetPostedSalesShipmentNo(No: code[20])
    begin
        NewPostedSalesShipmentNo := No;
    end;


    procedure CreateFileLocation(SalesHeader: record "Sales Header"; SalesReceive: record "Sales & Receivables Setup"): Text
    var
        PriceFileExport: Report "Price File Export Customer";
        CurrDate: Text;
        CurrTime: Text;
    begin
        exit(SalesReceive."Consignor Path" + SalesHeader."No." + '_' + format(CurrentDateTime, 0, '<Day,2>-<Month,2>-<Year4>_<Hours24,2><Minutes,2><Seconds,2>') + '.csv');
    end;


    var
        NewPostedSalesShipmentNo: code[20];

}