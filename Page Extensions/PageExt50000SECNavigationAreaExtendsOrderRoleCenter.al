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
                 
            }
        }
    }
}