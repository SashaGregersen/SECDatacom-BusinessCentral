pageextension 50099 "Temp Hacks" extends "Company Information"
{
    //This should not end up in the final solution to the customer
    //This is only for setting or correcting data in the DEV database
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("Jobs Setup")
        {
            action(MAHATempHacks)
            {
                ApplicationArea = all;
                Image = ApplyTemplate;
                Caption = 'Run MAHA Temp Hacks';

                trigger OnAction()
                var
                    TempHacks: Codeunit "Temp Hacks";
                begin
                    TempHacks.Run();
                end;
            }
        }
    }

    var
        myInt: Integer;
}