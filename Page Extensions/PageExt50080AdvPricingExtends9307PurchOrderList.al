pageextension 50080 "Adv. Pricing" extends "Purchase Order List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter(RemoveFromJobQueue)
        {
            action(MAHATESTPOST)
            {
                ApplicationArea = All;
                Caption = 'Martins Test Posting';

                trigger OnAction()
                begin
                    Codeunit.Run(50021, Rec); //fjernes
                end;
            }
        }

    }
}