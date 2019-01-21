pageextension 50028 "End Customer and Reseller 8" extends 132
{
    layout
    {
        addbefore("No.")
        {
            field("End Customer"; "End Customer")
            {
                ApplicationArea = all;
            }
        }
        addafter("End Customer")
        {
            field(Reseller; Reseller)
            {
                ApplicationArea = all;
            }
        }

    }

    actions
    {
        addlast(Processing)
        {
            action(ShowMyReport)
            {
                Image = ItemGroup;
                trigger OnAction();
                begin
                    SalesInvoice.Run();
                end;
            }

        }
    }

    var
        SalesInvoice: report "Invoice PM w/FI-Card";
}