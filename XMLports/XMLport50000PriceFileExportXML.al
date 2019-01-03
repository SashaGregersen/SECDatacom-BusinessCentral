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
                fieldelement(VendCurrency; item."Vendor Currency")
                {

                }
                fieldelement(Vendor; item."Vendor No.")
                {

                }
                fieldelement(Inventory; item.Inventory)
                {

                }

                tableelement(SalesPrice; "Sales Price")
                {
                    XmlName = 'SalesPrice';
                    LinkTable = Item;
                    LinkFields = "Item No." = field ("No."), "Currency code" = field ("Vendor Currency");
                    fieldelement(SalesPriceItemNo; SalesPrice."Item No.")
                    {

                    }
                    fieldelement(SalesPriceCode; SalesPrice."Sales Code")
                    {

                    }
                    fieldelement(SalesPriceType; SalesPrice."Sales Type")
                    {

                    }
                    fieldelement(SalesPriceUnitPrice; SalesPrice."Unit Price")
                    {

                    }
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
                    If CustomerFilter <> '' then begin
                        SalesPrice.SetRange("Sales Code", CustomerFilter);
                        If SalesPrice.FindSet() then
                            Item.SetRange("No.", SalesPrice."Item No.");
                    end;
                    If DimFilter <> '' then
                        if ItemHasDim(Dimfilter, Item."No.") = true then begin
                            DefaultDimension.SetRange("Table ID", database::Item);
                            DefaultDimension.SetRange("No.", Item."No.");
                            if DefaultDimension.FindSet() then
                                Item.SetRange("No.", DefaultDimension."No.");
                        end;
                    //currXMLport.Skip();
                end;
            }
        }
    }

    var
        CustomerFilter: text;
        DimFilter: text;

    procedure SetCustomerFilter(NewCustomerFilter: Text)
    var

    begin
        CustomerFilter := NewCustomerFilter;
    end;

    procedure SetDimFilter(NewDimFilter: Text)
    var

    begin
        DimFilter := NewDimFilter;
    end;

    local procedure ItemHasDim(DimValCode: code[20]; ItemNo: code[20]): Boolean
    var
        DefaultDim: Record "Default Dimension";
    begin
        DefaultDimension.SetRange("Table ID", database::Item);
        DefaultDimension.SetRange("No.", ItemNo);
        exit(DefaultDimension.findfirst);
    end;
}