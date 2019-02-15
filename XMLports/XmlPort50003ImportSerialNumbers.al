xmlport 50003 "Import Serial Numbers"
{
    Direction = Import;
    TextEncoding = WINDOWS;
    Format = VariableText;
    FieldDelimiter = '';
    FieldSeparator = ';';

    schema
    {
        textelement(Root)
        {
            Textelement(TrackingSpec)
            {
                textattribute(VendorNo)
                {

                }

                textattribute(VendorItemNo)
                {

                }

                textattribute(SerialNo)
                {

                }

                trigger OnBeforePassVariable()
                var
                    SalesLine: Record "Sales Line";
                    NextEntryNo: integer;
                    EntrySummary: record "Entry Summary";
                begin
                    /* SkipFirstLine := SkipFirstLine + 1;
                    if SkipFirstLine = 1 then
                        currXMLport.skip;

                    Salesline.Init;
                    SalesLine.SetRange("Document No.", NewSalesLine."Document No.");
                    SalesLine.SetRange("Document Type", NewSalesLine."Document Type");
                    SalesLine.SetRange(Type, NewSalesLine.Type::Item);
                    SalesLine.SetRange("No.", TrackingSpec."Item No.");
                    if Salesline.Findset() then
                        repeat
                            TrackingSpec.SetRange("Item No.", TrackingSpec."Item No.");
                            TrackingSpec.SetRange("Serial No.", TrackingSpec."Serial No.");
                            TrackingSpec.SetRange("Source Subtype", Salesline."Line No.");
                            if not TrackingSpec.FindFirst() then begin
                                TrackingSpec.init;
                                //entry no mangler?
                                TrackingSpec.Validate("Item No.", TrackingSpec."Item No.");
                                TrackingSpec.Validate("Serial No.", TrackingSpec."Serial No.");
                                TrackingSpec.Validate("Location Code", SalesLine."Location Code");
                                TrackingSpec.Validate("Quantity (Base)", 1);
                                TrackingSpec.Validate(Positive, true);
                                TrackingSpec.Validate("Source ID", SalesLine."Document No.");
                                TrackingSpec.Validate("Source Ref. No.", SalesLine."Line No.");
                                TrackingSpec.Validate("Source Subtype", SalesLine."Document Type");
                                TrackingSpec.Validate("Source Type", 37);
                                TrackingSpec.Insert(true);
                            end;
                        until Salesline.next = 0; */
                end;
            }
        }
    }
    var
        NewSalesLine: record "Sales Line";
        SkipFirstLine: Integer;


    procedure setsaleslinefilter(SalesLine: Record "Sales Line")
    var

    begin
        NewSalesLine := SalesLine;
    end;




}