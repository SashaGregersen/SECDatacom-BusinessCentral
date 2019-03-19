table 50009 "Job Queue Notif. Recipient"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Job Queue ID"; Guid)
        {
            DataClassification = ToBeClassified;
            CaptionML = DAN = 'Opgavekø-id', ENU = 'Job Queue ID';
        }
        field(2; "Recipient ID"; Code[50])
        {
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(3; "Notify By"; Option)
        {
            OptionMembers = "Note","E-mail";
        }
        field(4; "Last Notified Log Entry"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = DAN = 'Sidst notificerede logpost', ENU = 'Last Notified Log Entry';
            Editable = false;
        }
        field(5; "Last Modified"; DateTime)
        {
            DataClassification = ToBeClassified;
            CaptionML = DAN = 'Sidst ændret', ENU = 'Last Modified';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Job Queue ID", "Recipient ID", "Notify By")
        {
            Clustered = true;
        }
    }
}