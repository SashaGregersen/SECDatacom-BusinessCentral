report 50000 "Update Purc. Disc. Item Group"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
           MaxIteration = 1; 
           DataItemTableView = sorting("No.");
           trigger OnAfterGetRecord();
           var
               AdvPriceMgt : Codeunit "Advanced Price Management";
           begin
                if NewDiscpercentage = 0 then
                    Error('You need to specify the discount percentage');
                if ItemDiscGroup.Code = '' then
                    Error('You need to specify the Item Discount Group');
                AdvPriceMgt.UpdatePurchaseDicountsForItemDiscGroup(ItemDiscGroup.Code,NewDiscpercentage,Vendor."No.");
           end;

           trigger OnPostDataItem();
           begin
               Message('Discounts updated for vendor %1 and Item Disc. Group %2',Vendor."No.",ItemDiscGroup.Code);
           end;
        }
    }
    
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                    field("item Disc. Group";ItemDiscGroup.Code)
                    {
                        trigger OnLookup(Text : Text) : Boolean;
                        var
                            myInt : Integer;
                        begin
                            if Page.RunModal(page::"Item Disc. Groups",ItemDiscGroup) <> "Action"::LookupOK then
                                Clear(ItemDiscGroup);
                        end;
                    }
                    field("New Disc Percentage";NewDiscpercentage)
                    {

                    }
                }
            }
        }
    
        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                }
            }
        }
    }
    
    var
        ItemDiscGroup : Record "Item Discount Group";
        NewDiscpercentage : Decimal;
}