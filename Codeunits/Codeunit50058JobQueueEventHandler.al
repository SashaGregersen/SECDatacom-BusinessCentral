codeunit 50058 "Job Queue Event Handler"
{
    SingleInstance = true;
    EventSubscriberInstance = StaticAutomatic;

    var
        RunWorkflowOnAfterJobQueueEntryErrorDescTxt: TextConst DAN = 'Job Que Entry Status has been changed to Error', ENU = 'Job Que Entry Status has been changed to Error';
        NotifyUserResponseDescTxt: TextConst ENU = 'Notify User (NC).';
        SendNotificationEmailResponseTxt: TextConst ENU = 'Send notification e-mail (NC).';

    trigger OnRun();
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnAfterJobQueueEntryErrorCode, Database::"Job Queue Entry", RunWorkflowOnAfterJobQueueEntryErrorDescTxt, 0, false);
        WorkflowResponseHandling.AddResponsePredecessor(NotifyUserResponseCode, RunWorkflowOnAfterJobQueueEntryErrorCode);
        WorkflowResponseHandling.AddResponsePredecessor(SendNotificationEmailResponseCode, RunWorkflowOnAfterJobQueueEntryErrorCode);
    end;

    local procedure NotifyUserResponseCode(): Code[128];
    begin
        exit(UpperCase('NotifyUser (NC)'));
    end;

    local procedure SendNotificationEmailResponseCode(): Code[128];
    begin
        exit(UpperCase('SendNotificationEmail (NC)'));
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
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnAfterInsertJobQueueLogEntryCode, DATABASE::"Job Queue Log Entry", RunWorkflowOnAfterInsertJobQueueLogEntryDescTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnAfterJobQueueEntryErrorCode, DATABASE::"Job Queue Entry", RunWorkflowOnAfterJobQueueEntryErrorDescTxt, 0, false);
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
        WorkflowResponseHandling.AddResponseToLibrary(NotifyUserResponseCode, 0, NotifyUserResponseDescTxt, 'NCNOTIFYUSER');
        WorkflowResponseHandling.AddResponseToLibrary(SendNotificationEmailResponseCode, 0, SendNotificationEmailResponseTxt, 'NCSENDMAIL');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', true, true)]
    local procedure ExecuteWorkflowResponses(var ResponseExecuted: Boolean; Variant: Variant; xVariant: Variant; ResponseWorkflowStepInstance: Record 1504);
    var
        WorkflowResponse: Record "Workflow Response";
    begin
        if WorkflowResponse.Get(ResponseWorkflowStepInstance."Function Name") then
            case WorkflowResponse."Function Name" of
                NotifyUserResponseCode:
                    begin
                        NotifyUserResponse(Variant, ResponseWorkflowStepInstance);
                        ResponseExecuted := true;
                    end;
                SendNotificationEmailResponseCode:
                    begin
                        SendNotificationEmailResponse(Variant, ResponseWorkflowStepInstance);
                        ResponseExecuted := true;
                    end;
            end;
    end;

    local procedure NotifyUserResponse(Variant: Variant; WorkflowStepInstance: Record 1504);
    var
        WorkflowStepArgument: Record 1523;
        /*NCWorkflowSupportFuntions : Codeunit 50032;*/
        JobQueueEntryId: GUID;
        JobQueueEntryDescription: Text;
        LastErrorText: Text;
    begin
        /*
      WorkflowStepArgument.GET(WorkflowStepInstance.Argument);
      GetErrorAndSource(Variant, JobQueueEntryId, JobQueueEntryDescription, LastErrorText);  //NC10.00.03
      NCWorkflowSupportFuntions.NotifyUserWkfl(Variant, '', TRUE, STRSUBSTNO(WorkflowStepArgument."Notification Message (NC)", JobQueueEntryId, JobQueueEntryDescription, LastErrorText)
        , WorkflowStepArgument."Notif. Link Target Page (NC)",WorkflowStepArgument."Notification User ID (NC)");
        */
    end;

    procedure SendNotificationEmailResponse(Variant: Variant; WorkflowStepInstance: Record 1504);
    var
        WorkflowStepArgument: Record 1523;
        UserSetup: Record 91;
        /*NCWorkflowSupportFuntions@1000000003 : Codeunit 50032;*/
        NotificationAttemptFailedTxt: TextConst ENU = '"An  attempt to send a notification e-mail failed. Important information might have been discarded. Please check your e-mail setup. "';
        JobQueueEntryId: GUID;
        JobQueueEntryDescription: Text;
        LastErrorText: Text;
    begin
        /*
        WorkflowStepArgument.GET(WorkflowStepInstance.Argument);
        GetErrorAndSource(Variant, JobQueueEntryId, JobQueueEntryDescription, LastErrorText);
        UserSetup.GET(WorkflowStepArgument."E-mail recipient User ID (NC)");

        IF NOT NCWorkflowSupportFuntions.TrySendNotificationEmail(UserSetup."E-Mail", STRSUBSTNO(WorkflowStepArgument."E-mail message (NC)", JobQueueEntryId, JobQueueEntryDescription, LastErrorText)
          , STRSUBSTNO(WorkflowStepArgument."E-mail subject (NC)", JobQueueEntryId, JobQueueEntryDescription, LastErrorText)) THEN
            NCWorkflowSupportFuntions.NotifyUserWkfl(Variant, '', TRUE, NotificationAttemptFailedTxt, 0, WorkflowStepArgument."E-mail recipient User ID (NC)");
            */
    end;

    local procedure GetErrorAndSource(Variant: Variant; var JobQueueEntryId: GUID; var JobQueueEntryDescription: Text; var LastErrorText: Text);
    var
        RecRef: RecordRef;
        JobQueueEntry: Record 472;
        JobQueueLogEntry: Record 474;
    begin
        RecRef.GetTable(Variant);
        Clear(JobQueueEntryId);
        Clear(JobQueueEntryDescription);
        Clear(LastErrorText);

        case RecRef.NUMBER of
            Database::"Job Queue Entry":
                begin
                    JobQueueEntry := Variant;
                    JobQueueEntryId := JobQueueEntry.ID;
                    JobQueueEntryDescription := JobQueueEntry.Description;
                    LastErrorText := StrSubstNo('%1%2%3%4', JobQueueEntry."Error Message", JobQueueEntry."Error Message 2", JobQueueEntry."Error Message 3", JobQueueEntry."Error Message 4");
                end;
            Database::"Job Queue Log Entry":
                begin
                    JobQueueLogEntry := Variant;
                    JobQueueEntryId := JobQueueLogEntry.ID;
                    JobQueueEntryDescription := JobQueueLogEntry.Description;
                    LastErrorText := StrSubstNo('%1%2%3%4', JobQueueLogEntry."Error Message", JobQueueLogEntry."Error Message 2", JobQueueLogEntry."Error Message 3", JobQueueLogEntry."Error Message 4");
                end;
        end;
    end;
}