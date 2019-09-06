report 50098 "Fix Problem Line Amount LCY"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(SalesInvoiceHeader; "Sales Invoice Header")
        {
            RequestFilterFields = "No.";

            dataitem(SalesInvoiceLine; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD ("No.");
                DataItemLinkReference = SalesInvoiceHeader;
                DataItemTableView = SORTING ("Document No.", "Line No.");

                trigger OnAfterGetRecord()
                var
                    ItemVariant: Record "Item Variant";
                begin
                    if "Line Amount" <> "Line Amount Excl. VAT (LCY)" then begin
                        "Line Amount Excl. VAT (LCY)" := "Line Amount";
                        Modify(false);
                    end;

                end;
            }

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                SetFilter("Currency Code", '');
                Window.open('SIH #1############')
            end;

            trigger OnAfterGetRecord()
            begin
                Window.Update(1, "No.");
            end;

            trigger OnPostDataItem()
            begin
                Window.Close();
            end;
        }
    }
    var
        Window: Dialog;
}