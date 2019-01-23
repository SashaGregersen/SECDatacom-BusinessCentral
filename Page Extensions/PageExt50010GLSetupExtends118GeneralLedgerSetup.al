pageextension 50010 "GLSetup" extends "General Ledger Setup"
{
    layout
    {
        addafter("Payroll Transaction Import")
        {
            group("Integration Setup")
            {
                field("Master Company"; "Master Company")
                {

                }
            }
        }
    }

    actions
    {

    }

    var

}