codeunit 50002 "Call Webservice Inventory"
{
    trigger OnRun();
    begin
    end;

    procedure CallWebserviceInventory(PurchLine: record "Purchase Line"): Decimal
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

    var
        Location: Record Location;
        AvailableInv: Decimal;
        Item: Record Item;


}