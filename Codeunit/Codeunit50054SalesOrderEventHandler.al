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
        BidNotification: Notification;
        Bid: record bid;
        BidItemPrices: record "Bid Item Price";
        BidMgt: codeunit "Bid Management";
        BidMessage: text;
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
            salesheader.get(rec."Document Type", rec."Document No.");
            bid.setrange("Vendor No.", Item."Vendor No.");
            bid.SetFilter("Expiry Date", '>=%1|%2', Today, 0D);
            bid.setrange(Deactivate, false);
            bid.setrange("One Time Bid", false);
            bid.setrange("Project Sale", false);
            if bid.FindSet() then
                repeat
                    BidItemPrices.SetRange("Bid No.", Bid."No.");
                    BidItemPrices.SetRange("item No.", Item."No.");
                    BidItemPrices.SetFilter("Expiry Date", '>=%1|%2', Today, 0D);
                    BidItemPrices.setfilter("Customer No.", '%1|%2', salesheader.Reseller, '');
                    BidItemPrices.SetRange("Currency Code", Item."Vendor Currency");
                    if BidItemPrices.FindSet() then begin
                        BidMessage := StrSubstNo('One or more bids exist on item %1', Item."No.");
                        BidNotification.Message(BidMessage);
                        BidNotification.Scope := NotificationScope::LocalScope;
                        BidNotification.Send();
                    end;
                until bid.next = 0;

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
        if rec."Bid No." <> '' then
            rec.validate("Bid No.", rec."Bid No.");
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

        //TestIfICLineCanBeChanged(rec); // 09-07-19 SDG had to remove this in order to post IC documents 

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
        if not GuiAllowed then
            exit;

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
        EdiProfile.setfilter("EDI Object", '<>%1', 0);
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
        if not GuiAllowed then
            exit;

        if CustChkCrLimit.SalesHeaderCheck(SalesHeader) then
            if not Confirm(Conf001) then
                IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, database::"Reservation Entry", 'OnAfterInsertEvent', '', true, true)]
    local procedure OnAfterInsertReservationEntry(VAR Rec: Record "Reservation Entry"; RunTrigger: Boolean)
    var
        PartnerRecord: Record "Reservation Entry";
    begin
        /* if not RunTrigger then
            exit; */
        if rec.IsTemporary then
            exit;
        IF (Rec."Source Type" = 37) THEN BEGIN
            IF Rec."Serial No." = '' THEN BEGIN
                IF PartnerRecord.GET(Rec."Entry No.", NOT Rec.Positive) THEN BEGIN
                    IF (PartnerRecord."Source Type" = 32) and (PartnerRecord."Serial No." <> '') THEN BEGIN
                        Rec.VALIDATE("Serial No.", PartnerRecord."Serial No.");
                        rec.UpdateItemTracking();
                        Rec.MODIFY(FALSE);
                    END;
                END;
            END;
        END;
        IF (rec."Source Type" = 32) THEN BEGIN
            IF Rec."Serial No." <> '' THEN BEGIN
                IF PartnerRecord.GET(Rec."Entry No.", NOT Rec.Positive) THEN BEGIN
                    IF (PartnerRecord."Source Type" = 37) and (PartnerRecord."Serial No." = '') THEN BEGIN
                        PartnerRecord.VALIDATE("Serial No.", Rec."Serial No.");
                        PartnerRecord.UpdateItemTracking();
                        PartnerRecord.MODIFY(FALSE);
                    END;
                END;
            END;
        END;
    end;

    [EventSubscriber(ObjectType::Table, database::"Reservation Entry", 'OnAfterModifyEvent', '', true, true)]
    local procedure OnAfterModifyReservationEntry(VAR Rec: Record "Reservation Entry"; VAR xRec: Record "Reservation Entry"; RunTrigger: Boolean)
    var
        PartnerRecord: Record "Reservation Entry";
    begin
        // if not RunTrigger then
        //     exit;
        if rec.IsTemporary then
            exit;
        IF (Rec."Source Type" = 37) THEN BEGIN
            IF Rec."Serial No." = '' THEN BEGIN
                IF PartnerRecord.GET(Rec."Entry No.", NOT Rec.Positive) THEN BEGIN
                    IF (PartnerRecord."Source Type" = 32) and (PartnerRecord."Serial No." <> '') THEN BEGIN
                        Rec.VALIDATE("Serial No.", PartnerRecord."Serial No.");
                        rec.UpdateItemTracking();
                        Rec.MODIFY(FALSE);
                    END;
                END;
            END;
        END;
        IF (rec."Source Type" = 32) THEN BEGIN
            IF Rec."Serial No." <> '' THEN BEGIN
                IF PartnerRecord.GET(Rec."Entry No.", NOT Rec.Positive) THEN BEGIN
                    IF (PartnerRecord."Source Type" = 37) and (PartnerRecord."Serial No." = '') THEN BEGIN
                        PartnerRecord.VALIDATE("Serial No.", Rec."Serial No.");
                        PartnerRecord.UpdateItemTracking();
                        PartnerRecord.MODIFY(FALSE);
                    END;
                END;
            END;
        END;
    end;

    local procedure TestIfICLineCanBeChanged(var SalesLineToTest: Record "Sales Line")
    var
        SalesHeader: record "Sales Header";
        LocalSalesLine: record "Sales Line";
        HandledICInboxSalesLine: record "Handled IC Inbox Sales Line";
    begin
        HandledICInboxSalesLine.setrange("Document No.", SalesLineToTest."IC PO No.");
        HandledICInboxSalesLine.SetRange("Line No.", SalesLineToTest."IC PO Line No.");
        if HandledICInboxSalesLine.FindFirst() then begin
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
        SalesOrderAction: Codeunit "Sales Order Event Handler";
    begin
        Clear(SelectionPage);
        SelectionPage.SetRecord(SalesHeader);
        SelectionPage.LookupMode(true);
        if SelectionPage.RunModal() = Action::LookupOK then
            SelectionPage.GetRecord(SalesHeader)
        else
            IsHandled := true;

        HideDialog := true;

        SalesOrderAction.SECCheckShippingAdvice(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterCopySellToCustomerAddressFieldsFromCustomer', '', true, true)]
    local procedure SalesHeader_OnAfterCopySellToCustomerAddressFieldsFromCustomer(var SalesHeader: Record "Sales Header"; SellToCustomer: Record Customer; CurrentFieldNo: Integer)
    begin
        SalesHeader.xShippingAdvice := SellToCustomer.xShippingAdvice;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Inventory Pick/Movement", 'OnAfterAutoCreatePickOrMove', '', true, true)]
    local procedure CreateInvtPick_OnAfterAutoCreatePickOrMove(var WarehouseRequest: Record "Warehouse Request"; LineCreated: Boolean)
    var
        WhseActivHeader: Record "Warehouse Activity Header";
        WhseActivLine: Record "Warehouse Activity Line";
        TmpLocation: Record Location temporary;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        if WarehouseRequest."Source Document" <> WarehouseRequest."Source Document"::"Sales Order" then exit;
        if WarehouseRequest."Source Subtype" <> WarehouseRequest."Source Subtype"::"1" then exit;
        SalesHeader.Get(WarehouseRequest."Source Subtype", WarehouseRequest."Source No.");
        if SalesHeader."xShippingAdvice" <> SalesHeader."xShippingAdvice"::Complete then exit;

        SECGetShippingAdviceLocations(WarehouseRequest, TmpLocation, SalesHeader);

        WhseActivHeader.SetRange("Source Document", WarehouseRequest."Source Document");
        WhseActivHeader.SetRange("Source Type", WarehouseRequest."Source Type");
        WhseActivHeader.SetRange("Source Subtype", WarehouseRequest."Source Subtype");
        WhseActivHeader.SetRange("Source No.", WarehouseRequest."Source No.");

        if TmpLocation.FindSet() then
            repeat
                WhseActivHeader.SetRange("Location Code", TmpLocation.Code);
                if WhseActivHeader.FindFirst() then
                    WhseActivHeader.Delete(true);
            until TmpLocation.Next() = 0;
    end;

    procedure SECGetShippingAdviceLocations(var WarehouseRequest: Record "Warehouse Request"; var TmpLocation: Record Location; SalesHeader: Record "Sales Header")
    var
        Location: Record Location;
        WhseActivLine: Record "Warehouse Activity Line";
        SalesLine: Record "Sales Line";
        ItemCheckAvail: Codeunit "Item-Check Avail.";
        Item: record item;
    begin
        if Location.FindSet() then
            repeat
                WhseActivLine.SetRange("Source Document", WarehouseRequest."Source Document");
                WhseActivLine.SetRange("Source Type", WarehouseRequest."Source Type");
                WhseActivLine.SetRange("Source Subtype", WarehouseRequest."Source Subtype");
                WhseActivLine.SetRange("Source No.", WarehouseRequest."Source No.");
                WhseActivLine.SetRange("Location Code", Location.Code);

                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine.SetRange("Location Code", Location.Code);
                SalesLine.setrange(Type, SalesLine.type::Item); //SDG 22-07-19
                if SalesLine.FindSet() then
                    repeat
                        Item.get(SalesLine."No.");//SDG 22-07-19
                        if item.type = item.type::Inventory then begin//SDG 22-07-19
                            WhseActivLine.SetRange("Source Line No.", SalesLine."Line No.");
                            //if (not WhseActivLine.FindFirst()) or //SDG 22-07-19
                            //(SalesLine."Qty. to Ship (Base)" <> salesLine.Quantity) then begin //SDG 22-07-19
                            if (not WhseActivLine.FindFirst()) or
                                (CalcInvtAvailability(WhseActivLine, WhseActivLine."Item No.", SalesLine) < SalesLine.Quantity) then begin //SDG 22-07-19
                                TmpLocation := Location;
                                if TmpLocation.Insert() then;
                            end;
                        end;//SDG 22-07-19
                    until SalesLine.Next() = 0;
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
                                     DAN = 'Dette dokument kan ikke leveres fuldt ud. Du kan ændre værdien i feltet Afsendelsesadvis til Delvis.';
    begin
        if SalesHeader.xShippingAdvice <> SalesHeader.xShippingAdvice::Complete then exit;

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

    procedure CalcInvtAvailability(WhseActivLine: record "Warehouse Activity Line"; ItemNo: code[20]; salesline: record "Sales Line"): Decimal
    var
        Item: Record item;
        WhseAvailMgt: codeunit "Warehouse Availability Mgt.";
        Location: record location;
        QtyAssgndtoPick: Decimal;
        QtyOnDedicatedBins: Decimal;
        LineReservedQty: Decimal;
        QtyBlocked: Decimal;
        QtyReservedOnPickShip: Decimal;
        TempWhseActivLine2: record "Warehouse Activity Line" temporary;
        CalcReserveEntry: Integer;
        ReservationEntry: Record "Reservation Entry";
        OppositeReservationEntry: record "Reservation Entry";
    begin
        WITH WhseActivLine DO BEGIN
            item.get(ItemNo);
            /* Item.SETRANGE("Location Filter", WhseActivLine."Location Code");
            Item.SETRANGE("Variant Filter", WhseActivLine."Variant Code"); */
            Item.CALCFIELDS(Inventory);
            Item.CALCFIELDS("Reserved Qty. on Inventory");
            /* location.get(WhseActivLine."Location Code");

            QtyAssgndtoPick := WhseAvailMgt.CalcQtyAssgndtoPick(Location, ItemNo, WhseActivLine."Variant Code", '');
            QtyOnDedicatedBins := WhseAvailMgt.CalcQtyOnDedicatedBins(WhseActivLine."Location Code", WhseActivLine."Item No.", WhseActivLine."Variant Code", '', '');
            QtyBlocked :=
              WhseAvailMgt.CalcQtyOnBlockedITOrOnBlockedOutbndBins(WhseActivLine."Location Code", WhseActivLine."Item No.", WhseActivLine."Variant Code", '', '', FALSE, FALSE);
            LineReservedQty :=
              WhseAvailMgt.CalcLineReservedQtyOnInvt(
                WhseActivLine."Source Type", WhseActivLine."Source Subtype", WhseActivLine."Source No.", WhseActivLine."Source Line No.", WhseActivLine."Source Subline No.", TRUE, '', '', TempWhseActivLine2);
            QtyReservedOnPickShip :=
              WhseAvailMgt.CalcReservQtyOnPicksShips(WhseActivLine."Location Code", WhseActivLine."Item No.", WhseActivLine."Variant Code", TempWhseActivLine2); */
        END;
        if (item.Inventory <> 0) and (Item."Reserved Qty. on Inventory" <> 0) then begin
            salesline.CalcFields("Reserved Quantity");
            if salesline."Reserved Quantity" <> 0 then begin
                ReservationEntry.SetRange("Item No.", salesline."No.");
                ReservationEntry.SetRange("Source ID", SalesLine."Document No.");
                ReservationEntry.SetRange("Source Subtype", SalesLine."Document Type");
                ReservationEntry.SetRange("Source Ref. No.", Salesline."Line No.");
                ReservationEntry.SetRange("Reservation Status", ReservationEntry."Reservation Status"::Reservation);
                ReservationEntry.Setrange("Location Code", salesline."Location Code");
                if ReservationEntry.FindSet() then begin
                    repeat
                        if OppositeReservationEntry.get(ReservationEntry."Entry No.", not ReservationEntry.Positive) then begin
                            if OppositeReservationEntry."Source ID" = '32' then
                                CalcReserveEntry := CalcReserveEntry + OppositeReservationEntry."Quantity (Base)";
                        end;
                    until ReservationEntry.next = 0;
                end;
            end;

        end;
        EXIT(Item.Inventory - ABS(Item."Reserved Qty. on Inventory") + CalcReserveEntry);/*  - QtyAssgndtoPick - QtyOnDedicatedBins - QtyBlocked +
          LineReservedQty + QtyReservedOnPickShip */
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"OIOUBL-Export Sales Invoice", 'OIOUBL_OnBeforeExportSalesInvoice', '', true, true)]
    local procedure OIOUBL_OnBeforeExportSalesInvoice(var XMLdocOut: XmlDocument; SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        namespaceManager: XmlNamespaceManager;
        RootElement: XmlElement;
        XMLElement1: XmlElement;
        XMLElement2: XmlElement;
        XMLNode1: XmlNode;
        XMLNode2: XmlNode;
        cbc: Text;
        cac: Text;
        PaymentMethod: Record "Payment Method";
        PmtSetup: Record "Payment Setup";
        PmtIDLength: Integer;
        PaymentID: Code[16];
    begin
        if not PaymentMethod.Get(SalesInvoiceHeader."Payment Method Code") then exit;

        namespaceManager.NameTable(XMLdocOut.NameTable);
        namespaceManager.AddNamespace('Invoice', 'urn:oasis:names:specification:ubl:schema:xsd:Invoice-2 UBL-Invoice-2.0.xsd');
        namespaceManager.AddNamespace('xsi', 'http://www.w3.org/2001/XMLSchema-instance');
        namespaceManager.AddNamespace('cac', 'urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2');
        namespaceManager.AddNamespace('cbc', 'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2');

        XMLdocOut.GetRoot(RootElement);
        RootElement.GetNamespaceOfPrefix('cbc', cbc);
        RootElement.GetNamespaceOfPrefix('cac', cac);

        //Udvidet beskrivelse
        if PaymentMethod."Invoice Text".HasValue then begin
            RootElement.SelectSingleNode('cbc:InvoiceTypeCode', namespaceManager, XMLNode1);

            XMLElement1 := XmlElement.Create('Note',
                                            cbc,
                                            XmlAttribute.Create('languageID', 'da'),
                                            PaymentMethod.GetPaymentMethodExtDescription());
            XMLNode1.AddAfterSelf(XMLElement1);
        end;

        //Print FIK
        RootElement.SelectSingleNode('cac:PaymentMeans', namespaceManager, XMLNode2);
        if PaymentMethod."Print FIK" then begin
            PmtSetup.Get;

            XMLNode2.SelectSingleNode('cbc:PaymentMeansCode', namespaceManager, XMLNode1);
            XMLElement1 := XmlElement.Create('PaymentMeansCode',
                                            cbc,
                                            '93');
            XMLNode1.ReplaceWith(XMLElement1);

            XMLNode2.SelectSingleNode('cbc:PaymentChannelCode', namespaceManager, XMLNode1);
            XMLElement1 := XmlElement.Create('PaymentChannelCode',
                                            cbc,
                                            'DK:FIK');
            XMLElement1.Add(XmlAttribute.Create('listAgencyID', '320'));
            XMLElement1.Add(XmlAttribute.Create('listID', 'urn:oioubl:codelist:paymentchannelcode-1.1'));
            XMLNode1.ReplaceWith(XMLElement1);

            case PmtSetup."IK Card Type" of
                '01':
                    PmtIDLength := 0;
                '04':
                    PmtIDLength := 16;
                '15':
                    PmtIDLength := 16;
                '41':
                    PmtIDLength := 10;
                '71':
                    PmtIDLength := 15;
                '73':
                    PmtIDLength := 0;
                '75':
                    PmtIDLength := 16;
                else
                    PmtIDLength := 0;
            end;

            if PmtIDLength > 0 then begin
                PaymentID := PadStr('', PmtIDLength - 2 - StrLen(SalesInvoiceHeader."No."), '0') + SalesInvoiceHeader."No." + '2';
                PaymentID := PaymentID + Modulus10(PaymentID);
            end else
                PaymentID := PadStr('', PmtIDLength, '0');

            XMLNode2.SelectSingleNode('cbc:PaymentChannelCode', namespaceManager, XMLNode1);
            XMLElement1 := XmlElement.Create('CreditAccount',
                                            cac); //Kreditornummer
            XMLNode1.AddAfterSelf(XMLElement1);
            XMLElement1.Add(XmlElement.Create('AccountID', cbc, PmtSetup."FIK/GIRO-No."));

            XMLElement1 := XmlElement.Create('PaymentID',
                                            cbc,
                                            PmtSetup."IK Card Type");//Kortart
            XMLNode1.AddAfterSelf(XMLElement1);

            XMLElement1 := XmlElement.Create('InstructionID',
                                            cbc,
                                            PaymentID);//15 numeriske tegn
            XMLNode1.AddAfterSelf(XMLElement1);

            XMLNode2.SelectSingleNode('cac:PayeeFinancialAccount', namespaceManager, XMLNode1);
            XMLNode1.Remove();
        end else begin
            XMLNode2.Remove();
        end;
    end;

    procedure Modulus10(TestNumber: Code[16]): Code[16]
    var
        Counter: Integer;
        Accumulator: Integer;
        WeightNo: Integer;
        SumStr: Text[30];
    begin
        // <PM>
        WeightNo := 2;
        SumStr := '';
        for Counter := StrLen(TestNumber) downto 1 do begin
            Evaluate(Accumulator, CopyStr(TestNumber, Counter, 1));
            Accumulator := Accumulator * WeightNo;
            SumStr := SumStr + Format(Accumulator);
            if WeightNo = 1 then
                WeightNo := 2
            else
                WeightNo := 1;
        end;
        Accumulator := 0;
        for Counter := 1 to StrLen(SumStr) do begin
            Evaluate(WeightNo, CopyStr(SumStr, Counter, 1));
            Accumulator := Accumulator + WeightNo;
        end;
        Accumulator := 10 - (Accumulator mod 10);
        if Accumulator = 10 then
            exit('0')
        else
            exit(Format(Accumulator));
        // </PM>
    end;

    [EventSubscriber(ObjectType::Page, Page::"WS Sales Header", 'OnAfterValidateEvent', 'Ship-to Name', true, true)]
    local procedure SalesHeaderReseller_OnAfterValidate(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if Rec."Ship-to Name" = '' then exit;
        Rec."Ship-to Name 2" := '';
        Rec."Ship-to Address" := '';
        Rec."Ship-to Address 2" := '';
        Rec."Ship-to City" := '';
        Rec."Ship-to Post Code" := '';
        Rec."Ship-to County" := '';
        Rec."Ship-to Country/Region Code" := '';
        Rec."Ship-to Contact" := '';
    end;

    [EventSubscriber(ObjectType::table, database::"Sales Header", 'OnAfterValidateEvent', 'Sell-To Contact', true, true)]
    local procedure OnAfterValidateSellToContactEvent(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        rec.SetDropShipment();
    end;

    procedure AddTransactionTypeToSalesDocument(var SalesHeader: Record "Sales Header");
    var
        SalesSetup: Record "Sales & Receivables Setup";
        DimVal: Record "Dimension Value";
        SalesLine: Record "Sales Line";
        DimSetEntry: Record "Dimension Set Entry" temporary;
        DimMgt: Codeunit DimensionManagement;
        DimSetID: Integer;
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        ReturnReceiptHeader: Record "Return Receipt Header";
    begin
        SalesSetup.Get();
        if SalesSetup."Transaction Type" = '' then exit;

        DimVal.SetRange("Dimension Code", SalesSetup."Transaction Type");
        if Page.RunModal(Page::"Dimension Value List", DimVal) <> Action::LookupOK then exit;

        DimMgt.GetDimensionSet(DimSetEntry, SalesHeader."Dimension Set ID");
        DimSetEntry.Init();
        DimSetEntry."Dimension Set ID" := 0;
        DimSetEntry.Validate("Dimension Code", SalesSetup."Transaction Type");
        DimSetEntry.Validate("Dimension Value Code", DimVal.Code);
        DimSetEntry.Insert(true);
        DimSetID := DimMgt.GetDimensionSetID(DimSetEntry);

        SalesHeader."Dimension Set ID" := DimSetID;
        SalesHeader.Modify();

        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindSet() then
            repeat
                DimSetEntry.Reset();
                DimSetEntry.DeleteAll();
                DimMgt.GetDimensionSet(DimSetEntry, SalesLine."Dimension Set ID");

                DimSetEntry.Init();
                DimSetEntry."Dimension Set ID" := 0;
                DimSetEntry.Validate("Dimension Code", SalesSetup."Transaction Type");
                DimSetEntry.Validate("Dimension Value Code", DimVal.Code);
                DimSetEntry.Insert(true);
                DimSetID := DimMgt.GetDimensionSetID(DimSetEntry);

                SalesLine."Dimension Set ID" := DimSetID;
                SalesLine.Modify();
            until SalesLine.Next() = 0;

        SalesShipmentHeader.SetRange("Order No.", SalesHeader."No.");
        SalesInvoiceHeader.SetRange("Order No.", SalesHeader."No.");
        SalesCrMemoHeader.SetRange("Return Order No.", SalesHeader."No.");
        ReturnReceiptHeader.SetRange("Return Order No.", SalesHeader."No.");

        if SalesShipmentHeader.FindSet() then
            repeat
                AddTransactionTypeToPostedSalesDocuments(SalesShipmentHeader, DimVal.Code);
            until SalesShipmentHeader.Next() = 0;

        if ReturnReceiptHeader.FindSet() then
            repeat
                AddTransactionTypeToPostedSalesDocuments(ReturnReceiptHeader, DimVal.Code);
            until ReturnReceiptHeader.Next() = 0;

        if SalesInvoiceHeader.FindSet() then
            repeat
                AddTransactionTypeToPostedSalesDocuments(SalesInvoiceHeader, DimVal.Code);
            until SalesInvoiceHeader.Next() = 0;

        if SalesCrMemoHeader.FindSet() then
            repeat
                AddTransactionTypeToPostedSalesDocuments(SalesCrMemoHeader, DimVal.Code);
            until SalesCrMemoHeader.Next() = 0;
    end;

    procedure AddTransactionTypeToPostedSalesDocument(v: Variant)
    var
        SalesSetup: Record "Sales & Receivables Setup";
        DimVal: Record "Dimension Value";
    begin
        SalesSetup.Get();
        if SalesSetup."Transaction Type" = '' then exit;

        DimVal.SetRange("Dimension Code", SalesSetup."Transaction Type");
        if Page.RunModal(Page::"Dimension Value List", DimVal) = Action::LookupOK then
            AddTransactionTypeToPostedSalesDocuments(v, DimVal.Code);
    end;

    procedure AddTransactionTypeToPostedSalesDocuments(v: Variant; NewDimValCode: Code[20])
    var
        SalesSetup: Record "Sales & Receivables Setup";
        DataTypeMgt: Codeunit "Data Type Management";
        RecRef: RecordRef;
        DocumentNo: Code[20];
        PostingDate: Date;
        DimSetEntry: Record "Dimension Set Entry" temporary;
        DimMgt: Codeunit DimensionManagement;
        DimSetID: Integer;
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentLine: Record "Sales Shipment Line";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        ReturnReceiptHeader: Record "Return Receipt Header";
        ReturnReceiptLine: Record "Return Receipt Line";
        GLEntry: Record "G/L Entry";
        CustEntry: Record "Cust. Ledger Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
    begin
        SalesSetup.Get();
        if SalesSetup."Transaction Type" = '' then exit;

        DimSetEntry.Reset();
        DimSetEntry.DeleteAll();

        DataTypeMgt.GetRecordRef(v, RecRef);
        case RecRef.Number of
            110:
                begin
                    SalesShipmentHeader.SetPosition(RecRef.GetPosition());
                    DocumentNo := SalesShipmentHeader."No.";
                    PostingDate := SalesShipmentHeader."Posting Date";
                    DimMgt.GetDimensionSet(DimSetEntry, SalesShipmentHeader."Dimension Set ID");
                end;
            112:
                begin
                    SalesInvoiceHeader.SetPosition(RecRef.GetPosition());
                    DocumentNo := SalesInvoiceHeader."No.";
                    PostingDate := SalesInvoiceHeader."Posting Date";
                    DimMgt.GetDimensionSet(DimSetEntry, SalesInvoiceHeader."Dimension Set ID");
                end;
            114:
                begin
                    SalesCrMemoHeader.SetPosition(RecRef.GetPosition());
                    DocumentNo := SalesCrMemoHeader."No.";
                    PostingDate := SalesCrMemoHeader."Posting Date";
                    DimMgt.GetDimensionSet(DimSetEntry, SalesCrMemoHeader."Dimension Set ID");
                end;
            6660:
                begin
                    ReturnReceiptHeader.SetPosition(RecRef.GetPosition());
                    DocumentNo := ReturnReceiptHeader."No.";
                    PostingDate := ReturnReceiptHeader."Posting Date";
                    DimMgt.GetDimensionSet(DimSetEntry, ReturnReceiptHeader."Dimension Set ID");
                end;
        end;

        DimSetEntry.Init();
        DimSetEntry."Dimension Set ID" := 0;
        DimSetEntry.Validate("Dimension Code", SalesSetup."Transaction Type");
        DimSetEntry.Validate("Dimension Value Code", NewDimValCode);
        DimSetEntry.Insert(true);
        DimSetID := DimMgt.GetDimensionSetID(DimSetEntry);

        GLEntry.SetRange("Document No.", DocumentNo);
        GLEntry.SetRange("Posting Date", PostingDate);

        CustEntry.SetRange("Document No.", DocumentNo);
        CustEntry.SetRange("Posting Date", PostingDate);

        ItemLedgEntry.SetRange("Document No.", DocumentNo);
        ItemLedgEntry.SetRange("Posting Date", PostingDate);

        ValueEntry.SetRange("Document No.", DocumentNo);
        ValueEntry.SetRange("Posting Date", PostingDate);

        case RecRef.Number of
            110:
                begin
                    GLEntry.SetRange("Dimension Set ID", SalesShipmentHeader."Dimension Set ID");
                    CustEntry.SetRange("Dimension Set ID", SalesShipmentHeader."Dimension Set ID");
                    ItemLedgEntry.SetRange("Dimension Set ID", SalesShipmentHeader."Dimension Set ID");
                    ValueEntry.SetRange("Dimension Set ID", SalesShipmentHeader."Dimension Set ID");

                    SalesShipmentHeader."Dimension Set ID" := DimSetID;
                    SalesShipmentHeader.Modify();

                    GLEntry.ModifyAll("Dimension Set ID", DimSetID);
                    CustEntry.ModifyAll("Dimension Set ID", DimSetID);
                    ItemLedgEntry.ModifyAll("Dimension Set ID", DimSetID);
                    ValueEntry.ModifyAll("Dimension Set ID", DimSetID);

                    SalesShipmentLine.SetRange("Document No.", SalesShipmentHeader."No.");
                    if SalesShipmentLine.FindSet() then
                        repeat
                            DimSetEntry.Reset();
                            DimSetEntry.DeleteAll();
                            DimMgt.GetDimensionSet(DimSetEntry, SalesShipmentLine."Dimension Set ID");

                            DimSetEntry.Init();
                            DimSetEntry."Dimension Set ID" := 0;
                            DimSetEntry.Validate("Dimension Code", SalesSetup."Transaction Type");
                            DimSetEntry.Validate("Dimension Value Code", NewDimValCode);
                            DimSetEntry.Insert(true);
                            DimSetID := DimMgt.GetDimensionSetID(DimSetEntry);

                            GLEntry.SetRange("Dimension Set ID", SalesShipmentHeader."Dimension Set ID");
                            CustEntry.SetRange("Dimension Set ID", SalesShipmentHeader."Dimension Set ID");
                            ItemLedgEntry.SetRange("Dimension Set ID", SalesShipmentHeader."Dimension Set ID");
                            ValueEntry.SetRange("Dimension Set ID", SalesShipmentHeader."Dimension Set ID");

                            SalesShipmentLine."Dimension Set ID" := DimSetID;
                            SalesShipmentLine.Modify();

                            GLEntry.ModifyAll("Dimension Set ID", DimSetID);
                            CustEntry.ModifyAll("Dimension Set ID", DimSetID);
                            ItemLedgEntry.ModifyAll("Dimension Set ID", DimSetID);
                            ValueEntry.ModifyAll("Dimension Set ID", DimSetID);
                        until SalesShipmentLine.Next() = 0;
                end;
            112:
                begin
                    GLEntry.SetRange("Dimension Set ID", SalesShipmentHeader."Dimension Set ID");
                    CustEntry.SetRange("Dimension Set ID", SalesShipmentHeader."Dimension Set ID");
                    ItemLedgEntry.SetRange("Dimension Set ID", SalesShipmentHeader."Dimension Set ID");
                    ValueEntry.SetRange("Dimension Set ID", SalesShipmentHeader."Dimension Set ID");

                    SalesInvoiceHeader."Dimension Set ID" := DimSetID;
                    SalesInvoiceHeader.Modify();

                    GLEntry.ModifyAll("Dimension Set ID", DimSetID);
                    CustEntry.ModifyAll("Dimension Set ID", DimSetID);
                    ItemLedgEntry.ModifyAll("Dimension Set ID", DimSetID);
                    ValueEntry.ModifyAll("Dimension Set ID", DimSetID);

                    SalesInvoiceLine.SetRange("Document No.", SalesInvoiceHeader."No.");
                    if SalesInvoiceLine.FindSet() then
                        repeat
                            DimSetEntry.Reset();
                            DimSetEntry.DeleteAll();
                            DimMgt.GetDimensionSet(DimSetEntry, SalesInvoiceLine."Dimension Set ID");

                            DimSetEntry.Init();
                            DimSetEntry."Dimension Set ID" := 0;
                            DimSetEntry.Validate("Dimension Code", SalesSetup."Transaction Type");
                            DimSetEntry.Validate("Dimension Value Code", NewDimValCode);
                            DimSetEntry.Insert(true);
                            DimSetID := DimMgt.GetDimensionSetID(DimSetEntry);

                            GLEntry.SetRange("Dimension Set ID", SalesShipmentHeader."Dimension Set ID");
                            CustEntry.SetRange("Dimension Set ID", SalesShipmentHeader."Dimension Set ID");
                            ItemLedgEntry.SetRange("Dimension Set ID", SalesShipmentHeader."Dimension Set ID");
                            ValueEntry.SetRange("Dimension Set ID", SalesShipmentHeader."Dimension Set ID");

                            SalesInvoiceLine."Dimension Set ID" := DimSetID;
                            SalesInvoiceLine.Modify();

                            GLEntry.ModifyAll("Dimension Set ID", DimSetID);
                            CustEntry.ModifyAll("Dimension Set ID", DimSetID);
                            ItemLedgEntry.ModifyAll("Dimension Set ID", DimSetID);
                            ValueEntry.ModifyAll("Dimension Set ID", DimSetID);
                        until SalesInvoiceLine.Next() = 0;
                end;
            114:
                begin
                    GLEntry.SetRange("Dimension Set ID", SalesShipmentHeader."Dimension Set ID");
                    CustEntry.SetRange("Dimension Set ID", SalesShipmentHeader."Dimension Set ID");
                    ItemLedgEntry.SetRange("Dimension Set ID", SalesShipmentHeader."Dimension Set ID");
                    ValueEntry.SetRange("Dimension Set ID", SalesShipmentHeader."Dimension Set ID");

                    SalesCrMemoHeader."Dimension Set ID" := DimSetID;
                    SalesCrMemoHeader.Modify();

                    GLEntry.ModifyAll("Dimension Set ID", DimSetID);
                    CustEntry.ModifyAll("Dimension Set ID", DimSetID);
                    ItemLedgEntry.ModifyAll("Dimension Set ID", DimSetID);
                    ValueEntry.ModifyAll("Dimension Set ID", DimSetID);

                    SalesCrMemoLine.SetRange("Document No.", SalesCrMemoHeader."No.");
                    if SalesCrMemoLine.FindSet() then
                        repeat
                            DimSetEntry.Reset();
                            DimSetEntry.DeleteAll();
                            DimMgt.GetDimensionSet(DimSetEntry, SalesCrMemoLine."Dimension Set ID");

                            DimSetEntry.Init();
                            DimSetEntry."Dimension Set ID" := 0;
                            DimSetEntry.Validate("Dimension Code", SalesSetup."Transaction Type");
                            DimSetEntry.Validate("Dimension Value Code", NewDimValCode);
                            DimSetEntry.Insert(true);
                            DimSetID := DimMgt.GetDimensionSetID(DimSetEntry);

                            GLEntry.SetRange("Dimension Set ID", SalesShipmentHeader."Dimension Set ID");
                            CustEntry.SetRange("Dimension Set ID", SalesShipmentHeader."Dimension Set ID");
                            ItemLedgEntry.SetRange("Dimension Set ID", SalesShipmentHeader."Dimension Set ID");
                            ValueEntry.SetRange("Dimension Set ID", SalesShipmentHeader."Dimension Set ID");

                            SalesCrMemoLine."Dimension Set ID" := DimSetID;
                            SalesCrMemoLine.Modify();

                            GLEntry.ModifyAll("Dimension Set ID", DimSetID);
                            CustEntry.ModifyAll("Dimension Set ID", DimSetID);
                            ItemLedgEntry.ModifyAll("Dimension Set ID", DimSetID);
                            ValueEntry.ModifyAll("Dimension Set ID", DimSetID);
                        until SalesCrMemoLine.Next() = 0;
                end;
            6660:
                begin
                    GLEntry.SetRange("Dimension Set ID", SalesShipmentHeader."Dimension Set ID");
                    CustEntry.SetRange("Dimension Set ID", SalesShipmentHeader."Dimension Set ID");
                    ItemLedgEntry.SetRange("Dimension Set ID", SalesShipmentHeader."Dimension Set ID");
                    ValueEntry.SetRange("Dimension Set ID", SalesShipmentHeader."Dimension Set ID");

                    ReturnReceiptHeader."Dimension Set ID" := DimSetID;
                    ReturnReceiptHeader.Modify();

                    GLEntry.ModifyAll("Dimension Set ID", DimSetID);
                    CustEntry.ModifyAll("Dimension Set ID", DimSetID);
                    ItemLedgEntry.ModifyAll("Dimension Set ID", DimSetID);
                    ValueEntry.ModifyAll("Dimension Set ID", DimSetID);

                    ReturnReceiptLine.SetRange("Document No.", ReturnReceiptHeader."No.");
                    if ReturnReceiptLine.FindSet() then
                        repeat
                            DimSetEntry.Reset();
                            DimSetEntry.DeleteAll();
                            DimMgt.GetDimensionSet(DimSetEntry, ReturnReceiptLine."Dimension Set ID");

                            DimSetEntry.Init();
                            DimSetEntry."Dimension Set ID" := 0;
                            DimSetEntry.Validate("Dimension Code", SalesSetup."Transaction Type");
                            DimSetEntry.Validate("Dimension Value Code", NewDimValCode);
                            DimSetEntry.Insert(true);
                            DimSetID := DimMgt.GetDimensionSetID(DimSetEntry);

                            GLEntry.SetRange("Dimension Set ID", SalesShipmentHeader."Dimension Set ID");
                            CustEntry.SetRange("Dimension Set ID", SalesShipmentHeader."Dimension Set ID");
                            ItemLedgEntry.SetRange("Dimension Set ID", SalesShipmentHeader."Dimension Set ID");
                            ValueEntry.SetRange("Dimension Set ID", SalesShipmentHeader."Dimension Set ID");

                            ReturnReceiptLine."Dimension Set ID" := DimSetID;
                            ReturnReceiptLine.Modify();

                            GLEntry.ModifyAll("Dimension Set ID", DimSetID);
                            CustEntry.ModifyAll("Dimension Set ID", DimSetID);
                            ItemLedgEntry.ModifyAll("Dimension Set ID", DimSetID);
                            ValueEntry.ModifyAll("Dimension Set ID", DimSetID);
                        until ReturnReceiptLine.Next() = 0;
                end;
        end;
    end;
}