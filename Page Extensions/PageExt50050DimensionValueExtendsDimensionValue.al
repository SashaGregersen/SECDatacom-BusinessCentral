pageextension 50050 "Dimension Value" extends "Dimension Values"
{
    layout
    {
        addafter(Blocked)
        {
            field("Exclude from Price file"; "Exclude from Price file")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

}