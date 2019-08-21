table 50012 "Consignor Label Information"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Sales Order No."; code[20])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Number of Labels"; integer)
        {
            DataClassification = CustomerContent;
        }
        field(4; "Weight"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Length"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if (Length <> 0) and (Width <> 0) and (Height <> 0) then
                    rec.validate(Volume, (Length * width * height));
            end;
        }
        field(6; "Width"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if (Length <> 0) and (Width <> 0) and (Height <> 0) then
                    rec.validate(Volume, (Length * width * height));
            end;
        }
        field(7; "Height"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if (Length <> 0) and (Width <> 0) and (Height <> 0) then
                    rec.validate(Volume, (Length * width * height));
            end;
        }
        field(8; "Volume"; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.", "Sales Order No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        ConsigLablInfo: record "Consignor Label Information";
    begin
        if "Entry No." = 0 then begin
            if ConsigLablInfo.FindLast() then
                "Entry No." := ConsigLablInfo."Entry No." + 1
            else
                "Entry No." := 1;

        end;
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