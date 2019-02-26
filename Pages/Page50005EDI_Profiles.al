page 50005 "EDI Profiles"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "EDI Profile";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Type; Type)
                {
                    ApplicationArea = All;
                }
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("EDI Object"; "EDI Object")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}