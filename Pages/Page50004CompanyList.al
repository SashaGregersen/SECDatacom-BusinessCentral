page 50005 "Company List"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = Company;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Name; Name)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    trigger OnClosePage()
    begin
        CurrPage.SetSelectionFilter(rec);
        if Rec.FindSet() then
            repeat
                CompanyTemp := Rec;
                CompanyTemp.Insert();
            until rec.Next() = 0;
    END;

    procedure GetCompanies(var ReturnCompaniesTemp: Record Company temporary)
    begin
        ReturnCompaniesTemp.DeleteAll();
        if CompanyTemp.FindSet() then
            repeat
                ReturnCompaniesTemp := CompanyTemp;
                ReturnCompaniesTemp.Insert();
            until CompanyTemp.Next() = 0;
    end;

    var
        CompanyTemp: Record Company temporary;
}