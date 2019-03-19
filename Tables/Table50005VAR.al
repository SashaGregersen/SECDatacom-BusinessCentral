table 50005 "VAR"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "VAR id"; Integer)
        {
            Caption = 'VAR id';
            DataClassification = ToBeClassified;
        }
        field(2; "Customer No."; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(3; "Vendor No."; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
    }

    keys
    {
        key(PK; "VAR id")
        {
            Clustered = true;
        }
        key(Key1; "Customer No.", "Vendor No.")
        {
        }
    }

    trigger OnInsert()
    var
        VarRec: Record "VAR";
    begin
        VarRec.SetCurrentKey("Customer No.", "Vendor No.");
        VarRec.SetRange("Customer No.", "Customer No.");
        VarRec.SetRange("Vendor No.", "Vendor No.");
        if VarRec.FindFirst() then Error('Combination of customer %1 and vendor %2 already exists', "Customer No.", "Vendor No.");
    end;

    trigger OnModify()
    var
        VarRec: Record "VAR";
    begin
        VarRec.SetCurrentKey("Customer No.", "Vendor No.");
        VarRec.SetRange("Customer No.", "Customer No.");
        VarRec.SetRange("Vendor No.", "Vendor No.");
        VarRec.SetFilter("VAR id", '<>%1', "VAR id");
        if VarRec.FindFirst() then Error('Combination of customer %1 and vendor %2 already exists', "Customer No.", "Vendor No.");
    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;
}