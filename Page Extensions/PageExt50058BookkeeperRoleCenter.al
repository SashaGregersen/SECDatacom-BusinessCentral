pageextension 50058 PreReminderBookkeeper extends "Bookkeeper Role Center"
{
    actions
    {
        addlast(Processing)
        {
            action(SendPreReminder)
            {
                Caption = 'Send Pre-Reminders';
                Image = SendAsPDF;
                ApplicationArea = All;
                RunObject = Report "Find PreReminders";
            }
        }
    }
}