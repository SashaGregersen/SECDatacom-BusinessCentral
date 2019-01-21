report 50008 "Reminder PM w/FI-Card"
{
    // version NAVW17.00,PM10.00.00.2.14

    // <PM>
    //   Payment Management
    // </PM>
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Reminder PM wFI-Card.rdl';

    Caption = 'Reminder Payment Management w/FI-Card';

    dataset
    {
        dataitem("Issued Reminder Header"; "Issued Reminder Header")
        {
            DataItemTableView = SORTING ("No.");
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Reminder';
            column(Issued_Reminder_Header_No_; "No.")
            {
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING (Number) WHERE (Number = CONST (1));
                column(Issued_Reminder_Header___Due_Date_; Format("Issued Reminder Header"."Due Date"))
                {
                }
                column(Issued_Reminder_Header___Posting_Date_; Format("Issued Reminder Header"."Posting Date"))
                {
                }
                column(Issued_Reminder_Header___No__; "Issued Reminder Header"."No.")
                {
                }
                column(Issued_Reminder_Header___Your_Reference_; "Issued Reminder Header"."Your Reference")
                {
                }
                column(ReferenceText; ReferenceText)
                {
                }
                column(Issued_Reminder_Header___VAT_Registration_No__; "Issued Reminder Header"."VAT Registration No.")
                {
                }
                column(VATNoText; VATNoText)
                {
                }
                column(Issued_Reminder_Header___Document_Date_; Format("Issued Reminder Header"."Document Date", 0, 4))
                {
                }
                column(Issued_Reminder_Header___Customer_No__; "Issued Reminder Header"."Customer No.")
                {
                }
                column(CompanyInfo__Bank_Account_No__; CompanyInfo."Bank Account No.")
                {
                }
                column(CompanyInfo__Bank_Name_; CompanyInfo."Bank Name")
                {
                }
                column(CompanyInfo__Giro_No__; CompanyInfo."Giro No.")
                {
                }
                column(CompanyInfo__VAT_Registration_No__; CompanyInfo."VAT Registration No.")
                {
                }
                column(CompanyInfo__Fax_No__; CompanyInfo."Fax No.")
                {
                }
                column(CustAddr_8_; CustAddr[8])
                {
                }
                column(CompanyInfo__Phone_No__; CompanyInfo."Phone No.")
                {
                }
                column(CustAddr_7_; CustAddr[7])
                {
                }
                column(CustAddr_6_; CustAddr[6])
                {
                }
                column(CompanyAddr_6_; CompanyAddr[6])
                {
                }
                column(CustAddr_5_; CustAddr[5])
                {
                }
                column(CompanyAddr_5_; CompanyAddr[5])
                {
                }
                column(CustAddr_4_; CustAddr[4])
                {
                }
                column(CompanyAddr_4_; CompanyAddr[4])
                {
                }
                column(CustAddr_3_; CustAddr[3])
                {
                }
                column(CompanyAddr_3_; CompanyAddr[3])
                {
                }
                column(CustAddr_2_; CustAddr[2])
                {
                }
                column(CompanyAddr_2_; CompanyAddr[2])
                {
                }
                column(CustAddr_1_; CustAddr[1])
                {
                }
                column(CompanyAddr_1_; CompanyAddr[1])
                {
                }
                column(STRSUBSTNO_Text002_CurrReport_PAGENO_; StrSubstNo(Text002, CurrReport.PageNo))
                {
                }
                column(CompanyInfo__IBAN__PM__; CompanyInfo."IBAN (PM)")
                {
                }
                column(TextPage; Text002)
                {
                }
                column(PageCaption; StrSubstNo(Text002, ''))
                {
                }
                column(PaymentID; PaymentID)
                {
                }
                column(CustAddr_1__Control1160940003; CustAddr[1])
                {
                }
                column(CustAddr_2__Control1160940004; CustAddr[2])
                {
                }
                column(CustAddr_3__Control1160940005; CustAddr[3])
                {
                }
                column(CustAddr_4__Control1160940006; CustAddr[4])
                {
                }
                column(CustAddr_5__Control1160940007; CustAddr[5])
                {
                }
                column(PmtSetup__FIK_GIRO_No__; PmtSetup."FIK/GIRO-No.")
                {
                }
                column(CompanyInfo_Name; CompanyInfo.Name)
                {
                }
                column(CompanyInfo_Address; CompanyInfo.Address)
                {
                }
                column(CompanyInfo__Post_Code__________CompanyInfo_City; CompanyInfo."Post Code" + ' ' + CompanyInfo.City)
                {
                }
                column(Kroner; Kroner)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(rer; Ører)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(DateText; DateText)
                {
                }
                column(Kroner_Control1160940015; Kroner)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(PaymentID_Control1160940016; PaymentID)
                {
                }
                column(PmtSetup__FIK_GIRO_No________; ' +' + PmtSetup."FIK/GIRO-No." + '<')
                {
                }
                column(PmtSetup__IK_Card_Type_____; '+' + PmtSetup."IK Card Type" + '<')
                {
                }
                column(rer_Control1160940019; Ører)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(Issued_Reminder_Header___Due_Date_Caption; Issued_Reminder_Header___Due_Date_CaptionLbl)
                {
                }
                column(Issued_Reminder_Header___Posting_Date_Caption; Issued_Reminder_Header___Posting_Date_CaptionLbl)
                {
                }
                column(Issued_Reminder_Header___No__Caption; Issued_Reminder_Header___No__CaptionLbl)
                {
                }
                column(Issued_Reminder_Header___Customer_No__Caption; "Issued Reminder Header".FieldCaption("Customer No."))
                {
                }
                column(CompanyInfo__Bank_Account_No__Caption; CompanyInfo__Bank_Account_No__CaptionLbl)
                {
                }
                column(CompanyInfo__Bank_Name_Caption; CompanyInfo__Bank_Name_CaptionLbl)
                {
                }
                column(CompanyInfo__Giro_No__Caption; CompanyInfo__Giro_No__CaptionLbl)
                {
                }
                column(CompanyInfo__VAT_Registration_No__Caption; CompanyInfo__VAT_Registration_No__CaptionLbl)
                {
                }
                column(CompanyInfo__Fax_No__Caption; CompanyInfo__Fax_No__CaptionLbl)
                {
                }
                column(CompanyInfo__Phone_No__Caption; CompanyInfo__Phone_No__CaptionLbl)
                {
                }
                column(RykkermeddelelseCaption; RykkermeddelelseCaptionLbl)
                {
                }
                column(CompanyInfo__IBAN__PM__Caption; CompanyInfo__IBAN__PM__CaptionLbl)
                {
                }
                column(Integer_Number; Number)
                {
                }
                dataitem(DimensionLoop; "Integer")
                {
                    DataItemLinkReference = "Issued Reminder Header";
                    DataItemTableView = SORTING (Number) WHERE (Number = FILTER (1 ..));
                    column(DimText; DimText)
                    {
                    }
                    column(Number; DimensionLoop.Number)
                    {
                    }
                    column(DimText_Control93; DimText)
                    {
                    }
                    column(Dimensioner___hovedCaption; Dimensioner___hovedCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if Number = 1 then begin
                            if not DimSetEntry.FindSet then
                                CurrReport.Break;
                        end else
                            if not Continue then
                                CurrReport.Break;

                        Clear(DimText);
                        Continue := false;
                        repeat
                            OldDimText := DimText;
                            if DimText = '' then
                                DimText := StrSubstNo('%1 - %2', DimSetEntry."Dimension Code", DimSetEntry."Dimension Value Code")
                            else
                                DimText :=
                                  StrSubstNo(
                                    '%1; %2 - %3', DimText,
                                    DimSetEntry."Dimension Code", DimSetEntry."Dimension Value Code");
                            if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                DimText := OldDimText;
                                Continue := true;
                                exit;
                            end;
                        until (DimSetEntry.Next = 0);
                    end;

                    trigger OnPreDataItem()
                    begin
                        if not ShowInternalInfo then
                            CurrReport.Break;
                    end;
                }
                dataitem("Issued Reminder Line"; "Issued Reminder Line")
                {
                    DataItemLink = "Reminder No." = FIELD ("No.");
                    DataItemLinkReference = "Issued Reminder Header";
                    DataItemTableView = SORTING ("Reminder No.", "Line No.");
                    column(Issued_Reminder_Line__Remaining_Amount_; "Remaining Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(Issued_Reminder_Line_Description; Description)
                    {
                    }
                    column(Type; Format("Issued Reminder Line".Type, 0, 2))
                    {
                    }
                    column(Issued_Reminder_Line__Document_Date_; Format("Document Date"))
                    {
                    }
                    column(Issued_Reminder_Line__Document_No__; "Document No.")
                    {
                    }
                    column(Issued_Reminder_Line__Due_Date_; Format("Due Date"))
                    {
                    }
                    column(Issued_Reminder_Line__Remaining_Amount__Control40; "Remaining Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(Issued_Reminder_Line__Original_Amount_; "Original Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(Issued_Reminder_Line__Document_Type_; "Document Type")
                    {
                    }
                    column(Issued_Reminder_Line_Description_Control31; Description)
                    {
                    }
                    column(Issued_Reminder_Line__Remaining_Amount__Control38; "Remaining Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(Issued_Reminder_Line__No__; "No.")
                    {
                    }
                    column(ShowInternalInfo; ShowInternalInfo)
                    {
                    }
                    column(Issued_Reminder_Line__Remaining_Amount__Control95; "Remaining Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(Issued_Reminder_Line_Description_Control96; Description)
                    {
                    }
                    column(Issued_Reminder_Line__Remaining_Amount__Control42; "Remaining Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(ReminderInterestAmount; ReminderInterestAmount)
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(NNC_InterestAmount; NNC_InterestAmount)
                    {
                    }
                    column(Remaining_Amount____ReminderInterestAmount; "Remaining Amount" + ReminderInterestAmount)
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(TotalText; TotalText)
                    {
                    }
                    column(NNC_Total; NNC_Total)
                    {
                    }
                    column(Remaining_Amount____ReminderInterestAmount____VAT_Amount_; "Remaining Amount" + ReminderInterestAmount + "VAT Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(TotalInclVATText; TotalInclVATText)
                    {
                    }
                    column(Issued_Reminder_Line__VAT_Amount_; "VAT Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(NNC_VATAmount; NNC_VATAmount)
                    {
                    }
                    column(NNC_TotalInclVAT; NNC_TotalInclVAT)
                    {
                    }
                    column(Issued_Reminder_Line__Document_Date_Caption; Issued_Reminder_Line__Document_Date_CaptionLbl)
                    {
                    }
                    column(Issued_Reminder_Line__Document_No__Caption; FieldCaption("Document No."))
                    {
                    }
                    column(Issued_Reminder_Line__Due_Date_Caption; Issued_Reminder_Line__Due_Date_CaptionLbl)
                    {
                    }
                    column(Issued_Reminder_Line__Remaining_Amount__Control40Caption; FieldCaption("Remaining Amount"))
                    {
                    }
                    column(Issued_Reminder_Line__Original_Amount_Caption; FieldCaption("Original Amount"))
                    {
                    }
                    column(Issued_Reminder_Line__Document_Type_Caption; FieldCaption("Document Type"))
                    {
                    }
                    column(Issued_Reminder_Line__Remaining_Amount_Caption; Issued_Reminder_Line__Remaining_Amount_CaptionLbl)
                    {
                    }
                    column(Issued_Reminder_Line__Remaining_Amount__Control42Caption; Issued_Reminder_Line__Remaining_Amount__Control42CaptionLbl)
                    {
                    }
                    column(ReminderInterestAmountCaption; ReminderInterestAmountCaptionLbl)
                    {
                    }
                    column(Issued_Reminder_Line__VAT_Amount_Caption; FieldCaption("VAT Amount"))
                    {
                    }
                    column(Issued_Reminder_Line_Reminder_No_; "Reminder No.")
                    {
                    }
                    column(Issued_Reminder_Line_Line_No_; "Line No.")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        VATAmountLine.Init;
                        VATAmountLine."VAT Identifier" := "VAT Identifier";
                        VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
                        VATAmountLine."Tax Group Code" := "Tax Group Code";
                        VATAmountLine."VAT %" := "VAT %";
                        VATAmountLine."VAT Base" := Amount;
                        VATAmountLine."VAT Amount" := "VAT Amount";
                        VATAmountLine."Amount Including VAT" := Amount + "VAT Amount";
                        VATAmountLine.InsertLine;

                        case Type of
                            Type::"G/L Account":
                                "Remaining Amount" := Amount;
                            Type::"Customer Ledger Entry":
                                ReminderInterestAmount := Amount;
                        end;

                        NNC_InterestAmountTotal += ReminderInterestAmount;
                        NNC_RemainingAmountTotal += "Remaining Amount";
                        NNC_VATAmountTotal += "VAT Amount";

                        NNC_InterestAmount := NNC_InterestAmountTotal;
                        NNC_Total := NNC_RemainingAmountTotal + NNC_InterestAmountTotal;
                        NNC_VATAmount := NNC_VATAmountTotal;
                        NNC_TotalInclVAT := NNC_RemainingAmountTotal + NNC_InterestAmountTotal + NNC_VATAmountTotal;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if Find('+') then begin
                            EndLineNo := "Line No." + 1;
                            repeat
                                Continue := Type = Type::" ";
                                if Continue and (Description = '') then
                                    EndLineNo := "Line No.";
                            until (Next(-1) = 0) or not Continue;
                        end;

                        VATAmountLine.DeleteAll;
                        SetFilter("Line No.", '<%1', EndLineNo);
                        CurrReport.CreateTotals("Remaining Amount", "VAT Amount", ReminderInterestAmount);
                    end;
                }
                dataitem(IssuedReminderLine2; "Issued Reminder Line")
                {
                    DataItemLink = "Reminder No." = FIELD ("No.");
                    DataItemLinkReference = "Issued Reminder Header";
                    DataItemTableView = SORTING ("Reminder No.", "Line No.");
                    column(IssuedReminderLine2_Description; Description)
                    {
                    }
                    column(IssuedReminderLine2_Reminder_No_; "Reminder No.")
                    {
                    }
                    column(IssuedReminderLine2_Line_No_; "Line No.")
                    {
                    }

                    trigger OnPreDataItem()
                    begin
                        SetFilter("Line No.", '>=%1', EndLineNo);
                    end;
                }
                dataitem(VATCounter; "Integer")
                {
                    DataItemTableView = SORTING (Number);
                    column(VATAmountLine__Amount_Including_VAT_; VATAmountLine."Amount Including VAT")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VATAmountLine__VAT_Amount_; VATAmountLine."VAT Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VATAmountLine__VAT_Base_; VATAmountLine."VAT Base")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VATAmountLine__Amount_Including_VAT__Control70; VATAmountLine."Amount Including VAT")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VATAmountLine__VAT_Amount__Control71; VATAmountLine."VAT Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VATAmountLine__VAT_Base__Control72; VATAmountLine."VAT Base")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VATAmountLine__VAT___; VATAmountLine."VAT %")
                    {
                    }
                    column(VATAmountLine__Amount_Including_VAT__Control78; VATAmountLine."Amount Including VAT")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VATAmountLine__VAT_Amount__Control79; VATAmountLine."VAT Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VATAmountLine__VAT_Base__Control80; VATAmountLine."VAT Base")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VATAmountLine__VAT_Amount__Control82; VATAmountLine."VAT Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VATAmountLine__VAT_Base__Control83; VATAmountLine."VAT Base")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VATAmountLine__Amount_Including_VAT__Control85; VATAmountLine."Amount Including VAT")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VATAmountLine__Amount_Including_VAT__Control70Caption; VATAmountLine__Amount_Including_VAT__Control70CaptionLbl)
                    {
                    }
                    column(VATAmountLine__VAT_Amount__Control71Caption; VATAmountLine__VAT_Amount__Control71CaptionLbl)
                    {
                    }
                    column(VATAmountLine__VAT_Base__Control72Caption; VATAmountLine__VAT_Base__Control72CaptionLbl)
                    {
                    }
                    column(VATAmountLine__VAT___Caption; VATAmountLine__VAT___CaptionLbl)
                    {
                    }
                    column(Momsbel_bspecifikationCaption; Momsbel_bspecifikationCaptionLbl)
                    {
                    }
                    column(VATAmountLine__VAT_Base_Caption; VATAmountLine__VAT_Base_CaptionLbl)
                    {
                    }
                    column(VATAmountLine__VAT_Base__Control80Caption; VATAmountLine__VAT_Base__Control80CaptionLbl)
                    {
                    }
                    column(VATAmountLine__VAT_Base__Control83Caption; VATAmountLine__VAT_Base__Control83CaptionLbl)
                    {
                    }
                    column(VATCounter_Number; Number)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        VATAmountLine.GetLine(Number);
                    end;

                    trigger OnPostDataItem()
                    begin
                        // <PM>
                        LastPage := true;
                        // </PM>
                    end;

                    trigger OnPreDataItem()
                    begin
                        if "Issued Reminder Line"."VAT Amount" = 0 then
                            CurrReport.Break;
                        SetRange(Number, 1, VATAmountLine.Count);
                        CurrReport.CreateTotals(VATAmountLine."VAT Base", VATAmountLine."VAT Amount", VATAmountLine."Amount Including VAT");
                    end;
                }
                dataitem(LastPageSeparator; "Integer")
                {
                    DataItemTableView = SORTING (Number) WHERE (Number = CONST (1));
                    column(KronerLP; Kroner)
                    {
                        DecimalPlaces = 0 : 0;
                    }
                    column(rerLP; Ører)
                    {
                        DecimalPlaces = 0 : 0;
                    }
                    column(DateTextLP; DateText)
                    {
                    }
                    column(LastPage; LastPage)
                    {
                    }
                    column(LastPageSeparator_Number; Number)
                    {
                    }

                    trigger OnPreDataItem()
                    begin
                        // <PM>
                        LastPage := true;
                        if (not LastPage) or (not LocalCurrency) then begin
                            Kroner := InsertSpaces('*********');
                            Ører := InsertSpaces('**');
                            DateText := '';
                        end else begin
                            Kroner := InsertSpaces(Format(AmountForPayment, 0, '<Integer>'));
                            Ører := Format(Abs(AmountForPayment - Round(AmountForPayment, 1, '<')) * 100);
                            Ører := CopyStr('00' + Ører, StrLen(Ører) + 1, 2);
                            DateText := InsertSpaces(Format(Due, 0, '<Day,2><Month,2><Year,2>'));
                        end;
                        // </PM>
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.Language := Language.GetLanguageID("Language Code");

                DimSetEntry.SetRange("Dimension Set ID", "Dimension Set ID");

                FormatAddrCodeunit.IssuedReminder(CustAddr, "Issued Reminder Header");
                if "Your Reference" = '' then
                    ReferenceText := ''
                else
                    ReferenceText := FieldCaption("Your Reference");
                if "VAT Registration No." = '' then
                    VATNoText := ''
                else
                    VATNoText := FieldCaption("VAT Registration No.");
                if "Currency Code" = '' then begin
                    GLSetup.TestField("LCY Code");
                    TotalText := StrSubstNo(Text000, GLSetup."LCY Code");
                    TotalInclVATText := StrSubstNo(Text001, GLSetup."LCY Code");
                end else begin
                    TotalText := StrSubstNo(Text000, "Currency Code");
                    TotalInclVATText := StrSubstNo(Text001, "Currency Code");
                end;
                CurrReport.PageNo := 1;

                if not CurrReport.Preview then begin
                    if LogInteraction then
                        SegManagement.LogDocument(
                          8, "No.", 0, 0, DATABASE::Customer, "Customer No.", '', '', "Posting Description", '');
                    IncrNoPrinted;
                end;

                // <PM>
                LastPage := false;
                LocalCurrency := "Currency Code" in ['', GLSetup."LCY Code"];

                case PmtSetup."IK Card Type" of
                    '01':
                        PmtIDLength := 0;
                    '04':
                        PmtIDLength := 16;
                    '15':
                        PmtIDLength := 16;
                    '41':
                        PmtIDLength := 10;
                    '71':
                        PmtIDLength := 15;
                    '73':
                        PmtIDLength := 0;
                    '75':
                        PmtIDLength := 16;
                    else
                        PmtIDLength := 0;
                end;

                if PmtIDLength > 0 then begin
                    PaymentID := PadStr('', PmtIDLength - 2 - StrLen("No."), '0') + "No." + '2';
                    PaymentID := PaymentID + Modulus10(PaymentID);
                end else
                    PaymentID := PadStr('', PmtIDLength, '0');
                // </PM>

                NNC_InterestAmountTotal := 0;
                NNC_RemainingAmountTotal := 0;
                NNC_VATAmountTotal := 0;
                NNC_InterestAmount := 0;
                NNC_Total := 0;
                NNC_VATAmount := 0;
                NNC_TotalInclVAT := 0;
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get;
                FormatAddrCodeunit.Company(CompanyAddr, CompanyInfo);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        Caption = 'Show Internal Information';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := true;
        end;

        trigger OnOpenPage()
        begin
            LogInteraction := SegManagement.FindInteractTmplCode(8) <> '';
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GLSetup.Get;
        // <PM>
        PmtSetup.Get;
        // </PM>
    end;

    var
        Text000: Label 'Total %1';
        Text001: Label 'Total %1 Incl. VAT';
        Text002: Label 'Page %1';
        GLSetup: Record "General Ledger Setup";
        CompanyInfo: Record "Company Information";
        VATAmountLine: Record "VAT Amount Line" temporary;
        DimSetEntry: Record "Dimension Set Entry";
        Language: Record Language;
        FormatAddrCodeunit: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        CustAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        VATNoText: Text[30];
        ReferenceText: Text[30];
        TotalText: Text[50];
        TotalInclVATText: Text[50];
        ReminderInterestAmount: Decimal;
        EndLineNo: Integer;
        Continue: Boolean;
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        LogInteraction: Boolean;
        "<PM>": Integer;
        PmtSetup: Record "Payment Setup";
        LastPage: Boolean;
        LocalCurrency: Boolean;
        Kroner: Text[20];
        "Ører": Text[3];
        DateText: Text[30];
        PaymentID: Code[16];
        Due: Date;
        AmountForPayment: Decimal;
        PmtIDLength: Integer;
        "</PM>": Integer;
        NNC_InterestAmount: Decimal;
        NNC_Total: Decimal;
        NNC_VATAmount: Decimal;
        NNC_TotalInclVAT: Decimal;
        NNC_InterestAmountTotal: Decimal;
        NNC_RemainingAmountTotal: Decimal;
        NNC_VATAmountTotal: Decimal;
        [InDataSet]
        LogInteractionEnable: Boolean;
        AddFeeInclVAT: Decimal;
        VATInterest: Decimal;
        VALVATBase: Decimal;
        VALVATAmount: Decimal;
        Interest: Decimal;
        Issued_Reminder_Header___Due_Date_CaptionLbl: Label 'Due Date';
        Issued_Reminder_Header___Posting_Date_CaptionLbl: Label 'Posting Date';
        Issued_Reminder_Header___No__CaptionLbl: Label 'Reminder No.';
        CompanyInfo__Bank_Account_No__CaptionLbl: Label 'Account No.';
        CompanyInfo__Bank_Name_CaptionLbl: Label 'Bank';
        CompanyInfo__Giro_No__CaptionLbl: Label 'Giro No.';
        CompanyInfo__VAT_Registration_No__CaptionLbl: Label 'VAT Reg. No.';
        CompanyInfo__Fax_No__CaptionLbl: Label 'Fax No.';
        CompanyInfo__Phone_No__CaptionLbl: Label 'Phone No.';
        RykkermeddelelseCaptionLbl: Label 'Reminder';
        CompanyInfo__IBAN__PM__CaptionLbl: Label 'IBAN';
        Dimensioner___hovedCaptionLbl: Label 'Header Dimensions';
        Issued_Reminder_Line__Document_Date_CaptionLbl: Label 'Document Date';
        Issued_Reminder_Line__Due_Date_CaptionLbl: Label 'Due Date';
        Issued_Reminder_Line__Remaining_Amount_CaptionLbl: Label 'Continued';
        Issued_Reminder_Line__Remaining_Amount__Control42CaptionLbl: Label 'Continued';
        ReminderInterestAmountCaptionLbl: Label 'Interest Amount';
        VATAmountLine__Amount_Including_VAT__Control70CaptionLbl: Label 'Amount Including VAT';
        VATAmountLine__VAT_Amount__Control71CaptionLbl: Label 'VAT Amount';
        VATAmountLine__VAT_Base__Control72CaptionLbl: Label 'VAT Base';
        VATAmountLine__VAT___CaptionLbl: Label 'VAT %';
        Momsbel_bspecifikationCaptionLbl: Label 'VAT Amount Specification';
        VATAmountLine__VAT_Base_CaptionLbl: Label 'Continued';
        VATAmountLine__VAT_Base__Control80CaptionLbl: Label 'Continued';
        VATAmountLine__VAT_Base__Control83CaptionLbl: Label 'Total';

    procedure Modulus10(TestNumber: Code[16]): Code[16]
    var
        Counter: Integer;
        Accumulator: Integer;
        WeightNo: Integer;
        SumStr: Text[30];
    begin
        // <PM>
        WeightNo := 2;
        SumStr := '';
        for Counter := StrLen(TestNumber) downto 1 do begin
            Evaluate(Accumulator, CopyStr(TestNumber, Counter, 1));
            Accumulator := Accumulator * WeightNo;
            SumStr := SumStr + Format(Accumulator);
            if WeightNo = 1 then
                WeightNo := 2
            else
                WeightNo := 1;
        end;
        Accumulator := 0;
        for Counter := 1 to StrLen(SumStr) do begin
            Evaluate(WeightNo, CopyStr(SumStr, Counter, 1));
            Accumulator := Accumulator + WeightNo;
        end;
        Accumulator := 10 - (Accumulator mod 10);
        if Accumulator = 10 then
            exit('0')
        else
            exit(Format(Accumulator));
        // </PM>
    end;

    procedure InsertSpaces(Text: Text[30]): Text[30]
    var
        j: Integer;
    begin
        // <PM>
        for j := 1 to StrLen(Text) - 1 do begin
            Text := InsStr(Text, ' ', 2 * j);
        end;
        exit(Text);
        // </PM>
    end;
}

