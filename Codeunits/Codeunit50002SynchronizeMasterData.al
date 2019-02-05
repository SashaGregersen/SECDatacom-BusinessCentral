codeunit 50002 "Synchronize Master Data"
{
    trigger OnRun();
    begin

    end;

    procedure UpdateInventoryFromLocation(PurchLine: record "Purchase Line"): Decimal
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
                PurchLine."Location Code" := Location.code;
                Item.ChangeCompany(GlSetup."Master Company");
                Item.GET(PurchLine."No.");
                Item.CALCFIELDS(Inventory, "Reserved Qty. on Inventory");
                AvailableInv := Item.Inventory - Item."Reserved Qty. on Inventory" - Item."Reserved Qty. on Purch. Orders";
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
        Rec.Validate("Order Tracking Policy", rec."Order Tracking Policy"::"Tracking Only"); // Bruges til at indsætte købsprisen fra salgsordren ud fra req worksheet
        rec.Validate("Reordering Policy", rec."Reordering Policy"::Order);
    end;

}