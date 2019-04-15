table 50005 "VAR"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "VAR id"; Code[20])
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
        key(Pk; "Customer No.", "Vendor No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        VarRec: Record "VAR";
    begin
        VarRec.SetRange("Vendor No.", "Vendor No.");
        VarRec.SetRange("VAR id", "VAR id");
        if VarRec.FindFirst() then Error('Combination of vendor %1 and var id %2 already exists', "Vendor No.", "VAR id");
    end;

    trigger OnModify()
    var
        VarRec: Record "VAR";
    begin
        VarRec.SetRange("Vendor No.", "Vendor No.");
        VarRec.SetRange("VAR id", "VAR id");
        VarRec.SetFilter("Customer No.", '<>%1', "Customer No.");
        if VarRec.FindFirst() then Error('Combination of vendor %1 and var id %2 already exists', "Vendor No.", "VAR id");
    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;
}