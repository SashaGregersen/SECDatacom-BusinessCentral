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
            If Item.Get(rec."No.") then
                If Item."Default Location" <> '' then
                    rec.validate("Location Code", Item."Default Location");
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterInvPostBufferPreparePurchase', '', true, true)]
    local procedure OnAfterInvPostBufferPreparePurchase(VAR PurchaseLine: Record "Purchase Line"; VAR InvoicePostBuffer: Record "Invoice Post. Buffer")
    begin
        if InvoicePostBuffer."Fixed Asset Line No." <> 0 then exit;
        InvoicePostBuffer."Fixed Asset Line No." := PurchaseLine."Line No."; //Bruges til opslit. Alternativt skal linjenummer/description laves rigtigt og primærnøglen rettes i tabellen
        InvoicePostBuffer.Description := PurchaseLine.Description; // virker ikke med spring release da description er udvidet til 100
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostInvPostBuffer', '', true, true)]
    local procedure OnBeforePostInvPostBuffer(VAR GenJnlLine: Record "Gen. Journal Line"; VAR InvoicePostBuffer: Record "Invoice Post. Buffer"; VAR PurchHeader: Record "Purchase Header"; VAR GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean; CommitIsSupressed: Boolean)
    begin
        GenJnlLine.Validate(Description, InvoicePostBuffer.Description);
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Header", 'OnRecreatePurchLinesOnBeforeInsertPurchLine', '', true, true)]
    local procedure OnBeforeRecreatePurchLinesEvent(var PurchaseLine: Record "Purchase Line"; var TempPurchaseLine: Record "Purchase Line")
    var
        Item: record item;
    begin
        if PurchaseLine.type = PurchaseLine.type::Item then begin
            if item.get(PurchaseLine."No.") then
                PurchaseLine.validate("Vendor-Item-No", item."Vendor-Item-No.");
        end;
    end;
}