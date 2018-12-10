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


    }

    actions
    {

    }

    var

    trigger OnAfterGetCurrRecord()
    var
        Vendor: Record Vendor;
    begin
        Vendor.SetRange("No.", rec."Vendor No.");
        IF Vendor.FindFirst() Then begin
            Rec.Validate("Vendor Currency", Vendor."Currency Code");
            Rec."Vendor Currency" := Vendor."Currency Code";
            Rec.modify;
        end;
    end;

}