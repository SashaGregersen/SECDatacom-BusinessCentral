codeunit 50052 "Customer Event Handler"
{
    SingleInstance = true;
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::Table, database::"Customer Price Group", 'OnAfterInsertEvent', '', true, true)]
    local procedure CustomerPriceGroupOnAfterinsert(var Rec: Record "Customer Price Group"; Runtrigger: Boolean)
    var
        CustomerDiscountGroup: Record "Customer Discount Group";
    begin
        if not Runtrigger then
            exit;
        If not CustomerDiscountGroup.Get(Rec.Code) then begin
            CustomerDiscountGroup.Init();
            CustomerDiscountGroup.Code := Rec.Code;
            CustomerDiscountGroup.Description := Rec.Description;
            CustomerDiscountGroup.Insert(false);
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Customer Price Group", 'OnAfterRenameEvent', '', true, true)]
    local procedure CustomerPriceGroupOnAfterRename(var Rec: Record "Customer Price Group"; var xRec: Record "Customer Price Group"; Runtrigger: Boolean)
    var
        CustomerDiscountGroup: Record "Customer Discount Group";
    begin
        if not Runtrigger then
            exit;
        If CustomerDiscountGroup.Get(xRec.Code) then
            CustomerDiscountGroup.Rename(Rec.Code)
    end;

    [EventSubscriber(ObjectType::Table, database::"Customer Discount Group", 'OnAfterInsertEvent', '', true, true)]
    local procedure CustomerDiscountGroupOnAfterinsert(var Rec: Record "Customer Discount Group"; RunTrigger: Boolean)
    var
        CustomerPriceGroup: Record "Customer Price Group";
    begin
        if not Runtrigger then
            exit;
        If not CustomerpriceGroup.Get(Rec.Code) then begin
            CustomerPriceGroup.Init();
            CustomerPriceGroup.Code := Rec.Code;
            CustomerPriceGroup.Description := Rec.Description;
            CustomerPriceGroup."Allow Line Disc." := false;
            CustomerPriceGroup.Insert(false);
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Customer Discount Group", 'OnAfterRenameEvent', '', true, true)]
    local procedure CustomerDiscountGroupOnAfterRename(var Rec: Record "Customer Discount Group"; xRec: record "Customer Discount Group"; RunTrigger: Boolean)
    var
        CustomerPriceGroup: Record "Customer Price Group";
    begin
        if not Runtrigger then
            exit;
        If CustomerpriceGroup.Get(xRec.Code) then
            CustomerPriceGroup.Rename(rec.Code)
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
        if rec.IsTemporary() then
            exit;
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
        if rec.IsTemporary() then
            exit;
        if CompanyName() = rec."Owning Company" then begin
            SalesSetup.get;
            IF SalesSetup."Synchronize Customer" = FALSE then
                Exit;
            SyncMasterData.SynchronizeCustomerToSECDK(Rec);
        end else
            Error('You must modify this customer in %1', rec."Owning Company");
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterInsertEvent', '', true, true)]

    local procedure UpdateSellToCustomerInRelatedFields(var rec: Record "Sales Header"; runtrigger: Boolean)
    var
        Customer: record Customer;
    begin
        if not runtrigger then
            exit;
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

    [EventSubscriber(ObjectType::table, database::"Ship-to Address", 'OnAfterinsertEvent', '', true, true)]
    local procedure ItemSubstituionOnAfterInsertEvent(var Rec: Record "Ship-to Address"; runtrigger: Boolean)
    var
        SyncMasterData: Codeunit "Synchronize Master Data";
    begin
        if not runtrigger then
            exit;
        if rec.IsTemporary() then
            exit;
        SyncMasterData.SynchronizeShipToAddressToCompany(Rec);
    end;

    [EventSubscriber(ObjectType::table, database::"Ship-to Address", 'OnAfterModifyEvent', '', true, true)]
    local procedure ItemSubstitutionOnAfterModifyEvent(var Rec: Record "Ship-to Address"; runtrigger: Boolean)
    var
        SyncMasterData: Codeunit "Synchronize Master Data";
    begin
        if not runtrigger then
            exit;
        if rec.IsTemporary() then
            exit;
        SyncMasterData.SynchronizeShipToAddressToCompany(Rec);
    end;

    [EventSubscriber(ObjectType::table, database::"Post Code", 'OnAfterinsertEvent', '', true, true)]
    local procedure PostCodeOnAfterInsertEvent(var Rec: Record "Post Code"; runtrigger: Boolean)
    var
        SyncMasterData: Codeunit "Synchronize Master Data";
    begin
        if not runtrigger then
            exit;
        if rec.IsTemporary() then
            exit;
        SyncMasterData.SynchronizePostCodeToCompany(Rec);
    end;

    [EventSubscriber(ObjectType::table, database::"Post Code", 'OnAfterModifyEvent', '', true, true)]
    local procedure PostCodeOnAfterModifyEvent(var Rec: Record "Post Code"; runtrigger: Boolean)
    var
        SyncMasterData: Codeunit "Synchronize Master Data";
    begin
        if not runtrigger then
            exit;
        if rec.IsTemporary() then
            exit;
        SyncMasterData.SynchronizePostCodeToCompany(Rec);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"E-Mail Template Mangement", 'SendMail_BeforePrint', '', true, true)]
    local procedure EmailTemplMgt_SendMail_BeforePrint(var FilterRecord: RecordRef; var ReportParameters: Text)
    var
        EDICygate: Codeunit EDICygate;
    begin
        ReportParameters := EDICygate.GetParameters(FilterRecord);
    end;

    [EventSubscriber(ObjectType::table, database::"Var", 'OnAfterInsertEvent', '', true, true)]
    local procedure VARIDOnAfterInsertEvent(var Rec: Record "Var"; runtrigger: Boolean)
    var
        SyncMasterData: Codeunit "Synchronize Master Data";
    begin
        if not runtrigger then
            exit;
        if rec.IsTemporary() then
            exit;
        SyncMasterData.SynchronizeVARIDToCompany(Rec);
    end;

    [EventSubscriber(ObjectType::table, database::"Contact", 'OnAfterInsertEvent', '', true, true)]
    local procedure OnAfterInsertContactEvent(var Rec: Record "Contact"; runtrigger: Boolean)
    var
        SalesSetup: record "Sales & Receivables Setup";
        SyncMasterData: codeunit "Synchronize Master Data";
    begin
        If not runtrigger then
            EXIT;
        if rec.IsTemporary() then
            exit;
        rec.validate("Owning-Company", CompanyName());

        if CompanyName() = rec."Owning-Company" then begin
            SalesSetup.get;
            IF SalesSetup."Synchronize Customer" = FALSE then
                Exit;
            SyncMasterData.SynchronizeContactToCompany(Rec);
        end else
            error('You must modify this contact in %1', rec."Owning-Company");
    end;

    [EventSubscriber(ObjectType::table, database::"Contact", 'OnAfterModifyEvent', '', true, true)]
    local procedure OnAfterModifyContactEvent(var Rec: Record "Contact"; runtrigger: Boolean)
    var
        SalesSetup: record "Sales & Receivables Setup";
        SyncMasterData: codeunit "Synchronize Master Data";
    begin
        If not runtrigger then
            EXIT;
        if rec.IsTemporary() then
            exit;
        rec.validate("Owning-Company", CompanyName());

        if CompanyName() = rec."Owning-Company" then begin
            SalesSetup.get;
            IF SalesSetup."Synchronize Customer" = FALSE then
                Exit;
            SyncMasterData.SynchronizeContactToCompany(Rec);
        end else
            error('You must modify this contact in %1', rec."Owning-Company");
    end;
}