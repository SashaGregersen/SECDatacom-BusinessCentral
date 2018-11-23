codeunit 50002 "Call Webservice Inventory"
{
    trigger OnRun();
    begin
    end;

    procedure CallWebserviceInventory(PurchLine : record "Purchase Line") : Decimal
    begin
        //Url := 'http://nav-app01-test:7057/NAVDEV/WS/SECDenmark/Codeunit/CalculateAvailableInventory';
        //SoapWebServiceReqMgt.SendRequestToWebService;
    end;
    var
        SoapWebServiceReqMgt :Codeunit "SOAP Web Service Request Mgt.";
        Url :text;
}