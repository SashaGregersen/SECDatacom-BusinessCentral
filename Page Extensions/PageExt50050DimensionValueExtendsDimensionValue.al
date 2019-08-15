pageextension 50050 "Dimension Value" extends "Dimension Value List"
{
    layout
    {
        addafter(Blocked)
        {
            field("Exclude from Price file"; "Exclude from Price file")
            {

            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}