pageextension 50004 "Synchronize items" extends "Inventory Setup"
{
    layout
    {
        addafter("Prevent Negative Inventory")
        {
            field("Synchronize Item"; "Synchronize Item")
            {
                ApplicationArea = all;
            }
        }
        addafter("Synchronize Item")
        {
            field("Receive Synchronized Items"; "Receive Synchronized Items")
            {
                ApplicationArea = all;
            }
        }

        addafter("Default Costing Method")
        {
            field("Price file location"; "Customer Price file location")
            {
                ApplicationArea = all;
            }
            field("Price file location 2"; "Webshop Price file location")
            {
                ApplicationArea = all;
            }
            field("Price file location 3"; "Customer Price file temp loc.")
            {
                ApplicationArea = all;
            }
            field("Price file location 4"; "Webshop file temp location")
            {
                ApplicationArea = all;
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