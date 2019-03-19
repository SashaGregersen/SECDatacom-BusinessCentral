page 50012 "Job Queue Notific. Recipients"
{
    PageType = List;
    SourceTable = "Job Queue Notif. Recipient";
    Editable = true;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Recipient ID"; "Recipient ID")
                {
                    ApplicationArea = All;
                }
                field("Notify By"; "Notify By")
                {
                    ApplicationArea = All;
                }
                field("Last Notified Log Entry"; "Last Notified Log Entry")
                {
                    ApplicationArea = All;
                }
                field("Last Modified"; "Last Modified")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}