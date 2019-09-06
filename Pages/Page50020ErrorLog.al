page 50020 "Error Log"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Error Log";

    layout
    {
        area(Content)
        {
            repeater("Error Logs")
            {
                field("Source Table"; "Source Table")
                {
                    ApplicationArea = all;
                }
                field("Source No."; "Source No.")
                {
                    ApplicationArea = All;
                }
                field("Source Document Type"; "Source Document Type")
                {
                    ApplicationArea = all;
                }
                field("Source Ref. No."; "Source Ref. No.")
                {
                    ApplicationArea = all;
                }
                field("IC Source No."; "IC Source No.")
                {
                    ApplicationArea = all;
                }
                field("Error Text"; "Error Text")
                {
                    ApplicationArea = All;
                }
            }
        }

    }
    trigger OnClosePage()
    var

    begin
        if Rec.Delete() then;
    end;

}