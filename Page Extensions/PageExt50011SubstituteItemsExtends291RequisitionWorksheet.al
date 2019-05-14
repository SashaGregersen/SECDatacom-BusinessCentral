pageextension 50011 "Substitute Items" extends "Req. Worksheet"
{
    layout
    {
        addafter("Action Message")
        {
            field("Substitute Item Exist"; "Substitute Item Exists")
            {
                ApplicationArea = all;
            }
        }
        addafter("Vendor Item No.")
        {
            field("Vendor-Item-No"; "Vendor-Item-No")
            {
                ApplicationArea = all;
            }
        }
        modify("Vendor Item No.")
        {
            Visible = false;
        }
    }

    actions
    {
        addafter(Reserve)
        {
            action("Select Substitute Items")
            {
                trigger OnAction()
                var
                    ItemSub: Codeunit "Item Substitution";
                begin
                    CurrPage.GetRecord(Rec);
                    ItemSub.FindItemSubstituions(Rec);
                end;

            }
        }
    }

}