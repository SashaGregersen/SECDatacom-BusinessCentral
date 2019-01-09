pageextension 50053 "Insert RecordID in Job Queue" extends 672
{
    layout
    {

    }

    actions
    {
        addafter(ShowRecord)
        {
            action("Insert RecordID")
            {
                RunObject = codeunit 50097;
                Promoted = true;
                Image = AddAction;

            }
        }
    }

    var
        myInt: Integer;
}