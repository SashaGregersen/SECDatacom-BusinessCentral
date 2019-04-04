dotnet
{
    assembly(mscorlib)
    {
        //Version='4.0.0.0';
        //Culture='neutral';
        //PublicKeyToken='b77a5c561934e089';
        type(System.Text.Encoding; mscorlib_System_Text_Encoding) { }
        type(System.Array; mscorlib_System_Array) { } //"'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Array"
        type(System.Convert; mscorlib_System_Convert) { } //"'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Convert"
        type(System.IO.MemoryStream; mscorlib_System_IO_MemoryStream) { } //"'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.MemoryStream"
        type(System.EventArgs; mscorlib_System_EventArgs) { } //"'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.EventArgs"
        type(System.IO.StreamReader; mscorlib_System_IO_StreamReader) { } //"'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.StreamReader"
        type(System.IO.StringWriter; mscorlib_System_IO_StringWriter) { }
        type(System.IO.StreamWriter; mscorlib_System_IO_StreamWriter) { }
    }
    assembly(System)
    {
        //Version = '4.0.0.0';
        //Culture = 'neutral';
        //PublicKeyToken = 'b77a5c561934e089';

        type(System.Diagnostics.Process; System_System_Diagnostics_Process) { } //"'System, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Diagnostics.Process"
        type(System.Collections.Specialized.NameValueCollection; System_System_Collections_Specialized_NameValueCollection) { } //"'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Specialized.NameValueCollection"
        type(System.Diagnostics.DataReceivedEventArgs; System_System_Diagnostics_DataReceivedEventArgs) { } //"'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Diagnostics.DataReceivedEventArgs"
        type(System.Net.DecompressionMethods; System_System_Net_DecompressionMethods) { } //"'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Net.DecompressionMethods"
        type(System.Net.HttpStatusCode; System_System_Net_HttpStatusCode) { } //"'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Net.HttpStatusCode"
        type(System.Net.HttpWebRequest; System_System_Net_HttpWebRequest) { } //"'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Net.HttpWebRequest"
        type(System.Net.HttpWebResponse; System_System_Net_HttpWebResponse) { } //"'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Net.HttpWebResponse"
        type(System.Net.WebException; System_System_Net_WebException) { } //"'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Net.WebException"
        type(System.Net.WebExceptionStatus; System_System_Net_WebExceptionStatus) { } //"'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Net.WebExceptionStatus"
        type(System.Net.WebClient; System_Net_WebClient) { } //"'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Net.webClient"
        type(System.Uri; System_System_Uri) { } //"'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Uri"
        type(System.UriKind; System_System_UriKind) { } //"'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.UriKind"
    }
    assembly(System.Xml)
    {
        //Version='4.0.0.0';
        //Culture='neutral';
        //PublicKeyToken='b77a5c561934e089';

        type(System.Xml.XmlAttribute; System_Xml_XmlAttribute) { } //"'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlAttribute"
        type(System.Xml.XmlDocument; System_Xml_XmlDocument) { } //"'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument"
        type(System.Xml.XmlNamedNodeMap; System_Xml_XmlNamedNodeMap) { } //"'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNamedNodeMap"
        type(System.Xml.XmlNode; System_Xml_XmlNode) { } //"'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode"
        type(System.Xml.XmlNodeChangedEventArgs; System_Xml_XmlNodeChangedEventArgs) { } //"'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNodeChangedEventArgs"
        type(System.Xml.XmlNodeList; System_Xml_XmlNodeList) { } //"'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNodeList"
        type(System.Xml.Xsl.XslCompiledTransform; System_Xml_Xsl_XslCompiledTransform) { } //"'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.Xsl.XslCompiledTransform"
        type(System.Xml.XmlTextWriter; System_Xml_XmlTextWriter) { }
        type(System.Xml.XmlElement; System_Xml_XmlElement) { }
    }
}

