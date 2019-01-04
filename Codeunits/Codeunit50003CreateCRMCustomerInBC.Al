codeunit 50003 "Create CRM Customer In BC"
{
    trigger OnRun()
    begin
        IF CRMAccount.FindSet() then repeat
                                         CRMIntegrationManagement.CreateNewRecordsFromCRM(CRMAccount);
            until CRMAccount.Next = 0;
    end;

    var
        CRMAccount: record "CRM Account";
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
}