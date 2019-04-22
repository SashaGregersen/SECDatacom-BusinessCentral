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

    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterInvPostBufferPreparePurchase', '', true, true)]
    local procedure OnAfterInvPostBufferPreparePurchase(VAR PurchaseLine: Record "Purchase Line"; VAR InvoicePostBuffer: Record "Invoice Post. Buffer")
    begin
        if InvoicePostBuffer."Fixed Asset Line No." <> 0 then exit;
        InvoicePostBuffer."Fixed Asset Line No." := PurchaseLine."Line No."; //Bruges til opslit. Alternativt skal linjenummer/description laves rigtigt og primærnøglen rettes i tabellen
        InvoicePostBuffer.Description := PurchaseLine.Description;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostInvPostBuffer', '', true, true)]
    local procedure OnBeforePostInvPostBuffer(VAR GenJnlLine: Record "Gen. Journal Line"; VAR InvoicePostBuffer: Record "Invoice Post. Buffer"; VAR PurchHeader: Record "Purchase Header"; VAR GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean; CommitIsSupressed: Boolean)
    begin
        GenJnlLine.Validate(Description, InvoicePostBuffer.Description);
    end;
}