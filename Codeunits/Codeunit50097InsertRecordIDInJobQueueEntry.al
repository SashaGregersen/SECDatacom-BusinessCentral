codeunit 50097 "Insert Record ID In Job Queue"
{
    trigger OnRun()
    var
        intMapTable: Record "Integration Table Mapping";
        JobQueueEntry: record "Job Queue Entry";
    begin
        intMapTable.SetFilter(name, '%1|%2|%3', 'RESELLER', 'MANUFACTURER', 'FINANCEPARTNER');
        if intMapTable.FindSet() then
            repeat
                JobQueueEntry.Init;
                clear(JobQueueEntry.ID);
                JobQueueEntry.Insert(true);
                JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
                JobQueueEntry."Object ID to Run" := 5339;
                JobQueueEntry.Description := intMapTable.name + ' - Dynamics 365 for Sales synchronization job.';
                JobQueueEntry."Record ID to Process" := intMapTable.RecordId();
                JobQueueEntry."Recurring Job" := true;
                JobQueueEntry."Run on Mondays" := true;
                JobQueueEntry."Run on Tuesdays" := true;
                JobQueueEntry."Run on Wednesdays" := true;
                JobQueueEntry."Run on Thursdays" := true;
                JobQueueEntry."Run on Fridays" := true;
                JobQueueEntry."Run on Saturdays" := true;
                JobQueueEntry."Run on Sundays" := true;
                JobQueueEntry."No. of Minutes between Runs" := 2;
                JobQueueEntry.Modify(true);
            Until intMapTable.next = 0;

    end;

    var


}