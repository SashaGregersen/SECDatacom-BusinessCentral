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

                field(PostOption; PostOption)
                {
                    ShowCaption = false;
                    ApplicationArea = All;
                }
            }
        }
    }
    var
        PostOption: Option "Ship","Post","Ship&Post";
        xStatus: Option Open,Released,"Pending Approval","Pending Prepayment";

    trigger OnOpenPage()
    begin
        if Status > Status::Open then begin
            xStatus := Status;
            Status := Status::Open;
        end;

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
        if (not Ship) and (not Invoice) then
            Ship := true;

        if Ship then
            PostOption := PostOption::Ship;

        if Invoice then
            PostOption := PostOption::Post;

        if Ship and Invoice then
            PostOption := PostOption::"Ship&Post";
    end;

    procedure UpdatePostOption()
    begin
        case PostOption of
            PostOption::Post:
                Invoice := true;
            PostOption::Ship:
                Ship := true;
            PostOption::"Ship&Post":
                begin
                    Invoice := true;
                    Ship := true;
                end;
        end;
    end;
}