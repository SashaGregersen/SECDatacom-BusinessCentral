pageextension 50035 "Synchronize Customer" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Create Item from Description")
        {
            field("Synchronize Customer"; "Synchronize Customer")
            {
                ApplicationArea = all;
            }

        }
        addafter("Direct Debit Mandate Nos.")
        {
            field("Bid Bo. Series"; "Bid No. Series")
            {
                ApplicationArea = all;
            }
        }

        addafter("Freight G/L Acc. No.")
        {
            field("Freight Item"; "Freight Item")
            {
                ApplicationArea = all;
                TableRelation = Item;
            }

            field("Consignor Path"; "Consignor Path")
            {
                ApplicationArea = all;
            }

            field("Cygate Customer No."; "Cygate Customer No.")
            {
                ApplicationArea = all;
            }

            field("Cygate Endpoint"; "Cygate Endpoint")
            {
                ApplicationArea = all;
            }

            field("Transaction Type"; "Transaction Type")
            {
                ApplicationArea = all;
            }

            field("Project Item Template"; "Project Item Template")
            {
                ApplicationArea = all;
            }

            field("License Item Template"; "License Item Template")
            {
                ApplicationArea = all;
            }

            field("Service Item Template"; "Service Item Template")
            {
                ApplicationArea = all;
            }
            field("Provision Journal Template"; "Provision Journal Template")
            {
                ApplicationArea = all;
            }
            field("Provision Journal Batch"; "Provision Journal Batch")
            {
                ApplicationArea = all;
            }
            field("Provision Account No."; "Provision Gl Account")
            {
                ApplicationArea = all;
                Caption = 'Provision Account No.';
            }
            field("Provision Balance Account No."; "Provision Balance Account No.")
            {
                ApplicationArea = all;
                Caption = 'Provision Balance Account No.';
            }
        }
    }

    actions
    {
        addafter("Customer Disc. Groups")
        {
            action("BNP Reporting Currencies")
            {
                trigger OnAction()
                var
                    BNPReporting: Page "BNP Reporting Currency";
                begin
                    BNPReporting.run;
                end;
            }
        }

    }

    var

}