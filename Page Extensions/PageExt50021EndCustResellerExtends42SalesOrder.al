pageextension 50021 "End Customer and Reseller" extends 42
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

    trigger OnInsertRecord(rec: Boolean): Boolean
    var
        customer: record Customer;
    begin
        If customer.get("No.") then
            If customer."Customer Type" = customer."Customer Type"::"End Customer" then begin
                validate("End Customer", customer."No.");
            end else
                if customer."Customer Type" = customer."Customer Type"::Reseller then
                    validate("End Customer", customer."No.");
    end;

    var

}