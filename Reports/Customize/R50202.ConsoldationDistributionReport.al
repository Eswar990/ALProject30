report 50202 ConsoldationDistributionReport
{
    ApplicationArea = All;
    Caption = 'Consoldation Distribution Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Layout/50202.ConsoldationDistributionReport.rdl';
    dataset
    {
        dataitem(CopyDistributionRule; "Copy Distribution Rule")
        {
            RequestFilterFields = "Posting Date", "G/L Account No.", "Shortcut Dimension 2 Code",
                 "Shortcut Dimension 3 Code", "Shortcut Dimension 1 Code" /*"Entry No.", "Document No."*/;

            trigger OnPreDataItem()
            begin
                CompInfo.Get();
                TxtFilter := GetFilters();
                Clear(CopyDistributionRule);
                GlAccountNo := GetFilter("G/L Account No.");
                PostingDate := GetFilter("Posting Date");
                ShortcutDimension1Code := GetFilter("Shortcut Dimension 1 Code");
                CopyDistributionRule.SetFilter("G/L Account No.", GlAccountNo);
                CopyDistributionRule.SetFilter("Posting Date", PostingDate);
                // if ShortcutDimension1Code = '' then
                //     CopyDistributionRule.SetRange("Global Dimension 1 Code", 'NA')

                // else
                //     CopyDistributionRule.SetFilter("Global Dimension 1 Code", ShortcutDimension1Code);
                // if CopyDistributionRule.FindFirst() then
                //     repeat
                //         // if CopyDistributionRule."Credit Amount" <> 0 then
                //     InitGLEntryTemp();
                // until CopyDistributionRule.Next() = 0;
            end;

            trigger OnAfterGetRecord()
            begin
                if ("G/L Account No." = '') then
                    CurrReport.Skip();
                if ("Shortcut Dimension 1 Code" = '') then
                    CurrReport.Skip();
                InitDistributiomRuleTemp();
            end;

            trigger OnPostDataItem()
            begin
                Clear(TempCopyDistributionRule);
                TempCopyDistributionRule.SetCurrentKey("G/L Account No.", "Posting Date",
                    "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Shortcut Dimension 3 Code");
            end;
        }
        dataitem(IntegerLoop; Integer)
        {
            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
            column(TxtFilter; TxtFilter)
            {

            }
            column(CompInfoName; CompInfo.Name)
            {

            }
            column(TempCopyDistributionRuleGLAccNo; TempCopyDistributionRule."G/L Account No.")
            {

            }
            column(GLAccName; GLAccName)
            {

            }
            column(Posting_Date; TempCopyDistributionRule."Posting Date")
            {

            }
            column(TempCopyDistributionRuleDoc; GLEntry."Document No.")
            {

            }
            column(TempCopyDistributionRuleEmpNo; TempCopyDistributionRule."Shortcut Dimension 1 Code")
            {

            }
            column(EmpName; EmpName)
            {

            }
            column(TempCopyDistributionRuleEmpBranch; TempCopyDistributionRule."Shortcut Dimension 2 Code")
            {

            }
            column(TempCopyDistributionRuleEmpProject; TempCopyDistributionRule."Shortcut Dimension 3 Code")
            {

            }
            column(TempCopyDistributionRuleDebit; DebitAmountAllocated)
            {

            }
            column(TempCopyDistributionRuleCredit; CreditAmountAllocated)
            {

            }
            column(TempCopyDistributionRuleEntryNo; TempCopyDistributionRule."Entry No.")
            {

            }
            column(TotalAmount; TotalAmount)
            {

            }
            column(DebitAmountAllocated2; DebitAmountAllocated2)
            {

            }
            column(CreditAmountAllocated2; CreditAmountAllocated2)
            {

            }
            trigger OnAfterGetRecord()
            var
                DimValue: Record "Dimension Value";
                DistributionRules: Record "Distribution Rule";
            begin
                Clear(GLAccName);
                Clear(EmpName);
                if Number = 1 then begin
                    if (TempCopyDistributionRule.FindSet(false) = false) then
                        CurrReport.Break();
                end else
                    if (TempCopyDistributionRule.Next() = 0) then
                        CurrReport.Break();

                Clear(GLEntry);
                Clear(DebitAmountAllocated);
                Clear(CreditAmountAllocated);

                GlAccounts.Get(TempCopyDistributionRule."G/L Account No.");
                GLAccName := GlAccounts.Name;
                DimValue.Get('EMPLOYEE', TempCopyDistributionRule."Shortcut Dimension 1 Code");
                EmpName := DimValue.Name;
                // GLEntry.CalcFields("Account Category");
                // DistributionRules.SetRange("Entry No.", TempCopyDistributionRule."Entry No.");
                // DistributionRules.SetRange("Shortcut Dimension 1 Code", TempCopyDistributionRule."Shortcut Dimension 1 Code");
                // DistributionRules.SetRange("Shortcut Dimension 2 Code", TempCopyDistributionRule."Shortcut Dimension 2 Code");
                // DistributionRules.SetRange("Shortcut Dimension 3 Code", TempCopyDistributionRule."Shortcut Dimension 3 Code");
                // DistributionRules.FindFirst();
                // if ((GLEntry."Account Category"::Expense) = GLEntry."Account Category") then begin
                //     DebitAmountAllocated := DistributionRules."Amount Allocated";
                //     DebitAmountAllocated2 += DistributionRules."Amount Allocated";
                // end;

                // if ((GLEntry."Account Category"::Income) = GLEntry."Account Category") then begin
                //     CreditAmountAllocated := DistributionRules."Amount Allocated";
                //     CreditAmountAllocated2 += DistributionRules."Amount Allocated";
                // end;
                // TotalAmount += CreditAmountAllocated2 - DebitAmountAllocated2;
                Commit();
            end;
        }
    }
    local procedure InitGLEntryTemp()
    begin
        Inx += 1;
        Clear(TempCopyDistributionRule);
        TempCopyDistributionRule."Entry No." := GLEntry."Entry No.";
        TempCopyDistributionRule."Line No." := Inx;
        TempCopyDistributionRule."G/L Account No." := GLEntry."G/L Account No.";
        TempCopyDistributionRule."Posting Date" := GLEntry."Posting Date";
        TempCopyDistributionRule."Document No." := GLEntry."Document No.";
        TempCopyDistributionRule."Shortcut Dimension 1 Code" := GLEntry."Global Dimension 1 Code";
        TempCopyDistributionRule."Shortcut Dimension 2 Code" := GLEntry."Global Dimension 2 Code";
        TempCopyDistributionRule."Shortcut Dimension 3 Code" := GLEntry."Shortcut Dimension 3 Code";
        TempCopyDistributionRule."Amount Allocated" := GLEntry."Credit Amount";
        TempCopyDistributionRule.Insert();
    end;

    local procedure InitDistributiomRuleTemp()
    begin
        Inx += 1;
        Clear(TempCopyDistributionRule);
        Clear(CreditAmountAllocated);
        Clear(DebitAmountAllocated);
        TempCopyDistributionRule."Entry No." := CopyDistributionRule."Entry No.";
        TempCopyDistributionRule."Line No." := Inx;
        TempCopyDistributionRule."G/L Account No." := CopyDistributionRule."G/L Account No.";
        TempCopyDistributionRule."Posting Date" := CopyDistributionRule."Posting Date";
        TempCopyDistributionRule."Document No." := CopyDistributionRule."Document No.";
        TempCopyDistributionRule."Shortcut Dimension 1 Code" := CopyDistributionRule."Shortcut Dimension 1 Code";
        TempCopyDistributionRule."Shortcut Dimension 2 Code" := CopyDistributionRule."Shortcut Dimension 2 Code";
        TempCopyDistributionRule."Shortcut Dimension 3 Code" := CopyDistributionRule."Shortcut Dimension 3 Code";
        TempCopyDistributionRule.Insert(false);
        Commit();
    end;

    var
        CompInfo: Record "Company Information";
        GLEntry: Record "G/L Entry";
        TempCopyDistributionRule: Record "Copy Distribution Rule" temporary;
        TempDistributionPrjectLine: Record "Distribution Project Line" temporary;
        GlAccounts: Record "G/L Account";
        DebitAmountAllocated: Decimal;
        CreditAmountAllocated: Decimal;
        DebitAmountAllocated2: Decimal;
        CreditAmountAllocated2: Decimal;
        TxtFilter: Text;
        GlAccountNo: Text;
        PostingDate: Text;
        ShortcutDimension1Code: Text;
        EmpName: Text[100];
        GLAccName: Text[100];
        Inx: Integer;
        TotalDebitAmount: Decimal;
        TotalCreditAmount: Decimal;
        TotalAmount: Decimal;
}