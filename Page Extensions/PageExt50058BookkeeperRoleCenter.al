pageextension 50058 PreReminderBookkeeper extends "Bookkeeper Role Center"
{
    actions
    {
        addlast(Processing)
        {
            action(SendPreReminder)
            {
                Caption = 'Send PreReminders';
                Image = SendAsPDF;
                ApplicationArea = All;
                RunObject = Report "Find PreReminders";
            }
        }
    }
}