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
        InvoicePostBuffer.Description := PurchaseLine.Description; // virker ikke med spring release da description er udvidet til 100
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostInvPostBuffer', '', true, true)]
    local procedure OnBeforePostInvPostBuffer(VAR GenJnlLine: Record "Gen. Journal Line"; VAR InvoicePostBuffer: Record "Invoice Post. Buffer"; VAR PurchHeader: Record "Purchase Header"; VAR GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean; CommitIsSupressed: Boolean)
    begin
        GenJnlLine.Validate(Description, InvoicePostBuffer.Description);
    end;

    procedure UpdatePurchLineQtyToInv(var rec: record "Purchase Line"; xrec: Record "sales Line"; ReservationEntry: Record "Reservation Entry"; ICorder: boolean; ICCompany: text[250])
    var
        NegativeReservEntry: Record "Reservation Entry";
    begin
        if ICorder then begin
            ReservationEntry.ChangeCompany(ICCompany);
            NegativeReservEntry.ChangeCompany(ICCompany);
        end;
        ReservationEntry.SetRange("Item No.", rec."No.");
        ReservationEntry.SetRange("Source ID", rec."Document No.");
        ReservationEntry.SetRange("Source Subtype", rec."Document Type");
        ReservationEntry.SetRange("Source Ref. No.", rec."Line No.");
        ReservationEntry.SetRange("Reservation Status", ReservationEntry."Reservation Status"::Reservation);
        ReservationEntry.SetRange(Binding, ReservationEntry.Binding::" ");
        ReservationEntry.SetRange(Positive, true);
        if ReservationEntry.FindSet() then
            repeat
                if ICorder then
                    ReservationEntry.validate("Qty. to Invoice (Base)", xrec."Qty. to Invoice")
                else
                    ReservationEntry.validate("Qty. to Invoice (Base)", rec."Qty. to Invoice");
                ReservationEntry.Modify(true);
                if NegativeReservEntry.get(ReservationEntry."Entry No.", not ReservationEntry.Positive) then begin
                    if ICorder then
                        NegativeReservEntry.validate("Qty. to Invoice (Base)", xrec."Qty. to Invoice")
                    else
                        NegativeReservEntry.validate("Qty. to Invoice (Base)", rec."Qty. to Invoice");
                    NegativeReservEntry.Modify(true);
                end;
            until ReservationEntry.next = 0;
    end;
}