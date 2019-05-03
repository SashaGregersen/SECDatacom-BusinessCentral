codeunit 50055 "Purchase Order Event Handler"
{

    SingleInstance = true;
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::table, database::"Purchase Line", 'OnAfterValidateEvent', 'Qty. to Invoice', true, true)]

    local procedure OnAfterModifyPurchLineEvent(var rec: record "Purchase Line")
    var
        ICSyncMgt: Codeunit "IC Sync Management";
        ReservationEntry: record "Reservation Entry";
    begin
        UpdatePurchLineQtyToInv(rec, ReservationEntry, false, '');
    end;

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
        InvoicePostBuffer.Description := PurchaseLine.Description; // virker ikke med spring release da description er udvidet til 100
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostInvPostBuffer', '', true, true)]
    local procedure OnBeforePostInvPostBuffer(VAR GenJnlLine: Record "Gen. Journal Line"; VAR InvoicePostBuffer: Record "Invoice Post. Buffer"; VAR PurchHeader: Record "Purchase Header"; VAR GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean; CommitIsSupressed: Boolean)
    begin
        GenJnlLine.Validate(Description, InvoicePostBuffer.Description);
    end;

    procedure UpdatePurchLineQtyToInv(var PurchLine: record "Purchase Line"; ReservationEntry: Record "Reservation Entry"; ICorder: boolean; ICCompany: text[250])
    var
        NegativeReservEntry: Record "Reservation Entry";
    begin
        if ICorder then
            ReservationEntry.ChangeCompany(ICCompany);
        ReservationEntry.SetRange("Item No.", PurchLine."No.");
        ReservationEntry.SetRange("Source ID", PurchLine."Document No.");
        ReservationEntry.SetRange("Source Subtype", PurchLine."Document Type");
        ReservationEntry.SetRange("Source Ref. No.", PurchLine."Line No.");
        ReservationEntry.SetRange("Reservation Status", ReservationEntry."Reservation Status"::Reservation);
        ReservationEntry.SetRange(Binding, ReservationEntry.Binding::" ");
        ReservationEntry.SetRange(Positive, true);
        if ReservationEntry.FindSet() then
            repeat
                ReservationEntry.validate("Qty. to Invoice (Base)", PurchLine."Qty. to Invoice");
                ReservationEntry.Modify(true);
                if ICorder then
                    NegativeReservEntry.ChangeCompany(ICCompany);
                if NegativeReservEntry.get(ReservationEntry."Entry No.", not ReservationEntry.Positive) then begin
                    NegativeReservEntry.validate("Qty. to Invoice (Base)", PurchLine."Qty. to Invoice");
                    NegativeReservEntry.Modify(true);
                end;
            until ReservationEntry.next = 0;
    end;
}