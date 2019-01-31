codeunit 50005 "Sync Prices IC"
{
    //OnRun is meant to be run in the child company - other functions meant to be run in the parent company to prepare data for the OnRun in Child company

    trigger OnRun()
    begin
        AdvPriceMgt.UpdatePricesfromWorksheet();
    end;

    procedure CopySPWToOtherCompanies(SalesPriceWorkSheet: Record "Sales Price Worksheet"; var CompanyTemp: Record Company temporary)
    var
        LocalSalesPricWorksheet: Record "Sales Price Worksheet";
    begin
        If CompanyTemp.FindSet() then
            repeat
                LocalSalesPricWorksheet.ChangeCompany(CompanyTemp.Name);
                LocalSalesPricWorksheet := SalesPriceWorkSheet;
                if not LocalSalesPricWorksheet.Insert(false) then
                    LocalSalesPricWorksheet.Modify(false);
            until CompanyTemp.Next() = 0;
    end;

    procedure GetCompaniesToSyncTo(var CompanyTemp: Record Company temporary)
    var
        CompanyRec: Record Company;
        InventorySetup: Record "Inventory Setup";

    begin
        CompanyRec.SetFilter(Name, '<>%1', CompanyName());
        if CompanyRec.FindSet() then
            repeat
                InventorySetup.ChangeCompany(CompanyRec.Name);
                if InventorySetup."Receive Synchronized Items" then begin
                    CompanyTemp := CompanyRec;
                    if not CompanyTemp.Insert(false) then;
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
    begin
        GetCompaniesToSyncTo(CompanyTemp);
        if CompanyTemp.Count() = 0 then
            exit;
        CopySPWToOtherCompanies(SalesPriceWorkSheet, CompanyTemp);
        StartSessionInOtherCompany(50005, CompanyTemp);
    end;

    local procedure StartSessionInOtherCompany(CodeunitNo: Integer; var CompanyTemp: Record Company temporary)
    //Does not support record varaible in startsession yet- codeunit that is started must know on which records to run
    var
        OK: Boolean;
        SessionID: Integer;
        SessionEventComment: Text;
    begin
        if CompanyTemp.FindSet() then
            repeat
                OK := StartSession(SessionID, CodeunitNo, CompanyTemp.Name);
                if not OK then
                    Error(GetLastErrorText());
                Commit();
                if SessionTimedOut(SessionID, 30) then
                    StopSession(SessionID, StrSubstNo('Session timed out in company %', CompanyTemp.Name));
                SessionEventComment := GetSessionEventComment(SessionID);
                if SessionEventComment <> '' then
                    Error('Session in company %1 ended with an error: %2', CompanyTemp.Name, SessionEventComment);
            until CompanyTemp.Next() = 0;
    end;

    local procedure SessionTimedOut(SessionID: Integer; SessionTimerSeconds: Integer): Boolean
    var
        Timedout: Boolean;
        SessionEnded: Boolean;
        TimeStart: DateTime;
        TimeOutStart: DateTime;
        SessionEvent: Record "Session Event";
    begin
        SessionEnded := FALSE;
        Timedout := false;
        TimeStart := CurrentDateTime();
        TimeOutStart := CurrentDateTime();
        WHILE NOT Timedout AND NOT SessionEnded DO BEGIN
            COMMIT;
            SelectLatestVersion();
            SLEEP(1000);
            Timedout := (CurrentDateTime() - TimeOutStart) DIV 1000 > SessionTimerSeconds;

            IF NOT Timedout THEN BEGIN
                SessionEvent.SETCURRENTKEY("Event Datetime");
                SessionEvent.SETFILTER("Event Datetime", '>=%1', TimeStart);
                SessionEvent.SETRANGE("User SID", USERSECURITYID);
                SessionEvent.SETRANGE("Server Instance ID", SERVICEINSTANCEID);
                SessionEvent.SETRANGE("Session ID", SessionID);
                SessionEvent.SETFILTER("Event Type", '%1|%2|%3', SessionEvent."Event Type"::Close, SessionEvent."Event Type"::Logoff, SessionEvent."Event Type"::Stop);
                SessionEvent.SETRANGE("Client Type", SessionEvent."Client Type"::Background);
                SessionEvent.SETRANGE("User ID", USERID);
                SessionEnded := SessionEvent.FINDFIRST;
            END;
            if SessionEnded then
                exit(false);
        end;
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