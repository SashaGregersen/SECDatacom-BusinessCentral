codeunit 50052 "Customer Event Handler"
{
    SingleInstance = true;
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::Table, database::"Customer Price Group", 'OnAfterInsertEvent', '', true, true)]
    local procedure CustomerPriceGroupOnAfterinsert(var Rec: Record "Customer Price Group")
    var
        CustomerDiscountGroup: Record "Customer Discount Group";
    begin
        If not CustomerDiscountGroup.Get(Rec.Code) then begin
            CustomerDiscountGroup.Init();
            CustomerDiscountGroup.Code := Rec.Code;
            CustomerDiscountGroup.Description := Rec.Description;
            CustomerDiscountGroup.Insert(false);
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Customer Discount Group", 'OnAfterInsertEvent', '', true, true)]
    local procedure CustomerDiscountGroupOnAfterinsert(var Rec: Record "Customer Discount Group")
    var
        CustomerPriceGroup: Record "Customer Price Group";
    begin
        If not CustomerpriceGroup.Get(Rec.Code) then begin
            CustomerPriceGroup.Init();
            CustomerPriceGroup.Code := Rec.Code;
            CustomerPriceGroup.Description := Rec.Description;
            CustomerPriceGroup."Allow Line Disc." := false;
            CustomerPriceGroup.Insert(false);
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterCopySellToCustomerAddressFieldsFromCustomer', '', true, true)]
    local procedure OnAfterCopySellToCustomerAddressFieldsFromCustomer(var SalesHeader: Record "Sales Header"; SellToCustomer: record customer)
    var
        ShipToAddress: record "Ship-to Address";
    begin
        if SellToCustomer."Prefered Shipment Address" <> '' then begin
            ShipToAddress.SetRange("Customer No.", SellToCustomer."No.");
            ShipToAddress.SetRange(Code, SellToCustomer."Prefered Shipment Address");
            if ShipToAddress.findfirst then begin
                SalesHeader."Prefered Shipment Address" := SellToCustomer."Prefered Shipment Address";
            end;
        end;
    end;

    [EventSubscriber(ObjectType::table, database::"Customer", 'OnAfterInsertEvent', '', true, true)]
    local procedure CustomerOnAfterInsert(var Rec: Record "Customer"; runtrigger: Boolean)
    var
        CompanyInfo: Record "Company Information";
        SyncMasterData: codeunit "Synchronize Master Data";
        SalesSetup: record "Sales & Receivables Setup";
    begin
        If not runtrigger then
            EXIT;

        if CompanyName() <> 'SECDenmark' then begin
            SalesSetup.get;
            IF SalesSetup."Synchronize Customer" = FALSE then
                Exit;
            SyncMasterData.SynchronizeCustomerToSECDK(Rec);
        end;
    end;

    [EventSubscriber(ObjectType::table, database::"Customer", 'OnAfterModifyEvent', '', true, true)]
    local procedure CustomerOnAfterModify(var Rec: Record "Customer"; runtrigger: Boolean)
    var
        CompanyInfo: Record "Company Information";
        SyncMasterData: codeunit "Synchronize Master Data";
        SalesSetup: record "Sales & Receivables Setup";
    begin
        If not runtrigger then
            EXIT;

        if CompanyName() <> 'SECDenmark' then begin
            SalesSetup.get;
            IF SalesSetup."Synchronize Customer" = FALSE then
                Exit;
            SyncMasterData.SynchronizeCustomerToSECDK(Rec);
        end;
    end;

    [EventSubscriber(ObjectType::Page, page::"Customer card", 'OnInsertRecordEvent', '', true, true)]

    local procedure UpdateOwningCompany(var rec: Record Customer)
    var

    begin
        rec.validate("Owning Company", CompanyName());
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterInsertEvent', '', true, true)]

    local procedure UpdateSellToCustomerInRelatedFields(var rec: Record "Sales Header")
    var
        Customer: record Customer;
    begin
        If rec."Sell-to Customer No." <> '' then begin
            IF Customer.GET(rec."Sell-to Customer No.") then begin
                if customer."Customer Type" = Customer."Customer Type"::Reseller then
                    rec.Reseller := Customer."No."
                else
                    if customer."Customer Type" = customer."Customer Type"::"End Customer" then
                        rec."End Customer" := customer."No."
                    else
                        if customer."Customer Type" = customer."Customer Type"::"Financing Partner" then
                            rec."Financing Partner" := Customer."No."
                        else
                            rec.Subsidiary := customer."No.";
            end;
        end;
    end;

}