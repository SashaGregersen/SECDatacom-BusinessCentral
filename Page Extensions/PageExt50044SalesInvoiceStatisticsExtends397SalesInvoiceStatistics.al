pageextension 50044 "Sales Invoice Statistics" extends "Sales Invoice Statistics"
{
    layout
    {
        addafter(ProfitPct)
        {
            field("Contribution Margin 1"; ContributionMargin)
            {
                ToolTip = 'Shows contribution margin for the whole order';
                ApplicationArea = all;
                Caption = 'Corrected Profit %';
                Editable = false;
            }
            field("Contribution Amount 1"; ContributionAmount)
            {
                ToolTip = 'Shows contribution amount for the whole order';
                ApplicationArea = all;
                Caption = 'Corrected Amount (LCY)';
                Editable = false;
            }

        }

        modify(AdjustedProfitLCY)
        {
            Visible = false;
        }
        modify(AdjProfitPct)
        {
            Visible = false;
        }

    }

    actions
    {

    }

    var
        ContributionMargin: decimal;
        ContributionAmount: decimal;

    trigger OnAfterGetCurrRecord()
    var
        SRsetup: record "Sales & Receivables Setup";
        GlEntries: record "G/L Entry";
        SalesInvLine: record "Sales Invoice Line";
        ProfitAmount: Decimal;
        Amount: decimal;
    begin
        SalesInvLine.setrange("Document No.", rec."No.");
        if SalesInvLine.findset then
            repeat
                ProfitAmount := ProfitAmount + SalesInVLine."Profit Amount LCY";
                Amount := Amount + SalesInvLine."Line Amount Excl. VAT (LCY)";
            until SalesInvLine.next = 0;

        SRsetup.get;
        GlEntries.setrange("Posting Date", Rec."Posting Date");
        GlEntries.setrange("Document No.", Rec."No.");
        GlEntries.SetRange("G/L Account No.", SRsetup."Provision GL Account");
        GlEntries.setrange("Bal. Account No.", SRsetup."Provision Balance Account No.");
        if GlEntries.FindSet() then
            repeat
                ProfitAmount := ProfitAmount + ExchangeCurrencyAmountToLCY(Rec, GlEntries);
            until GlEntries.next = 0;
        if (ProfitAmount <> 0) and (Amount <> 0) then begin
            ContributionAmount := ProfitAmount;
            ContributionMargin := (ProfitAmount / Amount) * 100;
        end;
    end;

    Local procedure ExchangeCurrencyAmountToLCY(SalesInoive: record "Sales Invoice Header"; GLEntry: record "G/L Entry"): Decimal
    var
        CurrencyExcRate: record "Currency Exchange Rate";
    begin
        if rec."Currency Code" <> '' then
            exit(CurrencyExcRate.ExchangeAmtFCYToLCY(rec."posting date", rec."Currency Code", GLEntry.amount, rec."Currency Factor"))
        else
            exit(GLEntry.amount);
    end;
}