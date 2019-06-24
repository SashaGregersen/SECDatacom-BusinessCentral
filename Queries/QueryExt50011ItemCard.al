query 50011 ItemCard
{
    Caption = 'ItemCardQuery';

    elements
    {
        dataitem(Item; "Item")
        {
            column(No_; "No.") { }

            column(Description; Description) { }

            column(Vendor_Item_No_; "Vendor Item No.") { }

            column(Vendor_No_; "Vendor No.") { }
        }
    }
}