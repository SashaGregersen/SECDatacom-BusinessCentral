pageextension 50037 "Purch. Rcpt. Hdr. Adv. pricing" extends "Posted Purchase Receipt"
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