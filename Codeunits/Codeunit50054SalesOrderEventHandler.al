codeunit 50054 "Sales Order Event Handler"
{
    SingleInstance = true;
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Type', true, true)]
    local procedure SalesLineOnAfterValidateType()
    var
        salesline: record "Sales Line";
        salesheader: record "sales header";
    begin
        if CompanyName() = 'SECDenmark' then
            exit;

        if salesheader.Subsidiary <> '' then begin
            salesline.SetRange("Document No.", salesheader."No.");
            salesline.SetRange("Document Type", salesheader."Document Type");
            if salesline.FindSet() then
                repeat
                    Error('You cannot change an intercompany order');
                until salesline.next = 0;
        end;

    end;

}