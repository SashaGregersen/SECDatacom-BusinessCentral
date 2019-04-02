tableextension 50042 "Job Queue Notification" extends "Job Queue Entry"
{
    fields
    {
        field(50000; "Use Notification"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = DAN = 'Brug notificering', ENU = 'Use Notification';
            trigger OnValidate()
            begin
                if "Use Notification" then
                    "Notification Enabled DateTime" := CurrentDateTime()
                else
                    "Notification Enabled DateTime" := 0DT;
            end;
        }
        field(50001; "Notification Enabled DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            CaptionML = DAN = 'Tidspunkt for aktivering af Notificering', ENU = 'Time for activation of Notification';
            Editable = false;
        }
    }
    trigger OnAfterDelete()
    var
        JobQueueNotifRecipient: Record "Job Queue Notif. Recipient";
    begin
        JobQueueNotifRecipient.SetRange("Job Queue ID", ID);
        JobQueueNotifRecipient.DeleteAll();
    end;
}