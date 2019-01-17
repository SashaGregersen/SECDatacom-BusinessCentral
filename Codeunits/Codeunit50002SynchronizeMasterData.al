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
    begin
        Location.ChangeCompany('SECDenmark');
        Location.SetRange("Calculate Available Stock", true);
        if Location.FindSet then
            repeat
                PurchLine."Location Code" := Location.code;
                Item.ChangeCompany('SECDenmark');
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

    procedure SynchronizeCustomerToSECDK(customer: record Customer)
    var
        Company: record company;
        Customer2: record customer;
    begin

        Company.SetRange(Company.Name, 'SECDenmark');
        IF Company.FindFirst() then begin
            Customer2.ChangeCompany(Company.Name);
            Customer2.Init();
            Customer2.TransferFields(customer);
            IF not Customer2.Insert(false) then
                Customer2.Modify(false);
        end;

    end;

}