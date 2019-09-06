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
            action(TempHacks)
            {
                ApplicationArea = all;
                Image = ApplyTemplate;
                Caption = 'Update Item Ledger Entries';

                trigger OnAction()
                var
                    TempHacks: Codeunit "Temp hacks"; //fjernes
                begin
                    TempHacks.RunHack();
                end;
            }
            action(TempHacks2)
            {
                ApplicationArea = all;
                Image = ApplyTemplate;
                Caption = 'Update Warehouse Entries';

                trigger OnAction()
                var
                    UpdateWareEntry: report "Update Warehouse Entries";
                begin
                    UpdateWareEntry.Run();
                end;
            }

            action(ResetSetupTableAfterRestore)
            {
                ApplicationArea = all;
                Image = Restore;
                Caption = 'Reset Setup Table After Company Restore';

                trigger OnAction()
                var
                    UpdateCompanyInfo: report "Update TST & DEV after restor";
                begin
                    UpdateCompanyInfo.Run();
                end;
            }
            action(FixLineAmountLCY)
            {
                ApplicationArea = all;
                Image = Restore;
                Caption = 'Fix Line Amount LCY problem';

                trigger OnAction()
                var
                    FixLineAmountProblem: report "Fix Problem Line Amount LCY";
                begin
                    FixLineAmountProblem.Run();
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