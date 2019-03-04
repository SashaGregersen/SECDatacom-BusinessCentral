codeunit 50002 "Synchronize Master Data"
{
    trigger OnRun();
    begin

    end;

    procedure UpdateInventoryOnPurchLineFromLocation(PurchLine: record "Purchase Line"): Decimal
    var
        Location: Record Location;
        AvailableInv: Decimal;
        Item: Record Item;
        GlSetup: record "General Ledger Setup";
    begin
        GlSetup.Get;
        Location.ChangeCompany(GlSetup."Master Company");
        Location.SetRange("Calculate Available Stock", true);
        if Location.FindSet then
            repeat
                Item.ChangeCompany(GlSetup."Master Company");
                Item.GET(PurchLine."No.");
                Item.CALCFIELDS(Inventory, "Reserved Qty. on Inventory");
                AvailableInv := AvailableInv + Item.Inventory - Item."Reserved Qty. on Inventory";
            until Location.Next = 0;
        exit(AvailableInv);
    end;

    procedure UpdateInventoryOnSalesLineFromLocation(SalesLine: record "Sales Line"): Decimal
    var
        Location: Record Location;
        AvailableInv: Decimal;
        Item: Record Item;
        GlSetup: record "General Ledger Setup";
    begin
        GlSetup.Get;
        Location.ChangeCompany(GlSetup."Master Company");
        Location.SetRange("Calculate Available Stock", true);
        if Location.FindSet then
            repeat
                Item.ChangeCompany(GlSetup."Master Company");
                Item.GET(SalesLine."No.");
                Item.CALCFIELDS(Inventory, "Reserved Qty. on Inventory");
                AvailableInv := AvailableInv + Item.Inventory - Item."Reserved Qty. on Inventory";
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

    procedure SynchronizeCustomerToSECDK(customer: record Customer)
    var
        Company: record company;
        Customer2: record customer;
        GlSetup: record "General Ledger Setup";
    begin
        GlSetup.Get;
        Company.SetRange(Company.Name, GlSetup."Master Company");
        IF Company.FindFirst() then begin
            Customer2.ChangeCompany(Company.Name);
            Customer2.Init();
            Customer2.TransferFields(customer);
            IF not Customer2.Insert(false) then
                Customer2.Modify(false);
        end;

    end;

    Procedure SetItemDefaults(var rec: record Item)
    var
        Location: record Location;
    begin
        Rec.validate(Reserve, rec.Reserve::Always);
        Rec.Validate("Prevent Negative Inventory", rec."Prevent Negative Inventory"::Yes);
        rec.Validate("Reordering Policy", rec."Reordering Policy"::Order);
    end;

}