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

        addafter("Line Discount %")
        {
            field("Reseller Discount"; "Reseller Discount")
            {
                ApplicationArea = all;
            }
        }

    }

    actions
    {

    }

}