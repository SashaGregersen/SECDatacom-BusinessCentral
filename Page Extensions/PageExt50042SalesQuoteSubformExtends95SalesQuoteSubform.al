pageextension 50042 "Sales Quote Subform" extends "Sales Quote Subform"
{
    layout
    {
        addafter("Unit Price")
        {
            field("Unit List Price"; "Unit List Price")
            {
                ApplicationArea = all;
            }
        }

    }

    actions
    {

    }

}