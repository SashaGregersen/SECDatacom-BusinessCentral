page 50017 "Sales Posting Options"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Sales Header";
    ShowFilter = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    LinksAllowed = false;

    layout
    {
        area(Content)
        {
            group(Dates)
            {
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; "Due Date")
                {
                    ApplicationArea = All;
                }
                field("Shipment Date"; "Shipment Date")
                {
                    ApplicationArea = All;
                }
            }
            group(Options)
            {
                ShowCaption = false;
                Visible = ("Document Type" = "Document Type"::"order") or ("Document Type" = "Document Type"::Invoice);

                field(PostOption; PostOption)
                {
                    ShowCaption = false;
                    ApplicationArea = All;

                }
            }
            group(Options2)
            {
                ShowCaption = false;
                Visible = ("Document Type" = "Document Type"::"Return Order") or ("Document Type" = "Document Type"::"Credit Memo");
                field(PostOption2; PostOption2)
                {
                    ShowCaption = false;
                    ApplicationArea = all;

                }
            }
        }
    }
    var
        PostOption: Option "Ship","Post","Ship&Post";
        PostOption2: Option "Receive","Post","Receive&Post";
        xStatus: Option Open,Released,"Pending Approval","Pending Prepayment";

    trigger OnOpenPage()
    begin
        SetHideValidationDialog(true);

        if Status > Status::Open then begin
            xStatus := Status;
            Status := Status::Open;
        end;

        xRec := Rec;
        Validate("Posting Date", WorkDate());
        Validate("Document Date", WorkDate());
        Validate("Shipment Date", WorkDate());

        SetPostOption();
    end;

    trigger OnClosePage()
    begin
        UpdatePostOption();

        if Status <> xStatus then
            Status := xStatus;
    end;

    procedure SetPostOption()
    begin
        if (rec."Document Type" = rec."Document Type"::"Blanket Order") or (rec."Document Type" = rec."Document Type"::Invoice) or (rec."Document Type" = rec."Document Type"::Order) then begin
            if Ship then
                PostOption := PostOption::Ship;

            if Invoice then
                PostOption := PostOption::Post;

            if Ship and Invoice then
                PostOption := PostOption::"Ship&Post";
        end else begin
            if Receive then
                PostOption2 := PostOption2::Receive;

            if Invoice then
                PostOption2 := PostOption2::Post;

            if Receive and Invoice then
                PostOption2 := PostOption2::"Receive&Post";
        end;
    end;

    procedure UpdatePostOption()
    begin
        if (rec."Document Type" = rec."Document Type"::"Blanket Order") or (rec."Document Type" = rec."Document Type"::Invoice) or (rec."Document Type" = rec."Document Type"::Order) then begin
            case PostOption of
                PostOption::Post:
                    begin
                        Invoice := true;
                        ship := false;
                    end;
                PostOption::Ship:
                    begin
                        Ship := true;
                        Invoice := false;
                    end;
                PostOption::"Ship&Post":
                    begin
                        Invoice := true;
                        Ship := true;
                    end;
            end;
        end else begin
            case PostOption2 of
                PostOption2::Post:
                    begin
                        Invoice := true;
                        Receive := false;
                    end;
                PostOption2::Receive:
                    begin
                        Receive := true;
                        Invoice := false;
                    end;
                PostOption2::"Receive&Post":
                    begin
                        Invoice := true;
                        Receive := true;
                    end;
            end;
        end;
    end;

}