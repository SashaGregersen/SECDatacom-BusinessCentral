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

            field("Cygate Endpoint"; "Cygate Endpoint")
            {
                ApplicationArea = all;
            }

            field("Project Item Template"; "Stock Item Template")
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
        }
    }

    actions
    {

    }

    var

}