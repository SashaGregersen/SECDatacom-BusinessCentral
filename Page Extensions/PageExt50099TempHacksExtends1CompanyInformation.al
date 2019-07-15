pageextension 50099 "Temp Hacks" extends "Company Information"
{
    //This should not end up in the final solution to the customer
    //This is only for setting or correcting data in the DEV database
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("Jobs Setup")
        {
            action(MAHATempHacks)
            {
                ApplicationArea = all;
                Image = ApplyTemplate;
                Caption = 'Update sales line 233120000089';

                trigger OnAction()
                var
                    TempHacks: Codeunit "Temp hacks"; //fjernes
                begin
                    TempHacks.RunHack();
                end;
            }
            /*  action(MAHATempHacks2)
             {
                 ApplicationArea = all;
                 Image = ApplyTemplate;
                 Caption = 'Update salesline on 213120000019';

                 trigger OnAction()
                 var
                     TempHacks: Codeunit "Temp hacks"; //fjernes
                 begin
                     TempHacks.UpdateSalesLine2();
                 end;
             } */
            /* action("Delete Prices1")
            {
                ApplicationArea = all;
                Image = ApplyTemplate;
                Caption = 'Delete Prices in DK';
                trigger OnAction()
                var
                    TempHacks: Codeunit "Temp Hacks"; //fjernes
                begin
                    TempHacks.DeletePricesDK();
                end;
            }
            action("Delete Prices2")
            {
                ApplicationArea = all;
                Image = ApplyTemplate;
                Caption = 'Delete Prices in SE';
                trigger OnAction()
                var
                    TempHacks: Codeunit "Temp Hacks"; //fjernes
                begin
                    TempHacks.DeletePricesSE();
                end;
            }
            action("Delete Prices3")
            {
                ApplicationArea = all;
                Image = ApplyTemplate;
                Caption = 'Delete Prices in NO';
                trigger OnAction()
                var
                    TempHacks: Codeunit "Temp Hacks"; //fjernes
                begin
                    TempHacks.DeletePricesNO();
                end;
            }
            action("Delete Prices4")
            {
                ApplicationArea = all;
                Image = ApplyTemplate;
                Caption = 'Delete Prices in FI';
                trigger OnAction()
                var
                    TempHacks: Codeunit "Temp Hacks"; //fjernes
                begin
                    TempHacks.DeletePricesFI();
                end;
            } */
        }
    }

    var
        myInt: Integer;
}