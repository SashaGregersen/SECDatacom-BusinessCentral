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
                fieldelement(VendItemNo; item."Vendor Item No.")
                {

                }
                fieldelement(VendCurrency; item."Vendor Currency")
                {

                }
                fieldelement(Vendor; item."Vendor No.")
                {

                }
                fieldelement(Inventory; item.Inventory)
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

                    fieldelement(DefaultDimCode; DefaultDimension."Dimension Value Code")
                    {

                    }
                }
                trigger OnAfterGetRecord()
                var

                begin
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
        if CustomerNo = '' then
            currXMLport.Skip();
    end;


    var
        CustomerNo: code[20];
        CurrencyFilter: text;
        UnitPrice: decimal;
        salesprice: record "Sales Price";

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
        SalesPrice.SetRange("Sales Code", FindSalesCodeFromCustomerNo());
        SalesPrice.SetRange("Currency Code", CurrencyFilter);
        if salesprice.FindLast() then
            exit(salesprice."Unit Price");
    end;

    local procedure FindSalesCodeFromCustomerNo(): code[20]
    var
        customer: record Customer;
    begin
        Customer.setrange("No.", CustomerNo);
        if customer.findfirst then
            exit(customer."Customer Disc. Group");
    end;
}