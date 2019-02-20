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
    trigger OnRun();
    begin
        //test encoding
        encoding := encoding.Default();
        Message('%1\%2\%3', encoding.EncodingName(), encoding.CodePage(), encoding.WebName());
    end;

    procedure SendConfirmationNotice(SalesHead: Record "Sales Header");
    var
        SalesSetup: Record "Sales & Receivables Setup";
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
    begin
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
        if SalesLine.FindSet then repeat
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

        /*
        ResultString := Format(
        //WebClient.UploadString('http://bisextwebtest.fssystem.se/SecDataCom.aspx','POST',StringWriter.ToString()));
        //WebClient.UploadString('http://cygatese.fssystem.se/SecDataCom.aspx','POST',StringWriter.ToString()));
        WebClient.UploadString(SalesSetup."Cygate Endpoint", 'POST', StringWriter.ToString()));
        */
        //encoding.UTF8.GetString(
        MESSAGE(ResultString);
    end;

    var
        encoding: DotNet mscorlib_System_Text_Encoding;
}