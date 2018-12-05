codeunit 50002 "Update Inventory"
{
    trigger OnRun();
    begin
    end;

    procedure UpdateInventoryFromLocation(PurchLine: record "Purchase Line"): Decimal
    var
        Location: Record Location;
        AvailableInv: Decimal;
        Item: Record Item;
    begin
        Location.ChangeCompany('CRONUS Danmark A/S');
        Location.SetFilter(Location.Code, '%1|%2', 'GRØN', 'RØD');
        if Location.FindSet then repeat
                                     PurchLine."Location Code" := Location.code;
                                     Item.ChangeCompany('CRONUS Danmark A/S');
                                     Item.GET(PurchLine."No.");
                                     Item.CALCFIELDS(Inventory, "Reserved Qty. on Inventory");
                                     AvailableInv := Item.Inventory - Item."Reserved Qty. on Inventory";
            until Location.Next = 0;
        exit(AvailableInv);

    end;



    procedure SynchronizeInventoryToCompany(Item: Record Item)
    var
        Company: Record Company;
        InventorySetup: Record "Inventory Setup";
        Newrec: Record Item;
    begin
        Company.SetFilter(Company.Name, '<>%1', CompanyName());
        IF Company.FindSet() then
            repeat
                InventorySetup.ChangeCompany(Company.Name);
                IF InventorySetup.Get() then
                    If InventorySetup."Receive Synchronized Items" = TRUE then begin
                        Newrec.ChangeCompany(Company.Name);
                        Newrec.Init();
                        Newrec.TransferFields(Item);
                        IF not Newrec.Insert(false) then
                            Newrec.Modify(false);
                    end;
            until Company.next = 0;
    End;



}