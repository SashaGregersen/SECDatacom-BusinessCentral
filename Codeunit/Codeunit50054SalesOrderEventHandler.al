codeunit 50054 "Sales Order Event Handler"
{
    SingleInstance = true;
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Type', true, true)]
    local procedure SalesLineOnAfterValidateType(Var rec: record "Sales Line")
    var
        salesheader: record "sales header";
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.get();
        if CompanyName() <> GLSetup."Master Company" then
            exit;

        TestIfLineCanBeChanged(rec);
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'No.', true, true)]
    local procedure SalesLineOnAfterValidateNo(Var rec: record "Sales Line")
    var
        salesheader: record "sales header";
        Item: record item;
        SubItem: record "Item Substitution";
        GlSetup: Record "General Ledger Setup";
        ItemSub: page "Item Substitutions";
        PriceEventHandler: codeunit "Price Event Handler";
    begin
        GlSetup.get();
        if (rec.Type = rec.type::Item) and (not rec.isicorder) then begin
            if not Item.Get(rec."No.") then
                exit;
            if item."Default Location" <> '' then
                rec.validate("Location Code", item."Default Location");
            PriceEventHandler.UpdateListPriceAndDiscount(rec, Item);
            if Item."Blocked from purchase" = true then begin
                SubItem.SetRange("No.", Item."No.");
                if not SubItem.IsEmpty() then begin
                    If Confirm('Item %1 is blocked from purchase.\Do you wish to select a substitute item?', false, item."No.") then begin
                        if page.RunModal(page::"Item Substitutions", SubItem) = action::LookupOK then begin //dette fungere ikke med en runmodal
                            rec.Validate("No.", SubItem."Substitute No.");
                        end else
                            Error('There is no substitute items available');
                    end else
                        if not Confirm('Item %1 is blocked from purchase\Do you wish to sell the item?', false, Item."No.") then
                            Error('The Item cannot be sold, please select another item');
                end else begin
                    If not Confirm('Item %1 is blocked from purchase and no substitute item exists.\\Do you wish to sell the item?', false, Item."No.") then begin
                        Error('The Item cannot be sold, please select another item');
                    end;
                end;
            end;
        end;

        if CompanyName() <> GlSetup."Master Company" then
            exit;

        TestIfLineCanBeChanged(rec);
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Description', true, true)]
    local procedure SalesLineOnAfterValidateDescription(Var rec: record "Sales Line")
    var
        salesheader: record "sales header";
        GlSetup: Record "General Ledger Setup";
    begin
        GlSetup.get();
        if CompanyName() <> GlSetup."Master Company" then
            exit;

        TestIfLineCanBeChanged(rec);

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Quantity', true, true)]
    local procedure SalesLineOnAfterValidateQuantity(Var rec: record "Sales Line")
    var
        salesheader: record "sales header";
        GlSetup: Record "General Ledger Setup";
    begin
        GlSetup.get();
        if CompanyName() <> GlSetup."Master Company" then
            exit;

        TestIfLineCanBeChanged(rec);

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Qty. to Assemble to Order', true, true)]
    local procedure SalesLineOnAfterValidateQtyToAssembleToOrder(Var rec: record "Sales Line")
    var
        salesheader: record "sales header";
        GlSetup: record "General Ledger Setup";
    begin
        GlSetup.get();
        if CompanyName() <> GlSetup."Master Company" then
            exit;

        TestIfLineCanBeChanged(rec);

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Unit Price', true, true)]
    local procedure SalesLineOnAfterValidateUnitPrice(Var rec: record "Sales Line")
    var
        salesheader: record "sales header";
        GlSetup: record "General Ledger Setup";
    begin
        GlSetup.get();
        if CompanyName() <> GlSetup."Master Company" then
            exit;

        TestIfLineCanBeChanged(rec);

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Line Amount', true, true)]
    local procedure SalesLineOnAfterValidateLineAmount(Var rec: record "Sales Line")
    var
        salesheader: record "sales header";
        GlSetup: record "General Ledger Setup";
    begin
        GlSetup.get();
        if CompanyName() <> GlSetup."Master Company" then
            exit;

        TestIfLineCanBeChanged(rec);

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Line Discount %', true, true)]
    local procedure SalesLineOnAfterValidateLineDiscount(Var rec: record "Sales Line")
    var
        salesheader: record "sales header";
        GLSetup: Record "General Ledger Setup";
    begin
        GlSetup.get();
        if CompanyName() <> GlSetup."Master Company" then
            exit;

        TestIfLineCanBeChanged(rec);

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Bid No.', true, true)]
    local procedure SalesLineOnAfterValidateBidNo(Var rec: record "Sales Line")
    var
        salesheader: record "sales header";
        GlSetup: Record "General Ledger Setup";
    begin
        GlSetup.get();
        if CompanyName() <> GlSetup."Master Company" then
            exit;

        TestIfLineCanBeChanged(rec);

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Bid Unit Sales Price', true, true)]
    local procedure SalesLineOnAfterValidateBidUnitSalesPrice(Var rec: record "Sales Line")
    var
        salesheader: record "sales header";
        GlSetup: Record "General Ledger Setup";
    begin
        GlSetup.get();
        if CompanyName() <> GlSetup."Master Company" then
            exit;

        TestIfLineCanBeChanged(rec);

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Bid Sales Discount', true, true)]
    local procedure SalesLineOnAfterValidateBidSalesDiscount(Var rec: record "Sales Line")
    var
        salesheader: record "sales header";
        GlSetup: Record "General Ledger Setup";
    begin
        GlSetup.get();
        if CompanyName() <> GlSetup."Master Company" then
            exit;

        TestIfLineCanBeChanged(rec);

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Unit Purchase Price', true, true)]
    local procedure SalesLineOnAfterValidateUnitPurchasePrice(Var rec: record "Sales Line")
    var
        salesheader: record "sales header";
        GlSetup: Record "General Ledger Setup";
    begin
        GlSetup.get();
        if CompanyName() <> GlSetup."Master Company" then
            exit;

        TestIfLineCanBeChanged(rec);

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Bid Unit Purchase Price', true, true)]
    local procedure SalesLineOnAfterValidateBidUnitPurchasePrice(Var rec: record "Sales Line")
    var
        salesheader: record "sales header";
        GlSetup: Record "General Ledger Setup";
    begin
        GlSetup.get();
        if CompanyName() <> GlSetup."Master Company" then
            exit;

        TestIfLineCanBeChanged(rec);

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Bid Purchase Discount', true, true)]
    local procedure SalesLineOnAfterValidateBidPurchaseDiscount(Var rec: record "Sales Line")
    var
        salesheader: record "sales header";
        GlSetup: Record "General Ledger Setup";
    begin
        GlSetup.get();
        if CompanyName() <> GlSetup."Master Company" then
            exit;

        TestIfLineCanBeChanged(rec);

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterValidateEvent', 'end customer', true, true)]
    local procedure SalesHeaderOnAfterValidateEndCustomer(var rec: record "Sales Header")
    var
        GlSetup: Record "General Ledger Setup";
    begin
        GlSetup.get();
        if CompanyName() <> GlSetup."Master Company" then
            exit;

        if rec.Subsidiary <> '' then
            Error('You cannot change an intercompany order');

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterValidateEvent', 'Reseller', true, true)]
    local procedure SalesHeaderOnAfterValidateReseller(var rec: record "Sales Header")
    var
        GlSetup: Record "General Ledger Setup";
    begin
        GlSetup.get();
        if CompanyName() <> GlSetup."Master Company" then
            exit;

        if rec.Subsidiary <> '' then
            Error('You cannot change an intercompany order');
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterValidateEvent', 'subsidiary', true, true)]
    local procedure SalesHeaderOnAfterValidateSubsidiary(var rec: record "Sales Header"; var xrec: Record "Sales Header")
    var
        GlSetup: Record "General Ledger Setup";
    begin
        GlSetup.get();
        if CompanyName() <> GlSetup."Master Company" then
            exit;

        if (xrec.Subsidiary <> '') and (rec.Subsidiary <> xrec.Subsidiary) then
            Error('You cannot change an intercompany order');
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterValidateEvent', 'financing partner', true, true)]
    local procedure SalesHeaderOnAfterValidateFinancingPartner(var rec: record "Sales Header")
    var
        GlSetup: Record "General Ledger Setup";
    begin
        GlSetup.get();
        if CompanyName() <> GlSetup."Master Company" then
            exit;

        if rec.Subsidiary <> '' then
            Error('You cannot change an intercompany order');
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterValidateEvent', 'Status', true, true)]
    local procedure SalesHeaderOnAfterValidateStatus(var rec: record "Sales Header")
    var

    begin
        if rec."Document Type" = rec."Document Type"::Order then
            if rec.Status = rec.Status::Released then begin
                rec.TestField("Ship-to Contact");
                rec.TestField("Ship-to Phone No.");
                rec.TestField("Ship-to Email");
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Release Sales Document", 'OnAfterUpdateSalesDocLines', '', true, true)]
    local procedure OnAfterUpdateSalesDocLinesOnBeforeReleaseSalesDoc(var SalesHeader: record "Sales Header")
    var
        SalesReceiveSetup: record "Sales & Receivables Setup";
        SalesLine: record "Sales Line";
        SalesLine2: record "Sales Line";
        InsertSalesLine: record "Sales Line";
    begin
        if SalesHeader."Document Type" <> salesheader."Document Type"::Order then
            exit;

        if SalesHeader.Status = SalesHeader.Status::Released then begin
            SalesHeader.TestField("Ship-to Contact");
            SalesHeader.TestField("Ship-to Phone No.");
            SalesHeader.TestField("Ship-to Email");
        end;

        SalesReceiveSetup.Get();
        if SalesReceiveSetup."Freight Item" <> '' then begin
            SalesLine.SetRange("Document No.", SalesHeader."No.");
            SalesLine.SetRange("Document Type", SalesHeader."Document Type"::Order);
            SalesLine.SetRange(Type, SalesLine.Type::Item);
            SalesLine.SetRange("No.", SalesReceiveSetup."Freight Item");
            if not SalesLine.FindFirst() then
                if confirm('Do you want to add freight to the order?', true) then begin
                    SalesLine2.SetRange("Document No.", SalesHeader."No.");
                    SalesLine2.SetRange("Document Type", SalesHeader."Document Type"::Order);
                    SalesLine2.FindLast();
                    InsertSalesLine.init;
                    InsertSalesLine."Document No." := SalesHeader."No.";
                    InsertSalesLine."Document Type" := SalesHeader."Document Type";
                    InsertSalesLine.Validate("Line No.", SalesLine2."Line No." + 10000);
                    InsertSalesLine.Validate(Type, InsertSalesLine.type::Item);
                    InsertSalesLine.Validate("No.", SalesReceiveSetup."Freight Item");
                    InsertSalesLine.Validate(Quantity, 1);
                    InsertSalesLine.Insert(true);
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

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Release Sales Document", 'OnBeforeModifySalesDoc', '', true, true)]
    local procedure ReleaseSalesDocOnBeforeModifySalesDoc(VAR SalesHeader: Record "Sales Header"; PreviewMode: Boolean; VAR IsHandled: Boolean)
    var
        CustChkCrLimit: Codeunit "Cust-Check Cr. Limit";
        Conf001: TextConst DAN = 'Debitorens kreditmaksimum er overskredet. Ønsker du at forsætte?', ENU = 'The customer''s credit limit has been exceeded. Do you want to continue?';
    begin
        if CustChkCrLimit.SalesHeaderCheck(SalesHeader) then
            if not Confirm(Conf001) then
                IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Quote to Order (Yes/No)", 'OnBeforeRun', '', true, true)]
    local procedure SalesQuoteToOrderOnBeforeRun(VAR SalesHeader: Record "Sales Header"; VAR IsHandled: Boolean)
    var
        CustChkCrLimit: Codeunit "Cust-Check Cr. Limit";
        Conf001: TextConst DAN = 'Debitorens kreditmaksimum er overskredet. Ønsker du at forsætte?', ENU = 'The customer''s credit limit has been exceeded. Do you want to continue?';
    begin
        if CustChkCrLimit.SalesHeaderCheck(SalesHeader) then
            if not Confirm(Conf001) then
                IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, database::"Reservation Entry", 'OnAfterModifyEvent', '', true, true)]
    local procedure OnAfterModifyReservationEntry(VAR Rec: Record "Reservation Entry"; VAR xRec: Record "Reservation Entry"; RunTrigger: Boolean)
    var
        PartnerRecord: Record "Reservation Entry";
    begin
        IF Rec."Source Type" = 37 THEN BEGIN
            IF Rec."Serial No." = '' THEN BEGIN
                IF PartnerRecord.GET(Rec."Entry No.", NOT Rec.Positive) THEN BEGIN
                    IF (PartnerRecord."Source Type" = 32) and (PartnerRecord."Serial No." <> '') THEN BEGIN
                        Rec.VALIDATE("Serial No.", PartnerRecord."Serial No.");
                        Rec.MODIFY(FALSE);
                    END;
                END;
            END;
        END;
    end;

    local procedure TestIfLineCanBeChanged(var SalesLineToTest: Record "Sales Line")
    var
        SalesHeader: record "Sales Header";
        LocalSalesLine: record "Sales Line";
    begin
        exit; //Need to be updated! Find a way to test if it is the IC flow that does this
        If salesheader.get(SalesLineToTest."Document Type", SalesLineToTest."Document No.") then begin
            if salesheader.Subsidiary <> '' then begin
                LocalSalesLine.SetRange("Document No.", salesheader."No.");
                LocalSalesLine.SetRange("Document Type", salesheader."Document Type");
                //LocalSalesLine.SetRange("Line No.", SalesLineToTest."Line No.");
                if LocalSalesLine.FindSet() then
                    Error('You cannot change an intercompany order');
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Reseller', true, true)]
    local procedure SalesHeaderOnAfterValidateResller(var Rec: record "Sales Header")
    var
        AdvPaymentMethodSetup: Record "Advanced Payment Method Setup";
    begin
        if AdvPaymentMethodSetup.Get(Rec."Customer Posting Group", Rec."Currency Code") then
            Rec.Validate("Payment Method Code", AdvPaymentMethodSetup."Payment Method Code");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Currency Code', true, true)]
    local procedure SalesHeaderOnAfterValidateCurrencyCode(var Rec: record "Sales Header")
    var
        AdvPaymentMethodSetup: Record "Advanced Payment Method Setup";
    begin
        if AdvPaymentMethodSetup.Get(Rec."Customer Posting Group", Rec."Currency Code") then
            Rec.Validate("Payment Method Code", AdvPaymentMethodSetup."Payment Method Code");
    end;

    [EventSubscriber(ObjectType::table, database::"Sales Line", 'OnAfterValidateEvent', 'Qty. to Invoice', true, true)]

    local procedure OnAfterValidateSalesLineEvent(var rec: record "Sales Line")
    var
        ICpartner: record "IC Partner";
        SalesHeader: record "Sales Header";
        SalesLine: record "Sales Line";
        PurchLine: Record "Purchase Line";
        ICEvents: codeunit "IC Event Handler";
        ReservationEntry: record "Reservation Entry";
        PurchOrderEvents: codeunit "Purchase Order Event Handler";
    begin
        if UpdateSalesLineQtyToInv(rec, ReservationEntry, false, '') then begin
            if (rec."IC SO No." <> '') and (rec."IC SO Line No." <> 0) and (rec."IC PO No." <> '') AND (rec."IC PO Line No." <> 0) then begin
                SalesHeader.get(rec."Document Type", rec."Document No.");
                if ICEvents.GetICPartner(ICpartner, SalesHeader.Subsidiary) then begin
                    SalesLine.ChangeCompany(ICpartner."Inbox Details");
                    SalesLine.get(rec."Document Type", rec."IC SO No.", rec."IC SO Line No.");
                    /*  SalesLine."Qty. to Invoice" := rec."Qty. to Invoice";
                     SalesLine.Modify(true); */
                    UpdateSalesLineQtyToInv(SalesLine, ReservationEntry, true, ICpartner."Inbox Details");
                    PurchLine.ChangeCompany(ICpartner."Inbox Details");
                    PurchLine.get(rec."Document Type", rec."IC PO No.", rec."IC PO Line No.");
                    /* PurchLine."Qty. to Invoice" := rec."Qty. to Invoice";
                    PurchLine.Modify(true); */
                    PurchOrderEvents.UpdatePurchLineQtyToInv(PurchLine, ReservationEntry, true, ICpartner."Inbox Details");
                end;
            end;
        end;
    end;

    local procedure UpdateSalesLineQtyToInv(var SalesLine: record "Sales Line"; ReservationEntry: record "Reservation Entry"; ICOrder: Boolean; ICCompany: text[250]): Boolean
    var
        PositiveReservEntry: Record "Reservation Entry";
    begin
        if ICOrder then
            ReservationEntry.ChangeCompany(ICCompany);
        ReservationEntry.SetRange("Item No.", SalesLine."No.");
        ReservationEntry.SetRange("Source ID", SalesLine."Document No.");
        ReservationEntry.SetRange("Source Subtype", SalesLine."Document Type");
        ReservationEntry.SetRange("Source Ref. No.", SalesLine."Line No.");
        ReservationEntry.SetRange("Reservation Status", ReservationEntry."Reservation Status"::Reservation);
        ReservationEntry.SetRange(Binding, ReservationEntry.Binding::" ");
        ReservationEntry.SetRange(Positive, false);
        if ReservationEntry.FindSet() then begin
            repeat
                ReservationEntry.validate("Qty. to Invoice (Base)", SalesLine."Qty. to Invoice");
                ReservationEntry.Modify(true);
                if ICOrder then
                    PositiveReservEntry.ChangeCompany(ICCompany);
                if PositiveReservEntry.get(ReservationEntry."Entry No.", not ReservationEntry.Positive) then begin
                    PositiveReservEntry.validate("Qty. to Invoice (Base)", SalesLine."Qty. to Invoice");
                    PositiveReservEntry.Modify(true);
                end;
            until ReservationEntry.next = 0;
            exit(true);
        end;

    end;


}