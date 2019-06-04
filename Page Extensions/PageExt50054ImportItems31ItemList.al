pageextension 50054 "Import Item List" extends "Item List"
{
    layout
    {
        modify("Vendor Item No.")
        {
            Visible = false;
        }

        addafter("Vendor Item No.")
        {
            field("Vendor-Item-No."; "Vendor-Item-No.")
            {
                ApplicationArea = all;
            }
        }

    }

    actions
    {
        addafter("Item Reclassification Journal")
        {
            action(ImportItems)
            {
                Caption = 'Import Items';
                Image = Import;
                ApplicationArea = All;
                Promoted = true;

                trigger OnAction()
                var
                    FileMgtImport: Codeunit "File Management Import";
                begin
                    FileMgtImport.ImportItems();
                end;
            }
        }

    }

}
