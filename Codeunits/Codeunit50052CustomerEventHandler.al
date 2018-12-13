codeunit 50052 "Customer Event Handler"
{
    SingleInstance = true;
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::Table, database::"Customer Price Group", 'OnAfterInsertEvent', '', true, true)]
    local procedure CustomerPriceGroupOnAfterinsert(var Rec: Record "Customer Price Group")
    var
        CustomerDiscountGroup: Record "Customer Discount Group";
    begin
        If not CustomerDiscountGroup.Get(Rec.Code) then begin
            CustomerDiscountGroup.Init();
            CustomerDiscountGroup.Code := Rec.Code;
            CustomerDiscountGroup.Description := Rec.Description;
            CustomerDiscountGroup.Insert(false);
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Customer Discount Group", 'OnAfterInsertEvent', '', true, true)]
    local procedure CustomerDiscountGroupOnAfterinsert(var Rec: Record "Customer Discount Group")
    var
        CustomerPriceGroup: Record "Customer Price Group";
    begin
        If not CustomerpriceGroup.Get(Rec.Code) then begin
            CustomerPriceGroup.Init();
            CustomerPriceGroup.Code := Rec.Code;
            CustomerPriceGroup.Description := Rec.Description;
            CustomerPriceGroup."Allow Line Disc." := false;
            CustomerPriceGroup.Insert(false);
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterCopySellToCustomerAddressFieldsFromCustomer', '', true, true)]
    local procedure OnAfterCopySellToCustomerAddressFieldsFromCustomer(var SalesHeader: Record "Sales Header"; SellToCustomer: record customer)
    var

    begin
        if SellToCustomer."Prefered Shipment Address" <> '' then begin

            SalesHeader."Sell-to Customer No." := SellToCustomer."Prefered Shipment Address";
            SalesHeader."Sell-to Customer Name" := SellToCustomer.Name;
            SalesHeader."Sell-to Customer Name 2" := SellToCustomer."Name 2";
            SalesHeader."Sell-to Address" := SellToCustomer.Address;
            SalesHeader."Sell-to Address 2" := SellToCustomer."Address 2";
            SalesHeader."Sell-to City" := SellToCustomer.City;
            SalesHeader."Sell-to Post Code" := SellToCustomer."Post Code";
            SalesHeader."Sell-to County" := SellToCustomer.County;
            SalesHeader."Sell-to Country/Region Code" := SellToCustomer."Country/Region Code";
            SalesHeader.modify(false);
        end;

    end;
}