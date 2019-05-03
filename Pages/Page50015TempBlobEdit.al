page 50015 "TempBlobEdit"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "TempBlob";
    SourceTableTemporary = true;
    DataCaptionExpression = '';
    Caption = 'Text';

    layout
    {
        area(Content)
        {
            field(BlobText; BlobText)
            {
                ApplicationArea = all;
                MultiLine = true;
            }
        }
    }

    var
        BlobText: Text;

    trigger OnOpenPage()
    begin
        ReadBlob();
    end;

    trigger OnClosePage()
    begin
        WriteBlob();
    end;

    procedure ReadBlob()
    begin
        CalcFields("Blob");
        BlobText := ReadAsTextWithCRLFLineSeparator();
    end;

    procedure WriteBlob()
    begin
        WriteAsText(BlobText, TextEncoding::UTF8);
    end;
}