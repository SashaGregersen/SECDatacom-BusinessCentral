codeunit 50007 "IC Sync Item"
{
    TableNo = Item;

    trigger OnRun()
    var
        ItemUOM: Record "Item Unit of Measure";
        ICpartner: Record "IC Partner";
        ItemDiscountGroup: record "Item Discount Group";
        Vendor: Record Vendor;
    begin
        ICpartner.SetFilter("Vendor No.", '<>%1', '');
        if not ICpartner.FindFirst() then
            Error('There are no Intercompany Partners with a Vendor No. in %1', CompanyName);

        if not ItemDiscountGroup.get(rec."Item Disc. Group") then
            Rec.Validate("IC partner Vendor No.", ICpartner."Vendor No.")
        else
            if not ItemDiscountGroup."Use Orginal Vendor in Subs" then
                Rec.Validate("IC partner Vendor No.", ICpartner."Vendor No.");

        if Vendor.Get(rec."Vendor No.") then
            Rec.Validate("Vendor Currency", Vendor."Currency Code");

        if not rec.Insert(false) then
            rec.Modify(false);
        if Rec."Base Unit of Measure" <> '' then begin
            if not ItemUOM.Get(rec."No.", rec."Base Unit of Measure") then begin
                ItemUOM."Item No." := Rec."No.";
                ItemUOM.Code := rec."Base Unit of Measure";
                ItemUOM."Qty. per Unit of Measure" := 1;
                ItemUOM.Insert(false);
            end;
        end;
    end;
}