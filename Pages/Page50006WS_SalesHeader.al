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
                field(Reseller; Reseller)
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
                field("Shipping Advice"; "xShippingAdvice")
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
                    trigger OnValidate()
                    var
                        EndCustNo: Code[20];
                    begin
                        EndCustNo := CheckCreateCustomer();
                        if ("End Customer" <> EndCustNo) and
                           (EndCustNo <> '') then
                            Validate("End Customer", EndCustNo);
                    end;
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
                part("Sales Lines"; "WS Sales Line")
                {
                    ApplicationArea = Basic, Suite;
                    SubPageLink = "Document Type" = field ("Document Type"), "Document No." = field ("No.");
                    UpdatePropagation = Both;
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    var
        EndCustNo: Code[20];
    begin
        EndCustNo := CheckCreateCustomer();
        if ("End Customer" <> EndCustNo) and
           (EndCustNo <> '') then
            Validate("End Customer", EndCustNo);
    end;

    trigger OnModifyRecord(): Boolean;
    var
        EndCustNo: Code[20];
    begin
        EndCustNo := CheckCreateCustomer();
        if ("End Customer" <> EndCustNo) and
           (EndCustNo <> '') then
            Validate("End Customer", EndCustNo);
    end;

    procedure CheckCreateCustomer(): Code[20];
    var
        Cust: Record Customer;
    begin
        if "End Customer" <> '' then exit("End Customer");
        if "End User Name" = '' then exit('');

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
            Cust.Validate("Customer Type", Cust."Customer Type"::"End Customer");
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