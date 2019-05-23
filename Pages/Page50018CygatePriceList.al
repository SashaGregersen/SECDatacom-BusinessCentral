page 50018 "Cygate Price List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Item;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Currency Code"; CygateCurrency)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Description 2"; "Description 2")
                {
                    ApplicationArea = all;
                }
                field("List Price"; ListPrice)
                {
                    ApplicationArea = all;
                }
                Field("Main Category Code"; MainCategoryCode)
                {
                    ApplicationArea = all;
                }
                field("Manufacturer Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = all;
                }
                field("Manufacturer Part Number"; "Vendor-Item-No.")
                {
                    ApplicationArea = all;
                }
                field("Part Number"; "No.")
                {
                    ApplicationArea = all;
                }
                field("Reseller Price"; ResellerPrice)
                {
                    ApplicationArea = all;
                }
                field(Inventory; Invent)
                {
                    ApplicationArea = all;
                }
                field("Subcategory Code"; SubCategoryCode)
                {
                    ApplicationArea = all;
                }


            }


        }
    }
    trigger OnOpenPage()
    var

    begin
        GlSetup.get;
        SalesReceiveSetup.get;
    end;

    trigger OnAfterGetRecord()
    var
        SalesPrice: record "Sales Price";
        SyncMasterData: Codeunit "Synchronize Master Data";
        ItemCategory: record "Item Category";
        Customer: record customer;
    begin
        Customer.get(SalesReceiveSetup."Cygate Customer No.");
        CygateCurrency := Customer."Currency Code";
        ListPrice := FindListPrice(SalesPrice);
        ResellerPrice := FindResellerPrice(salesprice, SalesReceiveSetup."Cygate Customer No.");
        MainCategoryCode := GetMainCategoryCode;
        SubCategoryCode := GetSubCategoryCode;
        if ItemCategory.Get(rec."Item Category Code") then begin
            if ItemCategory."Overwrite Quantity" then
                Invent := 999
            else
                Invent := SyncMasterData.UpdateInventoryOnItemFromLocation(Rec, GLSetup);
        end else
            Invent := SyncMasterData.UpdateInventoryOnItemFromLocation(Rec, GLSetup);
    end;

    procedure FindListPrice(SalesPrice: record "Sales Price"): Decimal
    var
    begin
        SalesPrice.setrange("Item No.", "No.");
        SalesPrice.SetRange("Currency Code", CygateCurrency);
        SalesPrice.setrange("Ending Date", 0D);
        SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::"All Customers");
        if SalesPrice.FindLast() then
            exit(SalesPrice."Unit Price");
        exit(0);
    end;

    procedure FindResellerPrice(SalesPrice: record "Sales Price"; CustomerNo: code[20]): Decimal
    var

    begin
        SalesPrice.setrange("Item No.", "No.");
        SalesPrice.SetRange("Currency Code", CygateCurrency);
        SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::Customer);
        SalesPrice.SetRange("Sales Code", CustomerNo);
        SalesPrice.setrange("Ending Date", 0D);
        if salesprice.FindLast() then
            exit(salesprice."Unit Price");
        SalesPrice.SetRange("Sales Code", FindDiscountGroup(CustomerNo));
        SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::"Customer Price Group");
        if SalesPrice.FindLast() then
            exit(SalesPrice."Unit Price");
        SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::"All Customers");
        if SalesPrice.FindLast() then
            exit(SalesPrice."Unit Price");
        exit(0);
    end;

    procedure FindDiscountGroup(CustomerNo: code[20]): code[20]
    var
        PriceGroupLink: record "Price Group Link";
        Customer: record Customer;
        SalesLineDiscountTemp: Record "Sales Line Discount" temporary;
        AdvancedPriceManage: Codeunit "Advanced Price Management";
    begin
        If AdvancedPriceManage.FindPriceGroupsFromItem(Rec, SalesLineDiscountTemp) then begin
            Customer.get(CustomerNo);
            SalesLineDiscountTemp.SetRange("Sales Code", Customer."Customer Price Group");
            if SalesLineDiscountTemp.FindFirst() then
                exit(SalesLineDiscountTemp."Sales Code")
            else
                exit('');
        end else
            exit('');
    end;

    local procedure GetMainCategoryCode(): code[20]
    var
        DefaultDim: Record "Default Dimension";
    begin
        DefaultDim.SetRange("Table ID", 27);
        DefaultDim.SetRange("No.", Rec."No.");
        DefaultDim.SetFilter("Dimension Code", '<>%1', GlSetup."Global Dimension 1 Code");
        if DefaultDim.FindFirst() then
            exit(DefaultDim."Dimension Code");
    end;

    local procedure GetSubCategoryCode(): code[20]
    var
        DefaultDim: Record "Default Dimension";
    begin
        DefaultDim.SetRange("Table ID", 27);
        DefaultDim.SetRange("No.", Rec."No.");
        DefaultDim.SetFilter("Dimension Code", '<>%1', GlSetup."Global Dimension 1 Code");
        if DefaultDim.FindFirst() then
            exit(DefaultDim."Dimension Value Code");
    end;


    var
        ListPrice: Decimal;
        MainCategoryCode: code[20];
        ResellerPrice: Decimal;
        SubCategoryCode: code[20];
        Invent: Integer;
        GlSetup: record "General Ledger Setup";
        SalesReceiveSetup: record "Sales & Receivables Setup";
        CygateCurrency: code[10];
}