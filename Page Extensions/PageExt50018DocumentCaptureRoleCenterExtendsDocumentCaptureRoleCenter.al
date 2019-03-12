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
                trigger OnAction()
                var
                    SendStatusEmailtoApprovers: Codeunit 6085712;
                begin
                    SendStatusEmailtoApprovers.Run();
                end;
            }

        }
    }


}