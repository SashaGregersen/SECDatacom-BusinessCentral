pageextension 50032 "Inventory Availability" extends "Purchase Line FactBox"
{
    layout
    {
        addafter(Availability)
        {
            field("Curr. Invt"; CurrentAvailability)
            {
                Editable = FALSE;
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
        Item: Record Item;
    begin
        CurrentAvailability := StrSubstNo('%1', CallWebservice.CallWebserviceInventory(Rec));
    end;

}