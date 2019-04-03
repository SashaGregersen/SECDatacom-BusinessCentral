pageextension 50099 "Advanced Pricing SO" extends "Sales Order List"
{

    //temp page ext for debugging
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter(Reopen)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Codeunit.Run(50022, Rec);
                end;
            }
        }
    }

    var
        myInt: Integer;
}