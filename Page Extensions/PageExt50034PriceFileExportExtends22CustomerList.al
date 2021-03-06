pageextension 50034 "Price File Export" extends "Customer List"
{
    layout
    {
        addafter(Name)
        {
            field(Address; Address)
            {

            }

            field("Address 2"; "Address 2")
            {

            }
            field(City; City)
            {

            }
        }
    }

    actions
    {
        addafter(Sales_Prices)
        {
            action("Export Customer Price File")
            {
                Promoted = true;
                PromotedCategory = New;
                Image = Export;
                trigger OnAction();
                begin
                    Report.Run(50025, true, false, item);
                end;
            }
        }

    }


    var
        item: record item;
}