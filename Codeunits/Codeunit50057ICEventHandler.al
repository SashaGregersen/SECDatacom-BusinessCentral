codeunit 50057 "IC Event Handler"
{
    SingleInstance = true;
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::Codeunit, codeunit::ICInboxOutboxMgt, 'OnAfterCreateSalesLines', '', true, true)]
    local procedure OnAfterCreateSalesLinesICIOMgt(ICInboxSalesLine: Record "IC Inbox Sales Line"; var SalesLine: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
        ICPartner: Record "IC Partner";
    begin
        if not ICpartner.Get(ICInboxSalesLine."IC Partner Code") then
            exit;
        SalesHeader.get(SalesLine."Document Type", SalesLine."Document No.");
        UpdateSalesOrderWithInfofromSubsidiary(SalesHeader, SalesLine, ICInboxSalesLine, ICPartner);
    end;

    local procedure UpdateSalesOrderWithInfoFromSubsidiary(LocalSalesHeader: Record "Sales Header"; LocalSalesline: Record "Sales Line"; ICInboxSalesLine: Record "IC Inbox Sales Line"; ICPartner: Record "IC Partner")
    var
        PurchaseLineOtherCompany: Record "Purchase Line";
        SalesLineOtherCompany: Record "Sales Line";
        SalesHeaderOtherCompany: Record "Sales Header";
    begin
        if not GetPurchaseLineFromOtherCompany(ICInboxSalesLine, PurchaseLineOtherCompany, ICPartner."Inbox Details") then
            exit;
        if not GetSalesLineFromOtherCompany(PurchaseLineOtherCompany, SalesLineOtherCompany, ICPartner."Inbox Details") then
            exit;
        if LocalSalesHeader.Subsidiary = '' then begin
            if GetSalesHeaderFromOtherCompany(SalesLineOtherCompany, SalesHeaderOtherCompany, ICPartner."Inbox Details") then
                CopyAdvPricingHeaderFields(LocalSalesHeader, SalesHeaderOtherCompany, ICPartner."Customer No.");
        end;
        CopyAdvPricingLineFields(LocalSalesline, SalesLineOtherCompany);
    end;

    local procedure CopyAdvPricingHeaderFields(LocalSalesHeader: Record "Sales Header"; SalesHeaderOtherCompany: Record "Sales Header"; SubsidiaryCustomerNo: code[20])
    begin
        LocalSalesHeader.Validate(Reseller, SalesHeaderOtherCompany.Reseller);
        LocalSalesHeader.Validate(Subsidiary, SubsidiaryCustomerNo);
        if SalesHeaderOtherCompany."End Customer" <> '' then
            LocalSalesHeader.Validate("End Customer", SalesHeaderOtherCompany."End Customer");
        //if SalesHeaderOtherCompany."Drop-Shipment" then begin        
        LocalSalesHeader."Ship-to Address" := SalesHeaderOtherCompany."Ship-to Address";
        LocalSalesHeader."Ship-to Address 2" := SalesHeaderOtherCompany."Ship-to Address 2";
        LocalSalesHeader."Ship-to City" := SalesHeaderOtherCompany."Ship-to City";
        LocalSalesHeader."Ship-to Contact" := SalesHeaderOtherCompany."Ship-to Contact";
        LocalSalesHeader."Ship-to Country/Region Code" := SalesHeaderOtherCompany."Ship-to Country/Region Code";
        LocalSalesHeader."Ship-to County" := SalesHeaderOtherCompany."Ship-to County";
        LocalSalesHeader."Ship-to Name" := SalesHeaderOtherCompany."Ship-to Name";
        LocalSalesHeader."Ship-to Name 2" := SalesHeaderOtherCompany."Ship-to Name 2";
        LocalSalesHeader."Ship-to Post Code" := SalesHeaderOtherCompany."Ship-to Post Code";
        //end;        
        LocalSalesHeader.Modify(false);
    end;

    local procedure CopyAdvPricingLineFields(LocalSalesLine: Record "Sales Line"; SalesLineOtherCompany: Record "Sales Line")
    begin
        //der skal noget currency ind over de her felter...
        LocalSalesLine."Bid No." := SalesLineOtherCompany."Bid No.";
        LocalSalesLine."Bid Sales Discount" := SalesLineOtherCompany."Bid Sales Discount";
        LocalSalesLine."Bid Unit Sales Price" := SalesLineOtherCompany."Bid Unit Sales Price";
        LocalSalesLine."Bid Purchase Discount" := SalesLineOtherCompany."Bid Purchase Discount";
        LocalSalesLine."Bid Unit Purchase Price" := SalesLineOtherCompany."Bid Unit Purchase Price";
    end;

    local procedure GetPurchaseLineFromOtherCompany(ICInboxSalesLine: Record "IC Inbox Sales Line"; var PurchaseLineOtherCompany: Record "Purchase Line"; OtherCompanyName: text[30]): Boolean
    begin
        PurchaseLineOtherCompany.ChangeCompany(OtherCompanyName);
        exit(PurchaseLineOtherCompany.Get(ICInboxSalesLine."Document Type" + 1, ICInboxSalesLine."Document No.", ICInboxSalesLine."Line No."));
    end;

    local procedure GetSalesLineFromOtherCompany(PurchaseLineOtherCompany: Record "Purchase Line"; var SalesLineOtherCompany: Record "Sales Line"; OtherCompanyName: text[30]): Boolean
    var
        PurchaseReservationEntry: Record "Reservation Entry";
        SalesReservationEntry: Record "Reservation Entry";
    begin
        PurchaseReservationEntry.ChangeCompany(OtherCompanyName);
        PurchaseReservationEntry.SetRange("Source Subtype", PurchaseLineOtherCompany."Document Type");
        PurchaseReservationEntry.SetRange("Source ID", PurchaseLineOtherCompany."Document No.");
        PurchaseReservationEntry.SetRange("Source Ref. No.", PurchaseLineOtherCompany."Line No.");
        PurchaseReservationEntry.SetRange("Source type", 39);
        if not PurchaseReservationEntry.FindFirst() then begin
            Clear(SalesLineOtherCompany);
            exit(false);
        end;
        SalesReservationEntry.ChangeCompany(OtherCompanyName);
        if not SalesReservationEntry.Get(PurchaseReservationEntry."Entry No.", not PurchaseReservationEntry.Positive) then begin
            Clear(SalesLineOtherCompany);
            exit(false);
        end;
        SalesLineOtherCompany.ChangeCompany(OtherCompanyName);
        if not SalesLineOtherCompany.Get(SalesReservationEntry."Source Subtype", SalesReservationEntry."Source ID", SalesReservationEntry."Source Ref. No.") then begin
            Clear(SalesLineOtherCompany);
            exit(false);
        end;
        exit(true);
    end;

    local procedure GetSalesHeaderFromOtherCompany(SalesLineOtherCompany: Record "Sales Line"; var SalesHeaderOtherCompany: Record "Sales Header"; OtherCompanyName: text[30]): Boolean
    begin
        SalesHeaderOtherCompany.ChangeCompany(OtherCompanyName);
        if not SalesHeaderOtherCompany.get(SalesLineOtherCompany."Document Type", SalesLineOtherCompany."Document No.") then begin
            Clear(SalesHeaderOtherCompany);
            exit(false);
        end;
    end;
}