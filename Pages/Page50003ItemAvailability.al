page 50003 "Item Availability"
{
    PageType = List;
    //ApplicationArea = All;
    SourceTable = Item;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;

                }
                field("Curr. Invt."; CurrInvt)
                {

                }
            }
        }

    }

    var
        CurrInvt: Decimal;

    trigger OnAfterGetCurrRecord()
    var
        PurLine: Record "Purchase Line";
        //CalcInvt: Codeunit "Calculate Available Inventory";
    begin
        PurLine."No." := "No.";
        //CurrInvt := CalcInvt.FindAvailableInventory(PurLine);
    end;
}