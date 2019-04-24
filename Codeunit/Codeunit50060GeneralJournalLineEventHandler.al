codeunit 50060 "Gen. Jnl. Line Event Handler"
{
    SingleInstance = true;
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::table, database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetGLAccount', '', true, true)]
    local procedure OnAfterAccountNoOnValidateGetGLAccountEvent(VAR GenJournalLine: Record "Gen. Journal Line"; VAR GLAccount: Record "G/L Account");
    var
        SRSetup: record "Sales & Receivables Setup";
    begin
        if SRSetup.Get() then
            if (GenJournalLine."Journal Batch Name" = SRSetup."Provision Journal Batch") and (GenJournalLine."Journal Template Name" = SRSetup."Provision Journal Template") then begin
                GenJournalLine."Account No." := SRSetup."Provision GL Account";
                GenJournalLine.Modify(false);
            end;
    end;

    [EventSubscriber(ObjectType::table, database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetGLAccount', '', true, true)]
    local procedure OnAfterAccountNoOnValidateGetGLBalAccountEvent(VAR GenJournalLine: Record "Gen. Journal Line"; VAR GLAccount: Record "G/L Account");
    var
        SRSetup: record "Sales & Receivables Setup";
    begin
        if SRSetup.Get() then
            if (GenJournalLine."Journal Batch Name" = SRSetup."Provision Journal Batch") and (GenJournalLine."Journal Template Name" = SRSetup."Provision Journal Template") then begin
                GenJournalLine."Bal. Account No." := SRSetup."Provision Balance Account No.";
                GenJournalLine.Modify(false);
            end;
    end;
}