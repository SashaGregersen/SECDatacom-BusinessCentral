pageextension 50033 "Update Sales Prices" extends "Sales Prices" //Lavet for at teste function
{
    actions
    {
        addafter(CopyPrices)
        {
            action("Update prices")
            {
                Image = ItemGroup;
                trigger OnAction();
                var
                    UpdatePriceWithCurr: Report "Update Prices with Currencies";
                begin
                    UpdatePriceWithCurr.run;
                end;
            }
        }
    }

}