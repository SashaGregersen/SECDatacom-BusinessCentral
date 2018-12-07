pageextension 50004 "Synchronize items" extends "Inventory Setup"
{
    layout
    {
        addafter("Prevent Negative Inventory")
        {
            field("Synchronize Item"; "Synchronize Item")
            {

            }
        }
        addafter("Synchronize Item")
        {
            field("Receive Synchronized Items"; "Receive Synchronized Items")
            {

            }
        }
    }

    actions
    {
        addafter("Item Discount Groups")
        {
            action(CreateVariant)
            {
                Caption = 'Create Variants';
                Image = ItemVariant;
                trigger OnAction();
                begin
                    Report.RunModal(50099, true, false);
                end;

            }
        }
    }

    var

}