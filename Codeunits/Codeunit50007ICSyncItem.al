codeunit 50007 "IC Sync Item"
{
    TableNo = Item;

    trigger OnRun()
    var
        ItemUOM: Record "Item Unit of Measure";
    begin
        if not rec.Insert(true) then
            rec.Modify(true);
        if Rec."Base Unit of Measure" <> '' then begin
            ItemUOM."Item No." := Rec."No.";
            ItemUOM.Code := rec."Base Unit of Measure";
            ItemUOM."Qty. per Unit of Measure" := 1;
            ItemUOM.Insert(true);
        end;
    end;
}