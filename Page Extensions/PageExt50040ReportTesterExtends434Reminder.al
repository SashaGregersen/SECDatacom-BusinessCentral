pageextension 50040 "report tester" extends 434
{
    actions
    {
        addlast(Processing)
        {
            action(ShowMyReport)
            {
                Image = ItemGroup;
                trigger OnAction();
                begin
                    Reminder.Run();
                end;
            }

        }
    }
    var
        Reminder: report 50008;
}