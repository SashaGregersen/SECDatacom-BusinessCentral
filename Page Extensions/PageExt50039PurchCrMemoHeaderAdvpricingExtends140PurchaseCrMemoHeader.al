pageextension 50039 "Posted Purch. CrMemo Adv.Price" extends "Posted Purchase Credit Memo"
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