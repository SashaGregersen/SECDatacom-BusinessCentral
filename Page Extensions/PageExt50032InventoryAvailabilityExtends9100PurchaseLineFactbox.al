pageextension 50032 "Inventory Availability" extends "Purchase Line FactBox"
{
    layout
    {
        addafter(Availability)
        {
            field("Curr. Invt"; CurrentAvailability)
            {
                ToolTip = 'Shows the current available inventory in SEC Denmark';
            }
        }
    }

    actions
    {

    }

    var
        CurrentAvailability: Text;
        CallWebservice: Codeunit 50002;
        Location: Record Location;


    trigger OnAfterGetCurrRecord();
    var
        CalcAvailInv: Codeunit 5790;
    begin
        CurrentAvailability := StrSubstNo('%1', CallWebservice.CallWebserviceInventory(Rec));
    end;

}