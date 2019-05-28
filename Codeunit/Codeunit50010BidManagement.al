codeunit 50010 "Bid Management"
{
    trigger OnRun()
    begin

    end;

    procedure CopyBidToOtherCompanies(BidToCopy: Record Bid)
    var
        CompanyTemp: Record Company temporary;
    begin
        if not GetCompaniesToCopyTo(CompanyTemp) then
            exit;
        if CompanyTemp.FindSet() then
            repeat
                CopyBidToOtherCompany(BidToCopy, CompanyTemp.Name);
            until CompanyTemp.Next() = 0;
    end;

    local procedure CopyBidToOtherCompany(BidToCopy: Record Bid; CompanyNameToCopyTo: Text[30])
    var
        BidToCopyTo: Record Bid;
        BidPrice: Record "Bid Item Price";
        BidPriceToCopyTo: Record "Bid Item Price";
        GLSetup: Record "General Ledger Setup";
        GLSetupInOtherCompany: Record "General Ledger Setup";
        Item: Record Item;
        ICPartner: record "IC Partner";
        VendorNo: code[20];
        ItemDiscGroup: record "Item Discount Group";
    begin
        ICPartner.ChangeCompany(CompanyNameToCopyTo);
        ICPartner.SetRange("Inbox Details", CompanyName);
        if ICPartner.FindFirst() then
            VendorNo := ICPartner."Vendor No.";
        GLSetup.Get();
        GLSetupInOtherCompany.ChangeCompany(CompanyNameToCopyTo);
        GLSetupInOtherCompany.Get();
        BidToCopyTo.ChangeCompany(CompanyNameToCopyTo);
        if not BidToCopyTo.Get(BidToCopy."No.") then begin
            BidToCopyTo := BidToCopy;
            BidToCopyTo.Claimable := false;
            BidToCopyTo.Insert(false);
        end else begin
            BidToCopyTo.TransferFields(BidToCopy, false);
            BidToCopyTo.Claimable := false;
            BidToCopyTo.Modify(false);
        end;
        BidPrice.SetRange("Bid No.", BidToCopy."No.");
        if BidPrice.FindSet() then
            repeat
                if (BidPrice."Currency Code" = '') and (GLSetup."LCY Code" <> GLSetupInOtherCompany."LCY Code") then
                    BidPrice."Currency Code" := GLSetup."LCY Code";
                Item.Get(BidPrice."item No.");
                BidPriceToCopyTo.ChangeCompany(CompanyNameToCopyTo);
                if not BidPriceToCopyTo.get(BidPrice."Bid No.", BidPrice."item No.", BidPrice."Customer No.", BidPrice."Currency Code") then begin
                    BidPriceToCopyTo := BidPrice;
                    BidPriceToCopyTo.Insert(false);
                end else
                    BidPriceToCopyTo.TransferFields(BidPrice, false);
                if Item."Transfer Price %" <> 0 then
                    BidPriceToCopyTo.Validate("Bid Unit Purchase Price", bidprice."Bid Unit Purchase Price" / (1 - (Item."Transfer Price %" / 100)));
                BidPriceToCopyTo.Claimable := false; // To find correct purchase price in IC companies in create purchase order
                BidPriceToCopyTo.Modify(false);
                if ItemDiscGroup.get(item."Item Disc. Group") then
                    if not ItemDiscGroup."Use Orginal Vendor in Subs" then begin
                        BidToCopyTo."Vendor No." := VendorNo;
                        BidToCopyTo.Modify(false);
                    end;
            until BidPrice.Next() = 0;
    end;

    local procedure GetCompaniesToCopyTo(var CompanyTemp: Record Company temporary): Boolean
    var
        CompanyList: Page "Company List";
    begin
        CompanyList.LookupMode(true);
        if CompanyList.RunModal() = Action::LookupOK then begin
            CompanyList.GetCompanies(CompanyTemp);
            exit(true);
        end else
            exit(false);
    end;

    procedure GetBestBidPrice(BidNo: code[20]; CustomerNo: code[20]; ItemNo: code[20]; CurrencyCode: code[20]; var BidPrice: Record "Bid Item Price"): Boolean
    var
        Item: Record Item;
    begin
        BidPrice.SetRange("Bid No.", BidNo);
        BidPrice.SetRange("item No.", ItemNo);
        BidPrice.SetRange("Customer No.", CustomerNo);
        BidPrice.SetRange("Currency Code", CurrencyCode);
        if BidPrice.FindFirst then
            Exit(true);
        BidPrice.SetRange("Customer No.");
        if BidPrice.FindFirst then
            exit(true);
        Item.Get(ItemNo);
        if Item."Vendor Currency" <> CurrencyCode then begin
            BidPrice.SetRange("Currency Code", Item."Vendor Currency");
            if BidPrice.FindFirst then
                exit(true)
        end;
        BidPrice.SetRange("Currency Code");
        if BidPrice.FindFirst then
            exit(true);
        Clear(BidPrice);
        exit(false);
    end;

    procedure MakePurchasePriceFromBidPrice(BidPrice: Record "Bid Item Price"; var PurchasePrice: Record "Purchase Price"; salesline: record "Sales Line")
    var
        Bid: Record Bid;
        AdvPriceMgt: Codeunit "Advanced Price Management";
    begin
        Bid.Get(BidPrice."Bid No.");
        if BidPrice.Claimable then
            AdvPriceMgt.FindBestPurchasePrice(SalesLine."No.", Bid."Vendor No.", BidPrice."Currency Code", SalesLine."Variant Code", PurchasePrice)
        else begin
            PurchasePrice."Item No." := BidPrice."item No.";
            PurchasePrice."Currency Code" := BidPrice."Currency Code";
            PurchasePrice."Vendor No." := Bid."Vendor No.";
            PurchasePrice."Direct Unit Cost" := BidPrice."Bid Unit Purchase Price";
        end;
    end;

    procedure MakeCreditClaimsPosting(VAR SalesHeader: Record "Sales Header"; VAR SalesShipmentHeader: Record "Sales Shipment Header"; VAR SalesInvoiceHeader: Record "Sales Invoice Header"; VAR SalesCrMemoHeader: Record "Sales Cr.Memo Header"; VAR ReturnReceiptHeader: Record "Return Receipt Header")
    var
        Bid: Record Bid;
        Vendor: Record Vendor;
        ClaimsVendor: Record Vendor;
        PurchSetup: Record "Purchases & Payables Setup";
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        ItemChargeAssignment: Record "Item Charge Assignment (Purch)";
        SalesShipLine: Record "Sales Shipment Line";
        SalesInvLine: Record "Sales Invoice Line";
        DoPostPurchaseheader: Boolean;
        PurchPost: Codeunit "Purch.-Post";
        LineNo: Integer;
        DCApprovalsMgt: Codeunit "DC Approval Management";
        ReleasePurchDoc: Codeunit "Release Purchase Document";
        ClaimAmountVendCurrency: Decimal;
    begin
        if not PurchSetup.Get() then
            exit;
        if PurchSetup."Claims Charge No." = '' then
            exit;

        SalesInvLine.SetRange("Document No.", SalesInvoiceHeader."No.");
        SalesInvLine.SetFilter(Quantity, '<>0');
        SalesInvLine.SetRange(Claimable, true);
        SalesInvLine.SetFilter("Claim Amount", '<>0');
        DoPostPurchaseheader := false;
        if SalesInvLine.FindSet() then
            repeat
                if not Bid.Get(SalesInvLine."Bid No.") then
                    exit;
                if not Vendor.Get(bid."Vendor No.") then
                    exit;
                if not ClaimsVendor.Get(Vendor."Claims Vendor") then
                    Error('Sales Invoice %1 uses Bid %2 from Vendor %3. Please add a value in the Claims Vendor field on Vendor %3', SalesInvoiceHeader."No.", SalesInvLine."Bid No.", Vendor."No.");
                SalesShipLine.SetRange("Order No.", SalesInvLine."Order No.");
                SalesShipLine.SetRange("Order Line No.", SalesInvLine."Order Line No.");
                SalesShipLine.SetFilter("Claim Document No.", '');
                if SalesShipLine.FindSet(true, false) then begin
                    Clear(ClaimAmountVendCurrency);
                    CreatePurchaseHeader(PurchHeader."Document Type"::"Credit Memo", SalesHeader."Posting Date", ClaimsVendor."No.", SalesInvoiceHeader."No.", PurchHeader);
                    LineNo := 0;
                    repeat
                        LineNo := LineNo + 10000;
                        ClaimAmountVendCurrency := ExchangeClaimAmountSalesShip(SalesShipmentHeader, SalesShipLine, PurchHeader, SalesShipLine."Claim Amount");
                        CreateItemChargePurchaseLine(PurchHeader, LineNo, PurchSetup."Claims Charge No.", ClaimAmountVendCurrency, PurchLine);
                        CreateItemChargeAssignPurchFromShipment(PurchLine, SalesShipLine, ItemChargeAssignment, ClaimAmountVendCurrency);
                        UpdateShimentLineWithClaimNo(SalesShipLine, PurchHeader."No.");
                    until SalesShipLine.Next() = 0;
                    DoPostPurchaseheader := true;
                end;
            until SalesInvLine.Next() = 0;
        if DoPostPurchaseheader then begin
            DCApprovalsMgt.ForceApproval(PurchHeader, false);
            ReleasePurchDoc.PerformManualRelease(PurchHeader);
            UpdatePostingDescOnPurchHeader(SalesInvLine."No.", SalesInvLine.Quantity, Bid."Vendor Bid No.", PurchHeader);
            PurchPost.SetPreviewMode(false);
            PurchPost.SetSuppressCommit(false);
            PurchPost.Run(PurchHeader);
        end;
    end;

    procedure MakeDebitClaimsPosting(VAR SalesHeader: Record "Sales Header"; VAR SalesShipmentHeader: Record "Sales Shipment Header"; VAR SalesInvoiceHeader: Record "Sales Invoice Header"; VAR SalesCrMemoHeader: Record "Sales Cr.Memo Header"; VAR ReturnReceiptHeader: Record "Return Receipt Header")
    var
        Bid: Record Bid;
        Vendor: Record Vendor;
        ClaimsVendor: Record Vendor;
        PurchSetup: Record "Purchases & Payables Setup";
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        ItemChargeAssignment: Record "Item Charge Assignment (Purch)";
        ReturnRcptLine: Record "Return Receipt Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        DoPostPurchaseheader: Boolean;
        PurchPost: Codeunit "Purch.-Post";
        DCApprovalsMgt: Codeunit "DC Approval Management";
        ReleasePurchDoc: Codeunit "Release Purchase Document";
        ClaimAmountVendCurrency: Decimal;
    begin
        if not PurchSetup.Get() then
            exit;
        if PurchSetup."Claims Charge No." = '' then
            exit;

        SalesCrMemoLine.SetRange("Document No.", SalesCrMemoHeader."No.");
        SalesCrMemoLine.SetFilter(Quantity, '<>0');
        SalesCrMemoLine.SetRange(Claimable, true);
        SalesCrMemoLine.SetFilter("Claim Amount", '<>0');
        DoPostPurchaseheader := false;
        if SalesCrMemoLine.FindSet() then
            repeat
                if not Bid.Get(SalesCRMemoLine."Bid No.") then
                    exit;
                if not Vendor.Get(bid."Vendor No.") then
                    exit;
                if not ClaimsVendor.Get(Vendor."Claims Vendor") then
                    Error('Sales Credit Memo %1 uses Bid %2 from Vendor %3. Please add a value in the Claims Vendor field on Vendor %3', SalesCrMemoHeader."No.", ReturnRcptLine."Bid No.", Vendor."No.");
                ReturnRcptLine.SetRange("return Order No.", SalesCrMemoLine."Order No.");
                ReturnRcptLine.SetRange("return Order Line No.", SalesCrMemoLine."Order Line No.");
                ReturnRcptLine.SetFilter("Claim Document No.", '');
                if ReturnRcptLine.FindSet(true, false) then begin
                    Clear(ClaimAmountVendCurrency);
                    CreatePurchaseHeader(PurchHeader."Document Type"::Invoice, SalesHeader."Posting Date", ClaimsVendor."No.", SalesCrMemoHeader."No.", PurchHeader);
                    repeat
                        ClaimAmountVendCurrency := ExchangeClaimAmountReturnRcpt(ReturnReceiptHeader, ReturnRcptLine, PurchHeader, ReturnRcptLine."Claim Amount");
                        CreateItemChargePurchaseLine(PurchHeader, SalesCrMemoLine."Line No.", PurchSetup."Claims Charge No.", ClaimAmountVendCurrency, PurchLine);
                        CreateItemChargeAssignPurchFromReturn(PurchLine, ReturnRcptLine, ItemChargeAssignment, ClaimAmountVendCurrency);
                        UpdateReturnRecptLineWithClaimNo(ReturnRcptLine, PurchHeader."No.");
                    until ReturnRcptLine.Next() = 0;
                    DoPostPurchaseheader := true;
                end;
            until SalesCrMemoLine.Next() = 0;
        if DoPostPurchaseheader then begin
            DCApprovalsMgt.ForceApproval(PurchHeader, false);
            ReleasePurchDoc.PerformManualRelease(PurchHeader);
            UpdatePostingDescOnPurchHeader(SalesCrMemoLine."No.", SalesCrMemoLine.Quantity, Bid."Vendor Bid No.", PurchHeader);
            PurchPost.SetPreviewMode(false);
            PurchPost.SetSuppressCommit(false);
            PurchPost.Run(PurchHeader);
        end;
    end;

    local procedure CreatePurchaseHeader(DocType: Integer; PostingDate: date; VendorNo: Code[20]; ExtDocNo: Code[20]; var PurchHeader: Record "Purchase Header")
    begin
        PurchHeader.Init();
        PurchHeader.Validate("Document Type", DocType);
        PurchHeader.validate("Posting Date", postingdate);
        PurchHeader.Validate("Buy-from Vendor No.", VendorNo);
        //PurchHeader.Validate("Currency Code", CurrenCode); //ændres til vendor currency
        case PurchHeader."Document Type" of
            PurchHeader."Document Type"::"Credit Memo":
                PurchHeader."Vendor Cr. Memo No." := ExtDocNo;
            PurchHeader."Document Type"::Invoice:
                PurchHeader."Vendor Invoice No." := ExtDocNo;
        end;
        PurchHeader.insert(true);
    end;

    local procedure CreateItemChargePurchaseLine(PurchHeader: Record "Purchase Header"; LineNo: Integer; ChargeNo: Code[20]; UnitCost: Decimal; var PurchLine: Record "Purchase Line")
    begin
        PurchLine.Init();
        PurchLine.Validate("Document Type", PurchHeader."Document Type");
        PurchLine.Validate("Document No.", PurchHeader."No.");
        PurchLine.Validate("Line No.", LineNo);
        PurchLine.Insert(true);
        PurchLine.Validate(Type, PurchLine.Type::"Charge (Item)");
        PurchLine.Validate("No.", ChargeNo);
        PurchLine.Validate(Quantity, 1);
        PurchLine.Validate("Direct Unit Cost", UnitCost);
        PurchLine.Modify(true);
    end;

    local procedure CreateItemChargeAssignPurchFromShipment(PurchLine: Record "Purchase Line"; SalesShipLine: Record "Sales Shipment Line"; var ItemChargeAssignment: Record "Item Charge Assignment (Purch)"; ClaimAmount: decimal)
    begin
        ItemChargeAssignment.Init();
        ItemChargeAssignment."Document Line No." := PurchLine."Line No.";
        ItemChargeAssignment."Document No." := PurchLine."Document No.";
        ItemChargeAssignment."Document Type" := PurchLine."Document Type";
        ItemChargeAssignment."Line No." := PurchLine."Line No.";
        ItemChargeAssignment."Applies-to Doc. Line No." := SalesShipLine."Line No.";
        ItemChargeAssignment."Applies-to Doc. No." := SalesShipLine."Document No.";
        ItemChargeAssignment."Applies-to Doc. Type" := ItemChargeAssignment."Applies-to Doc. Type"::"Sales Shipment";
        ItemChargeAssignment.Validate("Item Charge No.", PurchLine."No.");
        ItemChargeAssignment.Validate("Item No.", SalesShipLine."No.");
        ItemChargeAssignment.Validate("Unit Cost", ClaimAmount);
        ItemChargeAssignment.Validate("Qty. to Assign", 1);
        ItemChargeAssignment.Insert(true);
    end;

    local procedure CreateItemChargeAssignPurchFromReturn(PurchLine: Record "Purchase Line"; ReturnRcptLine: Record "Return Receipt Line"; var ItemChargeAssignment: Record "Item Charge Assignment (Purch)"; ClaimAmount: Decimal)
    begin
        ItemChargeAssignment.Init();
        ItemChargeAssignment."Document Line No." := PurchLine."Line No.";
        ItemChargeAssignment."Document No." := PurchLine."Document No.";
        ItemChargeAssignment."Document Type" := PurchLine."Document Type";
        ItemChargeAssignment."Line No." := PurchLine."Line No.";
        ItemChargeAssignment."Applies-to Doc. Line No." := ReturnRcptLine."Line No.";
        ItemChargeAssignment."Applies-to Doc. No." := ReturnRcptLine."Document No.";
        ItemChargeAssignment."Applies-to Doc. Type" := ItemChargeAssignment."Applies-to Doc. Type"::"Return Receipt";
        ItemChargeAssignment.Validate("Item Charge No.", PurchLine."No.");
        ItemChargeAssignment.Validate("Item No.", ReturnRcptLine."No.");
        ItemChargeAssignment.Validate("Unit Cost", ClaimAmount);
        ItemChargeAssignment.Validate("Qty. to Assign", 1);
        ItemChargeAssignment.Insert(true);
    end;

    local procedure UpdateShimentLineWithClaimNo(SalesShipLine: Record "Sales Shipment Line"; ClaimDocNo: code[20])
    begin
        SalesShipLine."Claim Document No." := ClaimDocNo;
        SalesShipLine.Modify(false);
    end;

    local procedure UpdateReturnRecptLineWithClaimNo(ReturnrcptLine: Record "Return Receipt Line"; ClaimDocNo: code[20])
    begin
        ReturnrcptLine."Claim Document No." := ClaimDocNo;
        ReturnrcptLine.Modify(false);
    end;

    local procedure UpdatePostingDescOnPurchHeader(ItemNo: Code[20]; Qty: Decimal; VendorBidNo: Text[100]; var PurchHeader: record "Purchase header")
    var
        Item: Record Item;
    begin
        If not Item.Get(ItemNo) then
            Clear(Item);
        PurchHeader."Posting Description" := CopyStr(StrSubstNo('%1 %2 %3', Format(Qty), Item."Vendor-Item-No.", VendorBidNo), 1, 100);
    end;

    local procedure ExchangeClaimAmountSalesShip(SalesShipmentHeader: record "Sales Shipment Header"; SalesShipLine: record "Sales Shipment Line"; PurchHeader: record "Purchase Header"; ClaimAmount: Decimal): Decimal
    var
        GlSetup: record "General Ledger Setup";
        CurrencyExchangeRate: record "Currency Exchange Rate";
    begin
        If SalesShipmentHeader."Currency Code" = PurchHeader."Currency Code" then
            exit(SalesShipLine."Claim Amount");
        GlSetup.get;
        if SalesShipmentHeader."Currency Code" = GlSetup."LCY Code" then
            //from LCYTOFCY 
            Exit(CurrencyExchangeRate.ExchangeAmtLCYToFCY(SalesShipmentHeader."Posting Date", PurchHeader."Currency Code", SalesShipLine."Claim Amount", SalesShipmentHeader."Currency Factor"))
        else
            //from FCYToFCY
            Exit(CurrencyExchangeRate.ExchangeAmtFCYToFCY(SalesShipmentHeader."Posting Date", SalesShipmentHeader."Currency Code", PurchHeader."Currency Code", SalesShipLine."Claim Amount"));
    end;

    local procedure ExchangeClaimAmountReturnRcpt(ReturnRcptHeader: record "Return Receipt Header"; ReturnRcptLine: record "Return Receipt Line"; PurchHeader: record "Purchase Header"; ClaimAmount: Decimal): Decimal
    var
        GlSetup: record "General Ledger Setup";
        CurrencyExchangeRate: record "Currency Exchange Rate";
    begin
        If ReturnRcptHeader."Currency Code" = PurchHeader."Currency Code" then
            exit(ReturnRcptLine."Claim Amount");
        GlSetup.get;
        if ReturnRcptHeader."Currency Code" = GlSetup."LCY Code" then
            //from LCYTOFCY 
            Exit(CurrencyExchangeRate.ExchangeAmtLCYToFCY(ReturnRcptHeader."Posting Date", PurchHeader."Currency Code", ReturnRcptLine."Claim Amount", ReturnRcptHeader."Currency Factor"))
        else
            //from FCYToFCY
            Exit(CurrencyExchangeRate.ExchangeAmtFCYToFCY(ReturnRcptHeader."Posting Date", ReturnRcptHeader."Currency Code", PurchHeader."Currency Code", ReturnRcptLine."Claim Amount"));
    end;

    procedure CopyBidToCustomer(bid: record bid)
    var
        Customer: page "Customer List";
    begin

    end;

}