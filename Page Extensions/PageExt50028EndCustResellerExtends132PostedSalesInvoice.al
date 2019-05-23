pageextension 50028 "End Customer and Reseller 8" extends 132
{
    //note - temp suspended the action - until reports are ok
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
            action(ShowMyReport)
            {
                Image = ItemGroup;
                trigger OnAction();
                begin
                    SalesInvoice.Run();
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
            action("Export Cygate XML")
            {
                Caption = 'Export Cygate XML';
                Image = CreateXMLFile;
                ApplicationArea = All;
                trigger OnAction()
                var
                    Cyg: Codeunit EDICygate;
                begin
                    Cyg.SendInvoiceNotice(rec);
                end;

            }

        }
    }

    var
        SalesInvoice: report 50006;
}