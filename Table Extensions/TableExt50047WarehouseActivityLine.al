tableextension 50047 "Warehouse Activity Line Ext" extends "Warehouse Activity Line"
{
    fields
    {
        field(50000; "Vendor Item No"; Text[60])
        {
            FieldClass = FlowField;
            CalcFormula = lookup (item."Vendor-Item-No." where ("No." = Field ("Item No.")));
            Editable = false;
        }
        field(50001; "GTIN"; Code[14])
        {
            FieldClass = FlowField;
            CalcFormula = lookup (item."GTIN" where ("No." = Field ("Item No.")));
            Editable = false;
        }
    }
}