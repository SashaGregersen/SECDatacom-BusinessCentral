report 50023 "Find PreReminders"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Customer Ledger Entry"; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING ("Customer No.", Open, Positive, "Due Date", "Currency Code") where (Open = const (true));
            RequestFilterFields = "Customer No.", "Due Date", "Document Type";

            trigger OnAfterGetRecord();
            begin
                Mark(true);
            end;

            trigger OnPostDataItem();
            begin
                "Customer Ledger Entry".MarkedOnly;
                PreReminders.SetTableView("Customer Ledger Entry");
                PreReminders.RunModal();
            end;
        }
    }

    var
        PreReminders: Page "PreReminders";
}