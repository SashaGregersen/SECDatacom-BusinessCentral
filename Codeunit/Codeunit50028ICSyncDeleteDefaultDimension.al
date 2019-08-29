codeunit 50028 "IC Sync Delete Def. Dimension"
{
    TableNo = "Default Dimension";

    var
        DefDim: Record "Default Dimension";

    trigger OnRun()
    begin
        if DefDim.get(rec."Table ID", Rec."No.", rec."Dimension Code") then
            DefDim.Delete(true);
    end;
}