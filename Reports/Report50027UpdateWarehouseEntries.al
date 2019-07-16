report 50027 "Update Warehouse Entries"
{
    UsageCategory = None;
    ProcessingOnly = true;
    UseRequestPage = true;


    dataset
    {

        dataitem(Item; Item)
        {
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            var
                ItemLedgerEntries: record "Item Ledger Entry";
                WarehouseEntries: record "Warehouse Entry";
            begin
                ItemLedgerEntries.setrange("Item No.", Item."No.");
                ItemLedgerEntries.setrange("Remaining Quantity", 1);
                ItemLedgerEntries.SetFilter("Serial No.", '<>%1', '');
                if ItemLedgerEntries.findset then
                    repeat
                        WarehouseEntries.setrange("Item No.", ItemLedgerEntries."Item No.");
                        WarehouseEntries.setrange("Serial No.", '');
                        if WarehouseEntries.FindFirst() then
                            WarehouseEntries."Serial No." := ItemLedgerEntries."Serial No.";
                        WarehouseEntries.Modify(false);

                    until ItemLedgerEntries.next = 0;
            end;

        }
    }

    var

}