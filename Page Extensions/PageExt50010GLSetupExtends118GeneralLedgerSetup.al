pageextension 50010 "GLSetup" extends "General Ledger Setup"
{
    layout
    {
        addafter("Payroll Transaction Import")
        {
            group("Integration Setup")
            {
                field("Master Company"; "Master Company")
                {

                }
            }
        }
    }

    actions
    {
        /*
        addafter("Change Payment &Tolerance")
        {
            action(MartinsHack)
            {
                Caption = 'Martin Hack - Only for test!';
                Image = ChangeCustomer;
                ApplicationArea = All;
                trigger OnAction()
                var
                    TempHacks: Codeunit 50058;
                begin
                    TempHacks.Run();
                end;
            }
        }
        */
    }
}