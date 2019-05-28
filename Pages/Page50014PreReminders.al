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
                    tmpCust: Record Customer temporary;
                    CustLedg: Record "Cust. Ledger Entry";
                    CustLedg2: Record "Cust. Ledger Entry";
                    EmailTemplateLine: Record "E-Mail Template Line";
                    RecRef: RecordRef;
                    HeaderDoc: Variant;
                    EMailTemplateMgt: Codeunit "E-Mail Template Mangement";
                begin
                    CurrPage.SetSelectionFilter(CustLedg);
                    if CustLedg.FindSet() then
                        repeat
                            Cust.Get(CustLedg."Customer No.");
                            tmpCust := Cust;
                            if tmpCust.Insert() then;
                        until CustLedg.Next() = 0;

                    if tmpCust.FindSet() then
                        repeat
                            Clear(CustLedg2);
                            CustLedg2.Copy(CustLedg);
                            CustLedg2.SetRange("Customer No.", tmpCust."No.");

                            RecRef.GetTable(tmpCust);

                            if EMailTemplateLine.FindTemplate(Report::PreReminders, tmpCust."Language Code", RecRef) then begin
                                RecRef.GetTable(CustLedg2);
                                HeaderDoc := tmpCust;
                                EMailTemplateMgt.SendMail(EmailTemplateLine, RecRef, HeaderDoc, '', true, false, 0);
                            end;
                        until tmpCust.Next() = 0;
                end;
            }
        }
    }

}