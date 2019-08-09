xmlport 50004 "Consignor"
{

    Direction = export;
    TextEncoding = UTF8;
    Format = VariableText;
    FieldDelimiter = '';
    FieldSeparator = ';';
    TableSeparator = '<NewLine>';
    schema
    {
        textelement(SalesOrder)
        {
            tableelement(SalesHeader; "Sales Header")
            {
                textattribute(Printer)
                {

                }
            }
        }
    }

    /* requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                    field(Name; SourceExpression)
                    {

                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {

                }
            }
        }
    } */

    var

}