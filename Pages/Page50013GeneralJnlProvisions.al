page 50013 "General Journal Provisions"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Gen. Journal Line";
    AutoSplitKey = true;
    PopulateAllFields = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = All;
                }
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
                field("Bal. Account Type"; "Bal. Account Type")
                {
                    ApplicationArea = All;
                }
                field("Bal. Account No."; "Bal. Account No.")
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
        rec.validate("Line No.", GetNewLineNo(SRSetup."Provision Journal Template", SRSetup."Provision Journal Batch"));
    end;


}