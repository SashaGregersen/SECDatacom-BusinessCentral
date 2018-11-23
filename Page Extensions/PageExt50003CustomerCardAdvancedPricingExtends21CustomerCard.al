pageextension 50003 "Customer Card Advanced Pricing" extends "Customer Card"
{
    layout
    {
        addafter("IC Partner Code")
        {        
            field("Customer Type";"Customer Type")
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
                    PriceGroupLink : Record "Price Group Link";
                begin
                    PriceGroupLink.SetRange("Customer No.","No.");
                    Page.RunModal(50002,PriceGroupLink);
                end;
            }
        }
        
    }

    
    
}