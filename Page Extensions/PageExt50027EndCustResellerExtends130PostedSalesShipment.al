pageextension 50027 "End Customer and Reseller 7" extends 130
{
    layout
    {
        addafter("No.")
        {
            field("End Customer"; "End Customer")
            {
                ApplicationArea = all;
            }
        }
        addbefore("End Customer")
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
                    SalesShipment.Run();
                end;
            }

        }
    }

    var
        myInt: Integer;
        SalesShipment: report 50009;
}