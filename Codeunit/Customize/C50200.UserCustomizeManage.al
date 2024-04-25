codeunit 50200 "User Customize Manage"
{
    Permissions = tabledata "G/L Entry" = rm;
    procedure GetFieldCaption(Inx: Integer; FieldNoTxt: Text): Text[100]

    var
        GenLedSetup: Record "General Ledger Setup";
        Dim: Record Dimension;
    begin
        GenLedSetup.Get();
        GenLedSetup.TestField("Shortcut Dimension 3 Code");
        if Inx = 3 then
            if Dim.Get(GenLedSetup."Shortcut Dimension 3 Code") then
                if FieldNoTxt = '' then
                    exit(Dim.Name)
                else
                    exit(Dim.Name + ' ' + FieldNoTxt);
        if Inx = 4 then
            if Dim.Get(GenLedSetup."Shortcut Dimension 4 Code") then
                exit(Dim.Name);
        if Inx = 5 then
            if Dim.Get(GenLedSetup."Shortcut Dimension 5 Code") then
                exit(Dim.Name);
    end;

    procedure GetDimValueAssigned(ShortDimCodeOne: Code[20]; var ShortDimCodeTwo: Code[20]; var ShortDimCodeThree: Code[20])
    var
        GenLedSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
    begin
        GenLedSetup.Get();
        Clear(ShortDimCodeTwo);
        Clear(ShortDimCodeThree);
        if not DimValue.Get(GenLedSetup."Global Dimension 1 Code", ShortDimCodeOne) then
            exit;
        ShortDimCodeTwo := DimValue."Shortcut Dimension 2 Code";
        ShortDimCodeThree := DimValue."Shortcut Dimension 3 Code";
    end;

    procedure InitDistributionProjectLine(EntryNo: Integer; DocNo: code[20]; NegValue: Boolean; DimTwoCode: Code[20]; DimOneCode: Code[20]; GLAccNo: code[20])
    var
        GLEntry: Record "G/L Entry";
        GLAcc: Record "G/L Account";
        DistProject: Record "Distribution Project";
        DimValue: Record "Dimension Value";
        DimValueTwoCode: Code[20];
        OldDimValueTwoCode: Code[20];
        DimValueThreeCode: Code[20];
        Inx: Integer;
        LineCraeted: Boolean;
    begin
        Clear(DistProject);
        DistProject.SetRange("Entry No.", EntryNo);
        if DistProject.FindSet() then
            exit;
        Clear(GLEntry);
        GLEntry.SetCurrentKey("Document No.");
        GLEntry.SetRange("Document No.", DocNo);
        GLEntry.SetFilter("Global Dimension 1 Code", DimOneCode);
        GLEntry.SetFilter("Global Dimension 2 Code", DimTwoCode);
        GLEntry.SetFilter("G/L Account No.", GLAccNo);
        GLEntry.SetFilter("Account Category", '%1|%2', GLEntry."Account Category"::Income, GLEntry."Account Category"::Expense);
        if not GLEntry.FindSet() then
            exit;
        repeat
            Clear(GLAcc);
            GLAcc.Get(GLEntry."G/L Account No.");
            if not GLAcc."VAT Account" then
                if GLEntry."Dimension Set ID" <> 0 then begin
                    Inx += 1;
                    Clear(DimValueTwoCode);
                    DimValueTwoCode := GetDimValueCode(GLEntry, 2);
                    if Inx = 1 then
                        OldDimValueTwoCode := DimValueTwoCode;
                    if OldDimValueTwoCode <> DimValueTwoCode then
                        Error('Branch code must be same.');
                    Clear(DimValueThreeCode);
                    DimValueThreeCode := GetDimValueCode(GLEntry, 3);
                    if DimValueThreeCode <> '' then begin
                        LineCraeted := true;
                        if DistProject.Get(EntryNo, DimValueThreeCode, DimValueTwoCode) then begin
                            DistProject."Project Amount" += GLEntry."Credit Amount";
                            DistProject.Modify();
                        end
                        else begin
                            Inx += 1;
                            Clear(DistProject);
                            DistProject."Entry No." := EntryNo;
                            DistProject."Shortcut Dimension 2 Code" := DimValueTwoCode;
                            DistProject."Shortcut Dimension 3 Code" := DimValueThreeCode;
                            DistProject."Project Amount" += GLEntry."Credit Amount";
                            DistProject."Project Line" := true;
                            DistProject."Line No." := Inx;
                            DistProject."G/L Account No." := GLEntry."G/L Account No.";
                            DistProject.Insert();
                        end;
                    end;
                end;
        until GLEntry.Next() = 0;
        if LineCraeted then
            exit;
        Clear(Inx);
        Clear(OldDimValueTwoCode);
        GLEntry.FindSet();
        repeat
            if GLEntry."Dimension Set ID" <> 0 then
                if not ProceedDimProjectType(GLEntry) then begin
                    Clear(DimValueTwoCode);
                    DimValueTwoCode := GetDimValueCode(GLEntry, 2);
                    Inx += 1;
                    if Inx = 1 then
                        OldDimValueTwoCode := DimValueTwoCode;
                    if OldDimValueTwoCode <> DimValueTwoCode then
                        Error('Branch code must be same.');
                    DimValue.SetRange("Shortcut Dimension 2 Code", DimValueTwoCode);
                    if DimValue.FindSet() then
                        repeat
                            if DimValue."Shortcut Dimension 3 Code" <> '' then
                                CreateDistProjectValue(EntryNo, DimValueTwoCode, DimValue."Shortcut Dimension 3 Code", GLEntry."G/L Account No.");
                            if DimValue."Shortcut Dimension 3 Two" <> '' then
                                CreateDistProjectValue(EntryNo, DimValueTwoCode, DimValue."Shortcut Dimension 3 Two", GLEntry."G/L Account No.");
                            if DimValue."Shortcut Dimension 3 Three" <> '' then
                                CreateDistProjectValue(EntryNo, DimValueTwoCode, DimValue."Shortcut Dimension 3 Three", GLEntry."G/L Account No.");
                        until DimValue.Next() = 0;
                end;
        until GLEntry.Next() = 0;
        Commit();
    end;

    procedure CreateProjectDistFromDistributionLine(EntryNo: Integer; RecDimensionValueOne: Code[20]; xRecDimensionValueOne: Code[20]; GLAccountNo: Code[20]);
    var
        DistProject: Record "Distribution Project";
        GLEntry: Record "G/L Entry";
    begin
        Clear(DistProject);
        DistProject.SetRange("Entry No.", EntryNo);
        if RecDimensionValueOne <> xRecDimensionValueOne then begin
            DistProject.SetRange("Shortcut Dimension 2 Code", xRecDimensionValueOne);
            if DistProject.FindSet() then begin
                DistProject.DeleteAll(true);
                if RecDimensionValueOne = '' then
                    exit;
            end;
        end;
        DistProject.SetRange("Shortcut Dimension 2 Code", RecDimensionValueOne);
        if DistProject.FindSet() then
            Error('Distribution projects lines exists, please delete projects lines.');

        if (GLEntry.Get(EntryNo) = false) then
            exit
        else
            if (GLEntry."Debit Amount" <> 0) then begin
                DistributionProjectLinesArePopulatedFromDistributionSetup(GLEntry, RecDimensionValueOne, GLAccountNo);
            end
    end;

    procedure CreateProjectDistRuleFilter(EntryNo: Integer; DimValueCode: Code[20]; xDimValueCode: Code[20]; GLAccNo: code[20])
    var
        DistProject: Record "Distribution Project";
        DimValue: Record "Dimension Value";
        GLEntry: Record "G/L Entry";
        GenJrnlDebitedAmount: Boolean;
    begin
        Clear(DistProject);
        DistProject.SetRange("Entry No.", EntryNo);
        if DimValueCode <> xDimValueCode then begin
            DistProject.SetRange("Shortcut Dimension 2 Code", xDimValueCode);
            if DistProject.FindSet() then begin
                DistProject.DeleteAll(true);
                if DimValueCode = '' then
                    exit;
            end;
        end;
        DistProject.SetRange("Shortcut Dimension 2 Code", DimValueCode);
        if DistProject.FindSet() then
            Error('Distribution projects lines exists, please delete projects lines.');

        if (GLEntry.Get(EntryNo) = false) then
            exit
        else
            if (GLEntry."Debit Amount" <> 0) then begin
                GenJrnlDebitedAmount := true;
                DistributionProjectLineInGeneralJournal(EntryNo, DimValueCode, DimValue."Shortcut Dimension 3 Code", GLAccNo, GenJrnlDebitedAmount);
            end
            else begin
                DimValue.SetRange("Shortcut Dimension 2 Code", DimValueCode);
                DimValue.SetRange("Distribute Enable", true);
                if DimValue.FindSet() then
                    repeat
                        if DimValue."Shortcut Dimension 3 Code" <> '' then
                            CreateDistProjectValue(EntryNo, DimValueCode, DimValue."Shortcut Dimension 3 Code", GLAccNo);
                        if DimValue."Shortcut Dimension 3 Two" <> '' then
                            CreateDistProjectValue(EntryNo, DimValueCode, DimValue."Shortcut Dimension 3 Two", GLAccNo);
                        if DimValue."Shortcut Dimension 3 Three" <> '' then
                            CreateDistProjectValue(EntryNo, DimValueCode, DimValue."Shortcut Dimension 3 Three", GLAccNo);
                    until DimValue.Next() = 0;

            end;
    end;

    procedure DistributionProjectLinesArePopulatedFromDistributionSetup(GLEntry: Record "G/L Entry"; RecDimensionValueOne: Code[20]; GLAccNo: code[20])
    var
        DistributionLine: Record "Distribution Line";
        DistributionProject: Record "Distribution Project";
        DistributionRule: Record "Distribution Rule";
        DistributionRuleFilter: Record "Distribution Rule Filter";
        BranchCodeList: List of [Text];
        BranchCodeList2: List of [Text];
        IntegerOfList: Integer;
        IntegerOfList2: Integer;
        EmployeeCount: Integer;
        DistributionProjectLineNo: Integer;
        ProjectIncrementValue: Integer;
        DistRuleIncrementValue: Integer;
        DistributionRuleLineNo: Integer;
        ValueOfText: Text;
        BranchCode: Text;
    begin
        CreateDistributionYearAndDate(GLEntry."Entry No.");
        DistributionLine.SetRange("Shortcut Dimension 2 Code", RecDimensionValueOne);
        DistributionLine.SetRange(Year, DistributionYear);
        DistributionLine.SetRange(Month, DistributionMonth);
        if (DistributionLine.FindSet() = true) then
            repeat
                BranchCodeList.Add(DistributionLine."Shortcut Dimension 2 Code");
                EmployeeCount += 1;
            until DistributionLine.Next() = 0;

        for IntegerOfList := 1 to BranchCodeList.Count do begin
            ValueOfText := BranchCodeList.Get(IntegerOfList);
            if (BranchCodeList2.IndexOf(ValueOfText) = 0) then
                BranchCodeList2.Add(ValueOfText);
        end;

        for IntegerOfList2 := 1 to BranchCodeList2.Count do begin
            if (BranchCode = '') then
                BranchCode := BranchCodeList2.Get(IntegerOfList2)
            else
                BranchCode += '|' + BranchCodeList2.Get(IntegerOfList2)
        end;

        DistributionRuleFilter.Get(GLEntry."Entry No.");
        if (DistributionLine.FindSet(false) = true) then begin
            repeat
                Clear(DistributionProject);
                DistributionProject.Init();
                DistributionProject."Entry No." := GLEntry."Entry No.";
                DistributionProject."Shortcut Dimension 2 Code" := DistributionLine."Shortcut Dimension 2 Code";
                DistributionProject."Shortcut Dimension 3 Code" := DistributionLine."Shortcut Dimension 1 Code";
                DistributionProject."Project Amount" := Round(DistributionRuleFilter."Distrubution Amount" / EmployeeCount, 0.01);
                DistributionProject."Project Line" := true;
                DistributionProject."Line No." := DistributionProjectLineNo + 1000;
                DistributionProject."Emp. Count" := GetEmployeeCountFromDistributionSetup(DistributionYear, DistributionMonth, DistributionLine."Shortcut Dimension 1 Code", BranchCode);
                DistributionProject."G/L Account No." := GLAccNo;
                DistributionProject.Insert();
                ProjectIncrementValue := 1;
                /* Distribution Rule tab is populating values*/
                Clear(DistributionRule);
                DistributionRule.SetRange("Entry No.", GLEntry."Entry No.");
                if (DistributionLine."Shortcut Dimension 3 Code" <> '') then begin
                    DistRuleIncrementValue += 1;
                    DistributionRuleLineNo := InsertDistributionRuleLineFromDistributionSetup(DistributionRuleFilter, DistributionRule, DistributionLine, DistributionRuleLineNo);
                    DistributionRule."Shortcut Dimension 3 Code" := DistributionLine."Shortcut Dimension 3 Code";
                    DistributionRule."Emp. Project Percentage" := DistributionLine."Percentage One";
                    DistributionRule."Posting Date" := GLEntry."Posting Date";
                    DistributionRule.Modify(false);
                end;

                if (DistributionLine."Shortcut Dimension 3 Two" <> '') then begin
                    DistRuleIncrementValue += 1;
                    DistributionRuleLineNo := InsertDistributionRuleLineFromDistributionSetup(DistributionRuleFilter, DistributionRule, DistributionLine, DistributionRuleLineNo);
                    DistributionRule."Shortcut Dimension 3 Code" := DistributionLine."Shortcut Dimension 3 Two";
                    DistributionRule."Emp. Project Percentage" := DistributionLine."Percentage Two";
                    DistributionRule."Posting Date" := GLEntry."Posting Date";
                    DistributionRule.Modify(false);
                end;

                if (DistributionLine."Shortcut Dimension 3 Three" <> '') then begin
                    DistRuleIncrementValue += 1;
                    DistributionRuleLineNo := InsertDistributionRuleLineFromDistributionSetup(DistributionRuleFilter, DistributionRule, DistributionLine, DistributionRuleLineNo);
                    DistributionRule."Shortcut Dimension 3 Code" := DistributionLine."Shortcut Dimension 3 Three";
                    DistributionRule."Emp. Project Percentage" := DistributionLine."Percentage Three";
                    DistributionRule."Posting Date" := GLEntry."Posting Date";
                    DistributionRule.Modify(false);
                end;
                Clear(ProjectIncrementValue);
                Clear(DistRuleIncrementValue);
            until DistributionLine.Next() = 0;
        end;

    end;

    procedure DistributionProjectLineInGeneralJournal(EntryNo: Integer; DimValueCode: Code[20]; xDimValueCode: Code[20]; GLAccNo: code[20]; GenJrnlDebitedAmount: Boolean)
    var
        DistributionLine: Record "Distribution Line";
        GLEntry: Record "G/L Entry";
        DistributionRuleFilter: Record "Distribution Rule Filter";
        DistributionPostingDate: Date;
        EmployeeCode: Code[20];
        PostingDate: Text;
        Month: Text;
        Year: Text;
    begin
        CreateDistributionYearAndDate(EntryNo);
        DistributionLine.SetRange("Shortcut Dimension 2 Code", DimValueCode);
        DistributionLine.SetRange(Year, DistributionYear);
        DistributionLine.SetRange(Month, DistributionMonth);
        if (DistributionLine.FindSet() = true) then
            repeat
                if (DistributionRuleFilter.Get(EntryNo) = true) then
                    if (DistributionRuleFilter."Distrubution Method" = DistributionRuleFilter."Distrubution Method"::Proportion) then begin
                        if DistributionLine."Shortcut Dimension 1 Code" <> '' then begin
                            EmployeeCode := DistributionLine."Shortcut Dimension 1 Code";
                            CreateDistProjectValueFromDistributionLine(EntryNo, DimValueCode, DistributionLine."Shortcut Dimension 3 Code", GLAccNo, DistributionMonth, DistributionYear, EmployeeCode);
                        end
                    end else begin
                        if DistributionLine."Shortcut Dimension 3 Code" <> '' then
                            CreateDistProjectValueGenJournal(EntryNo, DimValueCode, DistributionLine."Shortcut Dimension 3 Code", GLAccNo, DistributionMonth, DistributionYear);
                        if DistributionLine."Shortcut Dimension 3 Two" <> '' then
                            CreateDistProjectValueGenJournal(EntryNo, DimValueCode, DistributionLine."Shortcut Dimension 3 Two", GLAccNo, DistributionMonth, DistributionYear);
                        if DistributionLine."Shortcut Dimension 3 Three" <> '' then
                            CreateDistProjectValueGenJournal(EntryNo, DimValueCode, DistributionLine."Shortcut Dimension 3 Three", GLAccNo, DistributionMonth, DistributionYear);
                    end;

            until DistributionLine.Next() = 0;
    end;

    procedure GetMonthAndYear(GlEntryNo: Integer)
    var
        GlEntry: Record "G/L Entry";
        DistributionPostingDate: Date;
        PostingDate: Text;
        Month: Text;
        Year: Text;
    begin
        if (GlEntry.Get(GlEntryNo) = true) then begin
            DistributionPostingDate := GLEntry."Posting Date";
            PostingDate := Format(DistributionPostingDate); // 01/10/23
            Month := CopyStr(PostingDate, 1, 2);
            Year := CopyStr(PostingDate, 7, 8);
            DistributionYear := InsStr(Year, '20', 1);
            DistributionMonth := ConvertingMonthAndYear(Month);
        end
    end;

    procedure ConvertingMonthAndYear(Month: Text): Text
    var
        MonthDataTxt: Text;
    begin
        case Month of
            '01':
                MonthDataTxt := 'JAN';
            '02':
                MonthDataTxt := 'FEB';
            '03':
                MonthDataTxt := 'MAR';
            '04':
                MonthDataTxt := 'APR';
            '05':
                MonthDataTxt := 'MAY';
            '06':
                MonthDataTxt := 'JUN';
            '07':
                MonthDataTxt := 'JUL';
            '08':
                MonthDataTxt := 'AUG';
            '09':
                MonthDataTxt := 'SEP';
            '10':
                MonthDataTxt := 'OCT';
            '11':
                MonthDataTxt := 'NOV';
            '12':
                MonthDataTxt := 'DEC';
        end;
        exit(MonthDataTxt);
    end;

    local procedure CreateDistProjectValueGenJournal(EntryNo: Integer; DimValueTwoCode: Code[20]; DimValueThreeCode: Code[20]; GLAccNo: code[20]; MonthText2: Text[20]; yeartext2: Text[20])
    var
        DistProject: Record "Distribution Project";
    begin
        Clear(DistProject);
        if DistProject.Get(EntryNo, DimValueThreeCode, DimValueTwoCode) then
            exit;
        Clear(DistProject);
        DistProject."Entry No." := EntryNo;
        DistProject."Shortcut Dimension 2 Code" := DimValueTwoCode;
        DistProject."Shortcut Dimension 3 Code" := DimValueThreeCode;
        DistProject."Emp. Count" := GetEmployeeCountDistributionSetup(DimValueTwoCode, DimValueThreeCode, MonthText2, yeartext2);
        DistProject."G/L Account No." := GLAccNo;
        DistProject."Line No." := 0;
        if (DistProject."Emp. Count" <> 0) then
            DistProject.Insert();

    end;

    local procedure CreateDistProjectValueFromDistributionLine(EntryNo: Integer; DimValueTwoCode: Code[20]; DimValueThreeCode: Code[20]; GLAccNo: code[20]; MonthText2: Text[20]; yeartext2: Text[20]; EmployeeCode: Code[20])
    var
        DistProject: Record "Distribution Project";
    begin
        Clear(DistProject);
        if DistProject.Get(EntryNo, DimValueTwoCode, EmployeeCode) then
            exit;
        Clear(DistProject);
        DistProject."Entry No." := EntryNo;
        DistProject."Shortcut Dimension 2 Code" := DimValueTwoCode;
        DistProject."Shortcut Dimension 3 Code" := EmployeeCode;
        // DistProject."Shortcut Dimension 3 Code" := DimValueThreeCode;
        DistProject."Emp. Count" := GetDistributionLineEmployeeCount(DimValueTwoCode, MonthText2, yeartext2, EmployeeCode);
        // DistProject."Emp. Count" := GetEmployeeCountDistributionSetup(DimValueTwoCode, DimValueThreeCode, MonthText2, yeartext2);
        DistProject."G/L Account No." := GLAccNo;
        DistProject."Line No." := 0;
        if (DistProject."Emp. Count" <> 0) then
            DistProject.Insert();

    end;

    local procedure GetDistributionLineEmployeeCount(DimValueTwoCode: Code[20]; Month: Text[20]; Year: Text[20]; EmployeeCode: Code[20]): Integer
    var
        Distributionline: Record "Distribution Line";
        EmpCount: Integer;
    begin
        Distributionline.SetRange("Shortcut Dimension 2 Code", DimValueTwoCode);
        Distributionline.SetRange("Shortcut Dimension 1 Code", EmployeeCode);
        Distributionline.SetRange(Year, Year);
        Distributionline.SetRange(Month, Month);
        if (Distributionline.FindSet(false) = true) then
            repeat
                EmpCount := Distributionline.Count();
            until Distributionline.Next() = 0;

        exit(EmpCount);
    end;

    local procedure GetEmployeeCountDistributionSetup(DimValueTwoCode: Code[20]; DimValueThreeCode: Code[20]; Month: Text[20]; Year: Text[20]): Integer
    var
        Distributionline: Record "Distribution Line";
        EmpCount: Integer;
    begin
        Distributionline.SetRange("Shortcut Dimension 2 Code", DimValueTwoCode);
        Distributionline.SetRange("Shortcut Dimension 3 Code", DimValueThreeCode);
        Distributionline.SetRange(Year, Year);
        Distributionline.SetRange(Month, Month);
        if (Distributionline.FindFirst() = true) then
            EmpCount := Distributionline.Count();

        Distributionline.SetRange("Shortcut Dimension 3 Code");
        Distributionline.SetRange("Shortcut Dimension 2 Code", DimValueTwoCode);
        Distributionline.SetRange("Shortcut Dimension 3 Two", DimValueThreeCode);
        Distributionline.SetRange(Year, Year);
        Distributionline.SetRange(Month, Month);
        if (Distributionline.FindFirst() = true) then
            EmpCount += Distributionline.Count();

        Distributionline.SetRange("Shortcut Dimension 3 Two");
        Distributionline.SetRange("Shortcut Dimension 3 Three", DimValueThreeCode);
        Distributionline.SetRange(Year, Year);
        Distributionline.SetRange(Month, Month);
        if (Distributionline.FindFirst() = true) then
            EmpCount += Distributionline.Count();

        exit(EmpCount);
    end;

    /* Getting Employee Count From Distribution Line*/
    procedure GetEmployeeCountFromDistributionSetup(Year: Text; Month: Text; EmployeeCode: Code[20]; BranchCode: Text): Integer
    var
        Distributionline: Record "Distribution Line";
        EmpCount: Integer;
    begin
        Distributionline.SetRange(Year, Year);
        Distributionline.SetRange(Month, Month);
        Distributionline.SetRange("Shortcut Dimension 1 Code", EmployeeCode);
        Distributionline.SetFilter("Shortcut Dimension 2 Code", BranchCode);
        if (Distributionline.FindSet() = true) then
            repeat
                Clear(EmpCount);
                EmpCount += 1
            until Distributionline.Next() = 0;
        exit(EmpCount);
    end;

    local procedure CreateDistProjectValue(EntryNo: Integer; DimValueTwoCode: Code[20]; DimValueThreeCode: Code[20]; GLAccNo: code[20])
    var
        DistProject: Record "Distribution Project";
    begin
        Clear(DistProject);
        if DistProject.Get(EntryNo, DimValueThreeCode, DimValueTwoCode) then
            exit;
        Clear(DistProject);
        DistProject."Entry No." := EntryNo;
        DistProject."Shortcut Dimension 2 Code" := DimValueTwoCode;
        DistProject."Shortcut Dimension 3 Code" := DimValueThreeCode;
        DistProject."Emp. Count" := GetEmployeeCount(DimValueTwoCode, DimValueThreeCode);
        DistProject."G/L Account No." := GLAccNo;
        DistProject."Line No." := 0;
        DistProject.Insert();

    end;

    local procedure ProceedDimProjectType(GLEntry: Record "G/L Entry"): Boolean
    var
        GenLedSetup: Record "General Ledger Setup";
        DimSetEntry: Record "Dimension Set Entry";
    begin
        GenLedSetup.Get();
        if DimSetEntry.Get(GLEntry."Dimension Set ID", GenLedSetup."Shortcut Dimension 8 Code") then
            exit(true);
        if DimSetEntry.Get(GLEntry."Dimension Set ID", GenLedSetup."Shortcut Dimension 7 Code") then
            exit(true);
        if DimSetEntry.Get(GLEntry."Dimension Set ID", GenLedSetup."Shortcut Dimension 6 Code") then
            exit(true);
        if DimSetEntry.Get(GLEntry."Dimension Set ID", GenLedSetup."Shortcut Dimension 5 Code") then
            exit(true);
        if DimSetEntry.Get(GLEntry."Dimension Set ID", GenLedSetup."Shortcut Dimension 4 Code") then
            exit(true);
        if DimSetEntry.Get(GLEntry."Dimension Set ID", GenLedSetup."Shortcut Dimension 3 Code") then
            exit(true);
        if DimSetEntry.Get(GLEntry."Dimension Set ID", GenLedSetup."Shortcut Dimension 2 Code") then
            exit(false);

    end;

    local procedure GetDimValueCode(GLEntry: Record "G/L Entry"; ValNo: Integer): Code[20]
    var
        GenLedSetup: Record "General Ledger Setup";
        DimSetEntry: Record "Dimension Set Entry";
    begin
        GenLedSetup.Get();
        if ValNo = 2 then
            if DimSetEntry.Get(GLEntry."Dimension Set ID", GenLedSetup."Shortcut Dimension 2 Code") then
                exit(DimSetEntry."Dimension Value Code");
        if ValNo = 3 then
            if DimSetEntry.Get(GLEntry."Dimension Set ID", GenLedSetup."Shortcut Dimension 3 Code") then
                exit(DimSetEntry."Dimension Value Code");
    end;

    procedure UploadDistributionRuleFromExcel(var DistRule: Record "Distribution Rule")
    var
        DistRuleFilter: Record "Distribution Rule Filter";
        TempExcelBuffer: Record "Excel Buffer" temporary;
        FileManage: Codeunit "File Management";
        InStm: InStream;
        FromFile: Text[250];
        FileName: Text[250];
        UploadExcelMsg: Text[100];
        SheetName: Text[100];
        SheetVal: Decimal;
        EntryNo: Integer;
        LineNo: Integer;
        MaxRowCount: Integer;
        RowCount: Integer;
        LoopInx: Integer;
    begin
        UploadExcelMsg := 'Please select the excel file.';
        UploadIntoStream(UploadExcelMsg, '', '', FromFile, InStm);
        if FromFile <> '' then begin
            FileName := FileManage.GetFileName(FromFile);
            SheetName := TempExcelBuffer.SelectSheetsNameStream(InStm);
        end
        else
            Error('No excel file selected.');
        Clear(TempExcelBuffer);
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.OpenBookStream(InStm, SheetName);
        TempExcelBuffer.ReadSheet();
        Clear(TempExcelBuffer);
        if TempExcelBuffer.FindLast() then
            MaxRowCount := TempExcelBuffer."Row No.";
        Clear(TempExcelBuffer);
        for RowCount := 2 to MaxRowCount do begin
            LoopInx += 1;
            Clear(EntryNo);
            Evaluate(EntryNo, GetValueAtCell(TempExcelBuffer, RowCount, 5));
            if LoopInx = 1 then
                DistRuleFilter.Get(EntryNo);
            DistRule.SetRange("Entry No.", EntryNo);
            Clear(LineNo);
            Evaluate(LineNo, GetValueAtCell(TempExcelBuffer, RowCount, 6));
            DistRule.SetRange("Line No.", LineNo);
            if not DistRule.FindFirst() then
                Error('Line entry not found entry no %1 line no %2.', EntryNo, LineNo);
            Clear(SheetVal);
            Evaluate(SheetVal, GetValueAtCell(TempExcelBuffer, RowCount, 4));
            if DistRuleFilter."Negative Allocation" then
                DistRule.Validate("Amount Allocated", -SheetVal)
            else
                DistRule.Validate("Amount Allocated", SheetVal);
            DistRule.Modify();
        end;
        Message('Allocation amount update process completed.');
    end;

    local procedure GetValueAtCell(var TempExcelBuffer: Record "Excel Buffer" temporary; RowNo: Integer; ColNo: Integer): Text
    begin
        If TempExcelBuffer.Get(RowNo, ColNo) then
            exit(TempExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;

    procedure UpdateGLEntryApplied(DocNo: Code[20]; DimTwoCode: Code[20]; DimOneCode: Code[20]; GLAccNo: code[20])
    var
        GLEntry: Record "G/L Entry";
    begin
        Clear(GLEntry);
        GLEntry.SetCurrentKey("Document No.");
        GLEntry.SetRange("Document No.", DocNo);
        GLEntry.SetFilter("Global Dimension 1 Code", DimOneCode);
        GLEntry.SetFilter("Global Dimension 2 Code", DimTwoCode);
        GLEntry.SetFilter("G/L Account No.", GLAccNo);
        GLEntry.ModifyAll("Distributio Rule Applied", true);
    end;

    procedure UpdateGLEntryUnApplied(DocNo: Code[20]; DimTwoCode: Code[20]; DimOneCode: Code[20]; GLAccNo: code[20])
    var
        GLEntry: Record "G/L Entry";
    begin
        Clear(GLEntry);
        GLEntry.SetCurrentKey("Document No.");
        GLEntry.SetRange("Document No.", DocNo);
        GLEntry.SetFilter("Global Dimension 1 Code", DimOneCode);
        GLEntry.SetFilter("Global Dimension 2 Code", DimTwoCode);
        GLEntry.SetFilter("G/L Account No.", GLAccNo);
        GLEntry.ModifyAll("Distributio Rule Applied", false);
    end;

    procedure UpdateGLEntryAppEntryNo(EntryNo: Integer; DocNo: Code[20]; DimTwoCode: Code[20]; DimOneCode: Code[20]; GLAccNo: code[20])
    var
        GLEntry: Record "G/L Entry";
    begin
        Clear(GLEntry);
        GLEntry.SetCurrentKey("Document No.");
        GLEntry.SetRange("Document No.", DocNo);
        GLEntry.SetFilter("Global Dimension 1 Code", DimOneCode);
        GLEntry.SetFilter("Global Dimension 2 Code", DimTwoCode);
        GLEntry.SetFilter("G/L Account No.", GLAccNo);
        GLEntry.ModifyAll("Dist. Entry No Applied", EntryNo);
    end;

    procedure CheckSalesInvoice(DocNo: Code[20]): Boolean
    var
        SalesInvHead: Record "Sales Invoice Header";
    begin
        if SalesInvHead.Get(DocNo) then
            exit(true);
    end;

    procedure GetGLDebitAmount(DocNo: Code[20]; DimTwoCode: Code[20]; DimOneCode: Code[20]; GLAccNo: code[20]): Decimal
    var
        GLEntry: Record "G/L Entry";
    begin
        GLEntry.SetCurrentKey("Document No.");
        GLEntry.SetRange("Document No.", DocNo);
        GLEntry.SetFilter("Global Dimension 1 Code", DimOneCode);
        GLEntry.SetFilter("Global Dimension 2 Code", DimTwoCode);
        GLEntry.SetFilter("G/L Account No.", GLAccNo);
        GLEntry.CalcSums("Debit Amount");
        exit(GLEntry."Debit Amount");
    end;

    procedure GetGLCreditAmount(DocNo: Code[20]; DimTwoCode: Code[20]; DimOneCode: Code[20]; GLAccNo: code[20]): Decimal
    var
        GLEntry: Record "G/L Entry";
    begin
        GLEntry.SetCurrentKey("Document No.");
        GLEntry.SetRange("Document No.", DocNo);
        GLEntry.SetFilter("Global Dimension 1 Code", DimOneCode);
        GLEntry.SetFilter("Global Dimension 2 Code", DimTwoCode);
        GLEntry.SetFilter("G/L Account No.", GLAccNo);
        GLEntry.SetFilter("Account Category", '%1|%2', GLEntry."Account Category"::Income, GLEntry."Account Category"::Expense);
        GLEntry.CalcSums("Credit Amount");
        exit(GLEntry."Credit Amount");
    end;

    local procedure GetEmployeeCount(DimValueTwoCode: Code[20]; DimValueThreeCode: Code[20]): Integer
    var
        DimValue: Record "Dimension Value";
        EmpCount: Integer;
    begin
        DimValue.SetRange("Shortcut Dimension 2 Code", DimValueTwoCode);
        DimValue.SetRange("Distribute Enable", true);
        DimValue.SetRange("Shortcut Dimension 3 Code", DimValueThreeCode);
        EmpCount := DimValue.Count();
        DimValue.SetRange("Shortcut Dimension 3 Code");
        DimValue.SetRange("Shortcut Dimension 3 Two", DimValueThreeCode);
        EmpCount += DimValue.Count();
        DimValue.SetRange("Shortcut Dimension 3 Two");
        DimValue.SetRange("Shortcut Dimension 3 Three", DimValueThreeCode);
        EmpCount += DimValue.Count();
        exit(EmpCount);
    end;

    procedure UpdateDistAmoutOther(var DistRuleFilter: Record "Distribution Rule Filter"; ClearVal: Integer)
    var
        DistProject: Record "Distribution Project";
    begin
        DistProject.SetRange("Entry No.", DistRuleFilter."Entry No.");
        if ClearVal = 1 then
            DistProject.SetRange("Shortcut Dimension 2 Code", DistRuleFilter."Dimension Value One");
        if ClearVal = 2 then
            DistProject.SetRange("Shortcut Dimension 2 Code", DistRuleFilter."Dimension Value Two");
        if ClearVal = 3 then
            DistProject.SetRange("Shortcut Dimension 2 Code", DistRuleFilter."Dimension Value Three");
        if ClearVal = 4 then
            DistProject.SetRange("Shortcut Dimension 2 Code", DistRuleFilter."Dimension Value Four");
        if ClearVal = 5 then
            DistProject.SetRange("Shortcut Dimension 2 Code", DistRuleFilter."Dimension Value Five");
        if not DistProject.FindSet() then
            exit;
        repeat
            DistProject."Project Amount" := 0;
            DistProject.Modify();
        until DistProject.Next() = 0;

    end;

    procedure UpdateDistAmountEquallyProporation(var DistRuleFilter: Record "Distribution Rule Filter"; FilterVal: Integer)
    var
        DistProject: Record "Distribution Project";
        DistributionLine: Record "Distribution Line";
        DistAmount: Decimal;
        DistAmountEquly: Decimal;
        TotEmpCount: Integer;
        Inx: Integer;
        DistributionLineCountOne: Integer;
        DistributionLineCountTwo: Integer;
        DistributionLineCountThree: Integer;
        DistributionLineCountFour: Integer;
        DistributionLineCountFive: Integer;
    begin
        DistRuleFilter.TestField("Distrubution Amount");
        DistProject.SetRange("Entry No.", DistRuleFilter."Entry No.");
        if FilterVal = 1 then
            DistProject.SetRange("Shortcut Dimension 2 Code", DistRuleFilter."Dimension Value One");
        if FilterVal = 2 then
            DistProject.SetRange("Shortcut Dimension 2 Code", DistRuleFilter."Dimension Value Two");
        if FilterVal = 3 then
            DistProject.SetRange("Shortcut Dimension 2 Code", DistRuleFilter."Dimension Value Three");
        if FilterVal = 4 then
            DistProject.SetRange("Shortcut Dimension 2 Code", DistRuleFilter."Dimension Value Four");
        if FilterVal = 5 then
            DistProject.SetRange("Shortcut Dimension 2 Code", DistRuleFilter."Dimension Value Five");

        // if (DistRuleFilter."Distrubution Method" = DistRuleFilter."Distrubution Method"::Proportion) then begin
        CreateDistributionYearAndDate(DistRuleFilter."Entry No.");
        DistributionLine.Reset();
        DistributionLine.SetRange(Year, DistributionYear);
        DistributionLine.SetRange(Month, DistributionMonth);
        if (FilterVal = 1) then begin
            DistributionLine.SetRange("Shortcut Dimension 2 Code", DistRuleFilter."Dimension Value One");
            if (DistributionLine.FindSet() = true) then
                repeat
                    DistributionLineCountOne := DistributionLine.Count();
                until DistributionLine.Next() = 0;
        end;
        if (FilterVal = 2) then begin
            DistributionLine.SetRange("Shortcut Dimension 2 Code", DistRuleFilter."Dimension Value Two");
            if (DistributionLine.FindSet() = true) then
                repeat
                    DistributionLineCountTwo := DistributionLine.Count();
                until DistributionLine.Next() = 0;
        end;
        if (FilterVal = 3) then begin
            DistributionLine.SetRange("Shortcut Dimension 2 Code", DistRuleFilter."Dimension Value three");
            if (DistributionLine.FindSet() = true) then
                repeat
                    DistributionLineCountThree := DistributionLine.Count();
                until DistributionLine.Next() = 0;
        end;
        if (FilterVal = 4) then begin
            DistributionLine.SetRange("Shortcut Dimension 2 Code", DistRuleFilter."Dimension Value four");
            if (DistributionLine.FindSet() = true) then
                repeat
                    DistributionLineCountFour := DistributionLine.Count();
                until DistributionLine.Next() = 0;
        end;
        if (FilterVal = 5) then begin
            DistributionLine.SetRange("Shortcut Dimension 2 Code", DistRuleFilter."Dimension Value five");
            if (DistributionLine.FindSet() = true) then
                repeat
                    DistributionLineCountFive := DistributionLine.Count();
                until DistributionLine.Next() = 0;
        end;
        // end;
        DistProject.CalcSums("Emp. Count");
        TotEmpCount := DistProject."Emp. Count";
        Inx := DistProject.Count();
        if not DistProject.FindSet() then
            exit;

        if TotEmpCount = 0 then
            exit;

        if FilterVal = 0 then begin
            DistAmount := DistRuleFilter."Distrubution Amount";
            DistAmountEquly := Round(DistAmount / TotEmpCount, 0.01);
        end;

        if ((FilterVal = 1) and (DistRuleFilter."Distrubution Method" = DistRuleFilter."Distrubution Method"::Proportion)) then begin
            DistAmount := DistRuleFilter."Distrubution Amount One";
            DistAmountEquly := Round(DistAmount / DistributionLineCountOne, 0.01);
        end
        else begin
            if ((FilterVal = 1) and (DistRuleFilter."Distrubution Method" = DistRuleFilter."Distrubution Method"::Equally)) then begin
                DistAmount := DistRuleFilter."Distrubution Amount One";
                DistAmountEquly := Round(DistAmount / TotEmpCount, 0.01);
            end;
        end;

        if ((FilterVal = 2) and (DistRuleFilter."Distrubution Method" = DistRuleFilter."Distrubution Method"::Proportion)) then begin
            DistAmount := DistRuleFilter."Distrubution Amount Two";
            DistAmountEquly := Round(DistAmount / DistributionLineCountTwo, 0.01);
        end
        else begin
            if ((FilterVal = 2) and (DistRuleFilter."Distrubution Method" = DistRuleFilter."Distrubution Method"::Equally)) then begin
                DistAmount := DistRuleFilter."Distrubution Amount two";
                DistAmountEquly := Round(DistAmount / TotEmpCount, 0.01);
            end;
        end;

        if ((FilterVal = 3) and (DistRuleFilter."Distrubution Method" = DistRuleFilter."Distrubution Method"::Proportion)) then begin
            DistAmount := DistRuleFilter."Distrubution Amount Three";
            DistAmountEquly := Round(DistAmount / DistributionLineCountThree, 0.01);
        end
        else begin
            if ((FilterVal = 3) and (DistRuleFilter."Distrubution Method" = DistRuleFilter."Distrubution Method"::Equally)) then begin
                DistAmount := DistRuleFilter."Distrubution Amount Three";
                DistAmountEquly := Round(DistAmount / TotEmpCount, 0.01);
            end;
        end;

        if ((FilterVal = 4) and (DistRuleFilter."Distrubution Method" = DistRuleFilter."Distrubution Method"::Proportion)) then begin
            DistAmount := DistRuleFilter."Distrubution Amount Four";
            DistAmountEquly := Round(DistAmount / DistributionLineCountFour, 0.01);
        end else begin
            if ((FilterVal = 4) and (DistRuleFilter."Distrubution Method" = DistRuleFilter."Distrubution Method"::Equally)) then begin
                DistAmount := DistRuleFilter."Distrubution Amount Four";
                DistAmountEquly := Round(DistAmount / TotEmpCount, 0.01);
            end;
        end;

        if ((FilterVal = 5) and (DistRuleFilter."Distrubution Method" = DistRuleFilter."Distrubution Method"::Proportion)) then begin
            DistAmount := DistRuleFilter."Distrubution Amount Five";
            DistAmountEquly := Round(DistAmount / DistributionLineCountFive, 0.01);
        end
        else begin
            if ((FilterVal = 5) and (DistRuleFilter."Distrubution Method" = DistRuleFilter."Distrubution Method"::Equally)) then begin
                DistAmount := DistRuleFilter."Distrubution Amount Five";
                DistAmountEquly := Round(DistAmount / TotEmpCount, 0.01);
            end;
        end;
        repeat
            if Inx <> 1 then
                DistProject."Project Amount" := DistAmountEquly * DistProject."Emp. Count"
            else
                DistProject."Project Amount" := DistAmount;
            DistProject.Modify();
            DistAmount := DistAmount - DistProject."Project Amount";
            Inx -= 1;
        until DistProject.Next() = 0;

    end;

    procedure UpdateDistAmountManually(var DistRuleFilter: Record "Distribution Rule Filter"; FilterVal: Integer)
    var
        DistProject: Record "Distribution Project";
        DistAmount: Decimal;
        DistAmountEquly: Decimal;
        TotEmpCount: Integer;
        Inx: Integer;
    begin
        DistRuleFilter.TestField("Distrubution Amount");
        DistProject.SetRange("Entry No.", DistRuleFilter."Entry No.");
        if FilterVal = 1 then
            DistProject.SetRange("Shortcut Dimension 2 Code", DistRuleFilter."Dimension Value One");
        if FilterVal = 2 then
            DistProject.SetRange("Shortcut Dimension 2 Code", DistRuleFilter."Dimension Value Two");
        if FilterVal = 3 then
            DistProject.SetRange("Shortcut Dimension 2 Code", DistRuleFilter."Dimension Value Three");
        if FilterVal = 4 then
            DistProject.SetRange("Shortcut Dimension 2 Code", DistRuleFilter."Dimension Value Four");
        if FilterVal = 5 then
            DistProject.SetRange("Shortcut Dimension 2 Code", DistRuleFilter."Dimension Value Five");
        DistProject.CalcSums("Emp. Count");
        TotEmpCount := DistProject."Emp. Count";
        Inx := DistProject.Count();
        if not DistProject.FindSet() then
            exit;
        if TotEmpCount = 0 then
            exit;
        if FilterVal = 0 then begin
            DistAmount := DistRuleFilter."Distrubution Amount";
            DistAmountEquly := Round(DistAmount / TotEmpCount, 0.01);
        end;
        if FilterVal = 1 then begin
            DistAmount := DistRuleFilter."Distrubution Amount One";
            DistAmountEquly := Round(DistAmount / TotEmpCount, 0.01);
        end;
        if FilterVal = 2 then begin
            DistAmount := DistRuleFilter."Distrubution Amount Two";
            DistAmountEquly := Round(DistAmount / TotEmpCount, 0.01);
        end;
        if FilterVal = 3 then begin
            DistAmount := DistRuleFilter."Distrubution Amount Three";
            DistAmountEquly := Round(DistAmount / TotEmpCount, 0.01);
        end;
        if FilterVal = 4 then begin
            DistAmount := DistRuleFilter."Distrubution Amount Four";
            DistAmountEquly := Round(DistAmount / TotEmpCount, 0.01);
        end;
        if FilterVal = 5 then begin
            DistAmount := DistRuleFilter."Distrubution Amount Five";
            DistAmountEquly := Round(DistAmount / TotEmpCount, 0.01);
        end;
        repeat
            if Inx <> 1 then
                DistProject."Project Amount" := DistAmountEquly * DistProject."Emp. Count"
            else
                DistProject."Project Amount" := DistAmount;
            DistProject.Modify();
            DistAmount := DistAmount - DistProject."Project Amount";
            Inx -= 1;
        until DistProject.Next() = 0;

    end;

    procedure CheckDistRuleExist(EntryNo: Integer)
    var
        DisRuleFilter: Record "Distribution Rule Filter";
        DistRule: Record "Distribution Rule";
    begin
        DisRuleFilter.Get(EntryNo);
        DisRuleFilter.TestField("Sales Invoice", false);
        //if not DisRuleFilter."Dimension Filter Exsist" then
        //if DisRuleFilter."Distrubution Method" = DisRuleFilter."Distrubution Method"::Equally then
        //Error('Project amount not allowed to change.');
        DistRule.SetRange("Entry No.", EntryNo);
        if DistRule.FindSet() then
            Error('Distribution line exists, please delete lines.');
    end;

    procedure CheckDistProjectExist(EntryNo: Integer): Boolean
    var
        DistProject: Record "Distribution Project";
    begin
        Clear(DistProject);
        DistProject.SetRange("Entry No.", EntryNo);
        if not DistProject.FindSet() then
            exit(false);
        DistProject.CalcSums("Project Amount");
        if DistProject."Project Amount" = 0 then
            exit(false);
        exit(true);
    end;

    procedure CopyFromDimValueOne(Year: Code[20]; Month: Code[20])
    var
        GeneLedSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
        DistLine: Record "Distribution Line";
    begin
        if not Confirm('Do you want to copy from employee details?', false) then
            exit;
        DistLine.SetRange(Year, Year);
        DistLine.SetRange(Month, Month);
        if DistLine.FindSet() then
            DistLine.DeleteAll();
        Clear(DistLine);
        GeneLedSetup.Get();
        GeneLedSetup.TestField("Shortcut Dimension 1 Code");
        DimValue.SetRange("Dimension Code", GeneLedSetup."Shortcut Dimension 1 Code");
        if not DimValue.FindSet() then
            exit;
        repeat
            Clear(DistLine);
            DistLine.Init();
            DistLine.Year := Year;
            DistLine.Month := Month;
            DistLine."Shortcut Dimension 1 Code" := DimValue.Code;
            DistLine."Shortcut Dimension 2 Code" := DimValue."Shortcut Dimension 2 Code";
            DistLine."Shortcut Dimension 3 Code" := DimValue."Shortcut Dimension 3 Code";
            DistLine."Shortcut Dimension 3 Two" := DimValue."Shortcut Dimension 3 Two";
            DistLine."Shortcut Dimension 3 Three" := DimValue."Shortcut Dimension 3 Three";
            DistLine."Percentage One" := DimValue."Percentage One";
            DistLine."Percentage Two" := DimValue."Percentage Two";
            DistLine."Percentage Three" := DimValue."Percentage Three";
            if (DistLine."Percentage One" + DistLine."Percentage Two" + DistLine."Percentage Three") <> (100.00) then
                Error('Percentage Values Must Be equal to 100 Percent');
            DistLine.Insert();
        until DimValue.Next() = 0;
        Message('Copy from employee details completed.');
    end;

    procedure CopyFromPreviousDetails(Year: Code[20]; Month: Code[20]; PreYear: Code[20]; PreMonth: Code[20])
    var
        DistLine: Record "Distribution Line";
        DistLineIn: Record "Distribution Line";
    begin
        if not Confirm('Do you want to copy employee details from previous year and month?', false) then
            exit;
        Clear(DistLine);
        DistLine.SetRange(Year, PreYear);
        DistLine.SetRange(Month, PreMonth);
        if not DistLine.FindSet() then
            Error('Employee details not found for previous year and month');
        Clear(DistLineIn);
        DistLineIn.SetRange(Year, Year);
        DistLineIn.SetRange(Month, Month);
        if DistLineIn.FindSet() then
            DistLineIn.DeleteAll();
        repeat
            Clear(DistLineIn);
            DistLineIn.Init();
            DistLineIn.Year := Year;
            DistLineIn.Month := Month;
            DistLineIn."Shortcut Dimension 1 Code" := DistLine."Shortcut Dimension 1 Code";
            DistLineIn."Shortcut Dimension 2 Code" := DistLine."Shortcut Dimension 2 Code";
            DistLineIn."Shortcut Dimension 3 Code" := DistLine."Shortcut Dimension 3 Code";
            DistLineIn."Shortcut Dimension 3 Two" := DistLine."Shortcut Dimension 3 Two";
            DistLineIn."Shortcut Dimension 3 Three" := DistLine."Shortcut Dimension 3 Three";
            DistLineIn."Percentage One" := DistLine."Percentage One";
            DistLineIn."Percentage Two" := DistLine."Percentage Two";
            DistLineIn."Percentage Three" := DistLine."Percentage Three";
            DistLineIn.Insert();
        until DistLine.Next() = 0;
        Message('Copy from employee details completed.');
    end;

    procedure UpdateToDimValueOne(Year: Code[20]; Month: Code[20])
    var
        GeneLedSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
        DistLine: Record "Distribution Line";
    begin
        if not Confirm('Do you want update employee details?', false) then
            exit;
        DistLine.SetRange(Year, Year);
        DistLine.SetRange(Month, Month);
        if not DistLine.FindSet() then
            exit;
        GeneLedSetup.Get();
        GeneLedSetup.TestField("Shortcut Dimension 1 Code");
        DimValue.SetRange("Dimension Code", GeneLedSetup."Shortcut Dimension 1 Code");
        if not DimValue.FindSet() then
            exit;
        repeat
            /*
            DimValue."Shortcut Dimension 2 Code" := '';
            DimValue."Shortcut Dimension 3 Code" := '';
            DimValue."Shortcut Dimension 3 Two" := '';
            DimValue."Shortcut Dimension 3 Three" := '';
            DimValue."Percentage One" := 0;
            DimValue."Percentage Two" := 0;
            DimValue."Percentage Three" := 0;
            */
            DimValue.Year := Year;
            DimValue.Month := Month;
            DimValue."Distribute Enable" := false;
            DimValue.Modify();
        until DimValue.Next() = 0;
        DimValue.FindSet();
        repeat
            Clear(DimValue);
            DimValue.Get(GeneLedSetup."Shortcut Dimension 1 Code", DistLine."Shortcut Dimension 1 Code");
            DimValue."Shortcut Dimension 2 Code" := DistLine."Shortcut Dimension 2 Code";
            DimValue."Shortcut Dimension 3 Code" := DistLine."Shortcut Dimension 3 Code";
            DimValue."Shortcut Dimension 3 Two" := DistLine."Shortcut Dimension 3 Two";
            DimValue."Shortcut Dimension 3 Three" := DistLine."Shortcut Dimension 3 Three";
            DimValue."Percentage One" := DistLine."Percentage One";
            DimValue."Percentage Two" := DistLine."Percentage Two";
            DimValue."Percentage Three" := DistLine."Percentage Three";
            DimValue.Year := Year;
            DimValue.Month := Month;
            DimValue."Distribute Enable" := true;
            DimValue.Modify();
        until DistLine.Next() = 0;
        Message('Employee details update completed.');
    end;

    procedure UpdateDisSetupLineXL(Year: Code[20]; Month: Code[20])
    var
        DisLine: Record "Distribution Line";
        TempExcelBuffer: Record "Excel Buffer" temporary;
        FileManage: Codeunit "File Management";
        InStm: InStream;
        FromFile: Text[250];
        FileName: Text[250];
        UploadExcelMsg: Text[100];
        SheetName: Text[100];
        SheetVal: Decimal;
        LineNo: Integer;
        MaxRowCount: Integer;
        RowCount: Integer;
    begin
        UploadExcelMsg := 'Please select the excel file.';
        UploadIntoStream(UploadExcelMsg, '', '', FromFile, InStm);
        if FromFile <> '' then begin
            FileName := FileManage.GetFileName(FromFile);
            SheetName := TempExcelBuffer.SelectSheetsNameStream(InStm);
        end
        else
            Error('No excel file selected.');
        Clear(TempExcelBuffer);
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.OpenBookStream(InStm, SheetName);
        TempExcelBuffer.ReadSheet();
        Clear(TempExcelBuffer);
        if TempExcelBuffer.FindLast() then
            MaxRowCount := TempExcelBuffer."Row No.";
        Clear(TempExcelBuffer);
        for RowCount := 2 to MaxRowCount do begin
            if Year <> GetValueAtCell(TempExcelBuffer, RowCount, 1) then
                Error('Year must be same.');
            if Month <> GetValueAtCell(TempExcelBuffer, RowCount, 2) then
                Error('Month must be same.');
            Clear(DisLine);
            DisLine.Init();
            DisLine.Year := Year;
            DisLine.Month := Month;
            DisLine."Shortcut Dimension 1 Code" := GetValueAtCell(TempExcelBuffer, RowCount, 3);
            DisLine."Shortcut Dimension 2 Code" := GetValueAtCell(TempExcelBuffer, RowCount, 4);
            DisLine."Shortcut Dimension 3 Code" := GetValueAtCell(TempExcelBuffer, RowCount, 5);
            Clear(SheetVal);
            Evaluate(SheetVal, GetValueAtCell(TempExcelBuffer, RowCount, 6));
            DisLine."Percentage One" := SheetVal;
            DisLine."Shortcut Dimension 3 Two" := GetValueAtCell(TempExcelBuffer, RowCount, 7);
            Clear(SheetVal);
            Evaluate(SheetVal, GetValueAtCell(TempExcelBuffer, RowCount, 8));
            DisLine."Percentage Two" := SheetVal;
            DisLine."Shortcut Dimension 3 Three" := GetValueAtCell(TempExcelBuffer, RowCount, 9);
            Clear(SheetVal);
            Evaluate(SheetVal, GetValueAtCell(TempExcelBuffer, RowCount, 10));
            DisLine."Percentage Three" := SheetVal;
            DisLine.Insert();
        end;
        Message('Excel update process completed.');
    end;

    procedure CreateDistributionYearAndDate(EntryNo: Integer)
    var
        DistributionLine: Record "Distribution Line";
        GLEntry: Record "G/L Entry";
        DistributionPostingDate: Date;
        PostingDate: Text;
        Month: Text;
        Year: Text;
    begin
        if (GLEntry.Get(EntryNo) = false) then
            exit;
        DistributionPostingDate := GLEntry."Posting Date";
        PostingDate := Format(DistributionPostingDate);// 01/10/23
        Month := CopyStr(PostingDate, 1, 2);
        Year := CopyStr(PostingDate, 7, 8);
        DistributionYear := InsStr(Year, '20', 1);
        DistributionMonth := ConvertingMonthAndYear(Month);
    end;

    procedure InsertDistributionRuleLineFromDistributionSetup(var DistributionruleFilter: Record "Distribution Rule Filter"; var DistributionRule: Record "Distribution Rule"; var DistributionLines: Record "Distribution Line"; DistributionRuleLineNo: Integer): Integer
    var
        RuleIncrement: Integer;
    begin
        DistributionRule.Init();
        DistributionRule."Entry No." := DistributionruleFilter."Entry No.";
        DistributionRule."Line No." := DistributionRuleLineNo + 1000;
        DistributionRule."Shortcut Dimension 1 Code" := DistributionLines."Shortcut Dimension 1 Code";
        DistributionRule."Shortcut Dimension 2 Code" := DistributionLines."Shortcut Dimension 2 Code";
        DistributionRule."G/L Account No." := DistributionruleFilter."G/L Account No.";
        DistributionRule.Insert();
        exit(DistributionRule."Line No.");
    end;

    var
        DistributionYear: Text;
        DistributionMonth: Text;
}