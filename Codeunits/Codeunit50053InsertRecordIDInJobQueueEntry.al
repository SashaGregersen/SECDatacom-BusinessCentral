codeunit 50053 "Insert Record ID In Job Queue"
{
    trigger OnRun()
    var
        intMapTable: Record "Integration Table Mapping";
    begin
        JobQueueEntry.setrange(Description, ' CUSTOMER - Dynamics 365 for Sales synchronization job.');
        JobQueueEntry.FindFirst();

        intMapTable.SetFilter(name, '%1|%2|%3', 'RESELLER', 'MANUFACTURER', 'FINANCEPARTNER');
        if intMapTable.FindSet() then
            repeat
                JobQueueEntry2.Init;
                JobQueueEntry2 := JobQueueEntry;
                JobQueueEntry2.Description := intMapTable.name + ' - Dynamics 365 for Sales synchronization job.';
                JobQueueEntry2."Record ID to Process" := intMapTable.RecordId();
                JobQueueEntry2.Insert(true);
            Until intMapTable.next = 0;

    end;

    var
        JobQueueEntry: record "Job Queue Entry";
        RecordID: RecordId;
        JobQueueEntry2: record "Job Queue Entry";
}