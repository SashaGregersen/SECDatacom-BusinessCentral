codeunit 50060 "Gen. Jnl. Line Event Handler"
{
    SingleInstance = true;
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::table, database::"Gen. Journal Line", 'OnAfterValidateEvent', 'Account No.', true, true)]
    local procedure OnAfterPostSalesDocOnPostSalesHeader(var rec: record "Gen. Journal Line")
    var
    begin

    end;
}