codeunit 50056 "Req Worksheet Event Handler"
{
    SingleInstance = true;
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::Table, database::"Order Tracking Entry", 'OnAfterInsertEvent', '', true, true)]

    local procedure OnAfterInsertReqLineEvent(var Rec: record "Order Tracking Entry")
    var
        ReqLine: record "Requisition Line";
        Salesline: Record "Sales Line";
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
                    end;
                end;
            until ReqLine.next = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"req. wksh.-make order", 'OnBeforePurchOrderLineInsert', '', true, true)]

    local procedure OnBeforePurchOrderLineEvent(VAR PurchOrderHeader: Record "Purchase Header"; VAR PurchOrderLine: Record "Purchase Line"; VAR ReqLine: Record "Requisition Line"; CommitIsSuppressed: Boolean)
    var
        OrdreTrackEntry: record "Order Tracking Entry";
        Salesline: Record "Sales Line";
    begin
        OrdreTrackEntry.SetRange("Entry No.", 1);
        ordreTrackEntry.SetRange("Item No.", ReqLine."No.");
        OrdreTrackEntry.SetRange("Starting Date", ReqLine."Starting Date");
        OrdreTrackEntry.SetRange("Ending Date", ReqLine."Ending Date");
        OrdreTrackEntry.SetRange(Quantity, ReqLine.Quantity);
        OrdreTrackEntry.SetRange("From Type", 37);
        if OrdreTrackEntry.FindFirst() then begin
            Salesline.SetRange("Document No.", OrdreTrackEntry."From ID");
            Salesline.SetRange("Document Type", Salesline."Document Type"::Order); //hvad med de andre typer?
            Salesline.SetRange("Line No.", OrdreTrackEntry."From Ref. No.");
            if Salesline.FindFirst() then begin
                if ReqLine."Vendor Item No." <> '' then
                    PurchOrderLine.Validate("Vendor-Item-No", ReqLine."Vendor-Item-No");
                if Salesline."Bid No." <> '' then
                    PurchOrderLine.Validate("Bid No.", Salesline."Bid No.");
            end;
        end;
    end;
}