codeunit 50013 "EDICygate"
{
    TableNo = "EDI Profile";

    trigger OnRun();
    var
        encoding: DotNet mscorlib_System_Text_Encoding;
        SalesHeader: Record "Sales Header";
        SalesShptHead: Record "Sales Shipment Header";
        SalesInvHead: Record "Sales Invoice Header";
    begin
        if DocumentNo = '' then begin
            //test encoding
            encoding := encoding.Default();
            Message('%1\%2\%3', encoding.EncodingName(), encoding.CodePage(), encoding.WebName());
            exit;
        end;

        if EDIAction = EDIAction::OrderConfirmation then begin
            SalesHeader.Get(DocumentType, DocumentNo);
            SendConfirmationNotice(SalesHeader);
            exit;
        end;

        if EDIAction = EDIAction::Shipment then begin
            SalesShptHead.Get(DocumentNo);
            SendDispatchNotice(SalesShptHead);
            exit;
        end;

        if EDIAction = EDIAction::Invoice then begin
            SalesInvHead.Get(DocumentNo);
            SendInvoiceNotice(SalesInvHead);
            exit;
        end;
    end;

    procedure SendConfirmationNotice(SalesHead: Record "Sales Header");
    var
        SalesSetup: Record "Sales & Receivables Setup";
        GLSetup: Record "General Ledger Setup";
        SalesLine: Record "Sales Line";
        Item: Record Item;
        ResultString: Text;
        XMLDoc: DotNet System_Xml_XmlDocument;
        XMLNode1: DotNet System_Xml_XmlNode;
        XMLElement1: DotNet System_Xml_XmlElement;
        XMLElement2: DotNet System_Xml_XmlElement;
        XMLElement3: DotNet System_Xml_XmlElement;
        XMLElement4: DotNet System_Xml_XmlElement;
        WebClient: DotNet System_Net_WebClient;
        StringWriter: DotNet mscorlib_System_IO_StringWriter;
        XmlWriter: DotNet System_Xml_XmlTextWriter;
        encoding: DotNet mscorlib_System_Text_Encoding;
    begin
        SalesSetup.Get;
        GLSetup.Get();
        SalesSetup.TestField("Cygate Endpoint");
        encoding := encoding.Default();

        XMLDoc := XMLDoc.XmlDocument();
        XMLNode1 := XMLDoc.CreateProcessingInstruction('xml', 'version=''1.0'' encoding=''' + FORMAT(encoding.WebName) + '''');

        XMLDoc.AppendChild(XMLNode1);
        XMLElement2 := XMLDoc.CreateElement('PurchaseOrderResponse');
        XMLDoc.AppendChild(XMLElement2);
        XMLElement1 := XMLDoc.CreateElement('Envelope');
        XMLElement2.AppendChild(XMLElement1);

        XMLNode1 := XMLDoc.CreateNode('element', 'Version', '');
        XMLNode1.InnerText('1.2');
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'SenderID', '');
        XMLNode1.InnerText('SecDataCom');
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'ReceiverID', '');
        XMLNode1.InnerText('FSBIS110');
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'TransactionID', '');
        XMLNode1.InnerText('2e6867376bbb4dbb92656661d557acfe');
        XMLElement1.AppendChild(XMLNode1);

        XMLElement1 := XMLDoc.CreateElement('Head');
        XMLElement2.AppendChild(XMLElement1);

        XMLNode1 := XMLDoc.CreateNode('element', 'PurchaseOrderNumber', '');
        XMLNode1.InnerText(SalesHead."External Document No.");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'PurchaseOrderDate', '');
        XMLNode1.InnerText(FORMAT(SalesHead."Order Date", 0, '<Year4>-<Month,2>-<Day,2>'));
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'CurrencyCode', '');
        if SalesHead."Currency Code" = '' then
            SalesHead."Currency Code" := GLSetup."Local Currency Symbol";

        XMLNode1.InnerText(SalesHead."Currency Code");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'VendorPartnerCode', '');
        XMLNode1.InnerText(SalesHead."Bill-to Customer No.");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'VendorOrderNumber', '');
        XMLNode1.InnerText(SalesHead."No.");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'VendorOrderStatus', '');
        IF SalesHead.Status = SalesHead.Status::Released THEN
            XMLNode1.InnerText('Ordered')
        ELSE
            XMLNode1.InnerText('Unknown');
        XMLElement1.AppendChild(XMLNode1);

        XMLElement3 := XMLDoc.CreateElement('Addresses');
        XMLElement1.AppendChild(XMLElement3);

        XMLElement1 := XMLDoc.CreateElement('Address');
        XMLElement3.AppendChild(XMLElement1);

        XMLNode1 := XMLDoc.CreateNode('element', 'AddressType', '');
        XMLNode1.InnerText('ShipTo');
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'AddressCode', '');
        XMLNode1.InnerText(SalesHead."Ship-to Code");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'Name', '');
        XMLNode1.InnerText(SalesHead."Ship-to Name");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'Department', '');
        XMLNode1.InnerText('');
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'Street', '');
        XMLNode1.InnerText(SalesHead."Ship-to Address");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'ZipCode', '');
        XMLNode1.InnerText(SalesHead."Ship-to Post Code");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'City', '');
        XMLNode1.InnerText(SalesHead."Ship-to City");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'CountryCode', '');
        XMLNode1.InnerText(SalesHead."Ship-to Country/Region Code");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'MobilePhoneNumber', '');
        XMLNode1.InnerText('');
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'Email', '');
        XMLNode1.InnerText('');
        XMLElement1.AppendChild(XMLNode1);

        XMLElement1 := XMLDoc.CreateElement('Address');
        XMLElement3.AppendChild(XMLElement1);

        XMLNode1 := XMLDoc.CreateNode('element', 'AddressType', '');
        XMLNode1.InnerText('Invoice');
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'AddressCode', '');
        XMLNode1.InnerText('');
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'Name', '');
        XMLNode1.InnerText(SalesHead."Bill-to Name");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'Department', '');
        XMLNode1.InnerText('');
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'Street', '');
        XMLNode1.InnerText(SalesHead."Bill-to Address");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'ZipCode', '');
        XMLNode1.InnerText(SalesHead."Bill-to Post Code");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'City', '');
        XMLNode1.InnerText(SalesHead."Bill-to City");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'CountryCode', '');
        XMLNode1.InnerText(SalesHead."Bill-to Country/Region Code");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'MobilePhoneNumber', '');
        XMLNode1.InnerText('');
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'Email', '');
        XMLNode1.InnerText('');
        XMLElement1.AppendChild(XMLNode1);

        XMLElement3 := XMLDoc.CreateElement('Rows');
        XMLElement2.AppendChild(XMLElement3);

        SalesLine.SetRange("Document Type", SalesHead."Document Type");
        SalesLine.SetRange("Document No.", SalesHead."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        if SalesLine.FindSet then
            repeat
                if not Item.Get(SalesLine."No.") then
                    Clear(Item);
                XMLElement1 := XMLDoc.CreateElement('Row');
                XMLElement3.AppendChild(XMLElement1);

                XMLNode1 := XMLDoc.CreateNode('element', 'PurchaseOrderRowNumber', '');
                XMLNode1.InnerText(FORMAT(SalesLine."Line No."));
                XMLElement1.AppendChild(XMLNode1);

                XMLNode1 := XMLDoc.CreateNode('element', 'VendorOrderRowNumber', '');
                XMLNode1.InnerText(FORMAT(SalesLine."Line No."));
                XMLElement1.AppendChild(XMLNode1);

                XMLNode1 := XMLDoc.CreateNode('element', 'PartNumber', '');
                XMLNode1.InnerText(SalesLine."No.");
                XMLElement1.AppendChild(XMLNode1);

                XMLNode1 := XMLDoc.CreateNode('element', 'Description', '');
                XMLNode1.InnerText(SalesLine.Description);
                XMLElement1.AppendChild(XMLNode1);

                XMLNode1 := XMLDoc.CreateNode('element', 'OrderedQuantity', '');
                XMLNode1.InnerText(FORMAT(SalesLine.Quantity));
                XMLElement1.AppendChild(XMLNode1);

                XMLNode1 := XMLDoc.CreateNode('element', 'OrderedUnitPrice', '');
                XMLNode1.InnerText(FORMAT(SalesLine."Unit Price", 0, '<Integer><Decimals>'));
                XMLElement1.AppendChild(XMLNode1);

                XMLNode1 := XMLDoc.CreateNode('element', 'VendorPartNumber', '');
                XMLNode1.InnerText(SalesLine."No.");
                XMLElement1.AppendChild(XMLNode1);

                XMLNode1 := XMLDoc.CreateNode('element', 'ManufacturerPartNumber', '');
                XMLNode1.InnerText(Item."Vendor Item No.");
                XMLElement1.AppendChild(XMLNode1);

                XMLElement4 := XMLDoc.CreateElement('SchedulingDetails');
                XMLElement1.AppendChild(XMLElement4);

                XMLElement1 := XMLDoc.CreateElement('SchedulingDetail');
                XMLElement4.AppendChild(XMLElement1);

                XMLNode1 := XMLDoc.CreateNode('element', 'SchedulingType', '');
                if SalesHead.Status = SalesHead.Status::Released then
                    XMLNode1.InnerText('Confirmed')
                else
                    XMLNode1.InnerText('Estimated');
                XMLElement1.AppendChild(XMLNode1);

                XMLNode1 := XMLDoc.CreateNode('element', 'Quantity', '');
                XMLNode1.InnerText(FORMAT(SalesLine."Qty. to Ship"));
                XMLElement1.AppendChild(XMLNode1);

                XMLNode1 := XMLDoc.CreateNode('element', 'DeliveryDate', '');
                XMLNode1.InnerText(FORMAT(SalesLine."Shipment Date", 0, '<Year4>-<Month,2>-<Day,2>'));
                XMLElement1.AppendChild(XMLNode1);

                XMLNode1 := XMLDoc.CreateNode('element', 'UnitPrice', '');
                XMLNode1.InnerText(FORMAT(SalesLine."Unit Price", 0, '<Integer><Decimals>'));
                XMLElement1.AppendChild(XMLNode1);
            until SalesLine.Next = 0;

        XMLDoc.Save('c:\temp\cygate1.xml');
        StringWriter := StringWriter.StringWriter();
        XmlWriter := XmlWriter.XmlTextWriter(StringWriter);

        XMLDoc.WriteTo(XmlWriter);

        WebClient := WebClient.WebClient();
        WebClient.Encoding(encoding);
        WebClient.Headers.Add('Content-Type', 'text/xml; charset=' + FORMAT(encoding.WebName));

        ResultString := WebClient.UploadString(SalesSetup."Cygate Endpoint", 'POST', StringWriter.ToString());
        Message(ResultString);
    end;


    procedure SendDispatchNotice(ShipHead: Record "Sales Shipment Header");
    var
        SalesSetup: Record "Sales & Receivables Setup";
        ShipLine: Record "Sales Shipment Line";
        Ile: Record "Item Ledger Entry";
        Item: Record Item;
        ResultString: Text;
        XMLDoc: DotNet System_Xml_XmlDocument;
        XMLNode1: DotNet System_Xml_XmlNode;
        XMLElement1: DotNet System_Xml_XmlElement;
        XMLElement2: DotNet System_Xml_XmlElement;
        XMLElement3: DotNet System_Xml_XmlElement;
        XMLElement4: DotNet System_Xml_XmlElement;
        XMLElement5: DotNet System_Xml_XmlElement;
        XMLElement6: DotNet System_Xml_XmlElement;
        XMLElement7: DotNet System_Xml_XmlElement;
        XMLElement8: DotNet System_Xml_XmlElement;
        WebClient: DotNet System_Net_WebClient;
        StringWriter: DotNet mscorlib_System_IO_StringWriter;
        XmlWriter: DotNet System_Xml_XmlTextWriter;
        encoding: DotNet mscorlib_System_Text_Encoding;
    begin
        SalesSetup.Get;
        SalesSetup.TestField("Cygate Endpoint");

        encoding := encoding.Default();

        XMLDoc := XMLDoc.XmlDocument();
        XMLNode1 := XMLDoc.CreateProcessingInstruction('xml', 'version=''1.0'' encoding=''' + FORMAT(encoding.WebName) + '''');
        XMLDoc.AppendChild(XMLNode1);
        XMLElement2 := XMLDoc.CreateElement('DespatchAdvice');
        XMLDoc.AppendChild(XMLElement2);
        XMLElement1 := XMLDoc.CreateElement('Envelope');
        XMLElement2.AppendChild(XMLElement1);

        XMLNode1 := XMLDoc.CreateNode('element', 'Version', '');
        XMLNode1.InnerText('1.2');
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'SenderID', '');
        XMLNode1.InnerText('SecDataCom');
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'ReceiverID', '');
        XMLNode1.InnerText('FSBIS110');
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'TransactionID', '');
        XMLNode1.InnerText('2e6867376bbb4dbb92656661d557acfe');
        XMLElement1.AppendChild(XMLNode1);

        XMLElement3 := XMLDoc.CreateElement('Shipment');
        XMLElement2.AppendChild(XMLElement3);

        XMLNode1 := XMLDoc.CreateNode('element', 'DeliveryDate', '');
        XMLNode1.InnerText(FORMAT(ShipHead."Shipment Date", 0, '<Year4>-<Month,2>-<Day,2>'));
        XMLElement3.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'ShipmentNumber', '');
        XMLNode1.InnerText(ShipHead."No.");
        XMLElement3.AppendChild(XMLNode1);

        XMLElement4 := XMLDoc.CreateElement('Addresses');
        XMLElement3.AppendChild(XMLElement4);

        XMLElement1 := XMLDoc.CreateElement('ShipToAddress');
        XMLElement4.AppendChild(XMLElement1);

        XMLNode1 := XMLDoc.CreateNode('element', 'AddressCode', '');
        XMLNode1.InnerText(ShipHead."Ship-to Code");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'Name', '');
        XMLNode1.InnerText(ShipHead."Ship-to Name");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'Department', '');
        XMLNode1.InnerText('');
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'Street', '');
        XMLNode1.InnerText(ShipHead."Ship-to Address");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'ZipCode', '');
        XMLNode1.InnerText(ShipHead."Ship-to Post Code");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'City', '');
        XMLNode1.InnerText(ShipHead."Ship-to City");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'CountryCode', '');
        XMLNode1.InnerText(ShipHead."Ship-to Country/Region Code");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'MobilePhoneNumber', '');
        XMLNode1.InnerText('');
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'TrackingReference', '');
        XMLNode1.InnerText(ShipHead."Package Tracking No.");
        XMLElement3.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'ShippingLabel', '');
        XMLNode1.InnerText('');
        XMLElement3.AppendChild(XMLNode1);

        XMLElement4 := XMLDoc.CreateElement('TransportDetails');
        XMLElement3.AppendChild(XMLElement4);

        XMLNode1 := XMLDoc.CreateNode('element', 'CarrierCode', '');
        XMLNode1.InnerText(ShipHead."Shipping Agent Code");
        XMLElement4.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'ModeOfTransport', '');
        XMLNode1.InnerText(ShipHead."Shipment Method Code");
        XMLElement4.AppendChild(XMLNode1);

        XMLElement4 := XMLDoc.CreateElement('Packages');
        XMLElement3.AppendChild(XMLElement4);

        ShipLine.SetRange("Document No.", ShipHead."No.");
        ShipLine.SetRange(Type, ShipLine.Type::Item);
        if ShipLine.FindSet then
            repeat
                if not Item.Get(ShipLine."No.") then
                    Clear(Item);

                XMLElement5 := XMLDoc.CreateElement('Package');
                XMLElement4.AppendChild(XMLElement5);

                XMLNode1 := XMLDoc.CreateNode('element', 'ModeOfTransport', '');
                XMLNode1.InnerText(ShipHead."Shipment Method Code");
                XMLElement5.AppendChild(XMLNode1);

                XMLNode1 := XMLDoc.CreateNode('element', 'TrackingReference', '');
                XMLNode1.InnerText('');
                XMLElement5.AppendChild(XMLNode1);

                XMLNode1 := XMLDoc.CreateNode('element', 'PackageIdentifier', '');
                XMLNode1.InnerText('');
                XMLElement5.AppendChild(XMLNode1);

                XMLElement6 := XMLDoc.CreateElement('PackageItems');
                XMLElement5.AppendChild(XMLElement6);

                XMLElement7 := XMLDoc.CreateElement('PackageItem');
                XMLElement6.AppendChild(XMLElement7);

                XMLNode1 := XMLDoc.CreateNode('element', 'PurchaseOrderNumber', '');
                XMLNode1.InnerText(ShipHead."External Document No.");
                XMLElement7.AppendChild(XMLNode1);

                XMLNode1 := XMLDoc.CreateNode('element', 'VendorOrderNumber', '');
                XMLNode1.InnerText(ShipHead."Order No.");
                XMLElement7.AppendChild(XMLNode1);

                XMLNode1 := XMLDoc.CreateNode('element', 'PurchaseOrderRowNumber', '');
                XMLNode1.InnerText(FORMAT(ShipLine."Line No."));
                XMLElement7.AppendChild(XMLNode1);

                XMLNode1 := XMLDoc.CreateNode('element', 'VendorOrderRowNumber', '');
                XMLNode1.InnerText(FORMAT(ShipLine."Line No."));
                XMLElement7.AppendChild(XMLNode1);

                XMLNode1 := XMLDoc.CreateNode('element', 'PartNumber', '');
                XMLNode1.InnerText(ShipLine."No.");
                XMLElement7.AppendChild(XMLNode1);

                XMLNode1 := XMLDoc.CreateNode('element', 'Description', '');
                XMLNode1.InnerText(ShipLine.Description);
                XMLElement7.AppendChild(XMLNode1);

                XMLNode1 := XMLDoc.CreateNode('element', 'DeliveredQuantity', '');
                XMLNode1.InnerText(FORMAT(ShipLine.Quantity));
                XMLElement7.AppendChild(XMLNode1);

                XMLNode1 := XMLDoc.CreateNode('element', 'VendorPartNumber', '');
                XMLNode1.InnerText(ShipLine."No.");
                XMLElement7.AppendChild(XMLNode1);

                XMLNode1 := XMLDoc.CreateNode('element', 'ManufacturerPartNumber', '');
                XMLNode1.InnerText(Item."Vendor Item No.");
                XMLElement7.AppendChild(XMLNode1);

                XMLNode1 := XMLDoc.CreateNode('element', 'EANCode', '');
                XMLNode1.InnerText();
                XMLElement7.AppendChild(XMLNode1);

                Ile.SetCurrentKey("Document No.", "Document Type", "Document Line No.");
                Ile.SetRange("Document No.", ShipLine."Document No.");
                Ile.SetRange("Document Line No.", ShipLine."Line No.");
                if Ile.FindSet then begin
                    XMLElement8 := XMLDoc.CreateElement('SerialNumbers');
                    XMLElement7.AppendChild(XMLElement8);
                    repeat
                        XMLNode1 := XMLDoc.CreateNode('element', 'Serial', '');
                        XMLNode1.InnerText(Ile."Serial No.");
                        XMLElement8.AppendChild(XMLNode1);
                    until Ile.Next() = 0;
                end;
            until ShipLine.Next() = 0;

        XMLDoc.Save('c:\temp\cygate2.xml');

        StringWriter := StringWriter.StringWriter();
        XmlWriter := XmlWriter.XmlTextWriter(StringWriter);

        XMLDoc.WriteTo(XmlWriter);

        WebClient := WebClient.WebClient();
        WebClient.Encoding(encoding);
        WebClient.Headers.Add('Content-Type', 'text/xml; charset=' + FORMAT(encoding.WebName));

        ResultString := WebClient.UploadString(SalesSetup."Cygate Endpoint", 'POST', StringWriter.ToString());

        Message(ResultString);
    end;

    procedure SendInvoiceNotice(InvoiceHead: Record "Sales Invoice Header");
    var
        SalesSetup: Record "Sales & Receivables Setup";
        InvoiceLine: Record "Sales Invoice Line";
        Ile: Record "Item Ledger Entry";
        Item: Record Item;
        ResultString: Text;
        XMLDoc: DotNet System_Xml_XmlDocument;
        XMLNode1: DotNet System_Xml_XmlNode;
        XMLElement1: DotNet System_Xml_XmlElement;
        XMLElement2: DotNet System_Xml_XmlElement;
        XMLElement3: DotNet System_Xml_XmlElement;
        XMLElement4: DotNet System_Xml_XmlElement;
        XMLElement5: DotNet System_Xml_XmlElement;
        XMLElement6: DotNet System_Xml_XmlElement;
        XMLElement7: DotNet System_Xml_XmlElement;
        XMLElement8: DotNet System_Xml_XmlElement;
        XMLAttribute1: DotNet System_Xml_XmlAttribute;
        WebClient: DotNet System_Net_WebClient;
        StringWriter: DotNet mscorlib_System_IO_StringWriter;
        XmlWriter: DotNet System_Xml_XmlTextWriter;
        encoding: DotNet mscorlib_System_Text_Encoding;
        SalesShipHead: Record "Sales Shipment Header";
        GLSetup: Record "General Ledger Setup";
        FreightAmt: Decimal;
        VATAmountLine: Record "VAT Amount Line" temporary;
    begin
        SalesSetup.Get();
        GLSetup.Get();
        SalesSetup.TestField("Cygate Endpoint");

        Clear(InvoiceLine);
        InvoiceLine.SetRange("Document No.", InvoiceHead."No.");

        encoding := encoding.Default();

        XMLDoc := XMLDoc.XmlDocument();
        XMLNode1 := XMLDoc.CreateProcessingInstruction('xml', 'version=''1.0'' encoding=''' + FORMAT(encoding.WebName) + '''');
        XMLDoc.AppendChild(XMLNode1);
        XMLElement2 := XMLDoc.CreateElement('Invoice');
        XMLDoc.AppendChild(XMLElement2);
        XMLElement1 := XMLDoc.CreateElement('Envelope');
        XMLElement2.AppendChild(XMLElement1);

        XMLNode1 := XMLDoc.CreateNode('element', 'Version', '');
        XMLNode1.InnerText('1.2');
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'SenderID', '');
        XMLNode1.InnerText('SecDataCom');
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'ReceiverID', '');
        XMLNode1.InnerText('FSBIS110');
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'TransactionID', '');
        XMLNode1.InnerText('2e6867376bbb4dbb92656661d557acfe');
        XMLElement1.AppendChild(XMLNode1);

        XMLElement3 := XMLDoc.CreateElement('DocumentInfo');
        XMLElement2.AppendChild(XMLElement3);

        XMLNode1 := XMLDoc.CreateNode('element', 'InvoiceType', '');
        XMLNode1.InnerText('Debit');
        XMLElement3.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'InvoiceNumber', '');
        XMLNode1.InnerText(InvoiceHead."No.");
        XMLElement3.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'InvoiceDate', '');
        XMLNode1.InnerText(FORMAT(InvoiceHead."Document Date", 0, '<Year4>-<Month,2>-<Day,2>'));
        XMLElement3.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'DueDate', '');
        XMLNode1.InnerText(FORMAT(InvoiceHead."Due Date", 0, '<Year4>-<Month,2>-<Day,2>'));
        XMLElement3.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'InvoiceCurrency', '');
        if InvoiceHead."Currency Code" = '' then
            InvoiceHead."Currency Code" := GLSetup."Local Currency Symbol";

        XMLNode1.InnerText(InvoiceHead."Currency Code");
        XMLElement3.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'VendorOrderNumber', '');
        XMLNode1.InnerText(InvoiceHead."Order No.");
        XMLElement3.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'PurchaseOrderNumber', '');
        XMLNode1.InnerText(InvoiceHead."External Document No.");
        XMLElement3.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'EndCustomerOrderNumber', '');
        XMLNode1.InnerText('');
        XMLElement3.AppendChild(XMLNode1);

        InvoiceLine.SetFilter("Shipment No.", '<>%1', '');
        IF InvoiceLine.FindFirst() then;
        XMLNode1 := XMLDoc.CreateNode('element', 'ShipmentNumber', '');
        XMLNode1.InnerText(InvoiceLine."Shipment No.");
        XMLElement3.AppendChild(XMLNode1);
        InvoiceLine.SetRange("Shipment No.");

        XMLNode1 := XMLDoc.CreateNode('element', 'TermsOfPayment', '');
        XMLNode1.InnerText(InvoiceHead."Payment Terms Code");
        XMLElement3.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'TermsOfDelivery', '');
        XMLNode1.InnerText(InvoiceHead."Shipment Method Code");
        XMLElement3.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'ModeOfDelivery', '');
        XMLNode1.InnerText('');
        XMLElement3.AppendChild(XMLNode1);

        XMLElement4 := XMLDoc.CreateElement('Addresses');
        XMLElement2.AppendChild(XMLElement4);

        XMLElement1 := XMLDoc.CreateElement('Address');
        XMLElement4.AppendChild(XMLElement1);

        XMLNode1 := XMLDoc.CreateNode('element', 'AddressType', '');
        XMLNode1.InnerText('ShipTo');
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'AddressCode', '');
        XMLNode1.InnerText(InvoiceHead."Ship-to Code");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'Name', '');
        XMLNode1.InnerText(InvoiceHead."Ship-to Name");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'Department', '');
        XMLNode1.InnerText('');
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'Street', '');
        XMLNode1.InnerText(InvoiceHead."Ship-to Address");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'ZipCode', '');
        XMLNode1.InnerText(InvoiceHead."Ship-to Post Code");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'City', '');
        XMLNode1.InnerText(InvoiceHead."Ship-to City");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'CountryCode', '');
        XMLNode1.InnerText(InvoiceHead."Ship-to Country/Region Code");
        XMLElement1.AppendChild(XMLNode1);

        XMLElement1 := XMLDoc.CreateElement('Address');
        XMLElement4.AppendChild(XMLElement1);

        XMLNode1 := XMLDoc.CreateNode('element', 'AddressType', '');
        XMLNode1.InnerText('Buyer');
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'AddressCode', '');
        XMLNode1.InnerText(InvoiceHead."Sell-to Customer No.");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'Name', '');
        XMLNode1.InnerText(InvoiceHead."Sell-to Customer Name");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'Department', '');
        XMLNode1.InnerText('');
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'Street', '');
        XMLNode1.InnerText(InvoiceHead."Sell-to Address");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'ZipCode', '');
        XMLNode1.InnerText(InvoiceHead."Sell-to Post Code");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'City', '');
        XMLNode1.InnerText(InvoiceHead."Sell-to City");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'CountryCode', '');
        XMLNode1.InnerText(InvoiceHead."Sell-to Country/Region Code");
        XMLElement1.AppendChild(XMLNode1);

        XMLElement1 := XMLDoc.CreateElement('Address');
        XMLElement4.AppendChild(XMLElement1);

        XMLNode1 := XMLDoc.CreateNode('element', 'AddressType', '');
        XMLNode1.InnerText('Invoice');
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'AddressCode', '');
        XMLNode1.InnerText(InvoiceHead."Bill-to Customer No.");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'Name', '');
        XMLNode1.InnerText(InvoiceHead."Bill-to Name");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'Department', '');
        XMLNode1.InnerText('');
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'Street', '');
        XMLNode1.InnerText(InvoiceHead."Bill-to Address");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'ZipCode', '');
        XMLNode1.InnerText(InvoiceHead."Bill-to Post Code");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'City', '');
        XMLNode1.InnerText(InvoiceHead."Bill-to City");
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'CountryCode', '');
        XMLNode1.InnerText(InvoiceHead."Bill-to Country/Region Code");
        XMLElement1.AppendChild(XMLNode1);

        XMLElement1 := XMLDoc.CreateElement('Address');
        XMLElement4.AppendChild(XMLElement1);

        XMLNode1 := XMLDoc.CreateNode('element', 'AddressType', '');
        XMLNode1.InnerText('Vendor');
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'AddressCode', '');
        XMLNode1.InnerText('');
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'Name', '');
        XMLNode1.InnerText('');
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'Department', '');
        XMLNode1.InnerText('');
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'Street', '');
        XMLNode1.InnerText('');
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'ZipCode', '');
        XMLNode1.InnerText('');
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'City', '');
        XMLNode1.InnerText('');
        XMLElement1.AppendChild(XMLNode1);

        XMLNode1 := XMLDoc.CreateNode('element', 'CountryCode', '');
        XMLNode1.InnerText('');
        XMLElement1.AppendChild(XMLNode1);

        XMLElement4 := XMLDoc.CreateElement('InvoiceLines');
        XMLElement2.AppendChild(XMLElement4);

        InvoiceLine.SetRange(Type, InvoiceLine.Type::Item);
        InvoiceLine.SetFilter("Gen. Prod. Posting Group", '<>FREIGHT');
        if InvoiceLine.FindSet then
            repeat
                if not Item.Get(InvoiceLine."No.") then
                    Clear(Item);

                XMLElement1 := XMLDoc.CreateElement('Line');
                XMLElement4.AppendChild(XMLElement1);

                XMLNode1 := XMLDoc.CreateNode('element', 'InvoiceLineNumber', '');
                XMLNode1.InnerText(Format(InvoiceLine."Line No."));
                XMLElement1.AppendChild(XMLNode1);

                XMLNode1 := XMLDoc.CreateNode('element', 'OrderLineNumber', '');
                XMLNode1.InnerText(Format(InvoiceLine."Order Line No."));
                XMLElement1.AppendChild(XMLNode1);

                XMLNode1 := XMLDoc.CreateNode('element', 'VendorPartNumber', '');
                XMLNode1.InnerText(InvoiceLine."No.");
                XMLElement1.AppendChild(XMLNode1);

                XMLNode1 := XMLDoc.CreateNode('element', 'ManufacturerPartNumber', '');
                XMLNode1.InnerText(Item."Vendor Item No.");
                XMLElement1.AppendChild(XMLNode1);

                XMLNode1 := XMLDoc.CreateNode('element', 'Description', '');
                XMLNode1.InnerText(InvoiceLine.Description);
                XMLElement1.AppendChild(XMLNode1);

                XMLNode1 := XMLDoc.CreateNode('element', 'InvoicedQuantity', '');
                XMLNode1.InnerText(FORMAT(InvoiceLine.Quantity));
                XMLElement1.AppendChild(XMLNode1);

                XMLNode1 := XMLDoc.CreateNode('element', 'TaxRate', '');
                XMLNode1.InnerText(Format(InvoiceLine."VAT %"));
                XMLAttribute1 := XMLNode1.OwnerDocument().CreateAttribute('Code');
                XMLAttribute1.Value(InvoiceLine."VAT Identifier");
                XMLNode1.Attributes.SetNamedItem(XMLAttribute1);
                XMLElement1.AppendChild(XMLNode1);

                XMLNode1 := XMLDoc.CreateNode('element', 'TaxTotalAmount', '');
                XMLNode1.InnerText(Format(InvoiceLine.GetLineAmountInclVAT() - InvoiceLine.GetLineAmountExclVAT()));
                XMLElement1.AppendChild(XMLNode1);

                XMLNode1 := XMLDoc.CreateNode('element', 'PricePerUnit', '');
                XMLNode1.InnerText(FORMAT(InvoiceLine."Unit Price"));
                XMLElement1.AppendChild(XMLNode1);

                XMLNode1 := XMLDoc.CreateNode('element', 'OrderRowTotalExclTax', '');
                XMLNode1.InnerText(Format(InvoiceLine.GetLineAmountExclVAT()));
                XMLElement1.AppendChild(XMLNode1);
            until InvoiceLine.Next() = 0;

        XMLElement4 := XMLDoc.CreateElement('InvoiceFees');
        XMLElement2.AppendChild(XMLElement4);

        FreightAmt := 0;
        //Vare type fragt
        InvoiceLine.SetRange(Type, InvoiceLine.Type::Item);
        InvoiceLine.SetRange("Gen. Prod. Posting Group", 'FREIGHT');
        if InvoiceLine.FindSet then
            repeat
                FreightAmt += InvoiceLine.GetLineAmountExclVAT();
            until InvoiceLine.Next() = 0;

        //Finans varegebyr mv.
        InvoiceLine.SetFilter(Type, '<>%1', InvoiceLine.Type::Item);
        InvoiceLine.SetRange("Gen. Prod. Posting Group");
        if InvoiceLine.FindSet then
            repeat
                FreightAmt += InvoiceLine.GetLineAmountExclVAT();
            until InvoiceLine.Next() = 0;

        if FreightAmt <> 0 then begin
            XMLNode1 := XMLDoc.CreateNode('element', 'Fee', '');
            XMLNode1.InnerText(Format(FreightAmt));
            XMLAttribute1 := XMLNode1.OwnerDocument().CreateAttribute('Code');
            XMLAttribute1.Value('Freight');
            XMLNode1.Attributes.SetNamedItem(XMLAttribute1);
            XMLElement4.AppendChild(XMLNode1);
        end;

        //Momsspecifikation
        XMLElement4 := XMLDoc.CreateElement('TaxSubTotals');
        XMLElement2.AppendChild(XMLElement4);

        VATAmountLine.DELETEALL;
        InvoiceLine.SetRange(Type);
        InvoiceLine.SetRange("Gen. Prod. Posting Group");
        if InvoiceLine.FindSet() then
            repeat
                VATAmountLine.Init();
                VATAmountLine."VAT Identifier" := InvoiceLine."VAT Identifier";
                VATAmountLine."VAT Calculation Type" := InvoiceLine."VAT Calculation Type";
                VATAmountLine."Tax Group Code" := InvoiceLine."Tax Group Code";
                VATAmountLine."VAT %" := InvoiceLine."VAT %";
                VATAmountLine."VAT Base" := InvoiceLine.Amount;
                VATAmountLine."Amount Including VAT" := InvoiceLine."Amount Including VAT";
                VATAmountLine."Line Amount" := InvoiceLine."Line Amount";
                if InvoiceLine."Allow Invoice Disc." then
                    VATAmountLine."Inv. Disc. Base Amount" := InvoiceLine."Line Amount";
                VATAmountLine."Invoice Discount Amount" := InvoiceLine."Inv. Discount Amount";
                VATAmountLine."VAT Clause Code" := InvoiceLine."VAT Clause Code";
                VATAmountLine.InsertLine;
            until InvoiceLine.Next() = 0;

        if VATAmountLine.FindSet() then
            repeat
                XMLElement1 := XMLDoc.CreateElement('TaxSubTotal');
                XMLElement4.AppendChild(XMLElement1);

                XMLNode1 := XMLDoc.CreateNode('element', 'TaxRate', '');
                XMLNode1.InnerText(Format(VATAmountLine."VAT %"));
                XMLAttribute1 := XMLNode1.OwnerDocument().CreateAttribute('Code');
                XMLAttribute1.Value(VATAmountLine."VAT Identifier");
                XMLNode1.Attributes.SetNamedItem(XMLAttribute1);
                XMLElement1.AppendChild(XMLNode1);

                XMLNode1 := XMLDoc.CreateNode('element', 'TaxableAmount', '');
                XMLNode1.InnerText(Format(VATAmountLine."VAT Base"));
                XMLElement1.AppendChild(XMLNode1);

                XMLNode1 := XMLDoc.CreateNode('element', 'TaxAmount', '');
                XMLNode1.InnerText(Format(VATAmountLine."VAT Amount"));
                XMLElement1.AppendChild(XMLNode1);
            until VATAmountLine.Next() = 0;

        XMLElement4 := XMLDoc.CreateElement('InvoiceTotal');
        XMLElement2.AppendChild(XMLElement4);

        InvoiceHead.CalcFields(Amount, "Amount Including VAT");

        //Linjesum - varer
        XMLNode1 := XMLDoc.CreateNode('element', 'NetAmount', '');
        XMLNode1.InnerText(Format(InvoiceHead.Amount - FreightAmt));
        XMLElement4.AppendChild(XMLNode1);

        //Linjesum - fragt
        XMLNode1 := XMLDoc.CreateNode('element', 'TotalFeeAmount', '');
        XMLNode1.InnerText(Format(FreightAmt));
        XMLElement4.AppendChild(XMLNode1);

        //Linjesum - moms sum
        XMLNode1 := XMLDoc.CreateNode('element', 'TotalTaxAmount', '');
        XMLNode1.InnerText(Format(InvoiceHead."Amount Including VAT" - InvoiceHead.Amount));
        XMLElement4.AppendChild(XMLNode1);

        //Afrunding
        XMLNode1 := XMLDoc.CreateNode('element', 'Rounding', '');
        XMLNode1.InnerText('0');
        XMLElement4.AppendChild(XMLNode1);

        //Afrunding - sum incl moms
        XMLNode1 := XMLDoc.CreateNode('element', 'InvoiceAmount', '');
        XMLNode1.InnerText(Format(InvoiceHead."Amount Including VAT"));
        XMLElement4.AppendChild(XMLNode1);

        XMLDoc.Save('c:\temp\cygate3.xml');
        exit;
        StringWriter := StringWriter.StringWriter();
        XmlWriter := XmlWriter.XmlTextWriter(StringWriter);

        XMLDoc.WriteTo(XmlWriter);

        WebClient := WebClient.WebClient();
        WebClient.Encoding(encoding);
        WebClient.Headers.Add('Content-Type', 'text/xml; charset=' + FORMAT(encoding.WebName));

        ResultString := WebClient.UploadString(SalesSetup."Cygate Endpoint", 'POST', StringWriter.ToString());

        Message(ResultString);
    end;
}