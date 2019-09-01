report 50025 "Price File Export Customer"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Vendor No.", "Vendor-Item-No.";
            trigger OnPreDataItem()
            var
                XmlStream: OutStream;
                PriceXmlFile: file;
                PriceExportCSV: XmlPort "Price File Export Customer CSV";
                PriceExportXML: XmlPort "Price File Export Customer XML";
                ItemNo: code[20];
                FileMgt: Codeunit "File Management";
            begin
                if customer."No." = '' then
                    Error('You cannot run the report without selecting a customer');

                Filelocation := createfilelocationpath(ExportCSV, false);
                FinalFileLocation := CreateFileLocationPath(ExportCSV, true);

                IF ExportCSV = true then begin
                    PriceExportCSV.SetCustomerFilter(customer);
                    PriceExportCSV.SetCurrencyFilter(currency.Code);
                    PriceExportCSV.SetTableView(Item);
                    PriceXmlFile.CREATE(Filelocation);
                    PriceXmlFile.CREATEOUTSTREAM(XmlStream);
                    PriceExportCSV.SetDestination(XmlStream);
                    PriceExportCSV.export;
                    PriceXmlFile.CLOSE;
                end else begin
                    PriceExportXML.SetCustomerFilter(customer);
                    PriceExportXML.SetCurrencyFilter(currency.Code);
                    PriceExportxml.SetTableView(Item);
                    PriceXmlFile.CREATE(Filelocation);
                    PriceXmlFile.CREATEOUTSTREAM(XmlStream);
                    PriceExportXML.SetDestination(XmlStream);
                    PriceExportXML.export;
                    PriceXmlFile.CLOSE;
                end;

                if File.Copy(Filelocation, FinalFileLocation) then
                    File.Erase(Filelocation)
            end;

            trigger OnAfterGetRecord()
            var

            begin
                CurrReport.Break();
            end;

            trigger OnPostDataItem()
            var

            begin
                Message('Price File Exported to %1', FinalFilelocation);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Customer Filters")
                {
                    field(Customer; Customer."No.")
                    {
                        trigger OnLookup(var text: text): Boolean
                        var

                        begin
                            if not Customer.Get(customer."No.") then
                                Clear(customer);
                            Customer.SetRange("Customer Type", customer."Customer Type"::Reseller);
                            IF page.RunModal(page::"Customer List", Customer, customer."No.") = Action::LookupOK then
                                customer."No." := customer."No.";
                        end;
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
        FinalFileLocation: Text;
        ExportCSV: Boolean;
        currency: record Currency;

    procedure CreateFileLocationPath(FormatCSV: Boolean; CreateFinalLocation: Boolean) Filelocation: Text
    var
        CurrDate: text;
        InvtSetup: record "Inventory Setup";
    begin
        InvtSetup.Get();
        if CreateFinalLocation then begin
            if (InvtSetup."Customer Price file location" = '') then
                Error('Customer Price File Location is missing in Inventory Setup');
            if FormatCSV = true then begin
                FormatCurrentDateTime(CurrDate);
                Filelocation := InvtSetup."Customer Price file location" + '\Pricelist-' + '' + CurrDate + '-' + customer."No." + '' + '.csv';
            end else begin
                FormatCurrentDateTime(CurrDate);
                Filelocation := InvtSetup."Customer Price file location" + '\Pricelist-' + '' + CurrDate + '-' + customer."No." + '' + '.xml';
            end;
        end else begin
            if (InvtSetup."Customer Price file temp loc." = '') then
                Error('Customer Price File Location is missing in Inventory Setup');
            if FormatCSV = true then begin
                FormatCurrentDateTime(CurrDate);
                Filelocation := InvtSetup."Customer Price file temp loc." + '\Pricelist-' + '' + CurrDate + '-' + customer."No." + '' + '.csv';
            end else begin
                FormatCurrentDateTime(CurrDate);
                Filelocation := InvtSetup."Customer Price file temp loc." + '\Pricelist-' + '' + CurrDate + '-' + customer."No." + '' + '.xml';
            end;
        end;
    end;

    procedure FormatCurrentDateTime(var CurrDate: Text)
    var
    //CurrDateTime2: text;
    begin
        //CurrDateTime2 := ConvertStr(format(CurrentDateTime(), 0, '<Year4>/<Month,2>/<Day,2> <Hours12,2>:<Minutes,2>:<Seconds,2>'), '/', '-');
        CurrDate := ConvertStr(Format(Today(), 0, '<Year4>-<Month,2>-<Day,2>'), ':', '.');
    end;
}