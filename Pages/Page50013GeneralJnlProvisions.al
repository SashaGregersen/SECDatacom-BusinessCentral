page 50013 "General Journal Provisions"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Gen. Journal Line";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;

                }
                field(Description; Description)
                {
                    ApplicationArea = All;

                }
                field("Debit Amount"; "Debit Amount")
                {
                    ApplicationArea = All;

                }
                field("Credit Amount"; "Credit Amount")
                {
                    ApplicationArea = All;

                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;

                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;

                }
            }

        }


    }
    trigger OnNewRecord(BelowRec: Boolean)
    var
        SRSetup: Record "Sales & Receivables Setup";
        DocNo: text;
    begin
        SRSetup.Get;
        DocNo := rec.GetFilter("Document No.");
        rec.validate("Document No.", DocNo);
        Rec.validate("Journal Template Name", SRSetup."Provision Journal Template");
        rec.validate("Journal Batch Name", SRSetup."Provision Journal Batch");
        rec.validate("Line No.", GetNewLineNo(SRSetup."Provision Journal Template", SRSetup."Provision Journal Batch"));
    end;

}