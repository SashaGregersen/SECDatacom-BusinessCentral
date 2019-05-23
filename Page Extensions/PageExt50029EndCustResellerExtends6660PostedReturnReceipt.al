pageextension 50029 "End Customer and Reseller 9" extends 6660
{
    layout
    {
        addbefore("No.")
        {
            field("End Customer"; "End Customer")
            {
                ApplicationArea = all;
            }
        }
        addbefore("End Customer")
        {
            field(Reseller; Reseller)
            {
                ApplicationArea = all;
            }
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

}