pageextension 50015 "Locations Cards" extends "Location Card"
{
    layout
    {
        addafter("Use As In-Transit")
        {
            field("Calculate Available Stock"; "Calculate Available Stock")
            {
                ApplicationArea = all;
            }
        }
    }


}