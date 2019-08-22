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
                textelement(CarrierCodeTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        CarrierCodeTxt := 'Carrier Code';
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
                textelement(OrderNumberTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        OrderNumberTxt := 'OrderNumber';
                    end;
                }
                textelement(AdditionalOrderNumberTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        AdditionalOrderNumberTxt := 'Additional OrderNumber';
                    end;
                }
                /* textelement(MessageToCarrierTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        MessageToCarrierTxt := 'Message To Carrier';
                    end;
                } */
                textelement(MessageToReceiverTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        MessageToReceiverTxt := 'Message To Receiver';
                    end;
                }
                /* textelement(MessageToDriverTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        MessageToCarrierTxt := 'Message To Driver';
                    end;
                } */
                textelement(ReceiverRefTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ReceiverRefTxt := 'ReceiverRef';
                    end;
                }

                textelement(ReceiverName1Txt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ReceiverName1Txt := 'Receiver Name 1';
                    end;
                }
                textelement(ReceiverName2Txt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ReceiverName2Txt := 'Receiver Name 2';
                    end;
                }
                textelement(ReceiverAttentionTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ReceiverAttentionTxt := 'Receiver Attention';
                    end;
                }
                textelement(ReceiverAddress1Txt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ReceiverAddress1Txt := 'Receiver Address 1';
                    end;
                }
                textelement(ReceiverAddress2Txt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ReceiverAddress2Txt := 'Receiver Address 2';
                    end;
                }
                textelement(ReceiverPostNoTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ReceiverPostNoTxt := 'Receiver Post No.';
                    end;
                }
                textelement(ReceiverCityTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ReceiverCityTxt := 'Receiver City';
                    end;
                }
                textelement(ReceiverCountryTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ReceiverCountryTxt := 'Receiver Country';
                    end;
                }
                textelement(ReceiverPhoneTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ReceiverPhoneTxt := 'Receiver Phone';
                    end;
                }
                textelement(ReceiverFaxTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ReceiverFaxTxt := 'Receiver Fax';
                    end;
                }
                textelement(ReceiverMobileTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ReceiverMobileTxt := 'Receiver Mobile';
                    end;
                }
                textelement(ReceiverEmailTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ReceiverEmailTxt := 'Receiver Email';
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
                textelement(NumberLineTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        NumberLineTxt := 'Number of Labels';
                    end;
                }
            }

            tableelement(Integer; Integer)
            {


                Textelement(Carriercode)
                {

                }
                /* fieldelement(Services; SalesHeader."Shipping Agent Service Code")
                {

                } */
                Textelement(ActorAlias)
                {
                    //Hvilken konto der skal bruges hos de forskellige transportører 
                }
                Textelement(OrderNumber)
                {

                }
                Textelement(PostedSalesShipNo)
                {

                }
                /* Textelement(MessageToCarrier)
                {

                } */
                Textelement(MessageToReceiver)
                {

                }
                // Textelement(MessageToDriver)
                // {

                // }
                Textelement(ReceiverRef)
                {

                }

                Textelement(ReceiverName1)
                {

                }
                Textelement(ReceiverName2)
                {

                }
                Textelement(ReceiverAttention)
                {

                }
                Textelement(ReceiverAddress1)
                {

                }
                Textelement(ReceiverAddres2)
                {

                }
                Textelement(ReceiverPostNo)
                {

                }
                Textelement(ReceiverCity)
                {

                }
                Textelement(ReceiverCountry)
                {

                }
                Textelement(ReceiverPhone)
                {

                }
                Textelement(ReceiverFax)
                {

                }
                Textelement(ReceiverMobile)
                {

                }
                Textelement(ReceiverEmail)
                {

                }
                Textelement(VAT)
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

                textelement(GoodsTypeLine)
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
                Textelement(CustomsInfoCurrency)
                {
                    // salesheader currency
                }
                /* textelement(ReasonForExport)
                {

                } */
                textelement(NumberLine)
                {
                    //Antallet af pakker/enheder på godslinjen
                }

                trigger OnPreXmlItem()
                var
                    ConsignorLabel: record "Consignor Label Information";
                begin
                    if not SalesHeader.get(NewDocType, NewSalesHeaderNo) then
                        exit;
                    ConsignorLabel.setrange("Sales Order No.", SalesHeader."No.");
                    if ConsignorLabel.FindSet() then
                        Integer.setrange(Number, 1, ConsignorLabel.Count)
                    else
                        currXMLport.skip;
                end;

                trigger OnAfterGetRecord()
                var
                    CompanyInfo: record "Company Information";
                    ShippingAgent: record "Shipping Agent";
                    ShipAgentService: record "Shipping Agent Services";
                    ConsignorLabel: record "Consignor Label Information";
                    SalesShipmentHeader: record "Sales Shipment Header";
                    SalesShipmentLine: record "Sales Shipment Line";
                    SalesLine: record "Sales Line";
                    NoOfUnits: Decimal;
                    UnitValueDec: Decimal;
                    Location: record Location;
                    SalesReceive: record "Sales & Receivables Setup";
                    GlSetup: record "General Ledger Setup";
                begin
                    if not SalesReceive.get then
                        exit;
                    if not CompanyInfo.get then
                        exit;
                    if not GlSetup.get then
                        exit;

                    Carriercode := SalesHeader."Shipping Agent Code";
                    if SalesHeader."Currency Code" = '' then
                        CustomsInfoCurrency := GlSetup."LCY Code"
                    else
                        CustomsInfoCurrency := SalesHeader."Currency Code";
                    MessageToReceiver := SalesHeader."Ship-to Comment"; //End Customer PO ref
                    OrderNumber := SalesHeader."No.";
                    ReceiverAddress1 := SalesHeader."Ship-to Address";
                    ReceiverAddres2 := SalesHeader."Ship-to Address 2";
                    ReceiverAttention := SalesHeader."Ship-to Contact";
                    ReceiverCity := SalesHeader."Ship-to City";
                    ReceiverCountry := SalesHeader."Ship-to Country/Region Code";
                    ReceiverEmail := SalesHeader."Ship-to Email";
                    ReceiverFax := SalesHeader."OIOUBL-Sell-to Contact Fax No.";
                    ReceiverMobile := SalesHeader."Ship-to Phone No.";
                    ReceiverName1 := SalesHeader."Ship-to Name";
                    ReceiverName2 := SalesHeader."Ship-to Name 2";
                    ReceiverPhone := SalesHeader."Ship-to Phone No.";
                    ReceiverPostNo := SalesHeader."Ship-to Post Code";
                    if SalesShipmentHeader.get(PostedSalesShipNo) then
                        ReceiverRef := SalesShipmentHeader."External Document No."; //Reseller PO Ref
                    VAT := SalesHeader."VAT Registration No.";

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
                        GoodsTypeLine := format(ConsignorLabel."Goods Type");
                    end;
                    ConsignorLabel.Delete();

                    Location.setrange("Require Pick", true);
                    if Location.findset then
                        repeat
                            SalesShipmentLine.setrange("Document No.", PostedSalesShipNo);
                            SalesShipmentLine.SetRange("Location Code", Location.Code);
                            SalesShipmentLine.setfilter("No.", '<>%1', SalesReceive."Freight Item");
                            SalesShipmentLine.setfilter(Quantity, '<>0');
                            if SalesShipmentLine.FindSet() then
                                repeat
                                    NoOfUnits := NoOfUnits + SalesShipmentLine.Quantity;
                                    if SalesLine.get(SalesHeader."Document Type", SalesShipmentLine."Order No.", SalesShipmentLine."Order Line No.") then
                                        UnitValueDec := UnitValueDec + (SalesLine."Unit Price" * SalesShipmentLine.Quantity);
                                until SalesShipmentLine.next = 0;
                        Until Location.next = 0;

                    NoUnit := format(NoOfUnits);
                    UnitValue := format(UnitValueDec);
                end;


            }

            tableelement(Integer2; Integer)
            {
                SourceTableView = SORTING (Number) WHERE (Number = CONST (0));

            }

        }

    }

    Procedure SetPostedSalesShipmentNo(No: code[20])
    begin
        NewPostedSalesShipmentNo := No;
    end;

    procedure SetSalesHeaderNoDocType(No: code[20]; DocType: Integer)
    begin
        NewSalesHeaderNo := No;
        NewDocType := DocType;
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
        NewSalesHeaderNo: code[20];
        NewDocType: integer;
        SalesHeader: record "Sales Header";
}