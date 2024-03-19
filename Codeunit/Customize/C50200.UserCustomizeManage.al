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

    procedure CreateProjectDistRuleFilter(EntryNo: Integer; DimValueCode: Code[20]; xDimValueCode: Code[20]; GLAccNo: code[20])
    var
        DistProject: Record "Distribution Project";
        DimValue: Record "Dimension Value";
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
}
