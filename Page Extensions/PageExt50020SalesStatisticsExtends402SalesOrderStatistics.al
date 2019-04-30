pageextension 50020 "Sales Order Statistics" extends "Sales Order Statistics"
{
    layout
    {
        addafter("AdjProfitLCY[2]")
        {
            field("Contribution Margin"; ContributionMargin)
            {
                ToolTip = 'Shows contribution margin for the whole order';
                ApplicationArea = all;
            }

        }
        modify("AdjProfitLCY[1]")
        {
            Visible = false;
        }
        modify("AdjProfitLCY[2]")
        {
            Visible = false;
        }
        modify("AdjProfitPct[1]")
        {
            Visible = false;
        }
        modify("AdjProfitPct[2]")
        {
            Visible = false;
        }

    }

    actions
    {

    }

    var
        ContributionMargin: decimal;

    trigger OnAfterGetCurrRecord()
    var
        SRsetup: record "Sales & Receivables Setup";
        GlJournal: record "Gen. Journal Line";
        SalesLine: record "Sales Line";
        ProfitAmount: Decimal;
        Amount: decimal;
    begin
        SalesLine.setrange("Document No.", rec."No.");
        SalesLine.SetRange("Document Type", rec."Document Type");
        if SalesLine.findset then
            repeat
                ProfitAmount := ProfitAmount + SalesLine."Profit Amount LCY";
                Amount := Amount + SalesLine."Line Amount Excl. VAT (LCY)";
            until SalesLine.next = 0;

        SRsetup.get;
        GlJournal.setrange("Journal Batch Name", SRsetup."Provision Journal Batch");
        GlJournal.SetRange("Journal Template Name", SRsetup."Provision Journal Template");
        GlJournal.setrange("Document No.", rec."No.");
        if GlJournal.FindSet() then
            repeat
                Amount := Amount + GlJournal."Amount (LCY)";
            until GlJournal.next = 0;
        if (ProfitAmount <> 0) and (Amount <> 0) then
            ContributionMargin := (ProfitAmount / Amount) * 100;
    end;
}