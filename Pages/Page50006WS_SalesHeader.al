page 50006 "WS Sales Header"
{
    PageType = Document;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Sales Header";
    SourceTableView = where ("Document Type" = filter (Order));

    layout
    {
        area(Content)
        {
            group(Generelt)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Sell-To Customer No."; "Sell-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = All;
                }
                field("Order Date"; "Order Date")
                {
                    ApplicationArea = All;
                }
                field("Shipping Advice"; "Shipping Advice")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Requested Delivery Date"; "Requested Delivery Date")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Name"; "Bill-to Name")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Name 2"; "Bill-to Name 2")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Address"; "Bill-to Address")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Address 2"; "Bill-to Address 2")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Post Code"; "Bill-to Post Code")
                {
                    ApplicationArea = All;
                }
                field("Bill-to City"; "Bill-to City")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Country/Region Code"; "Bill-to Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Contact"; "Bill-to Contact")
                {
                    ApplicationArea = All;
                    trigger OnValidate();
                    begin
                        "Sell-to Contact" := "Bill-to Contact";
                    end;
                }
                field("Ship-to Name"; "Ship-to Name")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Name 2"; "Ship-to Name 2")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Address"; "Ship-to Address")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Address 2"; "Ship-to Address 2")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Post Code"; "Ship-to Post Code")
                {
                    ApplicationArea = All;
                }
                field("Ship-to City"; "Ship-to City")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Country/Region Code"; "Ship-to Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Contact"; "Ship-to Contact")
                {
                    ApplicationArea = All;
                }
                field("End Customer"; "End Customer")
                {
                    ApplicationArea = All;
                }
                /*
                <End User Name>	<Slutbrugernavn>	Field		"End User Name"
                <End User Address>	<Slutbrugeradresse>	Field		"End User Address"
                <End User Address 2>	<Slutbrugeradresse 2>	Field		"End User Address 2"
                <End User Post Code>	<Slutbrugerpostnr.>	Field		"End User Post Code"
                <End User City>	<Slutbrugerby>	Field		"End User City"
                <End User Country>	<Slutbrugerlandekode>	Field		"End User Country"
                <End User Phone No.>	<Slutbrugertelefon>	Field		"End User Phone No."
                */
                field(ShipComment; ShipComment)
                {
                    //Gemmes ikke i deres eksisterende løsning?
                    ApplicationArea = All;
                    Caption = 'ShipComment';
                }
                field(VendorOrderComment; VendorOrderComment)
                {
                    //Gemmes ikke i deres eksisterende løsning?
                    ApplicationArea = All;
                    Caption = 'VendorOrderComment';
                }
                part("WS SalesLines"; "WS Sales Line")
                {
                    ApplicationArea = Basic, Suite;
                    SubPageLink = "Document Type" = field ("Document Type"), "Document No." = field ("No.");
                    UpdatePropagation = Both;
                }
            }
        }
    }
    var
        ShipComment: Text;
        VendorOrderComment: Text;
}