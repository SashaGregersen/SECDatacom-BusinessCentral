pageextension 50076 "Get Posted Doc Lines" extends "Get Post.Doc - S.InvLn Subform"
{
    layout
    {
        addafter("No.")
        {
            field("Vendor Item No."; "Vendor Item No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

}