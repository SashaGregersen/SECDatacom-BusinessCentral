pageextension 50054 "Import Item List" extends "Item List"
{
    actions
    {
        addafter("Item Reclassification Journal")
        {
            action(ImportItems)
            {
                Caption = 'Import Items';
                Image = Import;
                ApplicationArea = All;
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