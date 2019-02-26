pageextension 50013 "Locations" extends "Location List"
{
    layout
    {
        addafter(Name)
        {
            field("Calculate Available Stock"; "Calculate Available Stock")
            {
                Editable = true;
                ApplicationArea = all;
            }
        }
    }

    actions
    {

    }


}