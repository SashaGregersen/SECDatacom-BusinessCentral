pageextension 50003 "Customer Card Advanced Pricing" extends "Customer Card"
{
    layout
    {
        addafter("IC Partner Code")
        {
            field("Customer Type"; "Customer Type")
            {
                ApplicationArea = all;
            }
        }
        addafter("Shipping Agent Service Code")
        {
            field("Prefered Shipment Address"; "Prefered Shipment Address")
            {
                ApplicationArea = all;
            }
        }
        addafter("Prefered Shipment Address")
        {
            field("Prefered Sender Address"; "Prefered Sender Address")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {

        addafter("Line Discounts")
        {
            action("Customer Price Groups")
            {
                Image = CustomerGroup;
                trigger OnAction();
                var
                    PriceGroupLink: Record "Price Group Link";
                begin
                    PriceGroupLink.SetRange("Customer No.", "No.");
                    Page.RunModal(page::"Price Group Links", PriceGroupLink);
                end;
            }
            action("Customer Kickback Percentages")
            {
                ApplicationArea = All;
                Image = CustomerRating;

                trigger OnAction()
                var
                    CustKickbackPct: Record "Customer Kickback Percentage";
                begin
                    CustKickbackPct.SetRange("Customer No.", "No.");
                    page.RunModal(page::"Customer Kickback Percentages", CustKickbackPct)
                end;
            }
            action("EDI Profile")
            {
                ApplicationArea = All;
                Image = ExportMessage;

                trigger OnAction()
                var
                    EDIProfile: Record "EDI Profile";
                begin
                    EDIProfile.SetRange(Type, EDIProfile.Type::Customer);
                    EDIProfile.SetRange("No.", "No.");
                    Page.RunModal(Page::"EDI Profiles", EDIProfile);
                end;
            }
        }

    }



}