pageextension 50036 "Purch. Header Adv. pricing" extends "Purchase Order"
{
    layout
    {
        addafter("Ship-to Contact")
        {
            field("End Customer"; "End Customer")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addafter("End Customer")
        {
            field(Reseller; Reseller)
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }

    actions
    {
        addafter("Create Inventor&y Put-away/Pick")
        {
            action("Import Serial Numbers")
            {
                Image = ImportExcel;
                trigger OnAction()
                var
                    ImportSerialNumbersPurchase: Codeunit "Import Serial Number Purchase";
                begin
                    ImportSerialNumbersPurchase.ImportSerialNumbers(Rec);
                end;
            }
        }
    }

}