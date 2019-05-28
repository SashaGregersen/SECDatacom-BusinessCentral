report 50024 "PreReminders"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PreReminder.rdl';
    Caption = 'PreReminder';
    PreviewMode = PrintLayout;

    dataset
    {
        Dataitem("General Ledger Setup"; "General Ledger Setup")
        {
            column(LCY_Code; "LCY Code") { }
        }
        dataitem(Customer; Customer)
        {
            Column(No_; "No.") { }
            column(Name; Name) { }
            column(Contact; Contact) { }
            column(Address; Address) { }
            column(Address_2; "Address 2") { }
            column(Post_Code; "Post Code") { }
            column(City; City) { }
            column(County; County) { }



            dataitem("Customer Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = field ("No.");
                DataItemTableView = SORTING ("Customer No.", Open, Positive, "Due Date", "Currency Code") where (Open = const (true));
                RequestFilterFields = "Customer No.", "Due Date", "Document Type";
                column(Document_No_; "Document No.") { }
                column(External_Document_No_; "External Document No.") { }
                column(Document_Date; "Document Date") { }
                column(Due_Date; "Due Date") { }
                column(Original_Amount; "Original Amount") { }
                column(Currency_Code; "Currency Code") { }
                column(Remaining_Amount; "Remaining Amount") { }
                column(Document_No_Cap; FieldCaption("Document No.")) { }
                column(ExternalDocumentCap; FieldCaption("External Document No.")) { }
                column(Document_Date_Cap; FieldCaption("Document Date")) { }
                column(Due_Date_Cap; FieldCaption("Due Date")) { }
                column(Original_Amount_Cap; FieldCaption("Original Amount")) { }
                column(Currency_Code_Cap; FieldCaption("Currency Code")) { }
                column(Remaining_Amount_Cap; FieldCaption("Remaining Amount")) { }
            }
        }
    }
}