pageextension 50018 "Documnet Capture Role Center" extends "Document Capture Role Center"
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
                RunObject = codeunit "Purch. Approval E-Mail";
            }

        }
    }


}