codeunit 50007 "IC Sync Item"
{
    TableNo = Item;

    trigger OnRun()
    var
        ItemUOM: Record "Item Unit of Measure";
        ICpartner: Record "IC Partner";
    begin
        ICpartner.SetFilter("Vendor No.", '<>%1', '');
        if ICpartner.FindFirst() then
            Rec.Validate("IC partner Vendor No.", ICpartner."Vendor No.");
        if not rec.Insert(true) then
            rec.Modify(true);
        if Rec."Base Unit of Measure" <> '' then begin
            if not ItemUOM.Get(rec."No.", rec."Base Unit of Measure") then begin
                ItemUOM."Item No." := Rec."No.";
                ItemUOM.Code := rec."Base Unit of Measure";
                ItemUOM."Qty. per Unit of Measure" := 1;
                ItemUOM.Insert(true);
            end;
        end;
    end;
}