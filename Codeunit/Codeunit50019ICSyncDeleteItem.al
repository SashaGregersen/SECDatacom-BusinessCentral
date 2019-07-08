codeunit 50019 "IC Sync Delete Item"
{
    TableNo = Item;

    trigger OnRun()
    var
        Item: Record Item;
        MoveEntries: codeunit MoveEntries;
        Serviceitem: record "Service Item";
    begin
        if item.Get(Rec."No.") then begin
            CheckJournalsAndWorksheets(0);
            CheckDocuments(0);
            MoveEntries.MoveItemEntries(Item);

            ServiceItem.RESET;
            ServiceItem.SETRANGE("Item No.", "No.");
            IF ServiceItem.FIND('-') THEN
                REPEAT
                    ServiceItem.VALIDATE("Item No.", '');
                    ServiceItem.MODIFY(TRUE);
                UNTIL ServiceItem.NEXT = 0;

            Item.Delete(false);
        end;
    end;
}