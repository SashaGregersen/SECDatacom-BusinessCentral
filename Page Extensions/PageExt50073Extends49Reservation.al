pageextension 50073 "Adv. Pricing Reservation" extends Reservation
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        modify(CancelReservationCurrentLine)
        {
            Visible = false;
            Promoted = false;
            Caption = 'Not usable at the moment';
        }

        // Add changes to page actions here
    }

    var
        myInt: Integer;
}