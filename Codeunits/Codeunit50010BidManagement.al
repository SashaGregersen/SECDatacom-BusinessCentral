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
    begin
        GLSetup.Get();
        GLSetupInOtherCompany.ChangeCompany(CompanyNameToCopyTo);
        GLSetupInOtherCompany.Get();
        BidToCopyTo.ChangeCompany(CompanyNameToCopyTo);
        BidToCopyTo := BidToCopy;
        if not BidToCopyTo.Insert(false) then
            BidToCopyTo.Modify(false);
        BidPrice.SetRange("Bid No.", BidToCopy."No.");
        if BidPrice.FindSet() then
            repeat
                if (BidPrice."Currency Code" = '') and (GLSetup."LCY Code" <> GLSetupInOtherCompany."LCY Code") then
                    BidPrice."Currency Code" := GLSetup."LCY Code";
                BidPriceToCopyTo.ChangeCompany(CompanyNameToCopyTo);
                BidPriceToCopyTo := BidPrice;

                if not BidPriceToCopyTo.Insert(false) then
                    BidPriceToCopyTo.Modify(false);
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

    procedure MakePurchasePriceFromBidPrice(BidPrice: Record "Bid Item Price"; var PurchasePrice: Record "Purchase Price")
    var
        Bid: Record Bid;
    begin
        Bid.Get(BidPrice."Bid No.");
        PurchasePrice."Item No." := BidPrice."item No.";
        PurchasePrice."Currency Code" := BidPrice."Currency Code";
        PurchasePrice."Vendor No." := Bid."Vendor No.";
        PurchasePrice."Direct Unit Cost" := BidPrice."Bid Unit Purchase Price";
    end;
}