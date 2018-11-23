pageextension 50005 "Price Wrksh. Adv. Pricing" extends "Sales Price Worksheet"
{
    actions
    {
        addafter("I&mplement Price Change")
        {
            action("Update prices from Discounts")
            {
                Image = ItemGroup;
                trigger OnAction();
                var 
                    AdvpricingMgt : Codeunit "Advanced Price Management";
                begin
                    AdvpricingMgt.CreateListprices(Rec);
                end;
            }
        }    
    }
    
}