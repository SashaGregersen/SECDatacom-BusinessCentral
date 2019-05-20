pageextension 50021 "End Customer and Reseller" extends 42
{
    layout
    {
        addafter("Shipping Advice")
        {
            field("SEC Shipping Advice"; xShippingAdvice)
            {
                ApplicationArea = all;
            }
        }
        modify("Shipping Advice")
        {
            Visible = false;
        }
        addbefore("Sell-to Customer No.")
        {
            field("End Customer"; "End Customer")
            {
                ApplicationArea = all;
                Caption = 'End Customer No.';
            }
        }
        addbefore("End Customer")
        {
            field(Reseller; Reseller)
            {
                ApplicationArea = all;
                Caption = 'Reseller No.';
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
        addafter("Ship directly from supplier")
        {
            field("Suppress Prices on Printouts"; "Suppress Prices on Printouts")
            {
                ApplicationArea = all;

            }
        }
        modify(ShippingOptions)
        {
            Visible = false;
        }
        modify(Control4)
        {
            Visible = true;
        }
        addbefore("Ship-to Code")
        {
            field("Ship-To-Code"; "Ship-To-Code")
            {
                ApplicationArea = all;
                Caption = 'Ship-to Code';
            }
        }
        addafter("Ship-to Contact")
        {
            field("Ship-to Phone No."; "Ship-to Phone No.")
            {
                ApplicationArea = all;
                Caption = 'Phone No.';
            }
            field("Ship-to Email"; "Ship-to Email")
            {
                ApplicationArea = all;
                Caption = 'E-mail';
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
            field("Purchase Currency Method"; "Purchase Currency Method")
            {
                ApplicationArea = all;
                Importance = Promoted;
                Editable = Subsidiary <> '';
            }
            field("Purchase Currency Code"; "Purchase Currency Code")
            {
                ApplicationArea = all;
                Importance = Promoted;
                Editable = ("Purchase Currency Method" = "Purchase Currency Method"::"Same Currency") and (Subsidiary <> '');
            }
        }

    }

    actions
    {
        addafter("Create Inventor&y Put-away/Pick")
        {
            action(SECCreateInvtPutAwayPick)
            {
                Caption = 'Create Inventor&y Put-away/Pick';
                Promoted = true;
                PromotedCategory = Process;
                Image = CreateInventoryPickup;
                AccessByPermission = TableData "Posted Invt. Pick Header" = R;
                Ellipsis = true;
                ToolTip = 'Create an inventory put-away or inventory pick to handle items on the document according to a basic warehouse configuration that does not require warehouse receipt or shipment documents.';

                trigger OnAction()
                var
                    SalesOrderAction: Codeunit "Sales Order Event Handler";
                begin
                    SalesOrderAction.SECCheckShippingAdvice(Rec);
                    CreateInvtPutAwayPick();
                end;
            }
        }
        modify("Create Inventor&y Put-away/Pick")
        {
            Visible = false;
        }
        addafter("Create Purchase Document")
        {
            action("Import Project Sale")
            {
                Image = ImportExcel;

                trigger OnAction()
                var
                    ProjectSalesImport: Codeunit "File Management Import";
                begin
                    ProjectSalesImport.ImportSalesOrderFromCSV(Rec);
                    CurrPage.Update();
                end;
            }
            action("Import Project Sales Lines")
            {
                Image = ImportExcel;

                trigger OnAction()
                var
                    ProjectSalesImport: Codeunit "File Management Import";
                begin
                    ProjectSalesImport.ImportSalesLinesFromCSV(Rec);
                    CurrPage.Update();
                end;
            }
            action("Create Purchase Order")
            {
                Image = NewDocument;

                trigger OnAction()
                var
                    CreatePurchOrder: Codeunit "Create Purchase Order";
                    PurchHeader: record "Purchase Header";
                begin
                    CreatePurchOrder.CreatePurchOrderFromSalesOrder(Rec);
                end;
            }
        }

        modify("Create Purchase Document")
        {
            Visible = false;
        }

        addlast(Processing)
        {
            action(ShowMyReport)
            {
                Image = ItemGroup;
                trigger OnAction();
                begin
                    SalesOrder.Run();
                end;
            }
        }
        addbefore(SendEmailConfirmation)
        {
            action(SendOrderConfirmation)
            {
                Image = SendConfirmation;
                Caption = 'Send ordrebekræftelse';
                Visible = EdiDocument;
                trigger OnAction();
                var
                    EdiProfile: Record "EDI Profile";
                begin
                    EdiProfile.SetRange(Type, EdiProfile.Type::Customer);
                    EdiProfile.SetRange("No.", "Sell-to Customer No.");
                    if not EdiProfile.FindFirst then exit;
                    EdiProfile.EDIAction := EdiProfile.EDIAction::OrderConfirmation;
                    EdiProfile.DocumentType := "Document Type";
                    EdiProfile.DocumentNo := "No.";
                    Codeunit.Run(EdiProfile."EDI Object", EdiProfile);
                end;
            }
        }

        addafter("Create &Warehouse Shipment")
        {
            action("Import Serial No.")
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

        addafter("Create Purchase Order")
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
                    GnlJnlLine.Setrange("Account No.", SRSetup."Provision GL Account");
                    GnlJnlLine.SetRange("Bal. Account Type", GnlJnlLine."Bal. Account Type"::"G/L Account");
                    GnlJnlLine.Setrange("Bal. Account No.", SRSetup."Provision Balance Account No.");
                    GnlJnlLine.Setrange("Posting Date", rec."Posting Date");
                    GnlJnlLine.SetRange("Document No.", Rec."No.");
                    GnlJnlLine.FilterGroup(0);
                    page.RunModal(Page::"General Journal Provisions", GnlJnlLine);
                end;
            }
        }
    }
    var
        SalesOrder: report 50013;
        EdiDocument: Boolean;

    trigger OnAfterGetCurrRecord();
    var
        EdiProfile: Record "EDI Profile";
        Customer: Record customer;
    begin
        EdiProfile.SetRange(Type, EdiProfile.Type::Customer);
        EdiProfile.SetRange("No.", "Sell-to Customer No.");
        EdiDocument := EdiProfile.FindFirst();
    end;

}