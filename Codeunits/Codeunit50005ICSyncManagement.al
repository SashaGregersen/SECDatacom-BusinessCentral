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
        if SalesPriceWorkSheet."Currency Code" = '' then begin
            LocalGLSetup.Get();
            ForeignGLSetup.ChangeCompany(CompanyToCopyTo);
            ForeignGLSetup.Get();
            if LocalGLSetup."LCY Code" <> ForeignGLSetup."LCY Code" then
                SalesPriceWorkSheet."Currency Code" := LocalGLSetup."LCY Code";
        end;
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

    procedure SyncPurchasePricesToOtherCompanies()
    //Add the specific sales prices form parent company as specific purchase prices in the child company

    var
        myInt: Integer;
    begin

    end;

    procedure UpdatePricesInOtherCompanies(SalesPriceWorkSheet: Record "Sales Price Worksheet")

    var
        CompanyTemp: Record Company temporary;
        SessionID: Integer;

    begin
        GetCompaniesToSyncTo(CompanyTemp);
        if CompanyTemp.Count() = 0 then
            exit;
        if CompanyTemp.FindSet() then
            repeat
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

    local procedure CheckSessionForTimeoutAndError(SessionID: Integer; SessionTimerSeconds: Integer; RunningInCompany: Text)
    var
        OK: Boolean;
        SessionEventComment: Text;
    begin
        if SessionTimedOut(SessionID, SessionTimerSeconds, SessionEventComment) then
            StopSession(SessionID, StrSubstNo('Session timed out in company %', RunningInCompany));
        if SessionEventComment <> '' then
            Error('Session in company %1 ended with an error: %2', RunningInCompany, SessionEventComment);
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

    local procedure SessionTimedOut(SessionID: Integer; SessionTimerSeconds: Integer; SessionEventComment: Text): Boolean
    var
        Timedout: Boolean;
        SessionEnded: Boolean;
        TimeOutStart: DateTime;
        SessionEvent: Record "Session Event";
    begin
        SessionEnded := FALSE;
        Timedout := false;
        TimeOutStart := CurrentDateTime();
        WHILE NOT Timedout AND NOT SessionEnded DO BEGIN
            COMMIT;
            SelectLatestVersion();
            SLEEP(1000);
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