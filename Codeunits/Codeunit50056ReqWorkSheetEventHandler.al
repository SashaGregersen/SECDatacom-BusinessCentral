codeunit 50056 "Req Worksheet Event Handler"
{
    SingleInstance = true;
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::Table, database::"Order Tracking Entry", 'OnAfterInsertEvent', '', true, true)]

    local procedure OnAfterInsertReqLineEvent(var Rec: record "Order Tracking Entry")
    var
        ReqLine: record "Requisition Line";
        Salesline: Record "Sales Line";
        OrderTrack: page "Order Tracking";
    begin

        ReqLine.SetRange(Type, ReqLine.Type::Item);
        ReqLine.SetRange("No.", Rec."Item No.");
        ReqLine.SetRange("Action Message", ReqLine."Action Message"::New);
        if ReqLine.FindSet() then
            repeat
                if ReqLine."Vendor Item No." <> '' then
                    ReqLine.Validate("Vendor-Item-No", ReqLine."Vendor Item No.");
                Rec.SetRange("Entry No.", 1);
                Rec.SetRange("Item No.", ReqLine."No.");
                Rec.SetRange("Starting Date", Rec."Starting Date");
                Rec.SetRange("Ending Date", Rec."Ending Date");
                Rec.SetRange(Quantity, Rec.Quantity);
                Rec.SetRange("From Type", 37);
                if Rec.FindFirst() then begin
                    Salesline.SetRange("Document No.", Rec."From ID");
                    Salesline.SetRange("Document Type", Salesline."Document Type"::Order); //hvad med de andre typer?
                    Salesline.SetRange("Line No.", Rec."From Ref. No.");
                    if Salesline.FindFirst() then begin
                        ReqLine.validate("Direct Unit Cost", Salesline."Purchase Price on Purchase Order");
                        ReqLine.Modify(true);
                    end;
                end;
            until ReqLine.next = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"req. wksh.-make order", 'OnAfterPurchOrderLineInsert', '', true, true)]

    local procedure OnBeforePurchOrderLineEvent(VAR PurchOrderLine: Record "Purchase Line")
    var
        ReservationEntry: record "Reservation Entry";
        Salesline: Record "Sales Line";
        EntryNo: integer;
    begin
        ReservationEntry.SetRange("Source ID", PurchOrderLine."Document No.");
        ReservationEntry.SetRange("Source Ref. No.", PurchOrderLine."Line No.");
        ReservationEntry.SetRange("Source Type", 39);
        ReservationEntry.SetRange("Source Subtype", PurchOrderLine."Document Type");
        ReservationEntry.SetRange("Reservation Status", ReservationEntry."Reservation Status"::Reservation);
        ReservationEntry.SetRange(Binding, ReservationEntry.Binding::"Order-to-Order");
        if ReservationEntry.FindFirst() then begin
            ReservationEntry.init;
            ReservationEntry.SetRange(Positive, false);
            ReservationEntry.SetRange("Source Type", 37);
            if ReservationEntry.FindFirst() then begin
                if Salesline.Get(PurchOrderLine."Document Type", ReservationEntry."Source ID", ReservationEntry."Source Ref. No.") then begin // source ID er her købsordrenummer
                    if Salesline."Purchase Price on Purchase Order" <> PurchOrderLine."Direct Unit Cost" then
                        PurchOrderLine.Validate("Direct Unit Cost", Salesline."Purchase Price on Purchase Order");
                    if PurchOrderLine."Vendor Item No." <> '' then
                        PurchOrderLine.Validate("Vendor-Item-No", PurchOrderLine."Vendor-Item-No");
                    if Salesline."Bid No." <> '' then
                        PurchOrderLine.Validate("Bid No.", Salesline."Bid No.");
                    PurchOrderLine.Modify(true);
                end;
            end;
        end;
    end;
}