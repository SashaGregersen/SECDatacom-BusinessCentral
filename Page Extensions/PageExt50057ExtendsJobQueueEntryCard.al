pageextension 50057 JobQueueEntryCard extends "Job Queue Entry Card"
{
    layout
    {
        addafter(Status)
        {
            field("Use Notification"; "Use Notification") { }
            field("Notification Enabled DateTime"; "Notification Enabled DateTime") { }
        }
    }
    actions
    {
        addlast(Navigation)
        {
            action(Recipients)
            {
                Caption = 'Job Queue Notification Recipients';
                Image = ContactReference;
                ApplicationArea = All;
                RunObject = page "Job Queue Notific. Recipients";
                RunPageLink = "Job Queue ID" = field (ID);
            }
        }
    }
}