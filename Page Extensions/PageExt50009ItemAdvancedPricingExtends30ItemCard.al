pageextension 50009 "Item Adv. Pricing" extends "Item Card"
{
    layout
    {
        addafter("Vendor Item No.")
        {
            field("Vendor Currency"; "Vendor Currency")
            {
                ApplicationArea = All;
            }
        }

        addafter("Profit %")
        {
            field("Transfer Price %"; "Transfer Price %")
            {
                ApplicationArea = All;
            }
        }
        addafter("Automatic Ext. Texts")
        {
            field("Use on Website"; "Use on Website")
            {
                ApplicationArea = all;
            }
        }


    }

    actions
    {

    }

    var

    trigger OnAfterGetCurrRecord()
    var
        Vendor: Record Vendor;
    begin
        if Vendor.get(rec."Vendor No.") then begin
            Rec.Validate("Vendor Currency", Vendor."Currency Code");
            Rec."Vendor Currency" := Vendor."Currency Code";
            Rec.modify;
        end;
    end;

}