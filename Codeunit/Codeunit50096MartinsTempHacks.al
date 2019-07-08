codeunit 50096 "Temp Hacks"
{
    trigger OnRun()
    var
        Purchheader: Record "Purchase Header";
        JobQueue: Record "Job Queue Entry";
    begin
        DeleteItemDublet();
        //SetOwningCompanyOnContacts();
        //SetOwningCompany();
        //if Purchheader.get(Purchheader."Document Type"::Order, '106061') then
        //Codeunit.Run(50021, Purchheader);
        //TestCurrencyUpdate();
        //TestPurPriceUpdate('70619');
    end;

    local procedure SetOwningCompany()
    var
        Customer: Record Customer;
        Window: Dialog;
    begin
        Window.Open('#1############');
        if Customer.FindSet(true, false) then
            repeat
                Window.Update(1, Customer."No.");
                Customer."Owning Company" := CompanyName();
                Customer.Modify(false);
            until Customer.Next() = 0;
        Window.Close();
        Message('Done');
    end;

    Local procedure TestCurrencyUpdate()
    var
        Item: record item;
    begin
        report.run(Report::"Update Prices with Currencies", false, false, item);
    end;

    local procedure SetOwningCompanyOnContacts()
    var
        Contact: Record Contact;
        Window: Dialog;
    begin
        Window.Open('#1############');
        if Contact.FindSet(true, false) then
            repeat
                Window.Update(1, Contact."No.");
                Contact."Owning-Company" := CompanyName();
                Contact.Modify(false);
            until Contact.Next() = 0;
        Window.Close();
        Message('Done');
    end;

    Local procedure TestPurPriceUpdate(ItemNo: Code[20])
    var
        PurchasePrice: Record "Purchase Price";
        SyncPurPrice: Codeunit "IC Sync Purchase price";
    begin
        PurchasePrice.SetRange("Item No.", ItemNo);
        if PurchasePrice.FindSet() then
            repeat
                SyncPurPrice.Run(PurchasePrice);
            until PurchasePrice.Next() = 0;
    end;

    LOCAL procedure DeleteItemDublet()
    var
        Item: record item;
        Item2: record item;
        Item3: record item;
        Window: Dialog;
        DeleteItemDub: report "Delete Item Dublets";
    begin
        DeleteItemDub.Run();
        /* Window.OPEN('#1############');
        IF Item.FINDSET THEN
            REPEAT
                Item2.SETRANGE("Vendor No.", Item."Vendor No.");
                Item2.SETRANGE("Vendor Item No.", Item."Vendor Item No.");
                Item2.SETFILTER("No.", '<>%1', Item."No.");
                IF Item2.FINDSET(TRUE, FALSE) THEN
                    REPEAT
                        Item3 := Item2;
                        IF (Item3."Vendor Item No." <> '') AND (Item3."Vendor No." <> '') THEN BEGIN
                            IF not Item3.DELETE(TRUE) THEN;
                            Window.UPDATE(1, Item3."No.")
                        END;
                    UNTIL Item2.NEXT() = 0;
            UNTIL Item.NEXT = 0;
        Window.CLOSE();
        MESSAGE('Done'); */
    end;

}