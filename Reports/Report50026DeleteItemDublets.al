report 50026 "Delete Item Dublets"
{
    UsageCategory = Administration;
    ApplicationArea = all;
    UseRequestPage = false;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            trigger OnPreDataItem()
            var

            begin
                Window.OPEN('#1############');
            end;

            trigger OnAfterGetRecord()
            var
                Item2: record item;
                Item3: record item;
            begin
                Item2.SETRANGE("Vendor No.", Item."Vendor No.");
                Item2.SETRANGE("Vendor Item No.", Item."Vendor Item No.");
                Item2.SETFILTER("No.", '<>%1', Item."No.");
                IF Item2.FINDSET(TRUE, FALSE) THEN
                    REPEAT
                        Item3 := Item2;
                        IF (Item3."Vendor Item No." <> '') AND (Item3."Vendor No." <> '') THEN BEGIN
                            IF not Item3.DELETE(TRUE) THEN
                                CurrReport.skip;
                            Window.UPDATE(1, Item3."No.")
                        END;
                    UNTIL Item2.NEXT() = 0;
            end;

            trigger OnPostDataItem()
            var

            begin
                Window.CLOSE();
                MESSAGE('Done');
            end;
        }
    }

    var
        Window: Dialog;
}