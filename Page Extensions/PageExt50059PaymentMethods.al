pageextension 50059 DesignPaymentMethod extends "Payment Methods"
{
    layout
    {
        addafter("Use for Invoicing")
        {
            field("Invoice Text"; "Invoice Text")
            {
                ApplicationArea = all;
                trigger OnAssistEdit()
                var
                    TempBlob: Record TempBlob temporary;
                    TempBlobEdit: Page TempBlobEdit;
                begin
                    CalcFields("Invoice Text");
                    TempBlob.Init;
                    TempBlob.Blob := "Invoice Text";
                    TempBlob.Insert();
                    if RunModal(Page::TempBlobEdit, TempBlob) = Action::LookupOK then begin
                        "Invoice Text" := TempBlob.Blob;
                        Modify();
                    end;
                end;
            }
            field("Print FIK"; "Print FIK")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter("T&ranslation")
        {
            action(AdvancedPaymentMethod)
            {
                Caption = 'Advanved Payment Method Setup';
                RunObject = page "Advanced Payment Method Setup";
                Promoted = true;
            }
        }
    }
}