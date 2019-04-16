query 50007 "BudgetEntries"
{
    Caption = 'BudgetEntries';

    elements
    {
        dataitem(G_L_Budget_Entry; "G/L Budget Entry")
        {
            column(Budget_Name; "Budget Name")
            {
            }
            column(G_L_Account_No_; "G/L Account No.")
            {

            }
            column(Date; Date)
            {

            }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code")
            {

            }
            column(Amount; Amount)
            {

            }
            column(Description; Description)
            {

            }

        }
    }
}