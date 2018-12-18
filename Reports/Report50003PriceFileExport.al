report 50003 "Price File Export"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            trigger OnPreDataItem()
            var
                XmlStream: OutStream;
                PriceXmlFile: file;
                PriceExportCSV: XmlPort "Price File Export CSV";
                PriceExportXML: XmlPort "Price File Export XML";

            begin
                repeat
                    if item.GetFilters() <> '' then begin
                        PriceExportCSV.SetTableView(Item);
                        PriceExportXML.SetTableView(Item);
                    end;
                    if customer.GetFilters() <> '' then begin
                        PriceExportCSV.SetCustomerFilter(customer.GetFilters());
                        PriceExportXML.SetCustomerFilter(customer.GetFilters());
                    end;
                    if DefaultDim.GetFilters() <> '' then begin
                        PriceExportCSV.SetDimFilter(DefaultDim.GetFilters());
                        PriceExportXML.SetDimFilter(DefaultDim.GetFilters());
                    end;

                    IF ExportCSV = true then begin
                        Filelocation := 'C:\XmlData\Pricelist.csv';
                        PriceXmlFile.CREATE(Filelocation);
                        PriceXmlFile.CREATEOUTSTREAM(XmlStream);
                        PriceExportCSV.SetDestination(XmlStream);
                        PriceExportCSV.export;
                        PriceXmlFile.CLOSE;
                    end else begin
                        Filelocation := 'C:\XmlData\Pricelist.xml';
                        PriceXmlFile.CREATE(Filelocation);
                        PriceXmlFile.CREATEOUTSTREAM(XmlStream);
                        PriceExportXML.SetDestination(XmlStream);
                        PriceExportXML.export;
                        PriceXmlFile.CLOSE;
                    end;
                until item.next = 0;

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
                    field("Item No"; Item."No.")
                    {
                        TableRelation = item;
                    }
                    field(Customer; Customer."No.")
                    {
                        TableRelation = customer;
                    }

                    field("Default Dimension"; DefaultDim."Dimension Value Code")
                    {
                        TableRelation = "Default Dimension"."Dimension Value Code" where ("Table ID" = CONST (27));
                    }

                    field("Export CSV"; ExportCSV)
                    {
                        ToolTip = 'If not selected, then the export is in XML format';
                    }

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(x)
                {



                }
            }
        }
    }

    var
        customer: record customer;
        DefaultDim: record "Default Dimension";
        Filelocation: text;
        ExportCSV: Boolean;
}