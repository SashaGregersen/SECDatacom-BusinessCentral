page 50009 "BNP Reporting Currency"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "BNP Reporting Currency";

    layout
    {
        area(Content)
        {
            repeater(group)
            {
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;

                }
                field("BNP Agreement No."; "BNP Agreement No.")
                {
                    ApplicationArea = All;

                }
            }
        }
    }

}