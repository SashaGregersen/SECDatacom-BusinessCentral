pageextension 50072 "Adv. Pricing Reservations" extends "Reservation Entries"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        modify(CancelReservation)
        {
            Visible = false;
        }

        addafter(CancelReservation)
        {
            action(SECCancelReservation)
            {
                Caption = 'Cancel Reservation';
                Image = Cancel;
                ApplicationArea = Reservation;
                trigger OnAction()
                var
                    ReservEntry: Record "Reservation Entry";
                    ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
                    Text001: TextConst ENU = 'Cancel reservation of %1 of item number %2, reserved for %3 from %4?', DAN = 'Vil du annullere reservation af %1 af varenr. %2, der er reserveret til %3 fra %4?';
                begin
                    CurrPage.SETSELECTIONFILTER(ReservEntry);
                    IF ReservEntry.FIND('-') THEN
                        REPEAT
                            ReservEntry.TESTFIELD("Reservation Status", "Reservation Status"::Reservation);
                            ReservEntry.TESTFIELD("Disallow Cancellation", FALSE);
                            IF CONFIRM(
                                 Text001, FALSE, ReservEntry."Quantity (Base)",
                                 ReservEntry."Item No.", ReservEngineMgt.CreateForText(Rec),
                                 ReservEngineMgt.CreateFromText(Rec))
                            THEN BEGIN
                                ReservEngineMgt.CloseReservEntry(ReservEntry, true, false);
                                COMMIT;
                            END;
                        UNTIL ReservEntry.NEXT = 0;
                end;
            }
        }
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}