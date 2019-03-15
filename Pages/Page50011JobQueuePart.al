page 50011 "Job Queue Part"
{
    PageType = ListPart;
    SourceTable = "Job Queue Entry";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Object Caption to Run"; "Object Caption to Run")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}