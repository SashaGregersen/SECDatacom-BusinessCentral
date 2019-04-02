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
                RunObject = codeunit "Send Expense Status Report";
            }

        }


        addafter("Send Status Email to Approvers")
        {
            action("Expense Approval E-mail")
            {
                RunObject = codeunit "Expense Approval E-Mail";
            }
        }

        addafter("Expense Approval E-mail")
        {
            action("Synchronize with Continia Online")
            {
                RunObject = codeunit "EM Online Mgt.";
            }
        }
    }
}