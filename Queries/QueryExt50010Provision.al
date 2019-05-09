query 50010 Provision
{
    QueryType = Normal;

    elements
    {
        dataitem(G_L_Entry; "G/L Entry")
        {
            column(G_L_Account_No_; "G/L Account No.") { }
            column(Posting_Date; "Posting Date") { }
            column(Document_No_; "Document No.") { }
            column(Amount; Amount) { }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }
            column(Journal_Batch_Name; "Journal Batch Name") { }

        }
    }

    trigger OnBeforeOpen()
    begin
        SetFilter(Journal_Batch_Name, '=PROVISIONS');
        SetFilter(G_L_Account_No_, '<7995');

    end;
}