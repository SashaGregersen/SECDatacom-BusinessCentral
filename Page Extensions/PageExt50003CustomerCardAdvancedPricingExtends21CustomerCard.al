pageextension 50003 "Customer Card Advanced Pricing" extends "Customer Card"
{
    layout
    {
        modify("Credit Limit (LCY)")
        {
            Editable = false;
        }
        addbefore("Credit Limit (LCY)")
        {
            field("Insured Risk"; "Insured Risk")
            {
                ApplicationArea = all;
                trigger OnValidate()
                begin
                    if not CreditInsurance.Get("No.") then begin
                        CreditInsurance."Customer No." := "No.";
                        CreditInsurance.Insert();
                    end;

                    CreditInsurance.Validate("Insured Risk", "Insured Risk");
                    CreditInsurance.Modify();

                    Validate("Credit Limit (LCY)", "Insured Risk" + "UnInsured Risk");
                end;
            }
            field("UnInsured Risk"; "UnInsured Risk")
            {
                ApplicationArea = all;
                trigger OnValidate()
                begin
                    if not CreditInsurance.Get("No.") then begin
                        CreditInsurance."Customer No." := "No.";
                        CreditInsurance.Insert();
                    end;

                    CreditInsurance.Validate("UnInsured Risk", "UnInsured Risk");
                    CreditInsurance.Modify();

                    Validate("Credit Limit (LCY)", "Insured Risk" + "UnInsured Risk");
                end;
            }
            field("Atradius No."; "Atradius No.")
            {
                ApplicationArea = all;
                trigger OnValidate()
                begin
                    if not CreditInsurance.Get("No.") then begin
                        CreditInsurance."Customer No." := "No.";
                        CreditInsurance.Insert();
                    end;

                    CreditInsurance.Validate("Atradius No.", "Atradius No.");
                    CreditInsurance.Modify();
                end;
            }
        }

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
        }
        addafter(CustomerReportSelections)
        {
            action("EDI Profile")
            {
                ApplicationArea = All;
                Image = ExportMessage;
                Caption = 'EDI Profile';

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
        addafter(Contact)
        {
            action(VARInfo)
            {
                Caption = 'VAR';
                Image = Relationship;
                RunObject = Page "VAR";
                RunPageLink = "Customer No." = field ("No.");
            }
            /*             action(SetOwningCompany)
                        {
                            Caption = 'SetOwningCompany)';
                            Image = Company;
                            RunObject = codeunit "Temp Hacks";
                            //Remove before release to test
                        } */
        }

    }
    var
        CreditInsurance: Record "Credit Insurance";
        "Insured Risk": Decimal;
        "UnInsured Risk": Decimal;
        "Atradius No.": Code[20];

    trigger OnAfterGetCurrRecord()
    begin
        "Insured Risk" := 0;
        "UnInsured Risk" := 0;
        "Atradius No." := '';
        if CreditInsurance.Get("No.") then begin
            "Insured Risk" := CreditInsurance."Insured Risk";
            "UnInsured Risk" := CreditInsurance."UnInsured Risk";
            "Atradius No." := CreditInsurance."Atradius No.";
        end;
    end;
}