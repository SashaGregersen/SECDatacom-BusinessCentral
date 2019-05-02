tableextension 50046 "Design Payment Method" extends "Payment Method"
{
    fields
    {
        field(50000; "Invoice Text"; Blob)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Print FIK"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
    procedure GetPaymentMethodExtDescription() PaymentMethodExtDescription: Text;
    var
        TempBlob: Record TempBlob temporary;
    begin
        PaymentMethodExtDescription := '';
        CalcFields("Invoice Text");
        if not "Invoice Text".HasValue then exit;

        TempBlob.Blob := PaymentMethod."Invoice Text";
        PaymentMethodExtDescription := TempBlob.ReadAsTextWithCRLFLineSeparator();
    end;
}