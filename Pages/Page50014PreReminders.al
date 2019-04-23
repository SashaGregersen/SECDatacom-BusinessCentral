page 50014 "PreReminders"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Cust. Ledger Entry";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Customer No."; "Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; "Due Date")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Original Amount"; "Original Amount")
                {
                    ApplicationArea = All;
                }
                field("Remaining Amount"; "Remaining Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(SendPreReminder)
            {
                Caption = 'Send PreReminder';
                Image = SendAsPDF;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Cust: Record Customer;
                    CustLedg: Record "Cust. Ledger Entry";
                    EmailTemplateLine: Record "E-Mail Template Line";
                    RecRef: RecordRef;
                    HeaderDoc: Variant;
                begin
                    CurrPage.SetSelectionFilter(CustLedg);
                    if CustLedg.FindSet() then
                        repeat
                        /*
                        HeaderDoc := CustLedg;
                        Cust.Get(CustLedg."Customer No.");
                        if EMailTemplateLine.FindTemplate(50023, Cust."Language Code", RecRef) then begin
                            EmailTemplateLine.OpenOutlookEMail(RecRef, HeaderDoc, 0);
                        end;
                        */
                        until CustLedg.Next() = 0;
                end;
            }
        }
    }
}