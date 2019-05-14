codeunit 50054 "Sales Order Event Handler"
{
    SingleInstance = true;
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnBeforeValidateEvent', 'Type', true, true)]
    local procedure SalesLineOnBeforeValidateType(Var rec: record "Sales Line")
    var
        salesheader: record "sales header";
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.get();
        if CompanyName() <> GLSetup."Master Company" then
            exit;

        TestIfICLineCanBeChanged(rec);
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnBeforeValidateEvent', 'No.', true, true)]
    local procedure SalesLineOnBeforeValidateNo(Var rec: record "Sales Line")
    var
        salesheader: record "sales header";
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.get();
        if CompanyName() <> GLSetup."Master Company" then
            exit;

        TestIfICLineCanBeChanged(rec);
    end;


    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'No.', true, true)]
    local procedure SalesLineOnAfterValidateNo(Var rec: record "Sales Line")
    var
        salesheader: record "sales header";
        Item: record item;
        SubItem: record "Item Substitution";
        ItemSub: page "Item Substitutions";
        PriceEventHandler: codeunit "Price Event Handler";
    begin
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
                        if page.RunModal(page::"Item Substitutions", SubItem) = action::LookupOK then begin
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

        TestIfICLineCanBeChanged(rec);

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

        TestIfICLineCanBeChanged(rec);

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

        TestIfICLineCanBeChanged(rec);

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Unit Price', true, true)]
    local procedure SalesLineOnAfterValidateUnitPrice(Var rec: record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        salesheader: record "sales header";
        GlSetup: record "General Ledger Setup";
    begin
        GlSetup.get();
        if CompanyName() <> GlSetup."Master Company" then
            exit;

        if Rec."Unit Price" = xRec."Unit Price" then exit;

        TestIfICLineCanBeChanged(rec);

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

        TestIfICLineCanBeChanged(rec);

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Line Discount %', true, true)]
    local procedure SalesLineOnAfterValidateLineDiscount(Var rec: record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        salesheader: record "sales header";
        GLSetup: Record "General Ledger Setup";
    begin
        GlSetup.get();
        if CompanyName() <> GlSetup."Master Company" then
            exit;

        if Rec."Line Discount %" = xRec."Line Discount %" then exit; //Kunne opdatere bogf. dato

        TestIfICLineCanBeChanged(rec);
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

        TestIfICLineCanBeChanged(rec);

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

        TestIfICLineCanBeChanged(rec);

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

        TestIfICLineCanBeChanged(rec);

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

        TestIfICLineCanBeChanged(rec);

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

        TestIfICLineCanBeChanged(rec);

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

        TestIfICLineCanBeChanged(rec);

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterValidateEvent', 'end customer', true, true)]
    local procedure SalesHeaderOnAfterValidateEndCustomer(var rec: record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        GlSetup: Record "General Ledger Setup";
    begin
        GlSetup.get();
        if CompanyName() <> GlSetup."Master Company" then
            exit;

        if Rec."End Customer" = xRec."End Customer" then exit;

        if rec.Subsidiary <> '' then
            Error('You cannot change an intercompany order');
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterValidateEvent', 'Reseller', true, true)]
    local procedure SalesHeaderOnAfterValidateReseller(var rec: record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        GlSetup: Record "General Ledger Setup";
    begin
        GlSetup.get();
        if CompanyName() <> GlSetup."Master Company" then
            exit;

        if Rec."Reseller" = xRec."Reseller" then exit;

        if rec.Subsidiary <> '' then
            Error('You cannot change an intercompany order');
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterValidateEvent', 'subsidiary', true, true)]
    local procedure SalesHeaderOnAfterValidateSubsidiary(var rec: record "Sales Header"; var xrec: Record "Sales Header"; CurrFieldNo: Integer)
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
    local procedure SalesHeaderOnAfterValidateFinancingPartner(var rec: record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        GlSetup: Record "General Ledger Setup";
    begin
        GlSetup.get();
        if CompanyName() <> GlSetup."Master Company" then
            exit;

        if Rec."Financing Partner" = xRec."Financing Partner" then exit;

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

    /* [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnBeforeValidateEvent', 'Quantity', true, true)]
    local procedure TestICFieldsOnBeforeValidateQty(var Rec: Record "Sales Line")
    var
        ICPONO: code[20];
        ICSONo: code[20];
    begin
        ICPONO := Rec."IC PO No.";
        ICSONo := Rec."IC SO No.";
    end; */

    local procedure TestIfICLineCanBeChanged(var SalesLineToTest: Record "Sales Line")
    var
        SalesHeader: record "Sales Header";
        LocalSalesLine: record "Sales Line";
        HandledICInboxSalesHeader: record "Handled IC Inbox Sales Header";
    begin
        //exit; //Need to be updated! Find a way to test if it is the IC flow that does this
        HandledICInboxSalesHeader.setrange("No.", SalesLineToTest."IC PO No.");
        if HandledICInboxSalesHeader.FindFirst() then begin
            If salesheader.get(SalesLineToTest."Document Type", SalesLineToTest."Document No.") then begin
                if salesheader.Subsidiary <> '' then begin
                    LocalSalesLine.SetRange("Document No.", salesheader."No.");
                    LocalSalesLine.SetRange("Document Type", salesheader."Document Type");
                    LocalSalesLine.SetRange("Line No.", SalesLineToTest."Line No.");
                    if LocalSalesLine.FindSet() then
                        Error('You cannot change an intercompany order');
                end;
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

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", 'OnBeforeConfirmSalesPost', '', true, true)]
    local procedure OnBeforeConfirmSalesPost_PostYesNo(VAR SalesHeader: Record "Sales Header"; VAR HideDialog: Boolean; VAR IsHandled: Boolean; VAR DefaultOption: Integer; VAR PostAndSend: Boolean)
    var
        SelectionPage: Page "Sales Posting Options";
    begin
        Clear(SelectionPage);
        SelectionPage.SetRecord(SalesHeader);
        if SelectionPage.RunModal() = Action::OK then
            SelectionPage.GetRecord(SalesHeader)
        else
            IsHandled := true;

        HideDialog := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Inventory Pick/Movement", 'OnAfterCreateInventoryPickMovement', '', true, true)]
    local procedure CreateInvtPick_OnAfterCreateInventoryPickMovement(VAR WarehouseRequest: Record "Warehouse Request"; LineCreated: Boolean)
    var
        WhseActivHeader: Record "Warehouse Activity Header";
        WhseActivLine: Record "Warehouse Activity Line";
        TmpLocation: Record Location temporary;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        if WarehouseRequest."Source Document" <> WarehouseRequest."Source Document"::"Sales Order" then exit;
        if WarehouseRequest."Source Subtype" <> WarehouseRequest."Source Subtype"::"1" then exit;

        SECGetShippingAdviceLocations(WarehouseRequest, TmpLocation);

        WhseActivHeader.SetRange("Source Document", WarehouseRequest."Source Document");
        WhseActivHeader.SetRange("Source Type", WarehouseRequest."Source Type");
        WhseActivHeader.SetRange("Source Subtype", WarehouseRequest."Source Subtype");

        if TmpLocation.FindSet() then
            repeat
                WhseActivHeader.SetRange("Location Code", TmpLocation.Code);
                WhseActivHeader.FindFirst();
                WhseActivHeader.Delete(true);
            until TmpLocation.Next() = 0;
    end;

    procedure SECGetShippingAdviceLocations(var WarehouseRequest: Record "Warehouse Request"; TmpLocation: Record Location)
    var
        Location: Record Location;
        WhseActivLine: Record "Warehouse Activity Line";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        SalesHeader.Get(WarehouseRequest."Source Subtype", WarehouseRequest."Source No.");
        if SalesHeader."SEC Shipping Advice" <> SalesHeader."SEC Shipping Advice"::Complete then exit;

        if Location.FindSet() then
            repeat
                WhseActivLine.SetRange("Source Document", WarehouseRequest."Source Document");
                WhseActivLine.SetRange("Source Type", WarehouseRequest."Source Type");
                WhseActivLine.SetRange("Source Subtype", WarehouseRequest."Source Subtype");
                WhseActivLine.SetRange("Location Code", Location.Code);
                WhseActivLine.SetRange("Activity Type", WhseActivLine."Action Type"::Take);
                if WhseActivLine.FindSet() then
                    repeat
                        SalesLine.Get(WhseActivLine."Source Subtype",
                                        WhseActivLine."Source No.",
                                        WhseActivLine."Source Line No.");
                        if SalesLine."Qty. to Ship (Base)" <> WhseActivLine."Qty. (Base)" then begin
                            TmpLocation := Location;
                            if TmpLocation.Insert() then;
                        end;
                    until WhseActivLine.Next() = 0;
            until Location.Next() = 0;
    end;

    procedure SECCheckShippingAdvice(SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        Item: Record Item;
        QtyToShipBaseTotal: Decimal;
        Result: Boolean;
        Location: Record Location;
        ShippingAdviceErr: TextConst ENU = 'This document cannot be shipped completely. Change the value in the Shipping Advice field to Partial.',
                                     DAN = 'Dette dokument kan leveres fuldt ud. Du kan ændre værdien i feltet Afsendelsesadvis til Delvis.';
    begin
        if SalesHeader."SEC Shipping Advice" <> SalesHeader."SEC Shipping Advice"::Complete then exit;

        if Location.FindSet() then
            repeat
                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine.SetRange("Drop Shipment", false);
                SalesLine.SetRange(Type, SalesLine.Type::Item);
                SalesLine.SetRange("Location Code", Location.Code);

                Result := true;
                if SalesLine.FindSet() then
                    repeat
                        Item.Get(SalesLine."No.");
                        if SalesLine.IsShipment and (Item.Type = Item.Type::Inventory) then begin
                            QtyToShipBaseTotal += SalesLine."Qty. to Ship (Base)";
                            if SalesLine."Quantity (Base)" <> SalesLine."Qty. to Ship (Base)" + SalesLine."Qty. Shipped (Base)" then
                                Result := false;
                        end;
                    until SalesLine.Next() = 0;
                if QtyToShipBaseTotal = 0 then
                    Result := true;
                if not Result then
                    Error(ShippingAdviceErr);
            until Location.Next() = 0;
    end;
}