pageextension 50008 "Purchase Disc. Adv. Pricing" extends "Purchase Line Discounts"
{
    layout
    {
        // Add changes to page layout here
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
                    Vendor : record Vendor;
                begin
                    Vendor.SetFilter("No.",rec.GetFilter("Vendor No."));
                    Report.RunModal(Report::"Update Purc. Disc. Item Group",true,false,Vendor);
                    CurrPage.Update;
                end;
                }
                 
            }
       }
    }
}