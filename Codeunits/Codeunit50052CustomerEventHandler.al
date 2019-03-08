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

        rec.validate("Owning Company", CompanyName());

        if CompanyName() = rec."Owning Company" then begin
            SalesSetup.get;
            IF SalesSetup."Synchronize Customer" = FALSE then
                Exit;
            SyncMasterData.SynchronizeCustomerToSECDK(Rec);
        end else
            error('You must modify this customer in %1', rec."Owning Company");
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

        if CompanyName() = rec."Owning Company" then begin
            SalesSetup.get;
            IF SalesSetup."Synchronize Customer" = FALSE then
                Exit;
            SyncMasterData.SynchronizeCustomerToSECDK(Rec);
        end else
            Error('You must modify this customer in %1', rec."Owning Company");
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterInsertEvent', '', true, true)]

    local procedure UpdateSellToCustomerInRelatedFields(var rec: Record "Sales Header")
    var
        Customer: record Customer;
    begin
        If rec."Sell-to Customer No." <> '' then begin
            IF Customer.GET(rec."Sell-to Customer No.") then begin
                if Customer."IC Partner Code" <> '' then
                    rec.validate(Subsidiary, Customer."No.")
                else
                    if customer."Customer Type" = Customer."Customer Type"::Reseller then
                        rec.Validate(Reseller, Customer."No.")
                    else
                        if customer."Customer Type" = customer."Customer Type"::"End Customer" then
                            rec.Validate("End Customer", customer."No.")
                        else
                            if customer."Customer Type" = customer."Customer Type"::"Financing Partner" then
                                rec.Validate("Financing Partner", Customer."No.");

                rec.Modify(true);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::table, database::"Customer", 'OnAfterValidateEvent', 'Customer Price Group', true, true)]
    local procedure CustomerPriceGroupOnAfterValidate(var Rec: Record "Customer")
    begin
        if rec."Customer Price Group" <> Rec."Customer Disc. Group" then
            Rec.Validate("Customer Disc. Group", Rec."Customer Price Group");
    end;

    [EventSubscriber(ObjectType::table, database::"Customer", 'OnAfterValidateEvent', 'Customer Disc. Group', true, true)]
    local procedure CustomerDiscGroupOnAfterValidate(var Rec: Record "Customer")
    var
        PriceGroupLink: Record "Price Group Link";
    begin
        if rec."Customer Disc. Group" <> Rec."Customer Price Group" then
            Rec.Validate(Rec."Customer Price Group", rec."Customer Disc. Group");
        if not PriceGroupLink.Get(rec."No.", Rec."Customer Disc. Group") then begin
            PriceGroupLink.Init();
            PriceGroupLink."Customer No." := Rec."No.";
            PriceGroupLink."Customer Discount Group Code" := Rec."Customer Disc. Group";
            PriceGroupLink.Insert(true);
        end;
    end;

    [EventSubscriber(ObjectType::table, database::"Customer", 'OnAfterValidateEvent', 'Post Code', true, true)]
    local procedure PostCodeOnAfterValidate(var Rec: Record "Customer")
    var
        SyncMasterData: Codeunit "Synchronize Master Data";
        PostCode: record "Post Code";
    begin
        SyncMasterData.CheckPostCode(Rec, PostCode);
    end;

}