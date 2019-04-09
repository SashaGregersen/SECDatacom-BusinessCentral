codeunit 50059 "Bid Event Handler"
{
    SingleInstance = true;
    EventSubscriberInstance = StaticAutomatic;

    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post", 'OnAfterPostSalesLine', '', true, true)]
    local procedure OnAfterPostSalesDocOnPostSalesHeader(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; CommitIsSuppressed: Boolean)
    var
        Bid: Record Bid;
        BidPrice: Record "Bid Item Price";
        GLJnlLine: Record "Gen. Journal Line";
    begin

    end;

}