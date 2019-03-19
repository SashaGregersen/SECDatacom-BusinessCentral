tableextension 50042 "Job Queue Notification" extends "Job Queue Entry"
{
    fields
    {
        field(50000; "Use Notification"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = DAN = 'Brug notificering', ENU = 'Use Notification';
        }
        field(50001; "Notification Enabled DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            CaptionML = DAN = 'Tidspunkt for aktivering af Notificering', ENU = 'Time for activation of Notification';
            Editable = false;
        }
    }
}