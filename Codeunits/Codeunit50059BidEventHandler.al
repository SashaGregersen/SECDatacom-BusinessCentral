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

    begin

    end;

    var
        myInt: Integer;
}