pageextension 50017 "Expense Management Role Center" extends "Expense Management Role Center"
{
    layout
    {

    }

    actions
    {
        addfirst(Processing)
        {
            action("Send Status Email to Approvers")
            {
                trigger OnAction()
                var
                    SendExpenseStatusReport: Codeunit 6086353;
                begin
                    SendExpenseStatusReport.SendExpenseStatusReport();
                end;
            }

        }

        addafter("Send Status Email to Approvers")
        {
            action("Send Reminder E-mail to Expense Users")
            {
                trigger OnAction()
                var
                    SendReminder: Codeunit 6086314;
                begin
                    SendReminder.Run();
                end;
            }
        }

        addafter("Send Reminder E-mail to Expense Users")
        {
            action("Expense Approval E-mail")
            {
                trigger OnAction()
                var
                    ExpenseApproval: Codeunit 6086313;
                begin
                    ExpenseApproval.Run();
                end;
            }
        }

        addafter("Expense Approval E-mail")
        {
            action("")
            {
                trigger OnAction()
                var
                    ExpenseOnlineMgt: Codeunit 6086305;
                begin
                    ExpenseOnlineMgt.Run();
                end;
            }
        }
    }

}