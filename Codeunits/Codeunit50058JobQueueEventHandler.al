codeunit 50058 "Job Queue Event Handler"
{
    SingleInstance = true;
    EventSubscriberInstance = StaticAutomatic;

    var
        RunWorkflowOnAfterJobQueueEntryErrorDescTxt: TextConst DAN = 'Job Que Entry Status has been changed to Error', ENU = 'Job Que Entry Status has been changed to Error';

    local procedure NotifyUserResponseCode(): Code[128];
    begin
        exit(UpperCase('Notify Reciepient'));
    end;

    procedure RunWorkflowOnAfterJobQueueEntryErrorCode(): Code[128];
    begin
        exit(UpperCase('RunWorkflowOnAfterJobQueueEntryError'));
    end;

    procedure RunWorkflowOnAfterInsertJobQueueLogEntryCode(): Code[128];
    begin
        exit(UpperCase('RunWorkflowOnAfterInsertJobQueueLogEntry'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', true, true)]
    local procedure AddWorkflowEventsToLibrary();
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        RunWorkflowOnAfterInsertJobQueueLogEntryDescTxt: TextConst ENU = 'A Job Queue Log Entry was inserted.';
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnAfterInsertJobQueueLogEntryCode, Database::"Job Queue Log Entry", RunWorkflowOnAfterInsertJobQueueLogEntryDescTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnAfterJobQueueEntryErrorCode, Database::"Job Queue Entry", RunWorkflowOnAfterJobQueueEntryErrorDescTxt, 0, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', true, true)]
    procedure ExecuteWorkflowResponses(var ResponseExecuted: Boolean; Variant: Variant; xVariant: Variant; ResponseWorkflowStepInstance: Record "Workflow Step Instance");
    var
        WorkflowResponse: Record "Workflow Response";
        JobQueueNotifRecipient: Record "Job Queue Notif. Recipient";
        JobQueueEntryId: GUID;
        JobQueueLogEntryNo: Integer;
        JobQueueEntryDescription: Text;
        LastErrorText: Text;
        UserSetup: Record "User Setup";
        NotificationAttemptFailedTxt: TextConst ENU = '"An  attempt to send a notification e-mail failed. Important information might have been discarded. Please check your e-mail setup. "';
    begin
        //forsæt kun hvis det er job queue / log
        if not GetErrorAndSource(Variant, JobQueueEntryId, JobQueueLogEntryNo, JobQueueEntryDescription, LastErrorText) then exit;

        JobQueueNotifRecipient.SetRange("Job Queue ID", JobQueueEntryId);
        if JobQueueNotifRecipient.FindSet() then
            repeat
                UserSetup.Get(JobQueueNotifRecipient."Recipient ID");

                case JobQueueNotifRecipient."Notify By" of
                    JobQueueNotifRecipient."Notify By"::"E-mail":
                        begin
                            IF NOT TrySendNotificationEmail(UserSetup."E-Mail",
                                        StrSubstNo('Job Queue %1 %2 has the following error %3',
                                                    JobQueueEntryId,
                                                    JobQueueEntryDescription,
                                                    LastErrorText),
                                        StrSubstNo('Job Queue %1 %2 has the following error %3',
                                                    JobQueueEntryId,
                                                    JobQueueEntryDescription,
                                                    LastErrorText)) then
                                NotifyUserWkfl(Variant,
                                                '',
                                                true,
                                                NotificationAttemptFailedTxt,
                                                0,
                                                UserSetup."User ID");
                        end;
                    JobQueueNotifRecipient."Notify By"::Note:
                        begin
                            NotifyUserWkfl(Variant, '',
                                true,
                                StrSubstNo('Job Queue %1 %2 has the following error %3',
                                            JobQueueEntryId,
                                            JobQueueEntryDescription,
                                            LastErrorText),
                                0,
                                UserSetup."User ID");
                        end;
                end;

                ResponseExecuted := true;
                JobQueueNotifRecipient."Last Notified Log Entry" := JobQueueLogEntryNo;
                JobQueueNotifRecipient.Modify(false);
            until JobQueueNotifRecipient.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Job Queue Log Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure RunWorkflowOnAfterInsertJobQueueLogEntry(var Rec: Record "Job Queue Log Entry"; RunTrigger: Boolean);
    var
        WorkflowManagement: Codeunit "Workflow Management";
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnAfterInsertJobQueueLogEntryCode, Rec);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Queue - Send Notification", 'OnAfterRun', '', false, false)]
    local procedure JobQueueSendNotificationOnAfterRun(JobQueueEntry: Record "Job Queue Entry"; RecordLink: Record "Record Link")
    var
        WorkflowManagement: Codeunit "Workflow Management";
    begin
        if JobQueueEntry.Status = JobQueueEntry.Status::Error then
            WorkflowManagement.HandleEvent(RunWorkflowOnAfterJobQueueEntryErrorCode, JobQueueEntry);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', true, true)]
    local procedure AddWorkflowResponsesToLibrary();
    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(NotifyUserResponseCode, 0, 'Notify Recipient', 'NCNOTIFYUSER');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', true, true)]
    procedure AddWorkflowEventResponseCombinationsToLibrary(ResponseFunctionName: Code[128]);
    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    begin
        case ResponseFunctionName OF
            NotifyUserResponseCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(NotifyUserResponseCode, RunWorkflowOnAfterInsertJobQueueLogEntryCode);
                    WorkflowResponseHandling.AddResponsePredecessor(NotifyUserResponseCode, RunWorkflowOnAfterJobQueueEntryErrorCode);
                end;
        end;
    end;

    local procedure GetErrorAndSource(Variant: Variant; var JobQueueEntryId: GUID; JobQueueLogEntryNo: Integer; var JobQueueEntryDescription: Text; var LastErrorText: Text): Boolean;
    var
        RecRef: RecordRef;
        JobQueueEntry: Record "Job Queue Entry";
        JobQueueLogEntry: Record "Job Queue Log Entry";
    begin
        RecRef.GetTable(Variant);
        Clear(JobQueueEntryId);
        Clear(JobQueueLogEntryNo);
        Clear(JobQueueEntryDescription);
        Clear(LastErrorText);

        case RecRef.Number of
            Database::"Job Queue Entry":
                begin
                    JobQueueEntry := Variant;
                    if not JobQueueEntry."Use Notification" then
                        exit(false);
                    JobQueueEntryId := JobQueueEntry.ID;
                    JobQueueEntryDescription := JobQueueEntry.Description;
                    LastErrorText := StrSubstNo('%1%2%3%4', JobQueueEntry."Error Message", JobQueueEntry."Error Message 2", JobQueueEntry."Error Message 3", JobQueueEntry."Error Message 4");

                    JobQueueLogEntry.SetCurrentKey(ID, Status);
                    JobQueueLogEntry.SetRange(ID, JobQueueEntryId);
                    JobQueueLogEntry.SetRange(Status, JobQueueLogEntry.Status::Error);
                    if JobQueueLogEntry.FindLast() then
                        JobQueueLogEntryNo := JobQueueLogEntry."Entry No.";
                end;
            Database::"Job Queue Log Entry":
                begin
                    JobQueueLogEntry := Variant;
                    JobQueueEntry.Get(JobQueueLogEntry.ID);
                    if not JobQueueEntry."Use Notification" then
                        exit(false);

                    JobQueueEntryId := JobQueueLogEntry.ID;
                    JobQueueLogEntryNo := JobQueueLogEntry."Entry No.";
                    JobQueueEntryDescription := JobQueueLogEntry.Description;
                    LastErrorText := StrSubstNo('%1%2%3%4', JobQueueLogEntry."Error Message", JobQueueLogEntry."Error Message 2", JobQueueLogEntry."Error Message 3", JobQueueLogEntry."Error Message 4");
                end;
            else
                exit(false);
        end;
        exit(true);
    end;

    [TryFunction]
    procedure TrySendNotificationEmail(SendToEmail: Text[80]; CustomText: Text; EmailSubject: Text[250]);
    VAR
        TempEmailItem: Record "Email Item" temporary;
        EmailBody: Record TempBlob temporary;
    begin
        if SendToEmail = '' then
            exit;
        GenerateEmailBody(EmailBody, CustomText);

        TempEmailItem."Send to" := SendToEmail;
        TempEmailItem.Subject := EmailSubject;
        TempEmailItem.Body := EmailBody.Blob;
        TempEmailItem."Plaintext Formatted" := false;

        if not TempEmailItem.Send(true) then
            error('E-mail not sent.');
    end;

    local procedure GenerateEmailBody(var BodyBlob: Record TempBlob; CustomText: Text);
    var
        BodyStream: OutStream;
    begin
        BodyBlob.Blob.CREATEOUTSTREAM(BodyStream, TextEncoding::UTF8);
        if CustomText <> '' then begin
            BodyStream.WriteText(CustomText);
            BodyStream.WriteText('<br><br>');
        end;
    end;

    procedure SendNotification(Description: Text; Note: text)
    var
        Notification: Notification;
    begin
        Notification.Message(StrSubstNo('%1 %2', UpperCase(Description), Note));
        Notification.SCOPE := NotificationScope::LocalScope;
        Notification.Send;
    end;

    procedure NotifyUserWkfl(RecRefAsVariant: Variant; Description: Text; IsError: Boolean; Note: Text; PageID: Integer; NotifyUserID: Code[50]);
    var
        RecordLink: Record "Record Link";
        DataTypeManagement: Codeunit "Data Type Management";
        RecRef: RecordRef;
    begin
        DataTypeManagement.GetRecordRef(RecRefAsVariant, RecRef);
        CreateNoteWkfl(RecRef, Description, IsError, PageID, Note, RecordLink, NotifyUserID);
        SendNotification(Description, Note);
    end;

    procedure CreateNoteWkfl(RecRef: RecordRef; Description: Text; IsError: Boolean; PageID: Integer; Note: Text; var RecordLink: Record "Record Link"; NotifyUserID: Code[50]);
    var
        LinkId: Integer;
        TypeHelper: Codeunit "Type Helper";
    begin
        RecordLink.FindLast();
        LinkId := RecordLink."Link ID" + 1;
        RecordLink.Init();
        RecordLink."Link ID" := LinkId;
        RecordLink."Record ID" := RecRef.RecordId;
        RecordLink.Description := Description;
        RecordLink.Type := RecordLink.Type::Note;
        RecordLink.Company := CompanyName;

        RecordLink.URL1 := GetUrl(ClientType::Windows, CompanyName, ObjectType::Page, PageID, RecRef);
        RecordLink.URL2 := GetUrl(ClientType::Web, CompanyName, ObjectType::Page, PageID, RecRef);
        RecordLink.URL3 := GetUrl(ClientType::Phone, CompanyName, ObjectType::Page, PageID, RecRef);
        RecordLink.URL4 := GetUrl(ClientType::Tablet, CompanyName, ObjectType::Page, PageID, RecRef);

        if IsError then
            RecordLink.Notify := true
        else
            RecordLink.Notify := false;
        RecordLink.Created := CurrentDateTime();
        RecordLink."User ID" := UserId();
        RecordLink."To User ID" := NotifyUserID;
        TypeHelper.WriteRecordLinkNote(RecordLink, StrSubstNo('%1 %2', UpperCase(RecordLink.Description), Note));
        RecordLink.Insert;
    end;
}