codeunit 50002 "Synchronize Master Data"
{
    trigger OnRun();
    begin

    end;

    procedure UpdateInventoryOnPurchLineFromLocation(PurchLine: record "Purchase Line"): Decimal
    var
        Location: Record Location;
        AvailableInv: Decimal;
        ItemLedgerEntry: record "Item Ledger Entry";
        GlSetup: record "General Ledger Setup";
    begin
        GlSetup.Get;
        Location.ChangeCompany(GlSetup."Master Company");
        Location.SetRange("Calculate Available Stock", true);
        if Location.FindSet then
            repeat
                ItemLedgerEntry.ChangeCompany(GLsetup."Master Company");
                ItemLedgerEntry.Setrange("Item No.", PurchLine."No.");
                ItemLedgerEntry.SetRange("Location Code", Location.Code);
                if ItemLedgerEntry.FindSet() then
                    repeat
                        ItemLedgerEntry.CalcFields("Reserved Quantity");
                        AvailableInv := (ItemLedgerEntry.Quantity - ItemLedgerEntry."Reserved Quantity") + AvailableInv;
                    until ItemLedgerEntry.next = 0;
            until Location.Next = 0;
        exit(AvailableInv);
    end;

    procedure UpdateInventoryOnSalesLineFromLocation(SalesLine: record "Sales Line"): Decimal
    var
        Location: Record Location;
        AvailableInv: Decimal;
        ItemLedgerEntry: record "Item Ledger Entry";
        GlSetup: record "General Ledger Setup";
    begin
        GlSetup.Get;
        Location.ChangeCompany(GlSetup."Master Company");
        Location.SetRange("Calculate Available Stock", true);
        if Location.FindSet then
            repeat
                ItemLedgerEntry.ChangeCompany(GLsetup."Master Company");
                ItemLedgerEntry.Setrange("Item No.", SalesLine."No.");
                ItemLedgerEntry.SetRange("Location Code", Location.Code);
                if ItemLedgerEntry.FindSet() then
                    repeat
                        ItemLedgerEntry.CalcFields("Reserved Quantity");
                        AvailableInv := (ItemLedgerEntry.Quantity - ItemLedgerEntry."Reserved Quantity") + AvailableInv;
                    until ItemLedgerEntry.next = 0;
            until Location.Next = 0;
        exit(AvailableInv);
    end;

    procedure UpdateInventoryOnItemFromLocation(Item: record "Item"; GLsetup: Record "General Ledger Setup"): Decimal
    var
        Location: Record Location;
        AvailableInv: Decimal;
        ItemLedgerEntry: record "Item Ledger Entry";
    begin
        Location.ChangeCompany(GlSetup."Master Company");
        Location.SetRange("Calculate Available Stock", true);
        if Location.FindSet then
            repeat
                ItemLedgerEntry.ChangeCompany(GLsetup."Master Company");
                ItemLedgerEntry.Setrange("Item No.", Item."No.");
                ItemLedgerEntry.SetRange("Location Code", Location.Code);
                if ItemLedgerEntry.FindSet() then
                    repeat
                        ItemLedgerEntry.CalcFields("Reserved Quantity");
                        AvailableInv := (ItemLedgerEntry.Quantity - ItemLedgerEntry."Reserved Quantity") + AvailableInv;
                    until ItemLedgerEntry.next = 0;
            until Location.Next = 0;
        exit(AvailableInv);
    end;

    procedure SynchronizeInventoryToCompany(Item: Record Item)
    var
        ICSyncMgt: Codeunit "IC Sync Management";
    begin
        ICSyncMgt.InsertModifyItemInOtherCompanies(Item);
    End;

    procedure SynchronizeItemDiscGroupToCompany(ItemDiscGroup: Record "Item Discount Group")
    var
        ICSyncMgt: Codeunit "IC Sync Management";
    begin
        ICSyncMgt.InsertModifyItemDiscGroupInOtherCompanies(ItemDiscGroup);
    End;

    procedure SynchronizeItemSubstituionToCompany(ItemSub: Record "Item Substitution")
    var
        ICSyncMgt: Codeunit "IC Sync Management";
    begin
        ICSyncMgt.InsertModifyItemSubstituionInOtherCompanies(ItemSub);
    End;

    procedure SynchronizeDefaultDimensionToCompany(DefaultDim: Record "Default Dimension")
    var
        ICSyncMgt: Codeunit "IC Sync Management";
    begin
        ICSyncMgt.InsertModifyDefaultDimInOtherCompanies(DefaultDim);
    End;

    procedure SynchronizeDeleteDefaultDimensionToCompany(DefaultDim: Record "Default Dimension")
    var
        ICSyncMgt: Codeunit "IC Sync Management";
    begin
        ICSyncMgt.DeleteDefaultDimInOtherCompanies(DefaultDim);
    End;

    procedure SynchronizeItemTranslationToCompany(ItemTrans: Record "Item Translation")
    var
        ICSyncMgt: Codeunit "IC Sync Management";
    begin
        ICSyncMgt.InsertModifyItemTranslationInOtherCompanies(ItemTrans);
    End;

    procedure SynchronizeExtendedTextHeaderToCompany(ExtendedTextHeader: Record "Extended Text Header")
    var
        ICSyncMgt: Codeunit "IC Sync Management";
    begin
        ICSyncMgt.InsertModifyExtendedTextHeaderInOtherCompanies(ExtendedTextHeader);
    End;

    procedure SynchronizeExtendedTextLineToCompany(ExtendedTextLine: Record "Extended Text Line")
    var
        ICSyncMgt: Codeunit "IC Sync Management";
    begin
        ICSyncMgt.InsertModifyExtendedTextLineInOtherCompanies(ExtendedTextLine);
    End;

    procedure SynchronizeShipToAddressToCompany(ShipToAddress: Record "Ship-to Address")
    var
        ICSyncMgt: Codeunit "IC Sync Management";
    begin
        ICSyncMgt.InsertModifyShipToAddressInOtherCompanies(ShipToAddress);
    End;

    procedure SynchronizePostCodeToCompany(PostCode: Record "Post Code")
    var
        ICSyncMgt: Codeunit "IC Sync Management";
    begin
        ICSyncMgt.InsertModifyPostCodeInOtherCompanies(PostCode);
    End;

    procedure SynchronizeVARIDToCompany(VARID: Record "VAR")
    var
        ICSyncMgt: Codeunit "IC Sync Management";
    begin
        ICSyncMgt.InsertModifyVARIDInOtherCompanies(VARID);
    End;

    procedure DeleteItemInOtherCompany(Item: Record "Item")
    var
        ICSyncMgt: Codeunit "IC Sync Management";
    begin
        ICSyncMgt.DeleteItemInOtherCompanies(Item);
    End;

    procedure SynchronizeCustomerToSECDK(customer: record Customer)
    var
        Company: record company;
        Customer2: record customer;
        GlSetup: record "General Ledger Setup";
        CustDiscGroup: record "Customer Discount Group";
        CustPriceGroup: record "Customer Price Group";
        postcode: Record "Post Code";
    begin
        GlSetup.Get;
        Company.SetRange(Company.Name, GlSetup."Master Company");
        IF Company.FindFirst() then begin
            Customer2.ChangeCompany(Company.Name);
            Customer2.Init();
            Customer2.TransferFields(customer);
            if customer."IC Partner Code" <> '' then
                Customer2."IC Partner Code" := '';
            if Customer."Location Code" <> '' then
                Customer2."Location Code" := '';
            if Customer."Customer Disc. Group" <> '' then
                Customer2."Customer Disc. Group" := '';
            if Customer."Customer Price Group" <> '' then
                Customer2."Customer Price Group" := '';
            IF not Customer2.Insert(false) then
                Customer2.Modify(false);
        end;
    end;

    procedure CheckPostCode(Customer: record Customer; postcode: record "Post Code")
    var

    begin
        if (Customer."Post Code" <> '') then begin
            if not Postcode.Get(Customer."Post Code", Customer.City) then begin
                CreateNewPostCode(Customer);
            end;
        end;
    end;

    local procedure CreateNewPostCode(Customer: Record Customer)
    var
        Postcode: record "Post Code";
        Glsetup: record "General Ledger Setup";
    begin
        Postcode.Init();
        Postcode.ValidatePostCode(Customer.City, Customer."Post Code", Customer.County, Customer."Country/Region Code", false);
        Postcode.Code := Customer."Post Code";
        Postcode.ValidateCity(Customer.City, Customer."Post Code", Customer.County, Customer."Country/Region Code", false);
        Postcode.City := Customer.City;
        Postcode.ValidateCountryCode(Customer.City, Customer."Post Code", Customer.County, Customer."Country/Region Code");
        Postcode."Country/Region Code" := Customer."Country/Region Code";
        Postcode.Insert(true);
    end;

    Procedure SetItemDefaults(var rec: record Item)
    var
        Location: record Location;
    begin
        Rec.validate(Reserve, rec.Reserve::Always);
        Rec.Validate("Prevent Negative Inventory", rec."Prevent Negative Inventory"::Yes);
        rec.Validate("Reordering Policy", rec."Reordering Policy"::Order);
    end;

    procedure SynchronizeContactToCompany(Contact: record Contact)
    var
        Company: record company;
        Contact2: record Contact;
        GlSetup: record "General Ledger Setup";
        CustDiscGroup: record "Customer Discount Group";
        CustPriceGroup: record "Customer Price Group";
        postcode: Record "Post Code";
    begin
        GlSetup.Get;
        Company.SetRange(Company.Name, GlSetup."Master Company");
        IF Company.FindFirst() then begin
            Contact2.ChangeCompany(Company.Name);
            Contact2.Init();
            Contact2.TransferFields(Contact);
            IF not Contact2.Insert(false) then
                Contact2.Modify(false);
        end;
    end;

}