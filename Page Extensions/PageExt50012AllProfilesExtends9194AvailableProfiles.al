pageextension 50012 "All Profile" extends "Available Profiles"
{
    layout
    {

    }

    actions
    {
        addfirst(Processing)
        {
            action("Create Role Center")
            {
                trigger OnAction()
                var
                    CreatePMAndDCORoleCenter: Codeunit 50095;
                begin
                    CreatePMAndDCORoleCenter.Run(); //skal fjernes efter kørt i PROD.
                end;
            }
        }

    }

}