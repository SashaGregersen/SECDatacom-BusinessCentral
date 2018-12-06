pageextension 50008 "Purchase Disc. Adv. Pricing" extends "Purchase Line Discounts"
{
    layout
    {
        addafter("Line Discount %")
        {
            field("Customer Markup"; "Customer Markup")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addfirst(Processing)
        {
            group(Update)
            {
                action(UpdateDiscunts)
                {
                    Caption = 'Update Discounts';
                    Image = UpdateUnitCost;
                    ApplicationArea = All;
                    trigger OnAction();
                    var
                        VendorFilter: Text;
                        Vendor: record Vendor;
                    begin
                        VendorFilter := rec.GetFilter("Vendor No.");
                        if VendorFilter = '' then
                            Error('This Function only works if there is a Filter on Vendor');
                        Vendor.SetFilter("No.", VendorFilter);
                        Report.RunModal(Report::"Update Purc. Disc. Item Group", true, false, Vendor);
                        CurrPage.Update;
                    end;
                }

            }
        }
    }
}