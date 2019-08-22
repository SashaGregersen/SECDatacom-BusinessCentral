page 50079 "Consignor Label Information"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Consignor Label Information";

    layout
    {
        area(Content)
        {
            repeater(Labels)
            {
                field("Sales Order No."; "Sales Order No.")
                {
                    ApplicationArea = All;
                }
                field("Number of Labels"; "Number of Labels")
                {
                    ApplicationArea = All;
                }
                field("Goods Type"; "Goods Type")
                {
                    ApplicationArea = all;
                }
                field(Weight; Weight)
                {
                    ApplicationArea = All;
                }
                field(Length; Length)
                {
                    ApplicationArea = All;
                }
                field(Height; Height)
                {
                    ApplicationArea = All;
                }
                field(Width; Width)
                {
                    ApplicationArea = All;
                }
                field(Volume; Volume)
                {
                    ApplicationArea = All;
                }
            }
        }
    }


}