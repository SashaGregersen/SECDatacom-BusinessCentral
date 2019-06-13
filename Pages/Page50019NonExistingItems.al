page 50019 "Non-Exisiting Items"
{
    PageType = List;
    UsageCategory = None;
    SourceTable = Item;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater("Non-Existing Items")
            {
                field("Vendor No."; "Vendor No.")
                {
                    ApplicationArea = All;

                }
                field("Vendor-Item-No."; "Vendor-Item-No.")
                {
                    ApplicationArea = All;

                }
            }
        }
    }

}