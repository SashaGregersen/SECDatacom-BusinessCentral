xmlport 50000 "Price File Export XML"
{
    Direction = export;

    schema
    {

        textelement(Root)
        {
            tableelement(Item; Item)
            {
                XmlName = 'Item';

                fieldelement(No; Item."No.")
                {
                }
                fieldelement(Descip; item.Description)
                {

                }
                fieldelement(Descrip2; item."Description 2")
                {

                }
                fieldelement(VendItemNo; item."Vendor Item No.")
                {

                }
                fieldelement(Vendor; item."Vendor No.")
                {

                }
                textelement(Invent)
                {

                }
                textelement(SalesPriceUnitPrice)
                {

                    trigger OnBeforePassVariable()
                    var

                    begin
                        SalesPriceUnitPrice := Format(FindCheapestPrice(salesprice));
                    end;

                }
                textelement(CurrencyCode)
                {
                    trigger OnAfterAssignVariable()
                    var

                    begin
                        CurrencyCode := CurrencyFilter;
                    end;
                }
                tableelement(DefaultDimension; "Default Dimension")
                {
                    XmlName = 'DefaultDimension';
                    LinkTable = Item;
                    LinkFields = "No." = field ("No."), "Table ID" = const (27);

                    fieldelement(DefaultDimCode; DefaultDimension."Dimension Code")
                    {

                    }
                    fieldelement(DefaultDimCode; DefaultDimension."Dimension Value Code")
                    {

                    }
                }
                trigger OnAfterGetRecord()
                var
                    SyncMasterData: Codeunit "Synchronize Master Data";
                    Item2: record Item;
                    Invt: Decimal;
                    ItemCategory: record "Item Category";
                begin
                    if not item."Use on Website" then
                        currXMLport.Skip();

                    if ItemCategory.Get(Item."Item Category Code") then begin
                        if ItemCategory."Overwrite Quantity" then
                            Invent := format(999)
                    end else begin
                        Item2.ChangeCompany(GLSetup."Master Company");
                        if (Item2.Get(Item."No.")) then begin
                            Invt := SyncMasterData.UpdateInventoryOnItemFromLocation(Item2, GLSetup);
                            if (Invt <= 0) and Item2."Blocked from purchase" then
                                currXMLport.skip;
                        end;
                        Invent := format(Invt);
                    end;

                    SalesPrice.SetRange("Item No.", Item."No.");
                    if not salesprice.FindSet() then
                        currXMLport.Skip();
                end;
            }

        }
    }

    trigger OnPreXmlPort()
    var
        salesprice: Record "Sales Price";
    begin
        GLSetup.get;
        GLSetup.TestField("Master Company");

        if CustomerNo = '' then
            currXMLport.Skip();
    end;

    var
        CustomerNo: code[20];
        CurrencyFilter: text;
        UnitPrice: decimal;
        salesprice: record "Sales Price";
        GLSetup: record "General Ledger Setup";

    procedure SetCurrencyFilter(NewCurrencyFilter: Text)
    var

    begin
        CurrencyFilter := NewCurrencyFilter;

    end;

    procedure SetCustomerFilter(Customer: Record Customer)
    var

    begin

        CustomerNo := customer."No.";
    end;

    procedure FindCheapestPrice(SalesPrice: record "Sales Price"): Decimal
    var

    begin
        SalesPrice.SetRange("Item No.", Item."No.");
        SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::Customer);
        SalesPrice.SetRange("Sales Code", CustomerNo);
        SalesPrice.SetRange("Currency Code", CurrencyFilter);
        SalesPrice.setrange("Ending Date", 0D);
        if salesprice.FindLast() then
            exit(salesprice."Unit Price");
        SalesPrice.SetRange("Sales Code", FindDiscountGroup());
        SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::"Customer Price Group");
        if SalesPrice.FindLast() then
            exit(SalesPrice."Unit Price");
        SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::"All Customers");
        if SalesPrice.FindLast() then
            exit(SalesPrice."Unit Price");
    end;

    procedure FindDiscountGroup(): code[20]
    var
        PriceGroupLink: record "Price Group Link";
        SalesLineDiscountTemp: Record "Sales Line Discount" temporary;
        AdvancedPriceManage: Codeunit "Advanced Price Management";
    begin
        If AdvancedPriceManage.FindPriceGroupsFromItem(Item, SalesLineDiscountTemp) then begin
            PriceGroupLink.SetRange("Customer No.", CustomerNo);
            if PriceGroupLink.FindSet then begin
                SalesLineDiscountTemp.SetRange("Sales Code", PriceGroupLink."Customer Discount Group Code");
                if SalesLineDiscountTemp.FindFirst() then
                    exit(SalesLineDiscountTemp."Sales Code");
            end;
        end else
            exit('');
    end;
}