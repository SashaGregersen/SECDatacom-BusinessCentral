pageextension 50030 "End Customer and Reseller 10" extends 134
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
    }

    actions
    {
        addlast(Processing)
        {
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
        SalesCrMemo: report 50015;
}