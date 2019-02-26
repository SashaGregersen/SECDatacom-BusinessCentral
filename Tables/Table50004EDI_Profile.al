table 50004 "EDI Profile"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Customer,Vendor;
            OptionCaption = 'Debitor,Kreditor';
        }
        field(2; "No."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = if (Type = const (Customer)) Customer
            else
            if ("Type" = const (Vendor)) Vendor;
        }
        field(3; "EDI Object"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = AllObjWithCaption."Object ID" where ("Object Type" = const (Codeunit));
        }
        field(4; DocumentType; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(5; DocumentNo; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; EDIAction; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = OrderConfirmation,Shipment,Invoice;
        }
    }

    keys
    {
        key(PK; "Type", "No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;
}