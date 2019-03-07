page 50008 "VAR"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "VAR";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("VAR id"; "VAR id")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; "Customer No.")
                {
                    ApplicationArea = All;
                    Visible = ShowCustomer;
                }
                field("Vendor No."; "Vendor No.")
                {
                    ApplicationArea = All;
                    Visible = ShowVendor;
                }
            }
        }
    }
    var
        ShowCustomer: Boolean;
        ShowVendor: Boolean;

    trigger OnOpenPage()
    begin
        ShowCustomer := GetFilter("Customer No.") = '';
        ShowVendor := GetFilter("Vendor No.") = '';
    end;
}