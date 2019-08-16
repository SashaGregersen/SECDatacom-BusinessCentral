pageextension 50027 "End Customer and Reseller 7" extends 130
{
    layout
    {
        addafter("No.")
        {
            field("End Customer Name"; "End Customer Name")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("End Customer"; "End Customer")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addafter("Sell-to Customer Name")
        {
            field(Reseller; Reseller)
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        modify("Sell-to Customer Name")
        {
            Caption = 'Reseller Name';
        }
        addafter("Ship-to Country/Region Code")
        {
            field("Ship-to Comment"; "Ship-to Comment")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addafter("External Document No.")
        {
            field("End Customer Reference"; "End Customer Reference")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }


    }

    actions
    {
        addlast(Processing)
        {
            action(ShowMyReport)
            {
                Image = ItemGroup;
                trigger OnAction();
                begin
                    SalesShipment.Run();
                end;
            }
            action(AddTransActionType)
            {
                Caption = 'Add Transaction Type';
                Image = ChangeDimensions;
                ApplicationArea = all;

                trigger OnAction()
                var
                    SalesOrderHandler: Codeunit "Sales Order Event Handler";
                begin
                    SalesOrderHandler.AddTransactionTypeToPostedSalesDocument(Rec);
                end;
            }

        }
    }

    var
        SalesShipment: report 50009;
}