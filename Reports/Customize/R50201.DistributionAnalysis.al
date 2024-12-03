report 50201 "Distribution Analysis"
{
    ApplicationArea = All;
    Caption = 'Distribution Analysis';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Layout/50201.DistributionAnalysis.rdl';
    dataset
    {
        dataitem(DistributionRule; "Distribution Rule")
        {
            RequestFilterFields = "Posting Date", "G/L Account No.", "Shortcut Dimension 2 Code",
                 "Shortcut Dimension 3 Code", "Shortcut Dimension 1 Code", "Document No.", "Entry No.";

            trigger OnPreDataItem()
            begin
                CompInfo.Get();
                TxtFilter := GetFilters();
                Clear(GLEntry);
                GLEntry.SetFilter("G/L Account No.", GetFilter("G/L Account No."));
                GLEntry.SetFilter("Posting Date", GetFilter("Posting Date"));
                if GetFilter("Shortcut Dimension 1 Code") = '' then
                    GLEntry.SetRange("Global Dimension 1 Code", 'NA')
                else
                    GLEntry.SetFilter("Global Dimension 1 Code", GetFilter("Shortcut Dimension 1 Code"));
                if GLEntry.FindFirst() then
                    repeat
                        if GLEntry."Credit Amount" <> 0 then
                            InitGLEntryTemp();
                    until GLEntry.Next() = 0;
            end;

            trigger OnAfterGetRecord()
            begin
                if "G/L Account No." = '' then
                    CurrReport.Skip();
                if "Shortcut Dimension 1 Code" = '' then
                    CurrReport.Skip();
                InitDistributiomRuleTemp();
            end;

            trigger OnPostDataItem()
            begin
                Clear(TempDistRule);
                TempDistRule.SetCurrentKey("G/L Account No.", "Posting Date",
                    "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Shortcut Dimension 3 Code", "Document No.", "Entry No.");
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
            column(TempDistRuleGLAccNo; TempDistRule."G/L Account No.")
            {

            }
            column(GLAccName; GLAccName)
            {

            }
            column(Posting_Date; TempDistRule."Posting Date")
            {

            }
            column(TempDistRuleDoc; TempDistRule."Document No.")
            {

            }
            column(TempDistRuleEmpNo; TempDistRule."Shortcut Dimension 1 Code")
            {

            }
            column(EmpName; EmpName)
            {

            }
            column(TempDistRuleEmpBranch; TempDistRule."Shortcut Dimension 2 Code")
            {

            }
            column(TempDistRuleEmpProject; TempDistRule."Shortcut Dimension 3 Code")
            {

            }
            column(TempDistRuleDebit; DebitAmountAllocated)
            {

            }
            column(TempDistRuleCredit; CreditAmountAllocated)
            {

            }
            column(TempDistRuleEntryNo; TempDistRule."Entry No.")
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
            column(CompanyName; TempDistRule."Company Name")
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
                    if (TempDistRule.FindSet(false) = false) then
                        CurrReport.Break();
                end else
                    if (TempDistRule.Next() = 0) then
                        CurrReport.Break();

                Clear(GLEntry);
                Clear(GLAccName);
                Clear(DebitAmountAllocated);
                Clear(CreditAmountAllocated);

                GLAccount.Get(TempDistRule."G/L Account No.");
                GLAccName := GLAccount.Name;
                DimValue.Get('EMPLOYEE', TempDistRule."Shortcut Dimension 1 Code");
                EmpName := DimValue.Name;
                DistributionRules.SetRange("Entry No.", TempDistRule."Entry No.");
                DistributionRules.SetRange("Shortcut Dimension 1 Code", TempDistRule."Shortcut Dimension 1 Code");
                DistributionRules.SetRange("Shortcut Dimension 2 Code", TempDistRule."Shortcut Dimension 2 Code");
                DistributionRules.SetRange("Shortcut Dimension 3 Code", TempDistRule."Shortcut Dimension 3 Code");
                DistributionRules.SetRange("Company Name", TempDistRule."Company Name");
                DistributionRules.FindFirst();
                if ((DistributionRules."Account Category"::Expense) = DistributionRules."Account Category") then begin
                    DebitAmountAllocated := DistributionRules."Amount Allocated";
                end;

                if ((DistributionRules."Account Category"::Income) = DistributionRules."Account Category") then begin
                    CreditAmountAllocated := DistributionRules."Amount Allocated";
                end;
                TotalAmount += CreditAmountAllocated2 - DebitAmountAllocated2;
                Commit();
            end;
        }
    }

    local procedure InitGLEntryTemp()
    begin
        Inx += 1;
        Clear(TempDistRule);
        TempDistRule."Entry No." := GLEntry."Entry No.";
        TempDistRule."Line No." := Inx;
        TempDistRule."G/L Account No." := GLEntry."G/L Account No.";
        TempDistRule."Posting Date" := GLEntry."Posting Date";
        TempDistRule."Document No." := GLEntry."Document No.";
        TempDistRule."Shortcut Dimension 1 Code" := GLEntry."Global Dimension 1 Code";
        TempDistRule."Shortcut Dimension 2 Code" := GLEntry."Global Dimension 2 Code";
        TempDistRule."Shortcut Dimension 3 Code" := GLEntry."Shortcut Dimension 3 Code";
        TempDistRule."Amount Allocated" := GLEntry."Credit Amount";
        TempDistRule.Insert(false);
    end;

    local procedure InitDistributiomRuleTemp()
    begin
        Inx += 1;
        Clear(TempDistRule);
        Clear(CreditAmountAllocated);
        Clear(DebitAmountAllocated);
        TempDistRule."Entry No." := DistributionRule."Entry No.";
        TempDistRule."Line No." := Inx;
        TempDistRule."G/L Account No." := DistributionRule."G/L Account No.";
        TempDistRule."Posting Date" := DistributionRule."Posting Date";
        TempDistRule."Document No." := DistributionRule."Document No.";
        TempDistRule."Shortcut Dimension 1 Code" := DistributionRule."Shortcut Dimension 1 Code";
        TempDistRule."Shortcut Dimension 2 Code" := DistributionRule."Shortcut Dimension 2 Code";
        TempDistRule."Shortcut Dimension 3 Code" := DistributionRule."Shortcut Dimension 3 Code";
        TempDistRule."Company Name" := DistributionRule."Company Name";
        TempDistRule."Account Category" := DistributionRule."Account Category";
        if ((TempDistRule."Account Category"::Expense) = DistributionRule."Account Category") then begin
            DebitAmountAllocated2 += DistributionRule."Amount Allocated";
        end else
            CreditAmountAllocated2 += DistributionRule."Amount Allocated";
        TempDistRule.Insert(false);
        Commit();
    end;

    var
        CompInfo: Record "Company Information";
        GLEntry: Record "G/L Entry";
        GLAccount: Record "G/L Account";
        TempDistRule: Record "Distribution Rule" temporary;
        DebitAmountAllocated: Decimal;
        CreditAmountAllocated: Decimal;
        DebitAmountAllocated2: Decimal;
        CreditAmountAllocated2: Decimal;
        TxtFilter: Text;
        EmpName: Text[100];
        GLAccName: Text[100];
        Inx: Integer;
        TotalAmount: Decimal;
}