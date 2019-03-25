report 50003 "Price File Export"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Vendor No.";
            trigger OnPreDataItem()
            var
                XmlStream: OutStream;
                PriceXmlFile: file;
                PriceExportCSV: XmlPort "Price File Export CSV";
                PriceExportXML: XmlPort "Price File Export XML";
                ItemNo: code[20];
            begin
                if customer."No." = '' then
                    Error('You cannot run the report without selecting a customer')
                else begin
                    PriceExportCSV.SetCustomerFilter(customer);
                    PriceExportXML.SetCustomerFilter(customer);
                end;

                PriceExportCSV.SetCurrencyFilter(currency.Code);
                PriceExportXML.SetCurrencyFilter(currency.Code);

                IF ExportCSV = true then begin
                    Filelocation := createfilelocationpath(true);
                    PriceExportCSV.SetTableView(Item);
                    PriceXmlFile.CREATE(Filelocation);
                    PriceXmlFile.CREATEOUTSTREAM(XmlStream);
                    PriceExportCSV.SetDestination(XmlStream);
                    PriceExportCSV.export;
                    PriceXmlFile.CLOSE;
                end else begin
                    Filelocation := createfilelocationpath(false);
                    PriceExportxml.SetTableView(Item);
                    PriceXmlFile.CREATE(Filelocation);
                    PriceXmlFile.CREATEOUTSTREAM(XmlStream);
                    PriceExportXML.SetDestination(XmlStream);
                    PriceExportXML.export;
                    PriceXmlFile.CLOSE;
                end;

            end;

            trigger OnAfterGetRecord()
            var

            begin
                CurrReport.Break();
            end;

            trigger OnPostDataItem()
            var

            begin
                Message('Price File Exported to %1', Filelocation);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(Customer; Customer."No.")
                    {
                        TableRelation = customer;
                    }
                    field("Currency code"; currency.Code)
                    {
                        TableRelation = Currency.Code;
                    }
                    field("Export CSV"; ExportCSV)
                    {
                        ToolTip = 'If not selected, then the export is in XML format';
                    }

                }
            }
        }
    }

    var
        customer: record customer;
        Filelocation: text;
        ExportCSV: Boolean;
        currency: record Currency;

    procedure CreateFileLocationPath(FormatCSV: Boolean) Filelocation: Text
    var
        CurrDateTime: text;
        InvtSetup: record "Inventory Setup";
    begin
        InvtSetup.Get();
        if InvtSetup."Price file location" = '' then
            Error('File Location is missing in Inventory Setup');
        if FormatCSV = true then begin
            FormatCurrentDateTime(CurrDateTime);
            Filelocation := InvtSetup."Price file location" + '\Pricelist_' + customer."No." + '_' + CurrDateTime + '.csv'
        end else begin
            FormatCurrentDateTime(CurrDateTime);
            Filelocation := InvtSetup."Price file location" + '\Pricelist_' + customer."No." + '_' + CurrDateTime + '.xml';
        end;
    end;

    procedure FormatCurrentDateTime(var CurrDateTime: Text)
    var
        CurrDateTime2: text;
    begin
        CurrDateTime2 := ConvertStr(format(CurrentDateTime()), '/', '-');
        CurrDateTime := ConvertStr(Format(CurrentDateTime()), ':', '.');
    end;
}