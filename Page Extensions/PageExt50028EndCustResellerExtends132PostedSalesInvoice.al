pageextension 50028 "End Customer and Reseller 8" extends 132
{
    //note - temp suspended the action - until reports are ok
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