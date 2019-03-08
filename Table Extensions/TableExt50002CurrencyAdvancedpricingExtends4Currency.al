tableextension 50002 "Currency Adv. Pricing" extends Currency
{
    fields
    {
        field(50000; "Make Prices"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(50001; "BNP Agreement No."; code[10])
        {
            DataClassification = ToBeClassified;
            ObsoleteState = Removed;
        }
    }

}