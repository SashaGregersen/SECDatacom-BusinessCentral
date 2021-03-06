pageextension 50032 "Inventory Availability" extends "Purchase Line FactBox"
{
    layout
    {
        addafter(Availability)
        {
            field("Curr. Invt"; CurrentAvailability)
            {
                ToolTip = 'Shows the current available inventory in SEC Denmark';
                ApplicationArea = all;
            }
        }
    }

    actions
    {

    }

    var
        CurrentAvailability: Text;
        UpdateInventory: Codeunit 50002;
        Location: Record Location;


    trigger OnAfterGetCurrRecord();
    var
        CalcAvailInv: Codeunit 5790;
    begin
        CurrentAvailability := StrSubstNo('%1', UpdateInventory.UpdateInventoryOnPurchLineFromLocation(Rec));
    end;

}