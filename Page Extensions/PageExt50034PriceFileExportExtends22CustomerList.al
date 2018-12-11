pageextension 50034 "Price File Export" extends "Customer List"
{
    layout
    {

    }

    actions
    {
        addafter(Sales_Prices)
        {
            action(ExportPriceFile)
            {
                Promoted = true;
                PromotedCategory = New;
                Image = Export;
                trigger OnAction();
                begin
                    Report.Run(50003, true, false, item);
                end;
            }
        }

    }


    var
        item: record item;
}