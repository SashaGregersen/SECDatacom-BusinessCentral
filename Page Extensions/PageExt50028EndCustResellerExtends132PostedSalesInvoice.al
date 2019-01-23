pageextension 50028 "End Customer and Reseller 8" extends 132
{
    //note - temp suspended the action - until reports are ok
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
<<<<<<< HEAD
                    //SalesInvoice.Run();
=======
                    // SalesInvoice.Run();
>>>>>>> 2747a87defa59540cf8a24184f21fc8227922a86
                end;
            }

        }
    }

    var
    //SalesInvoice: report "Invoice PM w/FI-Card";
}