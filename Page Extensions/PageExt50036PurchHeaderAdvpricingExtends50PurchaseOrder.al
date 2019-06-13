pageextension 50036 "Purch. Header Adv. pricing" extends "Purchase Order"
{
    layout
    {
        addafter("Ship-to Country/Region Code")
        {
            field("Ship-To Comment"; "Ship-To Comment")
            {
                ApplicationArea = all;
            }
        }
        addafter("Ship-to Contact")
        {
            field("End Customer"; "End Customer")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("End Customer Contact No."; "End Customer Contact No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("End Customer Company Name"; ContactEndCust."Company Name")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("End Customer Name"; ContactEndCust.Name)
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("End Customer Address1"; ContactEndCust.Address)
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("End Customer Address2"; ContactEndCust."Address 2")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("End Customer Post Code"; ContactEndCust."Post Code")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("End Customer City"; ContactEndCust."City")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("End Customer Country/region"; ContactEndCust."Country/Region Code")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("End Customer Phone No."; ContactEndCust."Phone No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("End Customer Email"; ContactEndCust."E-Mail")
            {
                ApplicationArea = all;
                Editable = false;
            }

        }
        addafter("End Customer")
        {
            field(Reseller; Reseller)
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Reseller Contact No."; "Reseller Contact No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Reseller Company Name"; ContactReseller."Company Name")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Reseller Name"; ContactReseller.Name)
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Reseller Address1"; ContactReseller.Address)
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Reseller Address2"; ContactReseller."Address 2")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Reseller Post Code"; ContactReseller."Post Code")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Reseller City"; ContactReseller."City")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Reseller Country/region"; ContactReseller."Country/Region Code")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Reseller Phone No."; ContactReseller."Phone No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Reseller Email"; ContactReseller."E-Mail")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }


    }


    actions
    {
        addafter("Create Inventor&y Put-away/Pick")
        {
            action("Import Serial Numbers")
            {
                Image = ImportExcel;
                trigger OnAction()
                var
                    ImportSerialNumbersPurchase: Codeunit "Import Serial Number Purchase";
                begin
                    ImportSerialNumbersPurchase.ImportSerialNumbers(Rec);
                end;
            }
        }
        addlast(Processing)
        {
            action(ShowMyReport)
            {
                Image = ItemGroup;
                trigger OnAction();
                begin
                    PurchOrder.Run();
                end;
            }

        }
    }

    trigger OnAfterGetRecord()
    var

    begin
        if ContactEndCust.get("End Customer Contact No.") then;
        if ContactReseller.get("Reseller Contact No.") then;
    end;

    var
        PurchOrder: report 50010;
        ContactEndCust: record Contact;
        ContactReseller: record Contact;
}