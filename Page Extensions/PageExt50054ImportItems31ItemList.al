pageextension 50054 "Import Item List" extends "Item List"
{
    layout
    {

        /* addafter("Vendor Item No.") // removed due to Microsoft mulitipath search error
        {
            field("Vendor-Item-No."; "Vendor-Item-No.")
            {
                ApplicationArea = all;
                Caption = 'Vendor Item No.';
            }
        }
        modify("Vendor Item No.")
        {
            Visible = false;
        } */

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
