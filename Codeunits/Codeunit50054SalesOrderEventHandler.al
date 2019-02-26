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
        SubItem: record "Item Substitution";
    begin
        if rec.Type = rec.type::Item then begin
            Item.Get(rec."No.");
            if item."Default Location" <> '' then
                rec.validate("Location Code", item."Default Location");
            if Item."Blocked from purchase" = true then begin
                SubItem.SetRange("No.", Item."No.");
                if not SubItem.IsEmpty() then begin
                    If Confirm('Item %1 is blocked from purchase.\Do you wish to select a substitute item?', false, item."No.") then begin
                        if page.RunModal(page::"Item Substitutions", SubItem) = action::LookupOK then begin
                            rec.Validate("No.", SubItem."Substitute No.");
                        end else
                            Error('There is no substitute items available');
                    end;
                end else begin
                    If not Confirm('Item %1 is blocked from purchase and no substitute item exists.\\Do you wish to sell the item?', false, Item."No.") then begin
                        Error('The Item cannot be sold, please select another item');
                    end;
                end;
            end;
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

    begin
        if CompanyName() <> 'SECDenmark' then
            exit;

        if rec.Subsidiary <> '' then
            Error('You cannot change an intercompany order');

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterValidateEvent', 'Reseller', true, true)]
    local procedure SalesHeaderOnAfterValidateReseller(var rec: record "Sales Header")
    var

    begin
        if CompanyName() <> 'SECDenmark' then
            exit;

        if rec.Subsidiary <> '' then
            Error('You cannot change an intercompany order');

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterValidateEvent', 'subsidiary', true, true)]
    local procedure SalesHeaderOnAfterValidateSubsidiary(var rec: record "Sales Header")
    var

    begin
        if CompanyName() <> 'SECDenmark' then
            exit;

        if rec.Subsidiary <> '' then
            Error('You cannot change an intercompany order');

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterValidateEvent', 'financing partner', true, true)]
    local procedure SalesHeaderOnAfterValidateFinancingPartner(var rec: record "Sales Header")
    var

    begin
        if CompanyName() <> 'SECDenmark' then
            exit;

        if rec.Subsidiary <> '' then
            Error('You cannot change an intercompany order');

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterValidateEvent', 'Status', true, true)]
    local procedure SalesHeaderOnAfterValidateStatus(var rec: record "Sales Header")
    var

    begin
        if rec.Status = rec.Status::Released then begin
            rec.TestField("Sell-to Contact");
            rec.TestField("OIOUBL-Sell-to Contact E-Mail");
            rec.TestField("OIOUBL-Sell-to Contact Phone No.");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Release Sales Document", 'OnAfterUpdateSalesDocLines', '', true, true)]
    local procedure OnAfterUpdateSalesDocLinesOnBeforeReleaseSalesDoc(var SalesHeader: record "Sales Header")
    var
        SalesReceiveSetup: record "Sales & Receivables Setup";
        SalesLine: record "Sales Line";
        InsertSalesLine: record "Sales Line";
    begin
        if SalesHeader.Status = SalesHeader.Status::Released then begin
            SalesHeader.TestField("Sell-to Contact");
            SalesHeader.TestField("OIOUBL-Sell-to Contact E-Mail");
            SalesHeader.TestField("OIOUBL-Sell-to Contact Phone No.");
        end;

        SalesReceiveSetup.Get();
        if SalesReceiveSetup."Freight Item" <> '' then begin
            if confirm('Do you want to add freight to the order?', true) then begin
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                if SalesLine.FindLast() then begin
                    InsertSalesLine.init;
                    InsertSalesLine."Document No." := SalesHeader."No.";
                    InsertSalesLine."Document Type" := SalesHeader."Document Type";
                    InsertSalesLine.Validate("Line No.", SalesLine."Line No." + 10000);
                    InsertSalesLine.Validate(Type, InsertSalesLine.type::Item);
                    InsertSalesLine.Validate("No.", SalesReceiveSetup."Freight Item");
                    InsertSalesLine.Validate(Quantity, 1);
                    InsertSalesLine.Insert(true);
                end;
            end;

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', true, true)]
    local procedure OnAfterPostSalesDocOnPostSalesHeader(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean)
    var
        EdiProfile: Record "EDI Profile";
    begin
        EdiProfile.SetRange(Type, EdiProfile.Type::Customer);
        EdiProfile.SetRange("No.", SalesHeader."Sell-to Customer No.");
        if not EdiProfile.FindFirst then exit;

        if SalesShptHdrNo <> '' then begin
            EdiProfile.EDIAction := EdiProfile.EDIAction::Shipment;
            EdiProfile.DocumentNo := SalesShptHdrNo;
            Codeunit.Run(EdiProfile."EDI Object", EdiProfile);
        end;

        if SalesInvHdrNo <> '' then begin
            EdiProfile.EDIAction := EdiProfile.EDIAction::Invoice;
            EdiProfile.DocumentNo := SalesInvHdrNo;
            Codeunit.Run(EdiProfile."EDI Object", EdiProfile);
        end;
    end;
}