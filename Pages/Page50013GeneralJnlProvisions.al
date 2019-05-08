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

                field("Debit Amount"; "Debit Amount")
                {
                    ApplicationArea = All;

                }
                field("Credit Amount"; "Credit Amount")
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

    trigger OnOpenPage()
    var
    begin
        SRSetup.Get;
        setrange("Journal Template Name", SRSetup."Provision Journal Template");
        setrange("Journal Batch Name", SRSetup."Provision Journal Batch");
    end;

    trigger OnNewRecord(BelowRec: Boolean)
    var
        GlAccount: record "G/L Account";
    begin
        SRSetup.Get;
        rec.validate("Line No.", GetNewLineNo(SRSetup."Provision Journal Template", SRSetup."Provision Journal Batch"));
        rec.validate("Account No.", SRSetup."Provision GL Account");
        GlAccount.get("Account No.");
        rec.validate(Description, GlAccount.Name);
        rec.validate("Bal. Account No.", SRSetup."Provision Balance Account No.");
    end;

    var
        SRSetup: Record "Sales & Receivables Setup";

}