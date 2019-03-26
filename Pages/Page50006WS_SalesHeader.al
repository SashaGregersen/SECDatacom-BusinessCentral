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
                /*
                field("End Customer"; "End Customer")
                {
                    ApplicationArea = All;
                }
                */
                field("End User Name"; "End User Name")
                {
                    ApplicationArea = All;
                }
                field("End User Address"; "End User Address")
                {
                    ApplicationArea = All;
                }
                field("End User Address 2"; "End User Address 2")
                {
                    ApplicationArea = All;
                }
                field("End User Post Code"; "End User Post Code")
                {
                    ApplicationArea = All;
                }
                field("End User City"; "End User City")
                {
                    ApplicationArea = All;
                }
                field("End User Country"; "End User Country")
                {
                    ApplicationArea = All;
                }
                field("End User Phone No."; "End User Phone No.")
                {
                    ApplicationArea = All;
                }
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
                part("Cygate Sales Line"; "WS Sales Line")
                {
                    ApplicationArea = Basic, Suite;
                    SubPageLink = "Document Type" = field ("Document Type"), "Document No." = field ("No.");
                    UpdatePropagation = Both;
                }
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        Validate("End Customer", CheckCreateCustomer());
    end;

    trigger OnModifyRecord(): Boolean;
    begin
        Validate("End Customer", CheckCreateCustomer());
    end;

    procedure CheckCreateCustomer(): Code[20];
    var
        Cust: Record Customer;
    begin
        if "End Customer" <> '' then exit("End Customer");

        Cust.SetRange(Address, "End User Address");
        Cust.SetRange("Post Code", "End User Post Code");
        Cust.SetRange(Name, "End User Name");
        if not Cust.FindFirst() then begin
            Cust.Init();
            Cust.Insert(true);
            Cust.Validate(Name, "End User Name");
            Cust.Validate(Address, "End User Address");
            Cust.Validate("Address 2", "End User Address 2");
            Cust.Validate("Post Code", "End User Post Code");
            Cust.Validate(City, "End User City");
            Cust.Validate("Country/Region Code", "End User Country");
            Cust.Validate("Phone No.", "End User Phone No.");
            Cust.Modify(true);
        end;
        exit(Cust."No.");
    end;

    var
        ShipComment: Text;
        VendorOrderComment: Text;
        "End User Name": Text[50];
        "End User Address": Text[50];
        "End User Address 2": Text[50];
        "End User Post Code": Code[20];
        "End User City": Text[30];
        "End User Country": Code[10];
        "End User Phone No.": Text[30];
}