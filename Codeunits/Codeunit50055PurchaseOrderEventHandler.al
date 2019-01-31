codeunit 50055 "Purchase Order Event Handler"
{

    SingleInstance = true;
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::table, database::"Purchase Line", 'OnAfterInsertEvent', '', true, true)]

    local procedure OnAfterInsertSalesLineEvent(var rec: record "Purchase Line"; runtrigger: Boolean)
    var
        Item: record item;
    begin
        If not runtrigger then
            EXIT;
        if rec.Type = rec.type::Item then begin
            Item.Get(rec."No.");
            Item.TestField("Default Location");
            rec.validate("Location Code", Item."Default Location");
        end;
    end;

    [EventSubscriber(ObjectType::table, database::"Purchase Line", 'OnAfterModifyEvent', '', true, true)]

    local procedure OnAfterModifySalesLineEvent(var rec: record "Purchase Line"; runtrigger: Boolean)
    var
        Item: record item;
    begin
        If not runtrigger then
            EXIT;
        if rec.Type = rec.type::Item then begin
            Item.Get(rec."No.");
            Item.TestField("Default Location");
            rec.validate("Location Code", Item."Default Location");
            rec.Modify(false);
        end;
    end;

}