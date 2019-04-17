codeunit 50025 "Provisions Event Handler"
{
    SingleInstance = true;
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::codeunit, codeunit::"Sales-Post", 'OnRunOnBeforeFinalizePosting', '', true, true)]
    local procedure CheckGnlJnlProvisions(VAR SalesHeader: Record "Sales Header"; VAR SalesShipmentHeader: Record "Sales Shipment Header"; VAR SalesInvoiceHeader: Record "Sales Invoice Header"; VAR SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    var
        CheckGnlJnlLine: Codeunit "Gen. Jnl.-Check Line";
        GenJnlLine: record "Gen. Journal Line";
        SRSetup: record "Sales & Receivables Setup";
    begin
        SRSetup.get;
        GenJnlLine.SetRange("Journal Template Name", SRSetup."Provision Journal Template");
        GenJnlLine.SetRange("Journal Batch Name", SRSetup."Provision Journal Batch");
        GenJnlLine.SetRange("Document No.", SalesHeader."No.");
        if GenJnlLine.FindSet() then
            repeat
                GenJnlLine.validate("Document No.", SalesInvoiceHeader."No.");
                GenJnlLine.Modify(false);
                GenJnlLine.TestField("Balance (LCY)", 0);
                CheckGnlJnlLine.run(GenJnlLine);
            until GenJnlLine.next = 0;
    end;

    [EventSubscriber(ObjectType::codeunit, codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', true, true)]
    local procedure OnAfterPostSalesDocPostProvisionsEvent(VAR SalesHeader: Record "Sales Header"; VAR GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean)
    var
        PostProvisionLine: Codeunit "Gen. Jnl.-Post Line";
        GenJnlLine: record "Gen. Journal Line";
        SRSetup: record "Sales & Receivables Setup";
    begin
        SRSetup.get;
        GenJnlLine.SetRange("Journal Template Name", SRSetup."Provision Journal Template");
        GenJnlLine.SetRange("Journal Batch Name", SRSetup."Provision Journal Batch");
        GenJnlLine.setrange("Document No.", SalesInvHdrNo);
        if GenJnlLine.FindSet() then
            repeat
                PostProvisionLine.run(GenJnlLine);
            until GenJnlLine.next = 0;
    end;



}