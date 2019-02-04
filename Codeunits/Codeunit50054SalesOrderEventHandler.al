codeunit 50054 "Sales Order Event Handler"
{
    SingleInstance = true;
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Type', true, true)]
    local procedure SalesLineOnAfterValidateType(Var rec: record "Sales Line")
    var
        salesheader: record "sales header";
    begin
        if CompanyName() <> 'SECDenmark' then
            exit;

        salesheader.setrange("No.", rec."Document No.");
        salesheader.SetRange("Document Type", rec."Document Type");
        if salesheader.FindFirst() then
            if salesheader.Subsidiary <> '' then begin
                rec.SetRange("Document No.", salesheader."No.");
                rec.SetRange("Document Type", salesheader."Document Type");
                if rec.FindSet() then
                    Error('You cannot change an intercompany order');
            end;

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'No.', true, true)]
    local procedure SalesLineOnAfterValidateNo(Var rec: record "Sales Line")
    var
        salesheader: record "sales header";
        Item: record item;
    begin
        if rec.Type = rec.type::Item then begin
            Item.Get(rec."No.");
            if item."Default Location" <> '' then
                rec.validate("Location Code", item."Default Location");
        end;

        if CompanyName() <> 'SECDenmark' then
            exit;

        salesheader.setrange("No.", rec."Document No.");
        salesheader.SetRange("Document Type", rec."Document Type");
        if salesheader.FindFirst() then
            if salesheader.Subsidiary <> '' then begin
                rec.SetRange("Document No.", salesheader."No.");
                rec.SetRange("Document Type", salesheader."Document Type");
                if rec.FindSet() then
                    Error('You cannot change an intercompany order');
            end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Description', true, true)]
    local procedure SalesLineOnAfterValidateDescription(Var rec: record "Sales Line")
    var
        salesheader: record "sales header";
    begin
        if CompanyName() <> 'SECDenmark' then
            exit;

        salesheader.setrange("No.", rec."Document No.");
        salesheader.SetRange("Document Type", rec."Document Type");
        if salesheader.FindFirst() then
            if salesheader.Subsidiary <> '' then begin
                rec.SetRange("Document No.", salesheader."No.");
                rec.SetRange("Document Type", salesheader."Document Type");
                if rec.FindSet() then
                    Error('You cannot change an intercompany order');
            end;

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Quantity', true, true)]
    local procedure SalesLineOnAfterValidateQuantity(Var rec: record "Sales Line")
    var
        salesheader: record "sales header";
    begin
        if CompanyName() <> 'SECDenmark' then
            exit;

        salesheader.setrange("No.", rec."Document No.");
        salesheader.SetRange("Document Type", rec."Document Type");
        if salesheader.FindFirst() then
            if salesheader.Subsidiary <> '' then begin
                rec.SetRange("Document No.", salesheader."No.");
                rec.SetRange("Document Type", salesheader."Document Type");
                if rec.FindSet() then
                    Error('You cannot change an intercompany order');
            end;

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Qty. to Assemble to Order', true, true)]
    local procedure SalesLineOnAfterValidateQtyToAssembleToOrder(Var rec: record "Sales Line")
    var
        salesheader: record "sales header";
    begin
        if CompanyName() <> 'SECDenmark' then
            exit;

        salesheader.setrange("No.", rec."Document No.");
        salesheader.SetRange("Document Type", rec."Document Type");
        if salesheader.FindFirst() then
            if salesheader.Subsidiary <> '' then begin
                rec.SetRange("Document No.", salesheader."No.");
                rec.SetRange("Document Type", salesheader."Document Type");
                if rec.FindSet() then
                    Error('You cannot change an intercompany order');
            end;

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Unit Price', true, true)]
    local procedure SalesLineOnAfterValidateUnitPrice(Var rec: record "Sales Line")
    var
        salesheader: record "sales header";
    begin
        if CompanyName() <> 'SECDenmark' then
            exit;

        salesheader.setrange("No.", rec."Document No.");
        salesheader.SetRange("Document Type", rec."Document Type");
        if salesheader.FindFirst() then
            if salesheader.Subsidiary <> '' then begin
                rec.SetRange("Document No.", salesheader."No.");
                rec.SetRange("Document Type", salesheader."Document Type");
                if rec.FindSet() then
                    Error('You cannot change an intercompany order');
            end;

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Line Amount', true, true)]
    local procedure SalesLineOnAfterValidateLineAmount(Var rec: record "Sales Line")
    var
        salesheader: record "sales header";
    begin
        if CompanyName() <> 'SECDenmark' then
            exit;

        salesheader.setrange("No.", rec."Document No.");
        salesheader.SetRange("Document Type", rec."Document Type");
        if salesheader.FindFirst() then
            if salesheader.Subsidiary <> '' then begin
                rec.SetRange("Document No.", salesheader."No.");
                rec.SetRange("Document Type", salesheader."Document Type");
                if rec.FindSet() then
                    Error('You cannot change an intercompany order');
            end;

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Line Discount %', true, true)]
    local procedure SalesLineOnAfterValidateLineDiscount(Var rec: record "Sales Line")
    var
        salesheader: record "sales header";
    begin
        if CompanyName() <> 'SECDenmark' then
            exit;

        salesheader.setrange("No.", rec."Document No.");
        salesheader.SetRange("Document Type", rec."Document Type");
        if salesheader.FindFirst() then
            if salesheader.Subsidiary <> '' then begin
                rec.SetRange("Document No.", salesheader."No.");
                rec.SetRange("Document Type", salesheader."Document Type");
                if rec.FindSet() then
                    Error('You cannot change an intercompany order');
            end;

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Bid No.', true, true)]
    local procedure SalesLineOnAfterValidateBidNo(Var rec: record "Sales Line")
    var
        salesheader: record "sales header";
    begin
        if CompanyName() <> 'SECDenmark' then
            exit;

        salesheader.setrange("No.", rec."Document No.");
        salesheader.SetRange("Document Type", rec."Document Type");
        if salesheader.FindFirst() then
            if salesheader.Subsidiary <> '' then begin
                rec.SetRange("Document No.", salesheader."No.");
                rec.SetRange("Document Type", salesheader."Document Type");
                if rec.FindSet() then
                    Error('You cannot change an intercompany order');
            end;

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Bid Unit Sales Price', true, true)]
    local procedure SalesLineOnAfterValidateBidUnitSalesPrice(Var rec: record "Sales Line")
    var
        salesheader: record "sales header";
    begin
        if CompanyName() <> 'SECDenmark' then
            exit;

        salesheader.setrange("No.", rec."Document No.");
        salesheader.SetRange("Document Type", rec."Document Type");
        if salesheader.FindFirst() then
            if salesheader.Subsidiary <> '' then begin
                rec.SetRange("Document No.", salesheader."No.");
                rec.SetRange("Document Type", salesheader."Document Type");
                if rec.FindSet() then
                    Error('You cannot change an intercompany order');
            end;

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Bid Sales Discount', true, true)]
    local procedure SalesLineOnAfterValidateBidSalesDiscount(Var rec: record "Sales Line")
    var
        salesheader: record "sales header";
    begin
        if CompanyName() <> 'SECDenmark' then
            exit;

        salesheader.setrange("No.", rec."Document No.");
        salesheader.SetRange("Document Type", rec."Document Type");
        if salesheader.FindFirst() then
            if salesheader.Subsidiary <> '' then begin
                rec.SetRange("Document No.", salesheader."No.");
                rec.SetRange("Document Type", salesheader."Document Type");
                if rec.FindSet() then
                    Error('You cannot change an intercompany order');
            end;

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Unit Purchase Price', true, true)]
    local procedure SalesLineOnAfterValidateUnitPurchasePrice(Var rec: record "Sales Line")
    var
        salesheader: record "sales header";
    begin
        if CompanyName() <> 'SECDenmark' then
            exit;

        salesheader.setrange("No.", rec."Document No.");
        salesheader.SetRange("Document Type", rec."Document Type");
        if salesheader.FindFirst() then
            if salesheader.Subsidiary <> '' then begin
                rec.SetRange("Document No.", salesheader."No.");
                rec.SetRange("Document Type", salesheader."Document Type");
                if rec.FindSet() then
                    Error('You cannot change an intercompany order');
            end;

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Bid Unit Purchase Price', true, true)]
    local procedure SalesLineOnAfterValidateBidUnitPurchasePrice(Var rec: record "Sales Line")
    var
        salesheader: record "sales header";
    begin
        if CompanyName() <> 'SECDenmark' then
            exit;

        salesheader.setrange("No.", rec."Document No.");
        salesheader.SetRange("Document Type", rec."Document Type");
        if salesheader.FindFirst() then
            if salesheader.Subsidiary <> '' then begin
                rec.SetRange("Document No.", salesheader."No.");
                rec.SetRange("Document Type", salesheader."Document Type");
                if rec.FindSet() then
                    Error('You cannot change an intercompany order');
            end;

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Bid Purchase Discount', true, true)]
    local procedure SalesLineOnAfterValidateBidPurchaseDiscount(Var rec: record "Sales Line")
    var
        salesheader: record "sales header";
    begin
        if CompanyName() <> 'SECDenmark' then
            exit;

        salesheader.setrange("No.", rec."Document No.");
        salesheader.SetRange("Document Type", rec."Document Type");
        if salesheader.FindFirst() then
            if salesheader.Subsidiary <> '' then begin
                rec.SetRange("Document No.", salesheader."No.");
                rec.SetRange("Document Type", salesheader."Document Type");
                if rec.FindSet() then
                    Error('You cannot change an intercompany order');
            end;

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterValidateEvent', 'end customer', true, true)]
    local procedure SalesHeaderOnAfterValidateEndCustomer(var rec: record "Sales Header")
    var
        salesline: record "Sales Line";
    begin
        if CompanyName() <> 'SECDenmark' then
            exit;

        if rec.Subsidiary <> '' then
            Error('You cannot change an intercompany order');

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterValidateEvent', 'Reseller', true, true)]
    local procedure SalesHeaderOnAfterValidateReseller(var rec: record "Sales Header")
    var
        salesline: record "Sales Line";
    begin
        if CompanyName() <> 'SECDenmark' then
            exit;

        if rec.Subsidiary <> '' then
            Error('You cannot change an intercompany order');

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterValidateEvent', 'subsidiary', true, true)]
    local procedure SalesHeaderOnAfterValidateSubsidiary(var rec: record "Sales Header")
    var
        salesline: record "Sales Line";
    begin
        if CompanyName() <> 'SECDenmark' then
            exit;

        if rec.Subsidiary <> '' then
            Error('You cannot change an intercompany order');

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterValidateEvent', 'financing partner', true, true)]
    local procedure SalesHeaderOnAfterValidateFinancingPartner(var rec: record "Sales Header")
    var
        salesline: record "Sales Line";
    begin
        if CompanyName() <> 'SECDenmark' then
            exit;

        if rec.Subsidiary <> '' then
            Error('You cannot change an intercompany order');

    end;

}