codeunit 50057 "IC Event Handler"
{
    SingleInstance = true;
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::Codeunit, codeunit::ICInboxOutboxMgt, 'OnAfterCreateSalesLines', '', true, true)]
    local procedure OnAfterCreateSalesLinesICIOMgt(ICInboxSalesLine: Record "IC Inbox Sales Line"; SalesLine: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
        ICParter: Record "IC Partner";
    begin
        if not ICparter.Get(ICInboxSalesLine."IC Partner Code") then
            exit;
        SalesHeader.get(SalesLine."Document Type", SalesLine."Document No.");
        if SalesHeader.Subsidiary = '' then
            UpdateSalesHeaderWithInfofromSubsidiary(SalesHeader, ICInboxSalesLine, ICParter);
        UpdatesSalesLineWithHeaderInfoFromSubsidiary();
    end;

    local procedure UpdateSalesHeaderWithInfoFromSubsidiary(LocalSalesHeader: Record "Sales Header"; ICInboxSalesLine: Record "IC Inbox Sales Line"; ICParter: Record "IC Partner")
    var
        PurchaseLineOtherCompany: Record "Purchase Line";
        SalesHeaderOtherCompany: Record "Sales Header";
    begin
        GetPurchaseLineFromOtherCompany(ICInboxSalesLine, PurchaseLineOtherCompany);
        GetSalesHeaderFromOtherCompany(PurchaseLineOtherCompany, SalesHeaderOtherCompany);
        CopyAdvPricingHeaderFields(LocalSalesHeader, SalesHeaderOtherCompany, ICParter."Customer No.");
    end;

    local procedure CopyAdvPricingHeaderFields(LocalSalesHeader: Record "Sales Header"; SalesHeaderOtherCompany: Record "Sales Header"; SubsidiaryCustomerNo: code[20])
    begin
        LocalSalesHeader.Validate(Subsidiary, SubsidiaryCustomerNo);
        LocalSalesHeader.Validate(Reseller, SalesHeaderOtherCompany.Reseller);
        if SalesHeaderOtherCompany."End Customer" <> '' then
            LocalSalesHeader.Validate("End Customer", SalesHeaderOtherCompany."End Customer");
        if SalesHeaderOtherCompany."Drop-Shipment" then begin

        end;
    end;

    local procedure UpdatesSalesLineWithHeaderInfoFromSubsidiary()
    var
        myInt: Integer;
    begin

    end;

    local procedure GetPurchaseLineFromOtherCompany(ICInboxSalesLine: Record "IC Inbox Sales Line"; var PurchaseLineOtherCompany: Record "Purchase Line")
    var
        myInt: Integer;
    begin

    end;

    local procedure GetSalesHeaderFromOtherCompany(PurchaseLineOtherCompany: Record "Purchase Line"; var SalesHeaderOtherCompany: Record "Sales Header")
    var
        myInt: Integer;
    begin

    end;
}