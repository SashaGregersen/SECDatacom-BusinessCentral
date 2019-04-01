codeunit 50005 "IC Sync Management"
{
    trigger OnRun()
    begin

    end;

    local procedure CopySPWToOtherCompanies(SalesPriceWorkSheet: Record "Sales Price Worksheet"; CompanyToCopyTo: Text)
    var
        LocalSalesPricWorksheet: Record "Sales Price Worksheet";
        LocalGLSetup: Record "General Ledger Setup";
        ForeignGLSetup: Record "General Ledger Setup";
    begin
        LocalGLSetup.Get();
        ForeignGLSetup.ChangeCompany(CompanyToCopyTo);
        ForeignGLSetup.Get();
        if SalesPriceWorkSheet."Currency Code" = '' then begin
            if LocalGLSetup."LCY Code" <> ForeignGLSetup."LCY Code" then
                SalesPriceWorkSheet."Currency Code" := LocalGLSetup."LCY Code";
        end;
        If SalesPriceWorkSheet."Currency Code" = ForeignGLSetup."LCY Code" then
            SalesPriceWorkSheet."Currency Code" := '';
        LocalSalesPricWorksheet.ChangeCompany(CompanyToCopyTo);
        LocalSalesPricWorksheet := SalesPriceWorkSheet;
        if not LocalSalesPricWorksheet.Insert(false) then
            LocalSalesPricWorksheet.Modify(false);
    end;

    local procedure GetCompaniesToSyncTo(var CompanyTemp: Record Company temporary)
    var
        CompanyRec: Record Company;
        InventorySetup: Record "Inventory Setup";

    begin
        InventorySetup.Get();
        if not InventorySetup."Synchronize Item" then
            exit;
        CompanyRec.SetFilter(Name, '<>%1', CompanyName());
        if CompanyRec.FindSet() then
            repeat
                InventorySetup.ChangeCompany(CompanyRec.Name);
                if InventorySetup.Get() then begin
                    if InventorySetup."Receive Synchronized Items" then begin
                        CompanyTemp := CompanyRec;
                        if not CompanyTemp.Insert(false) then;
                    end;
                end;
            until CompanyRec.Next() = 0;
    end;

    local procedure GetCompaniesToDeleteItem(var CompanyTemp: Record Company temporary)
    var
        CompanyRec: Record Company;
        InventorySetup: Record "Inventory Setup";

    begin
        CompanyRec.SetFilter(Name, '<>%1', CompanyName());
        if CompanyRec.FindSet() then
            repeat
                InventorySetup.ChangeCompany(CompanyRec.Name);
                if InventorySetup.Get() then begin
                    if InventorySetup."Receive Synchronized Items" then begin
                        CompanyTemp := CompanyRec;
                        if not CompanyTemp.Insert(false) then;
                    end;
                end;
            until CompanyRec.Next() = 0;
    end;

    procedure CopyPurchasePricesToOtherCompanies(ItemNo: code[20])
    //Add the specific sales prices from parent company as specific purchase prices in the child company

    var
        ICPartner: Record "IC Partner";
        ICPartnerInOtherCompany: Record "IC Partner";
        SalesPrice: Record "Sales Price";
        PurchasePrice: Record "Purchase Price";
    begin
        ICPartner.SetFilter("Inbox Details", '<>%1', '');
        if ICPartner.FindSet() then
            repeat
                SalesPrice.SetRange("Item No.", ItemNo);
                SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::Customer);
                SalesPrice.SetRange("Sales Code", ICPartner."Customer No.");
                if SalesPrice.FindSet() then
                    repeat
                        ICPartnerInOtherCompany.ChangeCompany(ICPartner."Inbox Details");
                        ICPartnerInOtherCompany.SetRange("Inbox Details", CompanyName());
                        if ICPartnerInOtherCompany.FindFirst() then begin
                            PurchasePrice.ChangeCompany(ICPartner."Inbox Details");
                            PurchasePrice.Init();
                            PurchasePrice."Item No." := SalesPrice."Item No.";
                            PurchasePrice."Vendor No." := ICPartnerInOtherCompany."Vendor No.";
                            PurchasePrice."Unit of Measure Code" := SalesPrice."Unit of Measure Code";
                            if SalesPrice."Currency Code" <> '' then begin
                                if SalesPrice."Currency Code" = ICPartner."Currency Code" then
                                    PurchasePrice."Currency Code" := ''
                                else
                                    PurchasePrice."Currency Code" := SalesPrice."Currency Code";
                            end else
                                PurchasePrice."Currency Code" := ICPartnerInOtherCompany."Currency Code";
                            PurchasePrice."Starting Date" := SalesPrice."Starting Date";
                            PurchasePrice."Ending Date" := SalesPrice."Ending Date";
                            PurchasePrice."Minimum Quantity" := SalesPrice."Minimum Quantity";
                            PurchasePrice."Direct Unit Cost" := SalesPrice."Unit Price";
                            if not PurchasePrice.Insert(false) then
                                PurchasePrice.Modify(false);
                        end;
                    until SalesPrice.Next() = 0;
            until ICPartner.Next() = 0;
    end;

    procedure UpdatePricesInOtherCompanies(SalesPriceWorkSheet: Record "Sales Price Worksheet")

    var
        InventorySetup: Record "Inventory Setup";
        CompanyTemp: Record Company temporary;
        SessionID: Integer;

    begin
        InventorySetup.Get();
        if not InventorySetup."Synchronize Item" then
            exit;
        GetCompaniesToSyncTo(CompanyTemp);
        if CompanyTemp.Count() = 0 then
            exit;
        if CompanyTemp.FindSet() then
            repeat
                //CopyPurchasePricesToOtherCompanies(SalesPriceWorkSheet."Item No.");  //skal den her være der? bør fjernes for ikke at lave noget 2 gange
                CopySPWToOtherCompanies(SalesPriceWorkSheet, CompanyTemp.Name);
                SessionID := RunUpdateListPricesInOtherCompany(CompanyTemp.Name);
                CheckSessionForTimeoutAndError(SessionID, 30, CompanyTemp.Name);
            until CompanyTemp.Next() = 0;
    end;

    procedure InsertModifyItemInOtherCompanies(Item: Record Item)

    var
        CompanyTemp: Record Company temporary;
        SessionID: Integer;
    begin
        GetCompaniesToSyncTo(CompanyTemp);
        if CompanyTemp.Count() = 0 then
            exit;
        if CompanyTemp.FindSet() then
            repeat
                SessionID := RunInsertModifyItemInOtherCompany(item, CompanyTemp.Name);
                CheckSessionForTimeoutAndError(SessionID, 5, CompanyTemp.Name);
            until CompanyTemp.Next() = 0;
    end;

    procedure InsertModifyItemDiscGroupInOtherCompanies(ItemDiscGroup: Record "Item Discount Group")

    var
        CompanyTemp: Record Company temporary;
        SessionID: Integer;
    begin
        GetCompaniesToSyncTo(CompanyTemp);
        if CompanyTemp.Count() = 0 then
            exit;
        if CompanyTemp.FindSet() then
            repeat
                SessionID := RunInsertModifyItemDiscGroupInOtherCompany(ItemDiscGroup, CompanyTemp.Name);
                CheckSessionForTimeoutAndError(SessionID, 5, CompanyTemp.Name);
            until CompanyTemp.Next() = 0;
    end;

    procedure InsertModifyItemSubstituionInOtherCompanies(ItemSub: Record "Item Substitution")

    var
        CompanyTemp: Record Company temporary;
        SessionID: Integer;
    begin
        GetCompaniesToSyncTo(CompanyTemp);
        if CompanyTemp.Count() = 0 then
            exit;
        if CompanyTemp.FindSet() then
            repeat
                SessionID := RunInsertModifyItemSubStituionInOtherCompany(ItemSub, CompanyTemp.Name);
                CheckSessionForTimeoutAndError(SessionID, 5, CompanyTemp.Name);
            until CompanyTemp.Next() = 0;
    end;

    procedure InsertModifyDefaultDimInOtherCompanies(DefaultDim: Record "Default Dimension")

    var
        CompanyTemp: Record Company temporary;
        SessionID: Integer;
    begin
        GetCompaniesToSyncTo(CompanyTemp);
        if CompanyTemp.Count() = 0 then
            exit;
        if CompanyTemp.FindSet() then
            repeat
                SessionID := RunInsertModifyDefaultDimInOtherCompany(DefaultDim, CompanyTemp.Name);
                CheckSessionForTimeoutAndError(SessionID, 5, CompanyTemp.Name);
            until CompanyTemp.Next() = 0;
    end;

    procedure InsertModifyItemTranslationInOtherCompanies(ItemTrans: Record "Item Translation")

    var
        CompanyTemp: Record Company temporary;
        SessionID: Integer;
    begin
        GetCompaniesToSyncTo(CompanyTemp);
        if CompanyTemp.Count() = 0 then
            exit;
        if CompanyTemp.FindSet() then
            repeat
                SessionID := RunInsertModifyItemTransInOtherCompany(ItemTrans, CompanyTemp.Name);
                CheckSessionForTimeoutAndError(SessionID, 5, CompanyTemp.Name);
            until CompanyTemp.Next() = 0;
    end;

    procedure InsertModifyExtendedTextHeaderInOtherCompanies(ExtendedTextHeader: Record "Extended Text Header")

    var
        CompanyTemp: Record Company temporary;
        SessionID: Integer;
    begin
        GetCompaniesToSyncTo(CompanyTemp);
        if CompanyTemp.Count() = 0 then
            exit;
        if CompanyTemp.FindSet() then
            repeat
                SessionID := RunInsertModifyExtendedTextHeaderInOtherCompany(ExtendedTextHeader, CompanyTemp.Name);
                CheckSessionForTimeoutAndError(SessionID, 5, CompanyTemp.Name);
            until CompanyTemp.Next() = 0;
    end;

    procedure InsertModifyExtendedTextLineInOtherCompanies(ExtendedTextLine: Record "Extended Text Line")

    var
        CompanyTemp: Record Company temporary;
        SessionID: Integer;
    begin
        GetCompaniesToSyncTo(CompanyTemp);
        if CompanyTemp.Count() = 0 then
            exit;
        if CompanyTemp.FindSet() then
            repeat
                SessionID := RunInsertModifyExtendedTextLineInOtherCompany(ExtendedTextLine, CompanyTemp.Name);
                CheckSessionForTimeoutAndError(SessionID, 5, CompanyTemp.Name);
            until CompanyTemp.Next() = 0;
    end;

    procedure DeleteItemInOtherCompanies(Item: Record "Item")

    var
        CompanyTemp: Record Company temporary;
        SessionID: Integer;
    begin
        GetCompaniesToDeleteItem(CompanyTemp);
        if CompanyTemp.Count() = 0 then
            exit;
        if CompanyTemp.FindSet() then
            repeat
                SessionID := RunDeleteItemInOtherCompany(Item, CompanyTemp.Name);
                CheckSessionForTimeoutAndError(SessionID, 5, CompanyTemp.Name);
            until CompanyTemp.Next() = 0;
    end;

    procedure PostPurchaseOrderInOtherCompany(PurchaseOrder: Record "Purchase Header"; PostInCompanyName: Text[35])

    var
        SessionID: Integer;
    begin
        if PostInCompanyName = '' then
            exit;
        SessionID := RunPostPurchaseOrderInOtherCompanyy(PurchaseOrder, PostInCompanyName);
        CheckSessionForTimeoutAndError(SessionID, 120, PostInCompanyName);
    end;

    local procedure CheckSessionForTimeoutAndError(SessionID: Integer; SessionTimerSeconds: Integer; RunningInCompany: Text)
    //needs to be refactored so the error message is returned to the calling procedure - then the calling procedure can take corrective measures before making the error
    var
        OK: Boolean;
        SessionEventComment: Text;
    begin
        if SessionTimedOut(SessionID, SessionTimerSeconds, SessionEventComment) then
            StopSession(SessionID, StrSubstNo('Session timed out in company %', RunningInCompany));
        if SessionEventComment <> '' then begin
            if CopyStr(SessionEventComment, 1, 14) <> 'Scheduled task' then
                Error('Session in company %1 ended with an error: %2', RunningInCompany, SessionEventComment);
        end;
    end;

    local procedure RunUpdateListPricesInOtherCompany(RunInCompany: Text) SessionID: Integer
    var
        OK: Boolean;
        SessionEventComment: Text;
    begin
        OK := StartSession(SessionID, 50006, RunInCompany);
        if not OK then
            Error(GetLastErrorText());
        Commit();
    end;

    local procedure RunInsertModifyItemInOtherCompany(Item: record item; RunInCompany: Text) SessionID: Integer
    var
        OK: Boolean;
        SessionEventComment: Text;
    begin
        OK := StartSession(SessionID, 50007, RunInCompany, Item);
        if not OK then
            Error(GetLastErrorText());
        Commit();
    end;

    local procedure RunInsertModifyItemDiscGroupInOtherCompany(ItemDiscGroup: record "Item Discount Group"; RunInCompany: Text) SessionID: Integer
    var
        OK: Boolean;
        SessionEventComment: Text;
    begin
        OK := StartSession(SessionID, 50008, RunInCompany, ItemDiscGroup);
        if not OK then
            Error(GetLastErrorText());
        Commit();
    end;

    local procedure RunInsertModifyItemSubStituionInOtherCompany(ItemSub: record "Item Substitution"; RunInCompany: Text) SessionID: Integer
    var
        OK: Boolean;
        SessionEventComment: Text;
    begin
        OK := StartSession(SessionID, 50014, RunInCompany, ItemSub);
        if not OK then
            Error(GetLastErrorText());
        Commit();
    end;

    local procedure RunInsertModifyDefaultDimInOtherCompany(DefaultDim: record "Default Dimension"; RunInCompany: Text) SessionID: Integer
    var
        OK: Boolean;
        SessionEventComment: Text;
    begin
        OK := StartSession(SessionID, 50015, RunInCompany, DefaultDim);
        if not OK then
            Error(GetLastErrorText());
        Commit();
    end;

    local procedure RunInsertModifyItemTransInOtherCompany(ItemTrans: record "Item Translation"; RunInCompany: Text) SessionID: Integer
    var
        OK: Boolean;
        SessionEventComment: Text;
    begin
        OK := StartSession(SessionID, 50016, RunInCompany, ItemTrans);
        if not OK then
            Error(GetLastErrorText());
        Commit();
    end;

    local procedure RunInsertModifyExtendedTextHeaderInOtherCompany(ExtendedTxtHeader: record "Extended Text Header"; RunInCompany: Text) SessionID: Integer
    var
        OK: Boolean;
        SessionEventComment: Text;
    begin
        OK := StartSession(SessionID, 50017, RunInCompany, ExtendedTxtHeader);
        if not OK then
            Error(GetLastErrorText());
        Commit();
    end;

    local procedure RunInsertModifyExtendedTextLineInOtherCompany(ExtendedTxtLine: record "Extended Text Line"; RunInCompany: Text) SessionID: Integer
    var
        OK: Boolean;
        SessionEventComment: Text;
    begin
        OK := StartSession(SessionID, 50018, RunInCompany, ExtendedTxtLine);
        if not OK then
            Error(GetLastErrorText());
        Commit();
    end;

    local procedure RunDeleteItemInOtherCompany(Item: record "Item"; RunInCompany: Text) SessionID: Integer
    var
        OK: Boolean;
        SessionEventComment: Text;
    begin
        OK := StartSession(SessionID, 50019, RunInCompany, Item);
        if not OK then
            Error(GetLastErrorText());
        Commit();
    end;

    local procedure RunPostPurchaseOrderInOtherCompanyy(Purchaseorder: Record "Purchase Header"; RunInCompany: Text) SessionID: Integer
    var
        OK: Boolean;
        SessionEventComment: Text;
    begin
        OK := StartSession(SessionID, Codeunit::"Post Purchase Order IC", RunInCompany, Purchaseorder);
        if not OK then
            Error(GetLastErrorText());
        Commit();
    end;

    local procedure SessionTimedOut(SessionID: Integer; SessionTimerSeconds: Integer; var SessionEventComment: Text): Boolean
    var
        Timedout: Boolean;
        SessionEnded: Boolean;
        TimeOutStart: DateTime;
        SessionEvent: Record "Session Event";
        SleepCounter: Integer;
    begin
        SessionEnded := FALSE;
        Timedout := false;
        TimeOutStart := CurrentDateTime();
        SleepCounter := 100;
        WHILE NOT Timedout AND NOT SessionEnded DO BEGIN
            COMMIT;
            SelectLatestVersion();
            SLEEP(SleepCounter);
            Timedout := (CurrentDateTime() - TimeOutStart) DIV 1000 > SessionTimerSeconds;

            IF NOT Timedout THEN BEGIN
                SessionEvent.SETCURRENTKEY("Event Datetime");
                SessionEvent.SETRANGE("User SID", USERSECURITYID);
                SessionEvent.SETRANGE("Server Instance ID", SERVICEINSTANCEID);
                SessionEvent.SETRANGE("Session ID", SessionID);
                SessionEvent.SETFILTER("Event Type", '%1|%2|%3', SessionEvent."Event Type"::Close, SessionEvent."Event Type"::Logoff, SessionEvent."Event Type"::Stop);
                SessionEvent.SETRANGE("Client Type", SessionEvent."Client Type"::Background);
                SessionEvent.SETRANGE("User ID", USERID);
                SessionEnded := SessionEvent.FindLast();
            END;
            if SessionEnded then begin
                SessionEventComment := SessionEvent.Comment;
                exit(false);
            end;
            SleepCounter := SleepCounter + SleepCounter;
        end;
        SessionEventComment := StrSubstNo('Session %1 timed out after %2 seconds', SessionID, SessionTimerSeconds);
        exit(true);
    end;

    local procedure GetSessionEventComment(SessionID: Integer): Text
    var
        ErrorFound: Boolean;
        SessionEvent: Record "Session Event";
    begin
        // check session event for errors
        ErrorFound := FALSE;
        SessionEvent.SETCURRENTKEY("Event Datetime");
        SessionEvent.SETRANGE("User SID", USERSECURITYID);
        SessionEvent.SETRANGE("Server Instance ID", SERVICEINSTANCEID);
        SessionEvent.SETRANGE("Session ID", SessionID);
        SessionEvent.SETRANGE("Event Type", SessionEvent."Event Type"::Logoff);
        SessionEvent.SETRANGE("Client Type", SessionEvent."Client Type"::Background);
        SessionEvent.SETRANGE("User ID", USERID);
        IF SessionEvent.FINDLAST then
            exit(SessionEvent.Comment)
        else
            exit('');
    END;

    var
        AdvPriceMgt: Codeunit "Advanced Price Management";
}