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
                PriceExport: XmlPort "Price File Export";

            begin
                repeat
                    if item.GetFilters() <> '' then begin
                        PriceExport.SetTableView(Item);
                    end;
                    if customer.GetFilters() <> '' then
                        PriceExport.SetCustomerFilter(customer.GetFilters());
                    if DefaultDim.GetFilters() <> '' then
                        PriceExport.SetDimFilter(DefaultDim.GetFilters());

                    Filelocation := 'C:\XmlData\Pricelist.xml';
                    PriceXmlFile.CREATE(Filelocation);
                    PriceXmlFile.CREATEOUTSTREAM(XmlStream);
                    PriceExport.SetDestination(XmlStream);
                    PriceExport.export;
                    PriceXmlFile.CLOSE;
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
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(x)
                {
                    ApplicationArea = All;


                }
            }
        }
    }

    var
        customer: record customer;
        DefaultDim: record "Default Dimension";
        Filelocation: text;
}