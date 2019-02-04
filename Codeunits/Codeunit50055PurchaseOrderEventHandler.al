codeunit 50055 "Purchase Order Event Handler"
{

    SingleInstance = true;
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::table, database::"Purchase Line", 'OnAfterValidateEvent', 'No.', true, true)]

    local procedure OnAfterValidatePurchLineEvent(var rec: record "Purchase Line")
    var
        Item: record item;
    begin
        if rec.Type = rec.type::Item then begin
            Item.Get(rec."No.");
            If Item."Default Location" <> '' then
                rec.validate("Location Code", Item."Default Location");
        end;
    end;

}