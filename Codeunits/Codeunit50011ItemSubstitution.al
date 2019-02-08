codeunit 50011 "Item Substitution"
{
    trigger OnRun()
    begin

    end;

    procedure FindItemSubstituions(var rec: record "Requisition Line")
    var
        SubItem: Record "Item Substitution";
        Item: Record item;
        ReservEntry: record "Reservation Entry";
        ReserveEngineMgt: Codeunit "Reservation Engine Mgt.";
    begin
        if item.get(Rec."No.") then begin
            SubItem.SetRange("No.", Item."No.");
            if not SubItem.IsEmpty() then begin
                if page.RunModal(page::"Item Substitutions", SubItem) = action::LookupOK then begin
                    ReservEntry.Setrange("Item No.", Rec."No.");
                    ReservEntry.SetRange(Quantity, Rec.Quantity);
                    ReservEntry.SetRange("Source Type", 246);
                    ReservEntry.SetRange("Source Subtype", 0);
                    ReservEntry.SetRange("Source ID", 'INDKØB');
                    ReservEntry.SetRange("Source Ref. No.", Rec."Line No.");
                    if ReservEntry.FindFirst() then begin
                        Item.Get(SubItem."Substitute No.");
                        item.CalcFields(Inventory);
                        Item.CalcFields("Reserved Qty. on Inventory");
                        if (Item.Inventory - item."Reserved Qty. on Inventory") < rec.Quantity then begin
                            ReserveEngineMgt.CancelReservation(ReservEntry);
                            Rec.Validate("No.", SubItem."Substitute No.");
                            Rec.Modify(true);
                        end else
                            if Confirm('The substitute item %1 is available on stock, do you wish to continue purchasing it?', false, item."No.") then begin
                                ReserveEngineMgt.CancelReservation(ReservEntry);
                                Rec.Validate("No.", SubItem."Substitute No.");
                                Rec.Modify(true);
                            end;
                    end;
                end;
            end;

        end;

    end;
}