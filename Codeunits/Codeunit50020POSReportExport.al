codeunit 50020 "POS Report Export"
{
    trigger OnRun()
    begin
        // Specify that TempFile is opened as a binary file.  
        TempFile.TEXTMODE(FALSE);
        // Specify that you can write to TempFile.  
        TempFile.WRITEMODE(TRUE);
        Name := CreateFileLocationPath();
        // Create and open TempFile.  
        TempFile.CREATE(Name);
        // Close TempFile so that the SAVEASEXCEL function can write to it.  
        TempFile.CLOSE;

        REPORT.SAVEASEXCEL(50011, Name);

        TempFile.OPEN(Name);
        TempFile.CREATEINSTREAM(NewStream);
        ToFile := 'POSReport.xls';

        // Transfer the content from the temporary file on Microsoft Dynamics NAV  
        // Server to a file on the client.  
        ReturnValue := DOWNLOADFROMSTREAM(
          NewStream,
          'Save file to client',
          '',
          'Excel File *.xls| *.xls',
          ToFile);

        // Close the temporary file.  
        TempFile.CLOSE();
    end;

    local procedure CreateFileLocationPath() Filelocation: Text
    var
        CurrDateTime: text;
        PurchPaySetup: record "Purchases & Payables Setup";
        ExportFormat: report "Price File Export";
    begin
        PurchPaySetup.Get();
        /* PurchPaySetup.TestField("POS file location");
        ExportFormat.FormatCurrentDateTime(CurrDateTime);
        Filelocation := PurchPaySetup."POS file location" + '\POSReport_' + CurrDateTime + '.xls'; */
    end;

    var
        TempFile: file;
        Name: text[250];
        NewStream: InStream;
        ToFile: text;
        ReturnValue: Boolean;
        POSReport: Report "POS Reporting";

}