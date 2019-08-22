report 50065 "Update TST & DEV after restor"
{
    // CHHO 08-19-2019 - Report to update system indicator and data in the test or development database, to make sure no NAVPROD paths are used

    ProcessingOnly = true;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING (Number) WHERE (Number = CONST (1));

            trigger OnAfterGetRecord()
            begin
                Message('Report Done');
            end;

            trigger OnPreDataItem()
            begin
                if Company.FindFirst then
                    repeat
                        //NAVDEV
                        if UpdateThisDatabase = UpdateThisDatabase::NAVDEV then begin
                            ServerInstance.Get(ServiceInstanceId);
                            if ServerInstance."Service Name" <> 'devbc' then
                                Error('This is not the development database');

                            //UPDATE SYSTEM INDICATOR IN NAVDEV
                            CompanyInformation.ChangeCompany(Company.Name);
                            CompanyInformation.Get;
                            CompanyInformation.Name := CompanyInformation.Name + '- TESTBC -';
                            CompanyInformation."System Indicator" := CompanyInformation."System Indicator"::"Company+Database";
                            CompanyInformation."Custom System Indicator Text" := Company.Name + ' ' + '- DEVBC -' + ' ' + ServerInstance."Server Computer Name";
                            CompanyInformation."System Indicator Style" := CompanyInformation."System Indicator Style"::Accent2;
                            CompanyInformation.Modify;

                            //UPDATE GENERAL LEDGER SETUP
                            GeneralLedgerSetup.ChangeCompany(Company.Name);
                            GeneralLedgerSetup.Get;
                            GeneralLedgerSetup."Allow Posting From" := DMY2Date(1, 1, Date2DMY(Today, 3));
                            GeneralLedgerSetup.Modify;

                            //UPDATE DOCUMENT CAPTURE IN NAVDEV
                            DocumentCaptureSetup.ChangeCompany(Company.Name);
                            if DocumentCaptureSetup.Get then
                                DocumentCaptureSetup.Delete;
                            ConnectionEndpoint.ChangeCompany(Company.Name);
                            ConnectionEndpoint.DeleteAll;

                            //UPDATE DOCUMENT OUTPUT IN NAVDEV
                            EMailTemplate.ChangeCompany(Company.Name);
                            EMailTemplate.ModifyAll("Test Recipient", 'CHHO@NETCOMPANY.COM');

                            //DOCUMENT OUTPUT SMTP SETUP IN NAVDEV
                            DocumentOutputSMTPSetup.ChangeCompany(Company.Name);
                            if DocumentOutputSMTPSetup.Get then
                                DocumentOutputSMTPSetup.DeleteAll;

                            //SMTP MAIL SETUP IN NAVDEV
                            SMTPMailSetup.ChangeCompany(Company.Name);
                            if SMTPMailSetup.Get then
                                SMTPMailSetup.DeleteAll;

                            //PAYMENT MANGEMENT IN NAVDEV
                            /*
                              PaymentSetup.ChangeCompany(Company.Name);
                              if PaymentSetup.Get then
                                  PaymentSetup.DeleteAll;
                              */

                            // CRM INTEGRATION
                            CRMConnectionSetup.ChangeCompany(Company.Name);
                            if CRMConnectionSetup.Get then begin
                                CRMConnectionSetup.Validate("Is Enabled", false);
                                CRMConnectionSetup.Modify;
                                CRMConnectionSetup."Server Address" := 'https://secdatacomsandbox.crm4.dynamics.com';
                                CRMConnectionSetup."User Name" := 'continia_test@secdatacom.dk';
                                CRMConnectionSetup."Dynamics NAV URL" := 'http://nav-app01-test:8082/?&company=SECDenmark&dc=0';
                                CRMConnectionSetup."User Password Key" := '147D5F6D-FB63-472B-B726-FF73126D025C';
                                //CORRECT PASSWORD BELOW;
                                //CRMConnectionSetup."User Password Key" := 'TPMR0j9CaF';
                                CRMConnectionSetup.Modify;
                            end;
                            //IF CRMConnectionSetup.GET THEN
                            //  CRMConnectionSetup.DELETEALL;

                            //UPDATE EXPENSE MANAGEMENT IN NAVDEV
                            ExpenseManagementSetup.ChangeCompany(Company.Name);
                            if ExpenseManagementSetup.Get then
                                ExpenseManagementSetup.Delete;

                            //UPDATE CONTINIA WEB PORTAL IN NAVTEST
                            ContiniaWebPortal.ChangeCompany(Company.Name);
                            if ContiniaWebPortal.Get then begin
                                ContiniaWebPortal."Web Site Url" := 'https://demo.continiaonline.com';
                                ContiniaWebPortal."Local Domain Name" := ''; //'HTTP://XX.XXX.XXX.XXX:7057/DEVBC/WS';
                                ContiniaWebPortal."Windows Web Service URL" := ''; //'http://XX.XXX.XXX.XXX:7057/DEVBC/WS/'; IKKE SEC's IP
                                ContiniaWebPortal.Modify;
                            end;

                            //UPDATE JOB QUEUE ENTRY IN NAVDEV
                            JobQueueEntry.ChangeCompany(Company.Name);
                            if JobQueueEntry.FindSet then
                                repeat
                                    JobQueueEntry.Status := JobQueueEntry.Status::"On Hold";
                                    JobQueueEntry.Modify;
                                until JobQueueEntry.Next = 0;

                            //BANK IN NAVDEV
                            /*
                            Bank.CHANGECOMPANY(Company.Name);
                            IF Bank.FINDSET THEN BEGIN
                              REPEAT
                                Bank.MODIFY;
                              UNTIL Bank.NEXT = 0;
                            END;
                            */

                            BankBookkeepingBranch.ChangeCompany(Company.Name);
                            BankBookkeepingBranch.ModifyAll(BankBookkeepingBranch."Webservice Download", BankBookkeepingBranch."Webservice Download"::"Manual Download");



                            //INVENTORY SETUP IN NAVDEV
                            /*
                            InventorySetup.CHANGECOMPANY(Company.Name);
                            IF InventorySetup.GET THEN BEGIN
                              InventorySetup.
                            END;
                            */

                            //UPDATE SALES SETUP IN NAVDEV
                            SalesSetup.CHANGECOMPANY(Company.Name);
                            if SalesSetup.GET then begin
                                SalesSetup."OIOUBL-Invoice Path" := '';
                                SalesSetup."OIOUBL-Cr. Memo Path" := '';
                                SalesSetup."OIOUBL-Reminder Path" := '';
                                SalesSetup."OIOUBL-Fin. Chrg. Memo Path" := '';
                                SalesSetup."Cygate Customer No." := '';
                                SalesSetup."Cygate Endpoint" := '';
                                SalesSetup."Consignor Path" := '';
                                SalesSetup.MODIFY;

                            End;

                            //UPDATE SALES SETUP IN NAVDEV
                            InventorySetup.ChangeCompany(company.Name);
                            if InventorySetup.Get then begin
                                InventorySetup."Price file location" := '';
                                InventorySetup."Price file location 2" := '';
                            end;
                        end;

                        //NAVTEST
                        if UpdateThisDatabase = UpdateThisDatabase::NAVTEST then begin
                            ServerInstance.Get(ServiceInstanceId);
                            if ServerInstance."Service Name" <> 'testbc' then
                                Error('This is not the test database');

                            //UPDATE SYSTEM INDICATOR IN NAVTEST
                            CompanyInformation.ChangeCompany(Company.Name);
                            CompanyInformation.Get;
                            CompanyInformation.Name := CompanyInformation.Name + '- TESTBC -';
                            CompanyInformation."System Indicator" := CompanyInformation."System Indicator"::"Company+Database";
                            CompanyInformation."Custom System Indicator Text" := Company.Name + ' ' + '- TESTBC -' + ' ' + ServerInstance."Server Computer Name";
                            CompanyInformation."System Indicator Style" := CompanyInformation."System Indicator Style"::Accent3;
                            CompanyInformation.Modify;

                            //UPDATE GENERAL LEDGER SETUP IN NAVTEST
                            GeneralLedgerSetup.ChangeCompany(Company.Name);
                            GeneralLedgerSetup.Get;
                            GeneralLedgerSetup."Allow Posting From" := DMY2Date(1, 1, Date2DMY(Today, 3));
                            GeneralLedgerSetup.Modify;

                            //UPDATE EXPENSE MANAGEMENT IN NAVTEST
                            ExpenseManagementSetup.ChangeCompany(Company.Name);
                            if ExpenseManagementSetup.Get then
                                ExpenseManagementSetup.Delete;

                            //UPDATE JOB QUEUE ENTRY IN NAVTEST
                            JobQueueEntry.ChangeCompany(Company.Name);
                            if JobQueueEntry.FindSet then
                                repeat
                                    JobQueueEntry.Status := JobQueueEntry.Status::"On Hold";
                                    JobQueueEntry.Modify;
                                until JobQueueEntry.Next = 0;

                            //UPDATE DOCUMENT CAPTURE IN NAVTEST
                            DocumentCaptureSetup.ChangeCompany(Company.Name);
                            DocumentCaptureSetup.DeleteAll;
                            ConnectionEndpoint.ChangeCompany(Company.Name);
                            ConnectionEndpoint.DeleteAll;

                            //UPDATE DOCUMENT OUTPUT IN NAVTEST
                            EMailTemplate.ChangeCompany(Company.Name);
                            EMailTemplate.ModifyAll("Test Recipient", 'CHHO@NETCOMPANY.COM');

                            //DOCUMENT OUTPUT SMTP SETUP IN NAVTEST
                            DocumentOutputSMTPSetup.ChangeCompany(Company.Name);
                            if DocumentOutputSMTPSetup.Get then
                                DocumentOutputSMTPSetup.DeleteAll;

                            //PAYMENT MANGEMENT IN NAVDEV
                            /*
                             PaymentSetup.ChangeCompany(Company.Name);
                             if PaymentSetup.Get then
                                 PaymentSetup.DeleteAll;
                             */
                            // CRM INTEGRATION
                            CRMConnectionSetup.ChangeCompany(Company.Name);
                            if CRMConnectionSetup.Get then begin
                                CRMConnectionSetup.Validate("Is Enabled", false);
                                CRMConnectionSetup.Modify;
                                CRMConnectionSetup."Server Address" := 'https://secdatacomsandbox.crm4.dynamics.com';
                                CRMConnectionSetup."User Name" := 'continia_test@secdatacom.dk';
                                CRMConnectionSetup."Dynamics NAV URL" := 'http://nav-app01-test:8082/?&company=SECDenmark&dc=0';
                                CRMConnectionSetup."User Password Key" := '147D5F6D-FB63-472B-B726-FF73126D025C';
                                //CORRECT PASSWORD BELOW;
                                //CRMConnectionSetup."User Password Key" := 'TPMR0j9CaF';
                                CRMConnectionSetup.Modify;
                            end;
                            //IF CRMConnectionSetup.GET THEN
                            //  CRMConnectionSetup.DELETEALL;

                            //UPDATE DOCUMENT CATEGORY IN NAVTEST
                            /*
                            DCDocumentCategory.CHANGECOMPANY(Company.Name);
                            IF DCDocumentCategory.FINDSET THEN REPEAT
                              DCDocumentCategory.VALIDATE("E-Mail Connection Endpoint");
                            UNTIL DCDocumentCategory.NEXT = 0;
                            */
                            ConnectionEndpoint.ChangeCompany(Company.Name);
                            ConnectionEndpoint.DeleteAll;

                            //UPDATE CONTINIA CLIENT CREDENTIALS IN NAVTEST
                            ContiniaClientCredentials.ChangeCompany(Company.Name);
                            if ContiniaClientCredentials.Get then begin
                                ContiniaClientCredentials."Client ID" := 'DEMO-5333993';
                                ContiniaClientCredentials."Client Password" := 'dl3SsLKLSkeQwCucV6s2Qw';
                                ContiniaClientCredentials.Modify;
                            end;

                            //UPDATE CONTINIA SETUP IN NAVTEST
                            ContiniaCompanySetup.ChangeCompany(Company.Name);
                            if ContiniaCompanySetup.Get then begin
                                ContiniaCompanySetup."Client ID" := 'DEMO-5333993';
                                ContiniaCompanySetup.Modify;
                            end;

                            //UPDATE CONTINIA WEB PORTAL IN NAVTEST
                            ContiniaWebPortal.ChangeCompany(Company.Name);
                            if ContiniaWebPortal.Get then begin
                                ContiniaWebPortal."Web Site Url" := 'https://demo.continiaonline.com';
                                ContiniaWebPortal."Local Domain Name" := ''; //'HTTP://XX.XXX.XXX.XXX:7057/TESTBC/WS';
                                ContiniaWebPortal."Windows Web Service URL" := ''; //'http://XX.XXX.XXX.XXX:7057/TESTBC/WS/'; IKKE SEC's IP
                                ContiniaWebPortal.Modify;
                            end;

                            //BANK IN NAVTEST
                            Bank.ChangeCompany(Company.Name);
                            if Bank.FindSet then begin
                                repeat
                                    Bank."In Use" := false;
                                    Bank.Modify;
                                until Bank.Next = 0;
                            end;

                            BankBookkeepingBranch.ChangeCompany(Company.Name);
                            BankBookkeepingBranch.ModifyAll(BankBookkeepingBranch."Webservice Download", BankBookkeepingBranch."Webservice Download"::"Manual Download");



                            //UPDATE SALES SETUP IN NAVTEST
                            //UPDATE MANUALLY IN BUSINESS CENTRAL SINCE FIELDS ARE OBSOLETE AND MOVED TO EXTENSION.
                            SalesSetup.CHANGECOMPANY(Company.Name);
                            if SalesSetup.GET then begin
                                SalesSetup."OIOUBL-Invoice Path" := '';
                                SalesSetup."OIOUBL-Cr. Memo Path" := '';
                                SalesSetup."OIOUBL-Reminder Path" := '';
                                SalesSetup."OIOUBL-Fin. Chrg. Memo Path" := '';
                                SalesSetup."Cygate Customer No." := '';
                                SalesSetup."Cygate Endpoint" := '';
                                SalesSetup."Consignor Path" := '';
                                SalesSetup.MODIFY;

                            End;

                            //UPDATE SALES SETUP IN NAVTEST
                            //UPDATE MANUALLY IN BUSINESS CENTRAL SINCE FIELDS ARE OBSOLETE AND MOVED TO EXTENSION.
                            InventorySetup.ChangeCompany(company.Name);
                            if InventorySetup.Get then begin
                                InventorySetup."Price file location" := '';
                                InventorySetup."Price file location 2" := '';
                            end;
                        end;
                    until Company.Next = 0;

            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(UpdateThisDatabase; UpdateThisDatabase)
                    {
                        Caption = 'Choose database to be updated';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if UpdateThisDatabase = UpdateThisDatabase::" " then
            Error('No database was selected');
    end;

    var
        Company: Record Company;
        CompanyInformation: Record "Company Information";
        DocumentCaptureSetup: Record "Document Capture Setup";
        UpdateThisDatabase: Option " ",NAVDEV,NAVTEST;
        ServerInstance: Record "Server Instance";
        SalesSetup: Record "Sales & Receivables Setup";
        ConnectionEndpoint: Record "Connection Endpoint";
        DCDocumentCategory: Record "DC Document Category";
        GeneralLedgerSetup: Record "General Ledger Setup";
        ExpenseManagementSetup: Record "Expense Management Setup";
        JobQueueEntry: Record "Job Queue Entry";
        ContiniaCompanySetup: Record "Continia Company Setup";
        ContiniaWebPortal: Record "Continia Web Portal";
        ContiniaClientCredentials: Record "Continia Client Credentials";
        EMailTemplate: Record "E-Mail Template";
        PaymentSetup: Record "Payment Setup";
        CRMConnectionSetup: Record "CRM Connection Setup";
        SMTPMailSetup: Record "SMTP Mail Setup";
        DocumentOutputSMTPSetup: Record "Document Output SMTP Setup";
        Bank: Record Bank;
        InventorySetup: Record "Inventory Setup";
        BankBookkeepingBranch: Record "Bank Bookkeeping Branch";
}

