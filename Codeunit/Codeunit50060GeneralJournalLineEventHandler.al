codeunit 50060 "Gen. Jnl. Line Event Handler"
{
    SingleInstance = true;
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::table, database::"Gen. Journal Line", 'OnAfterValidateEvent', 'Account No.', true, true)]
    local procedure OnAfterPostSalesDocOnPostSalesHeader(var rec: record "Gen. Journal Line")
    var
        SRSetup: record "Sales & Receivables Setup";
    begin
        /* if SRSetup.Get() then
            if (rec."Journal Batch Name" = SRSetup."Provision Journal Batch") and (rec."Journal Template Name" = SRSetup."Provision Journal Template") then begin
                rec."Account No." := SRSetup."Provision GL Account";
                rec."Bal. Account No." := SRSetup."Provision Balance Account No.";
                rec.Modify(false);
            end; */
    end;
}