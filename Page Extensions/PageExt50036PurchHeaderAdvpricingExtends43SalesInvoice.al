pageextension 50036 "Purch. Header Adv. pricing" extends "Purchase Order"
{
    layout
    {
        addafter("Ship-to Contact")
        {
            field("End Customer"; "End Customer")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addafter("End Customer")
        {
            field(Reseller; Reseller)
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }

}