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

    actions
    {
        area(Processing)
        {
            action(Dimensions)
            {
                ApplicationArea = Dimensions;
                Image = Dimensions;
                Promoted = true;
                PromotedCategory = Category10;
                ShortcutKey = 'Shift+Ctrl+D';
                AccessByPermission = TableData Dimension = R;
                ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history';
                trigger OnAction()
                var
                begin
                    ShowDimensions();
                    CurrPage.SAVERECORD;
                end;
            }
        }

    }
    trigger OnNewRecord(BelowRec: Boolean)
    var
        SRSetup: Record "Sales & Receivables Setup";
        GlAccount: record "G/L Account";
    begin
        SRSetup.Get;
        rec.validate("Line No.", GetNewLineNo(SRSetup."Provision Journal Template", SRSetup."Provision Journal Batch"));
        rec.validate("Account No.", SRSetup."Provision GL Account");
        GlAccount.get("Account No.");
        rec.validate(Description, GlAccount.Name);
        rec.validate("Bal. Account No.", SRSetup."Provision Balance Account No.");
    end;


}