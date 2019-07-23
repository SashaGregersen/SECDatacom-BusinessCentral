codeunit 50096 "Temp Hacks"
{
    trigger OnRun()
    var
        Purchheader: Record "Purchase Header";
        JobQueue: Record "Job Queue Entry";
    begin
        //UpdateSalesLine();
        //DeleteItemDublet();
        //SetOwningCompanyOnContacts();
        //SetOwningCompany();
        //if Purchheader.get(Purchheader."Document Type"::Order, '106061') then
        //Codeunit.Run(50021, Purchheader);
        //TestCurrencyUpdate();
        //TestPurPriceUpdate('70619');
    end;

    procedure RunHack()
    var
        WarehousePick: Report "Create Invt Put-away/Pick/Mvmt";
    begin
        WarehousePick.Run();

    end;

    procedure UpdateSalesLine2()
    var
        Salesline2: record "Sales Line";
        salesline3: record "Sales Line";
        Salesline4: record "Sales Line";
    begin
        Salesline2.get(salesline2."Document Type"::Order, '213120000019', 10000);
        Salesline2."Qty. Invoiced (Base)" := 1;
        Salesline2."Quantity Invoiced" := 1;
        Salesline2.Modify(false);

        Salesline3.get(salesline2."Document Type"::Order, '213120000019', 20000);
        Salesline3."Qty. Invoiced (Base)" := 1;
        Salesline3."Quantity Invoiced" := 1;
        Salesline3.Modify(false);

        Salesline4.get(salesline2."Document Type"::Order, '213120000019', 30000);
        Salesline4."Qty. Invoiced (Base)" := 1;
        Salesline4."Quantity Invoiced" := 1;
        Salesline4.Modify(false);
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
    end;

    procedure DeletePricesDK()
    var
        window: Dialog;
        purchprice: record "Purchase Price";
        Item: record item;
        SalesPrice: record "Sales Price";
    begin
        Window.OPEN('#1############');
        PurchPrice.SETRANGE("Vendor No.", '101300001581');
        PurchPrice.DELETEALL;
        Window.UPDATE(1, PurchPrice."Item No.");

        Item.SETRANGE("Global Dimension 1 Code", 'RUCKUS');
        IF Item.FINDSET THEN
            REPEAT
                SalesPrice.SETRANGE("Item No.", Item."No.");
                SalesPrice.DELETEALL;
                Window.UPDATE(1, SalesPrice."Item No.");
            UNTIL Item.NEXT = 0;

        Window.CLOSE();
        MESSAGE('Done');
    end;

    procedure DeletePricesSE()
    var
        window: Dialog;
        purchprice: record "Purchase Price";
        Item: record item;
        SalesPrice: record "Sales Price";
    begin
        Window.OPEN('#1############');
        PurchPrice.SETRANGE("Vendor No.", '21210001');
        PurchPrice.DELETEALL;
        Window.UPDATE(1, PurchPrice."Item No.");

        Item.SETRANGE("Global Dimension 1 Code", 'RUCKUS');
        IF Item.FINDSET THEN
            REPEAT
                SalesPrice.SETRANGE("Item No.", Item."No.");
                SalesPrice.DELETEALL;
                Window.UPDATE(1, SalesPrice."Item No.");
            UNTIL Item.NEXT = 0;

        Window.CLOSE();
        MESSAGE('Done');
    end;

    procedure DeletePricesNO()
    var
        window: Dialog;
        purchprice: record "Purchase Price";
        Item: record item;
        SalesPrice: record "Sales Price";
    begin
        Window.OPEN('#1############');
        PurchPrice.SETRANGE("Vendor No.", '31210001');
        PurchPrice.DELETEALL;
        Window.UPDATE(1, PurchPrice."Item No.");

        Item.SETRANGE("Global Dimension 1 Code", 'RUCKUS');
        IF Item.FINDSET THEN
            REPEAT
                SalesPrice.SETRANGE("Item No.", Item."No.");
                SalesPrice.DELETEALL;
                Window.UPDATE(1, SalesPrice."Item No.");
            UNTIL Item.NEXT = 0;

        Window.CLOSE();
        MESSAGE('Done');
    end;

    procedure DeletePricesFI()
    var
        window: Dialog;
        purchprice: record "Purchase Price";
        Item: record item;
        SalesPrice: record "Sales Price";
    begin
        Window.OPEN('#1############');
        PurchPrice.SETRANGE("Vendor No.", '41210002');
        PurchPrice.DELETEALL;
        Window.UPDATE(1, PurchPrice."Item No.");

        Item.SETRANGE("Global Dimension 1 Code", 'RUCKUS');
        IF Item.FINDSET THEN
            REPEAT
                SalesPrice.SETRANGE("Item No.", Item."No.");
                SalesPrice.DELETEALL;
                Window.UPDATE(1, SalesPrice."Item No.");
            UNTIL Item.NEXT = 0;

        Window.CLOSE();
        MESSAGE('Done');
    end;

}