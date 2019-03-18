pageextension 50021 "End Customer and Reseller" extends 42
{
    layout
    {
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
            field("End Customer Name"; EndCustName)
            {
                ApplicationArea = all;
            }
        }
        addafter("reseller")
        {
            field("Reseller name"; Resellername)
            {
                ApplicationArea = all;
            }
            field(Subsidiary; Subsidiary)
            {
                ApplicationArea = all;
                Caption = 'Subsidiary No.';
            }
        }
        addafter(Subsidiary)
        {
            field("Subsidiary Name"; SubsidiaryName)
            {
                ApplicationArea = all;
            }
            field("Financing Partner"; "Financing Partner")
            {
                ApplicationArea = all;
                Caption = 'Financing Partner No.';
            }
        }
        addafter("Financing Partner")
        {
            field("Financing Partner Name"; FinanceName)
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
    }
    var
        SalesOrder: report 50005;
        EdiDocument: Boolean;
        EndCustName: text[50];
        ResellerName: text[50];
        SubsidiaryName: text[50];
        FinanceName: text[50];

    trigger OnAfterGetCurrRecord();
    var
        EdiProfile: Record "EDI Profile";
    begin
        EdiProfile.SetRange(Type, EdiProfile.Type::Customer);
        EdiProfile.SetRange("No.", "Sell-to Customer No.");
        EdiDocument := EdiProfile.FindFirst();
    end;

    trigger OnModifyRecord(): Boolean
    var
        Customer: Record customer;
    begin
        if "End Customer" <> '' then begin
            Customer.get("End Customer");
            EndCustName := Customer.Name;
            Rec.Modify(true);
        end;
        if "Reseller" <> '' then begin
            Customer.get("Reseller");
            Resellername := Customer.Name;
            Rec.Modify(true);
        end;
        if "Subsidiary" <> '' then begin
            Customer.get("Subsidiary");
            SubsidiaryName := Customer.Name;
            Rec.Modify(true);
        end;
        if "Financing Partner" <> '' then begin
            Customer.get("Financing Partner");
            FinanceName := Customer.Name;
            Rec.Modify(true);
        end;
    end;
}