xmlport 50001 "Price File Export CSV"
{
    Direction = export;
    TextEncoding = WINDOWS;
    Format = VariableText;
    FieldDelimiter = '';
    FieldSeparator = ';';

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
                fieldelement(VendItemNo; item."Vendor-Item-No.")
                {

                }
                fieldelement(VendCurrency; item."Vendor Currency")
                {

                }
                fieldelement(Vendor; item."Vendor No.")
                {

                }
                Textelement(Invent)
                {

                }
                textelement(SalesPriceUnitPrice)
                {

                    trigger OnBeforePassVariable()
                    begin
                        SalesPriceUnitPrice := Format(FindCheapestPrice(salesprice, CustomerNo));
                    end;

                }
                textelement(CurrencyCode)
                {
                    trigger OnBeforePassVariable()
                    begin
                        if CurrencyFilter = '' then
                            CurrencyCode := GLSetup."LCY Code"
                        else
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
                        else begin
                            Item2.ChangeCompany(GLSetup."Master Company");
                            if (Item2.Get(Item."No.")) then begin
                                Invt := SyncMasterData.UpdateInventoryOnItemFromLocation(Item2, GLSetup);
                                if (Invt <= 0) and Item2."Blocked from purchase" then
                                    currXMLport.skip;
                            end;
                            Invent := format(Invt);
                        end;
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

    procedure FindCheapestPrice(SalesPrice: record "Sales Price"; CustomerNo: code[20]): Decimal
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
        Customer: record customer;
        SalesLineDiscountTemp: Record "Sales Line Discount" temporary;
        AdvancedPriceManage: Codeunit "Advanced Price Management";
    begin
        If AdvancedPriceManage.FindPriceGroupsFromItem(Item, SalesLineDiscountTemp) then begin
            Customer.get(CustomerNo);
            SalesLineDiscountTemp.SetRange("Sales Code", Customer."Customer Price Group");
            if SalesLineDiscountTemp.FindFirst() then
                exit(SalesLineDiscountTemp."Sales Code")
            else
                exit('');
        end else
            exit('');
    end;
}