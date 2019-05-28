report 50024 "PreReminders"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PreReminder.rdl';
    Caption = 'PreReminder';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Customer Ledger Entry"; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING ("Customer No.", Open, Positive, "Due Date", "Currency Code") where (Open = const (true));
            RequestFilterFields = "Customer No.", "Due Date", "Document Type";
            column(Name; Cust.Name) { }
            column(Contact; Cust.Contact) { }
            column(Address; Cust.Address) { }
            column(Address_2; Cust."Address 2") { }
            column(Post_Code; Cust."Post Code") { }
            column(City; Cust.City) { }
            column(County; Cust.County) { }
            column(Document_No_; "Document No.") { }
            column(Document_Date; "Document Date") { }
            column(Due_Date; "Due Date") { }
            column(Original_Amount; "Original Amount") { }
            column(Currency_Code; "Currency Code") { }
            column(Remaining_Amount; "Remaining Amount") { }
            column(Document_No_Cap; FieldCaption("Document No.")) { }
            column(Document_Date_Cap; FieldCaption("Document Date")) { }
            column(Due_Date_Cap; FieldCaption("Due Date")) { }
            column(Original_Amount_Cap; FieldCaption("Original Amount")) { }
            column(Currency_Code_Cap; FieldCaption("Currency Code")) { }
            column(Remaining_Amount_Cap; FieldCaption("Remaining Amount")) { }

            trigger OnPreDataItem()
            begin
                if FindFirst() then
                    Cust.Get("Customer No.");
            end;
        }
    }
    var
        Cust: Record Customer;
}