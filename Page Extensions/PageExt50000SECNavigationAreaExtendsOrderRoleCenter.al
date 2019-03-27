pageextension 50000 SECNavigationArea extends "Order Processor Role Center"
{

    actions
    {
        addlast(Sections)
        {
            group("SEC")
            {
                action("Bid List")
                {
                    RunObject = page "Bid List";
                    ApplicationArea = All;
                }
                action("Bid Prices")
                {
                    RunObject = page "Bid Prices";
                    ApplicationArea = All;
                }


            }
        }

        addafter(Action31)
        {
            action("POS Report")
            {
                ApplicationArea = all;
                Image = Excel;
                RunObject = codeunit "POS Report Export";
            }
        }
    }
}