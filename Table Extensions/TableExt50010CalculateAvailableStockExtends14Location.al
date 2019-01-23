tableextension 50010 "Calculate Available Stock" extends Location
{
    fields
    {
        field(50000; "Calculate Available Stock"; boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(50001; "Default"; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var

            begin
                Rec.SetRange(Default, true);
                if rec.FindFirst() then
                    error('You can only select one default location');
            end;
        }
    }

}