pageextension 50005 "Price Wrksh. Adv. Pricing" extends "Sales Price Worksheet"
{
    layout
    {
        addafter("Item No.")
        {
            field("Vendor Item No"; "Vendor Item No.") //Til indlæsning af sales price worksheet ud fra Vendor Item No.
            {
                ApplicationArea = all;
                trigger OnValidate()
                var
                    Item: Record Item;
                begin
                    if "Vendor Item No." <> '' then begin
                        Item.SetRange("Vendor Item No.", rec."Vendor Item No.");
                        if Item.FindFirst() then
                            rec.Validate("Item No.", item."No.");
                    end;

                end;
            }
        }
    }
    actions
    {
        addafter("I&mplement Price Change")
        {
            action("Update prices from Discounts")
            {
                Image = ItemGroup;
                trigger OnAction();
                var
                    AdvpricingMgt: Codeunit "Advanced Price Management";
                begin
                    //AdvpricingMgt.CreateListprices(Rec);
                    AdvpricingMgt.UpdatePricesfromWorksheet();
                end;
            }
        }
    }

}