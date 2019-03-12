pageextension 50055 "PM Role Center" extends "PM Role Center"
{
    layout
    {
    }
    actions
    {
        addafter("Aged Accounts Payable")
        {
            action("Vendor Payment Information")
            {
                Image = Report;
                ApplicationArea = All;

                trigger onAction()
                var
                    VendorPaymentInformation: Report 6016818;
                begin
                    VendorPaymentInformation.Run();
                end;
            }
        }
    }

}