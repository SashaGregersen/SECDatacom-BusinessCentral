pageextension 50022 "End Customer and Reseller 2" extends 41
{
    layout
    {
        addbefore("Sell-to Customer No.")
        {
            field("End Customer"; "End Customer")
            {
                ApplicationArea = all;
            }
        }
        addafter("End Customer")
        {
            field(Reseller; Reseller)
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {

    }


    trigger OnAfterGetRecord()
    var
        customer: record Customer;
    begin
        If customer.get(Rec."Sell-to Customer No.") then
            If customer."Customer Type" = customer."Customer Type"::"End Customer" then begin
                validate("End Customer", customer."No.");
                Modify(true);
            end else
                if customer."Customer Type" = customer."Customer Type"::Reseller then begin
                    validate("reseller", customer."No.");
                    Modify(true);
                end;
    end;

    var

}