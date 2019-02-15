report 50010 "Import Serial Numbers"
{
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem(SalesLine; "Sales Line")
        {
            trigger OnPreDataItem()
            var
                WindowTitle: text;
                Filename: text;
                filemgt: Codeunit "File Management";
                ImportSerialNumbers: XmlPort "Import Serial Numbers";
                XmlStream: InStream;
                SerialNoXmlFile: file;

            begin
                WindowTitle := 'Select file';
                Filename := FileMgt.OpenFileDialog(WindowTitle, '', '');
                ImportSerialNumbers.setsaleslinefilter(SalesLine);
                SerialNoXmlFile.Open(Filename);
                SerialNoXmlFile.CREATEINSTREAM(XmlStream);
                Xmlport.Import(50003, XmlStream);
                SerialNoXmlFile.CLOSE;
            end;

            trigger OnAfterGetRecord()
            var

            begin
                CurrReport.Break();
            end;

            trigger OnPostDataItem()
            var

            begin
                Message('Serial numbers imported');
            end;
        }
    }

}