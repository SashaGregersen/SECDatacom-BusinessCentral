pageextension 50006 "Currencies Adv. Pricing" extends currencies
{
    layout
    {
        addafter(ExchangeRateAmt)
        {
            field("Make Prices";"Make Prices")
            {
                ApplicationArea = all;
            }
        }
    }

   
}