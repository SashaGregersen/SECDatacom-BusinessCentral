codeunit 50096 "Temp Hacks"
{
    trigger OnRun()
    var
        Purchheader: Record "Purchase Header";
        JobQueue: Record "Job Queue Entry";
    begin

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

    var
        myInt: Integer;
}