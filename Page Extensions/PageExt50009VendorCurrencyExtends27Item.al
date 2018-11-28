pageextension 50009 "Vendor Currency" extends "item card"
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
    }

    actions
    {

    }

    var

    trigger OnAfterGetCurrRecord()
    var
        Vendor: Record Vendor;
    begin
        vendor.SetRange("No.", rec."Vendor No.");
        IF vendor.FindFirst() Then begin
            Rec.Validate("Vendor Currency", Vendor."Currency Code");
            Rec."Vendor Currency" := Vendor."Currency Code";
            Rec.modify;
        end;
    end;
}