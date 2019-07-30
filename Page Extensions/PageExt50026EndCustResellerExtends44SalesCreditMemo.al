pageextension 50026 "End Customer and Reseller 6" extends 44
{
    layout
    {
        addbefore("Sell-to Customer No.")
        {
            field(Reseller; Reseller)
            {
                ApplicationArea = all;
            }
            field("End Customer"; "End Customer")
            {
                ApplicationArea = all;
            }
        }
        addafter("End Customer")
        {
            field("End Customer Name"; "End Customer Name")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("End Customer Contact"; "End Customer Contact")
            {
                ApplicationArea = all;
                Importance = Additional;
            }
            field("End Customer Contact Name"; "End Customer Contact Name")
            {
                ApplicationArea = all;
                Importance = Additional;
            }
            field("End Customer Phone No."; "End Customer Phone No.")
            {
                ApplicationArea = all;
                Importance = Additional;
            }
            field("End Customer Email"; "End Customer Email")
            {
                ApplicationArea = all;
                Importance = Additional;
            }
        }
        addafter("reseller")
        {
            field("Reseller Name"; "Reseller Name")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field(Subsidiary; Subsidiary)
            {
                ApplicationArea = all;
                Caption = 'Subsidiary No.';
            }
        }
        addafter(Subsidiary)
        {
            field("Subsidiary Name"; "Subsidiary Name")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Financing Partner"; "Financing Partner")
            {
                ApplicationArea = all;
                Caption = 'Financing Partner No.';
            }
        }
        addafter("Financing Partner")
        {
            field("Financing Partner Name"; "Financing Partner Name")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addbefore("Salesperson Code")
        {
            field("Suppress Prices on Printouts"; "Suppress Prices on Printouts")
            {
                ApplicationArea = all;
            }
        }
        addafter("External Document No.")
        {
            field("Drop-Shipment"; "Drop-Shipment")
            {
                ApplicationArea = all;
                Caption = 'Deliver directly to end customer';
            }

            field("Ship directly from supplier"; "Ship directly from supplier")
            {
                ApplicationArea = all;
            }
        }
        modify("Sell-to Customer No.")
        {
            Visible = false;
        }
        modify("Sell-to Customer Name")
        {
            Visible = false;
        }
        addafter("Sell-to Customer No.")
        {
            field("Sell-to-Customer-Name"; "Sell-to-Customer-Name")
            {
                ApplicationArea = all;
                Caption = 'Sell-to Customer Name';
            }
        }


    }

    actions
    {
        addbefore(CalculateInvoiceDiscount)
        {
            action("Add Provision")
            {
                image = AdjustEntries;

                trigger OnAction()
                var
                    GnlJnlProvision: page "General Journal Provisions";
                    GnlJnlLine: record "Gen. Journal Line";
                    SRSetup: Record "Sales & Receivables Setup";
                begin
                    SRSetup.get;
                    GnlJnlLine.Reset();
                    GnlJnlLine.FilterGroup(2);
                    GnlJnlLine.SetRange("Journal Template Name", SRSetup."Provision Journal Template");
                    GnlJnlLine.SetRange("Journal Batch Name", SRSetup."Provision Journal Batch");
                    GnlJnlLine.SetRange("Account Type", GnlJnlLine."Account Type"::"G/L Account");
                    GnlJnlLine.Setrange("Account No.", SRSetup."Provision Gl Account");
                    GnlJnlLine.SetRange("Bal. Account Type", GnlJnlLine."Bal. Account Type"::"G/L Account");
                    GnlJnlLine.Setrange("Bal. Account No.", SRSetup."Provision Balance Account No.");
                    GnlJnlLine.Setrange("Posting Date", rec."Posting Date");
                    GnlJnlLine.SetRange("Document No.", Rec."No.");
                    GnlJnlLine.FilterGroup(0);
                    page.RunModal(Page::"General Journal Provisions", GnlJnlLine);
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
                    SalesOrderHandler.AddTransactionTypeToSalesDocument(Rec);
                end;
            }
            action("Import Serial Numbers")
            {
                Image = ImportExcel;

                trigger OnAction()
                var
                    ImportSerialNumberSales: Codeunit "Import Serial Number Sales";
                begin
                    ImportSerialNumberSales.ImportSerialNumbers(Rec);
                end;
            }

        }

    }

}