page 50201 "Distribution Rule Filter"
{
    ApplicationArea = All;
    Caption = 'Distribution Rule Filter';
    PageType = Card;
    SourceTable = "Distribution Rule Filter";
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    Editable = false;
                }
                field(GLAccNo; GLAccNo)
                {
                    Caption = 'G/L Account No.';
                    Editable = false;
                    Visible = FieldGLVisible;
                    ApplicationArea = All;
                }
                field(GLAccName; GLAccName)
                {
                    Caption = 'G/L Account Name';
                    Editable = false;
                    Visible = FieldGLVisible;
                    ApplicationArea = All;
                }
                field("Dimension Filter"; Rec."Dimension Filter")
                {
                    ToolTip = 'Specifies the value of the Dimension Filter field.';
                    Visible = true;
                    //Editable = FieldDimVEdit;
                    trigger OnValidate()
                    var
                        GLEntry: Record "G/L Entry";
                    begin
                        GLEntry.Get(Rec."Entry No.");
                        CalRemAmount(GLEntry);
                        CurrPage.DistributionRule.Page.UpdateAmount(Amount, RemAmount);
                    end;

                }
                field("Dimension Filter Value"; Rec."Dimension Value")
                {
                    ToolTip = 'Specifies the value of the Dimension Filter field.';
                    Editable = false;
                    trigger OnValidate()
                    var
                        GLEntry: Record "G/L Entry";
                    begin
                        GLEntry.Get(Rec."Entry No.");
                        CalRemAmount(GLEntry);
                        CurrPage.DistributionRule.Page.UpdateAmount(Amount, RemAmount);
                    end;
                }
                field("Distrubution Method"; Rec."Distrubution Method")
                {
                    ToolTip = 'Specifies Distrubution Method field.';
                    Editable = DisMFieldEditable;
                    trigger OnValidate()
                    var
                        GLEntry: Record "G/L Entry";
                    begin
                        GLEntry.Get(Rec."Entry No.");
                        CalRemAmount(GLEntry);
                        CurrPage.DistributionRule.Page.UpdateAmount(Amount, RemAmount);
                    end;
                }
                field("Distrubution Amount"; Rec."Distrubution Amount")
                {
                    ToolTip = 'Specifies the value of the Amount Distribute field.';
                    Visible = FieldEditable;
                }

                field("Distribution Setup"; Rec."Distribution Setup")
                {
                    ToolTip = 'Specifies Distribution Method Setup';

                }
            }
            group("Branch Distribution")
            {

                field("Dimension Value One"; Rec."Dimension Value One")
                {
                    ToolTip = 'Specifies the value of the Dimension Value One field.';
                    //Editable = FieldDimVEdit;
                    trigger OnValidate()
                    var
                        GLEntry: Record "G/L Entry";
                    begin
                        GLEntry.Get(Rec."Entry No.");
                        CalRemAmount(GLEntry);
                        CurrPage.DistributionRule.Page.UpdateAmount(Amount, RemAmount);
                    end;
                }
                field("Distrubution Amount One"; Rec."Distrubution Amount One")
                {
                    ToolTip = 'Specifies the value of the Distribution Amount One field.';
                    //Editable = FieldDimVEdit;
                    trigger OnValidate()
                    var
                        GLEntry: Record "G/L Entry";
                    begin
                        GLEntry.Get(Rec."Entry No.");
                        CalRemAmount(GLEntry);
                        CurrPage.DistributionRule.Page.UpdateAmount(Amount, RemAmount);
                    end;
                }
                field("Dimension Value Two"; Rec."Dimension Value Two")
                {
                    ToolTip = 'Specifies the value of the Dimension Value Two field.';
                    //Editable = FieldDimVEdit;
                    trigger OnValidate()
                    var
                        GLEntry: Record "G/L Entry";
                    begin
                        GLEntry.Get(Rec."Entry No.");
                        CalRemAmount(GLEntry);
                        CurrPage.DistributionRule.Page.UpdateAmount(Amount, RemAmount);
                    end;
                }
                field("Distrubution Amount Two"; Rec."Distrubution Amount Two")
                {
                    ToolTip = 'Specifies the value of the Distribution Amount Two field.';
                    //Editable = FieldDimVEdit;
                    trigger OnValidate()
                    var
                        GLEntry: Record "G/L Entry";
                    begin
                        GLEntry.Get(Rec."Entry No.");
                        CalRemAmount(GLEntry);
                        CurrPage.DistributionRule.Page.UpdateAmount(Amount, RemAmount);
                    end;
                }
                field("Dimension Value Three"; Rec."Dimension Value Three")
                {
                    ToolTip = 'Specifies the value of the Dimension Value Three field.';
                    //Editable = FieldDimVEdit;
                    trigger OnValidate()
                    var
                        GLEntry: Record "G/L Entry";
                    begin
                        GLEntry.Get(Rec."Entry No.");
                        CalRemAmount(GLEntry);
                        CurrPage.DistributionRule.Page.UpdateAmount(Amount, RemAmount);
                    end;
                }
                field("Distrubution Amount Three"; Rec."Distrubution Amount Three")
                {
                    ToolTip = 'Specifies the value of the Distribution Amount Three field.';
                    //Editable = FieldDimVEdit;
                    trigger OnValidate()
                    var
                        GLEntry: Record "G/L Entry";
                    begin
                        GLEntry.Get(Rec."Entry No.");
                        CalRemAmount(GLEntry);
                        CurrPage.DistributionRule.Page.UpdateAmount(Amount, RemAmount);
                    end;
                }
                field("Dimension Value Four"; Rec."Dimension Value Four")
                {
                    ToolTip = 'Specifies the value of the Dimension Value Four field.';
                    //Editable = FieldDimVEdit;
                    trigger OnValidate()
                    var
                        GLEntry: Record "G/L Entry";
                    begin
                        GLEntry.Get(Rec."Entry No.");
                        CalRemAmount(GLEntry);
                        CurrPage.DistributionRule.Page.UpdateAmount(Amount, RemAmount);
                    end;
                }
                field("Distrubution Amount Four"; Rec."Distrubution Amount Four")
                {
                    ToolTip = 'Specifies the value of the Distribution Amount Four field.';
                    //Editable = FieldDimVEdit;
                    trigger OnValidate()
                    var
                        GLEntry: Record "G/L Entry";
                    begin
                        GLEntry.Get(Rec."Entry No.");
                        CalRemAmount(GLEntry);
                        CurrPage.DistributionRule.Page.UpdateAmount(Amount, RemAmount);
                    end;
                }
                field("Dimension Value Five"; Rec."Dimension Value Five")
                {
                    ToolTip = 'Specifies the value of the Dimension Value Five field.';
                    //Editable = FieldDimVEdit;
                    trigger OnValidate()
                    var
                        GLEntry: Record "G/L Entry";
                    begin
                        GLEntry.Get(Rec."Entry No.");
                        CalRemAmount(GLEntry);
                        CurrPage.DistributionRule.Page.UpdateAmount(Amount, RemAmount);
                    end;
                }
                field("Distrubution Amount Five"; Rec."Distrubution Amount Five")
                {
                    ToolTip = 'Specifies the value of the Distribution Amount Five field.';
                    //Editable = FieldDimVEdit;
                    trigger OnValidate()
                    var
                        GLEntry: Record "G/L Entry";
                    begin
                        GLEntry.Get(Rec."Entry No.");
                        CalRemAmount(GLEntry);
                        CurrPage.DistributionRule.Page.UpdateAmount(Amount, RemAmount);
                    end;
                }
            }
            part(DistributionProject; "Distribution Project")
            {
                Caption = 'Project Line';
                SubPageLink = "Entry No." = field("Entry No.");
                //Editable = FieldEditable;
            }
            part(DistributionRule; "Distribution Rule")
            {
                Caption = 'Line';
                SubPageLink = "Entry No." = field("Entry No.");
            }
        }
    }
    actions
    {
        area(Processing)

        {
            action("Employee Distribution")
            {
                // Clicks This Action gives Employee Distribution Entries  
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = Line;
                trigger OnAction()
                var
                    GLEntry: Record "G/L Entry";
                    DistributionLines: Record "Distribution Line";
                    DistributionProject: Record "Distribution Project";
                    DistributionRule: Record "Distribution Rule";
                    BranchCodeList: List of [Text];
                    BranchCodeList2: List of [Text];
                    IntegerOfList: Integer;
                    IntegerOfList2: Integer;
                    EmployeeCount: Integer;
                    DistributionProjectLineNo: Integer;
                    DistributionRuleLineNo: Integer;
                    ProjectIncrementValue: Integer;
                    DistRuleIncrementValue: Integer;
                    ValueOfText: Text;
                    BranchCode: Text;
                begin
                    // CheckingTotalValue();
                    // if Rec."Distrubution Method" = Rec."Distrubution Method"::Manually then
                    if Rec."Sales Invoice" then
                        if Rec."G/L Amount" <> 0 then
                            UpdateAmountManually();
                    GLEntry.Get(Rec."Entry No.");
                    CalRemAmount(GLEntry);
                    CurrPage.DistributionRule.Page.UpdateAmount(Amount, RemAmount);
                    // if Rec."Dimension Value" <> '' then
                    //     InsertDistributionRuleLine(Rec."Dimension Value", Rec."Distrubution Amount", 0);
                    // if Rec."Dimension Value One" <> '' then
                    //     InsertDistributionRuleLine(Rec."Dimension Value One", Rec."Distrubution Amount One", 1);
                    // if Rec."Dimension Value Two" <> '' then
                    //     InsertDistributionRuleLine(Rec."Dimension Value Two", Rec."Distrubution Amount Two", 2);
                    // if Rec."Dimension Value Three" <> '' then
                    //     InsertDistributionRuleLine(Rec."Dimension Value Three", Rec."Distrubution Amount Three", 3);
                    // if Rec."Dimension Value Four" <> '' then
                    //     InsertDistributionRuleLine(Rec."Dimension Value Four", Rec."Distrubution Amount Four", 4);
                    // if Rec."Dimension Value Five" <> '' then
                    //     InsertDistributionRuleLine(Rec."Dimension Value Five", Rec."Distrubution Amount Five", 5);

                    /*Employee Distribution Entries*/
                    if (Rec."Distribution Setup" = true) then begin
                        GetMonthAndYear(GLEntry);
                        DistributionLines.SetRange(Year, DistributionYear);
                        DistributionLines.SetRange(Month, DistributionMonth);
                        if (DistributionLines.FindSet() = true) then
                            repeat
                                BranchCodeList.Add(DistributionLines."Shortcut Dimension 2 Code");
                                EmployeeCount += 1;
                            until DistributionLines.Next() = 0;

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

                        DistributionProject.SetRange("Entry No.", Rec."Entry No.");
                        DistributionProject.SetFilter("Shortcut Dimension 2 Code", BranchCode);
                        if (DistributionProject.FindSet(false) = true) then
                            Error('Line exist please delete line.')
                        else begin
                            if (DistributionLines.FindSet(false) = true) then begin
                                repeat
                                    Clear(DistributionProject);
                                    DistributionProject.Init();
                                    DistributionProject."Entry No." := Rec."Entry No.";
                                    DistributionProject."Shortcut Dimension 2 Code" := DistributionLines."Shortcut Dimension 2 Code";
                                    DistributionProject."Shortcut Dimension 3 Code" := DistributionLines."Shortcut Dimension 1 Code";
                                    DistributionProject."Project Amount" := Round(Rec."Distrubution Amount" / EmployeeCount, 0.01);
                                    DistributionProject."Project Line" := true;
                                    DistributionProject."Line No." := DistributionProjectLineNo + 1000;
                                    DistributionProject."Emp. Count" := UserCustomizedmanage.GetEmployeeCountFromDistributionSetup(DistributionYear, DistributionMonth, DistributionLines."Shortcut Dimension 1 Code", BranchCode);
                                    DistributionProject."G/L Account No." := GLEntry."G/L Account No.";
                                    DistributionProject.Insert();
                                    ProjectIncrementValue := 1;
                                    /* Distribution Rule tab is populating values*/
                                    Clear(DistributionRule);
                                    DistributionRule.SetRange("Entry No.", Rec."Entry No.");
                                    if (DistributionLines."Shortcut Dimension 3 Code" <> '') then begin
                                        DistRuleIncrementValue += 1;
                                        DistributionRuleLineNo := UserCustomizedmanage.InsertDistributionRuleLineFromDistributionSetup(Rec, DistributionRule, DistributionLines, DistributionRuleLineNo);
                                        DistributionRule."Shortcut Dimension 3 Code" := DistributionLines."Shortcut Dimension 3 Code";
                                        DistributionRule."Emp. Project Percentage" := DistributionLines."Percentage One";
                                        DistributionRule."Posting Date" := GLEntry."Posting Date";
                                        DistributionRule.Modify(false);
                                    end;

                                    if (DistributionLines."Shortcut Dimension 3 Two" <> '') then begin
                                        DistRuleIncrementValue += 1;
                                        DistributionRuleLineNo := UserCustomizedmanage.InsertDistributionRuleLineFromDistributionSetup(Rec, DistributionRule, DistributionLines, DistributionRuleLineNo);
                                        DistributionRule."Shortcut Dimension 3 Code" := DistributionLines."Shortcut Dimension 3 Two";
                                        DistributionRule."Emp. Project Percentage" := DistributionLines."Percentage Two";
                                        DistributionRule."Posting Date" := GLEntry."Posting Date";
                                        DistributionRule.Modify(false);
                                    end;

                                    if (DistributionLines."Shortcut Dimension 3 Three" <> '') then begin
                                        DistRuleIncrementValue += 1;
                                        DistributionRuleLineNo := UserCustomizedmanage.InsertDistributionRuleLineFromDistributionSetup(Rec, DistributionRule, DistributionLines, DistributionRuleLineNo);
                                        DistributionRule."Shortcut Dimension 3 Code" := DistributionLines."Shortcut Dimension 3 Three";
                                        DistributionRule."Emp. Project Percentage" := DistributionLines."Percentage Three";
                                        DistributionRule."Posting Date" := GLEntry."Posting Date";
                                        DistributionRule.Modify(false);
                                    end;
                                    Clear(ProjectIncrementValue);
                                    Clear(DistRuleIncrementValue);
                                until DistributionLines.Next() = 0;
                            end;
                        end;
                        Clear(DistributionYear);
                        Clear(DistributionMonth);
                    end;
                end;
            }
            action("Distribution Project Amount")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = UpdateUnitCost;
                trigger OnAction()
                var
                    GLEntry: Record "G/L Entry";
                    Distributionproject: Record "Distribution Project";
                    DistributionRule: Record "Distribution Rule";
                    DistributionLine: Record "Distribution Line";
                    UserCustManage: Codeunit "User Customize Manage";
                    TotalProjectAmount: Decimal;
                begin
                    // if (Rec."Distrubution Method" = Rec."Distrubution Method"::Equally) or
                    //     (Rec."Distrubution Method" = Rec."Distrubution Method"::Proportion) then begin
                    Clear(GLEntry);
                    GLEntry.Get(Rec."Entry No.");
                    CalRemAmount(GLEntry);
                    if (RemAmount = 0) then
                        Error('Remaining amount must have a value');
                    Distributionproject.Reset();
                    Distributionproject.SetRange("Entry No.", Rec."Entry No.");
                    if (Distributionproject.FindSet() = false) then
                        exit
                    else
                        repeat
                            Distributionproject.TestField("Project Amount");
                            DistributionRule.SetRange("Entry No.", Rec."Entry No.");
                            DistributionRule.SetRange("Shortcut Dimension 1 Code", Distributionproject."Shortcut Dimension 3 Code");
                            DistributionRule.SetRange("Shortcut Dimension 2 Code", Distributionproject."Shortcut Dimension 2 Code");
                            if (DistributionRule.FindSet(false) = true) then
                                repeat
                                    DistributionRule."Amount Allocated" := Round(Distributionproject."Project Amount" * (DistributionRule."Emp. Project Percentage" / 100), 0.01);
                                    DistributionRule.Modify(false);
                                until DistributionRule.Next() = 0;

                            TotalProjectAmount += Distributionproject."Project Amount";
                        until Distributionproject.Next() = 0;
                    if (TotalProjectAmount <> Abs(Rec."Distrubution Amount")) then
                        Error('Total project is %1 amount must be equal to Distribution amount %2.', TotalProjectAmount, Rec."Distrubution Amount");

                    // UpdateEmpCountProject();
                    // if Rec."Dimension Value" <> '' then begin
                    //     Rec.TestField("Distrubution Amount");
                    //     UpdatetDistributionRuleLine(Rec."Dimension Value", Rec."Distrubution Amount");
                    // end;
                    // if Rec."Dimension Value One" <> '' then begin
                    //     Rec.TestField("Distrubution Amount One");
                    //     UpdatetDistributionRuleLine(Rec."Dimension Value One", Rec."Distrubution Amount One");
                    // end;
                    // if Rec."Dimension Value Two" <> '' then begin
                    //     Rec.TestField("Distrubution Amount Two");
                    //     UpdatetDistributionRuleLine(Rec."Dimension Value Two", Rec."Distrubution Amount Two");
                    // end;
                    // if Rec."Dimension Value Three" <> '' then begin
                    //     Rec.TestField("Distrubution Amount Three");
                    //     UpdatetDistributionRuleLine(Rec."Dimension Value Three", Rec."Distrubution Amount Three");
                    // end;
                    // if Rec."Dimension Value Four" <> '' then begin
                    //     Rec.TestField("Distrubution Amount Four");
                    //     UpdatetDistributionRuleLine(Rec."Dimension Value Four", Rec."Distrubution Amount Four");
                    // end;
                    // if Rec."Dimension Value Five" <> '' then begin
                    //     Rec.TestField("Distrubution Amount Five");
                    //     UpdatetDistributionRuleLine(Rec."Dimension Value Five", Rec."Distrubution Amount Five");
                    // end;
                    RemAmount := 0;
                    CurrPage.DistributionRule.Page.UpdateAmount(Amount, RemAmount);
                    UserCustManage.UpdateGLEntryApplied(GLEntry."Document No.", GLEntry."Global Dimension 2 Code", GLEntry."Global Dimension 1 Code",
                        Rec."G/L Account No.");
                    Message('Amount distributed successfully.');
                end;
                // end;
            }
            action("Update Posting Date")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = UpdateXML;
                Visible = false;
                trigger OnAction()
                var
                    GLEntry: Record "G/L Entry";
                    DistRule: Record "Distribution Rule";
                begin
                    if DistRule.FindSet() then
                        repeat
                            Clear(GLEntry);
                            if GLEntry.Get(DistRule."Entry No.") then begin
                                DistRule."Posting Date" := GLEntry."Posting Date";
                                DistRule.Modify();
                            end;
                        until DistRule.Next() = 0;
                    Message('OK');
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        FieldEditable := true;
        FieldDimVEdit := false;
    end;

    trigger OnAfterGetCurrRecord()
    var
        GLEntry: Record "G/L Entry";
        xRecDimValue: Code[20];
    begin
        if Rec."Dimension Value" = '' then
            FieldDimVEdit := true;
        GLEntry.Get(Rec."Entry No.");
        CalRemAmount(GLEntry);
        if Rec."Sales Invoice" then begin
            Rec."Distrubution Amount" := Amount;
            Rec."Distrubution Method" := Rec."Distrubution Method"::Manually;
            FieldEditable := false;
            DisMFieldEditable := false;
            if Rec."Distrubution Amount" = 0 then
                Rec."Distrubution Amount" := Rec."G/L Amount";
        end
        else
            Rec."Distrubution Amount" := Rec."G/L Amount";
        if not Rec."Sales Invoice" then
            if Rec."Dimension Filter Exsist" then begin
                FieldEditable := false;
                DisMFieldEditable := true;
            end
            else
                DisMFieldEditable := true;
        if Rec."G/L Account No." <> '' then begin
            FieldGLVisible := true;
            GLAccNo := Rec."G/L Account No.";
            GLAccName := GLEntry."G/L Account Name";
        end;
        if Rec."Dimension Value" <> '' then begin
            xRecDimValue := Rec."Dimension Value";
            Rec.Validate("Dimension Value", '');
            if Rec."Dimension Value One" = '' then begin
                Rec."Dimension Value One" := xRecDimValue;
                Rec."Distrubution Amount One" := Rec."Distrubution Amount";
            end;

        end;
        Rec.Modify();
        CurrPage.DistributionRule.Page.UpdateAmount(Amount, RemAmount);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        GLEntry: Record "G/L Entry";
        UserCustManage: Codeunit "User Customize Manage";
    begin
        GLEntry.Get(Rec."Entry No.");
        CalRemAmount(GLEntry);
        if RemAmount <> 0 then begin
            Message('Distribution amount not fully applied.');
            UserCustManage.UpdateGLEntryUnApplied(GLEntry."Document No.", GLEntry."Global Dimension 2 Code",
                GLEntry."Global Dimension 1 Code", Rec."G/L Account No.");
        end
        else
            if not UserCustManage.CheckDistProjectExist(Rec."Entry No.") then
                UserCustManage.UpdateGLEntryUnApplied(GLEntry."Document No.", GLEntry."Global Dimension 2 Code",
                     GLEntry."Global Dimension 1 Code", Rec."G/L Account No.");

    end;

    procedure InitPageDetails(var GLEntry: Record "G/L Entry")
    begin
        DocNo := GLEntry."Document No.";
        Description := GLEntry.Description;
    end;

    local procedure CalRemAmount(GLEntry: Record "G/L Entry")
    var
        DisRule: Record "Distribution Rule";
        DisProject: Record "Distribution Project";
    begin
        Clear(DisProject);
        DisProject.SetRange("Entry No.", GLEntry."Entry No.");
        DisProject.CalcSums("Project Amount");
        Amount := DisProject."Project Amount";
        Clear(DisRule);
        DisRule.SetRange("Entry No.", GLEntry."Entry No.");
        DisRule.CalcSums("Amount Allocated");
        RemAmount := Amount - DisRule."Amount Allocated";
    end;

    local procedure InsertDistributionRuleLine(DimTwoValeFilter: Code[20]; DisAmtValue: Decimal; DimFilter: Integer)
    var
        GLEntry: Record "G/L Entry";
        GeneLedSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
        DistRule: Record "Distribution Rule";
        DistProject: Record "Distribution Project";
        DistributionLine: Record "Distribution Line";
        "Account Category": Enum "G/L Account Category";
        TxtFilter: Text;
        TotProjAmt: Decimal;
        LineInx: Integer;
        LineCreated: Boolean;
        MonthAndYear: Boolean;
    begin
        Clear(GLEntry);
        GLEntry.Get(Rec."Entry No.");
        CalRemAmount(GLEntry);
        if (RemAmount = 0) then
            Error('Remaining amount must have a value');
        GeneLedSetup.Get();
        DimValue.SetRange("Dimension Code", GeneLedSetup."Shortcut Dimension 1 Code");
        DimValue.SetFilter("Shortcut Dimension 2 Code", DimTwoValeFilter);
        DimValue.SetRange("Distribute Enable", true);
        Clear(DistProject);
        DistProject.SetRange("Entry No.", Rec."Entry No.");
        DistProject.SetFilter("Shortcut Dimension 2 Code", DimTwoValeFilter);
        if (DistProject.FindSet()) then
            repeat
                DistProject.TestField("Project Amount");
                if (TxtFilter = '') then
                    TxtFilter := DistProject."Shortcut Dimension 3 Code"
                else
                    TxtFilter += '|' + DistProject."Shortcut Dimension 3 Code";

                TotProjAmt += DistProject."Project Amount";
            until DistProject.Next() = 0;
        if (TotProjAmt <> DisAmtValue) then
            Error('Total project amount must be equal to distribution amount.');

        Clear(DistRule);
        DistRule.Reset();
        DistRule.SetRange("Entry No.", Rec."Entry No.");
        DistRule.SetRange("Shortcut Dimension 2 Code", DimTwoValeFilter);
        if (DistRule.FindSet() = true) then begin
            DistProject.Reset();
            DistProject.SetRange("Entry No.", Rec."Entry No.");
            DistProject.CalcSums("Emp. Count");
            if (DistProject."Emp. Count" = DistributionRuleCount) then
                exit
            else
                Error('Line exist please delete line.');
        end;

        DistRule.SetRange("Shortcut Dimension 2 Code");
        if (DistRule.FindLast() = true) then
            LineInx := DistRule."Line No." + 1;

        if (TxtFilter <> '') then
            DimValue.SetFilter("Shortcut Dimension 3 Code", TxtFilter)
        else
            DimValue.SetRange("Shortcut Dimension 3 Code", TxtFilter);

        if (DimValue.FindSet() = true) then begin
            if (Rec."Distribution Setup" = true) then begin
                Clear(DistributionLine);
                GetMonthAndYear(GLEntry);
                DistributionLine.SetRange(Year, DistributionYear);
                DistributionLine.SetRange(Month, DistributionMonth);
                if (DistributionLine.FindSet() = true) then begin
                    // InitDistutionRule2(DimValue, DistributionLine, LineInx, 1);
                    LineCreated := true;
                end;
            end
            else begin
                InitDistutionRule(DimValue, LineInx, 1);
                LineCreated := true;
            end;
        end;

        DimValue.SetRange("Shortcut Dimension 3 Code");
        if (TxtFilter <> '') then
            DimValue.SetFilter("Shortcut Dimension 3 Two", TxtFilter)
        else
            DimValue.SetRange("Shortcut Dimension 3 Two", TxtFilter);

        if (DimValue.FindSet() = true) then begin
            if (Rec."Distribution Setup" = true) then begin
                Clear(DistributionLine);
                GetMonthAndYear(GLEntry);
                DistributionLine.SetFilter("Shortcut Dimension 3 Two", TxtFilter);
                DistributionLine.SetRange(Year, DistributionYear);
                DistributionLine.SetRange(Month, DistributionMonth);
                if (DistributionLine.FindSet() = true) then begin
                    // InitDistutionRule2(DimValue, DistributionLine, LineInx, 2);
                    LineCreated := true;
                end;
            end
            else begin
                InitDistutionRule(DimValue, LineInx, 2);
                LineCreated := true;
            end;
        end;

        DimValue.SetRange("Shortcut Dimension 3 Two");
        if TxtFilter <> '' then
            DimValue.SetFilter("Shortcut Dimension 3 Three", TxtFilter)
        else
            DimValue.SetRange("Shortcut Dimension 3 Three", TxtFilter);
        if DimValue.FindSet() then begin
            if (Rec."Distribution Setup" = true) then begin
                Clear(DistributionLine);
                GetMonthAndYear(GLEntry);
                DistributionLine.SetFilter("Shortcut Dimension 3 Three", TxtFilter);
                DistributionLine.SetRange(Year, DistributionYear);
                DistributionLine.SetRange(Month, DistributionMonth);
                if (DistributionLine.FindSet() = true) then begin
                    InitDistutionRule2(DimValue, DistributionLine, Rec, LineInx, 3);
                    LineCreated := true;
                end;
            end else begin
                InitDistutionRule(DimValue, LineInx, 3);
                LineCreated := true;
            end;
        end;

        if not LineCreated then begin
            Message('Line not generated.');
            exit;
        end;
        CurrPage.DistributionRule.Page.UpdateAmount(Amount, 0);
        Message('Line generated successfully.');
    end;

    local procedure InsertDistributionRuleLineOnProjectLine(DimTwoValeFilter: Code[20]; DisAmtValue: Decimal; DimFilter: Integer)
    var
        GLEntry: Record "G/L Entry";
        GeneLedSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
        DistRule: Record "Distribution Rule";
        DistProject: Record "Distribution Project";
        DistributionLine: Record "Distribution Line";
        "Account Category": Enum "G/L Account Category";
        ListFilter1: List of [Text];
        ListFilter2: List of [Text];
        TxtFilter: Text;
        TxtFilter1: Text;
        TxtFilter2: Text;
        CopyTxtFilter: Text;
        IntFilter1: Integer;
        IntFilter2: Integer;
        TotProjAmt: Decimal;
        LineInx: Integer;
        LineCreated: Boolean;
        MonthAndYear: Boolean;
        EmployeeCode: Text;
        Value: Text;
        Integer2: Integer;
        Integer: Integer;
    begin
        Clear(GLEntry);
        GLEntry.Get(Rec."Entry No.");
        CalRemAmount(GLEntry);
        if (RemAmount = 0) then
            Error('Remaining amount must have a value');
        GeneLedSetup.Get();
        DimValue.SetRange("Dimension Code", GeneLedSetup."Shortcut Dimension 1 Code");
        DimValue.SetFilter("Shortcut Dimension 2 Code", DimTwoValeFilter);
        DimValue.SetRange("Distribute Enable", true);
        Clear(DistProject);
        DistProject.SetRange("Entry No.", Rec."Entry No.");
        DistProject.SetFilter("Shortcut Dimension 2 Code", DimTwoValeFilter);
        GetMonthAndYear(GLEntry);
        if (DistProject.FindSet()) then
            repeat
                DistProject.TestField("Project Amount");
                if (Rec."Distrubution Method" = Rec."Distrubution Method"::Proportion) then begin
                    Clear(DistributionLine);
                    DistributionLine.SetRange(Year, DistributionYear);
                    DistributionLine.SetRange(Month, DistributionMonth);
                    DistributionLine.SetRange("Shortcut Dimension 2 Code", DimTwoValeFilter);
                    DistributionLine.SetRange("Shortcut Dimension 1 Code", DistProject."Shortcut Dimension 3 Code");
                    if (DistributionLine.FindFirst() = true) then begin
                        // repeat
                        if (DistributionLine."Shortcut Dimension 3 Code" <> '') then begin
                            ListFilter1.Add(DistributionLine."Shortcut Dimension 3 Code");
                            Count += 1;
                        end;

                        if (DistributionLine."Shortcut Dimension 3 Two" <> '') then begin
                            Count += 1;
                            ListFilter1.Add(DistributionLine."Shortcut Dimension 3 Two");
                        end;

                        if (DistributionLine."Shortcut Dimension 3 Three" <> '') then begin
                            Count += 1;
                            ListFilter1.Add(DistributionLine."Shortcut Dimension 3 Three");
                        end;
                        // until DistributionLine.Next() = 0;
                    end;
                end else begin
                    if (TxtFilter = '') then
                        TxtFilter := DistProject."Shortcut Dimension 3 Code"
                    else
                        TxtFilter += '|' + DistProject."Shortcut Dimension 3 Code";

                end;
                TotProjAmt += DistProject."Project Amount";
            until DistProject.Next() = 0;

        for Integer := 1 to ListFilter1.Count do begin
            Value := ListFilter1.Get(Integer);
            if (ListFilter2.IndexOf(Value) = 0) then
                ListFilter2.Add(Value);
        end;

        for Integer2 := 1 to ListFilter2.Count do begin
            if (TxtFilter = '') then
                TxtFilter := ListFilter2.Get(Integer2)
            else
                TxtFilter += '|' + ListFilter2.Get(Integer2)
        end;

        if (TotProjAmt <> DisAmtValue) then
            Error('Total project amount must be equal to distribution amount.');

        Clear(DistRule);
        DistRule.Reset();
        DistRule.SetRange("Entry No.", Rec."Entry No.");
        DistRule.SetRange("Shortcut Dimension 2 Code", DimTwoValeFilter);
        if (DistRule.FindSet() = true) then begin
            DistProject.Reset();
            DistProject.SetRange("Entry No.", Rec."Entry No.");
            DistProject.CalcSums("Emp. Count");
            if (Rec."Distrubution Method" = Rec."Distrubution Method"::Proportion) then begin
                if (Count = DistributionRuleCount) then
                    exit
                else
                    Error('Line exist please delete line.');
            end else begin
                if (DistProject."Emp. Count" = DistributionRuleCount) then
                    exit
                else
                    Error('Line exist please delete line.');
            end;

        end;

        DistRule.SetRange("Shortcut Dimension 2 Code");
        if (DistRule.FindLast() = true) then
            LineInx := DistRule."Line No." + 1;

        if (TxtFilter <> '') then
            DimValue.SetFilter("Shortcut Dimension 3 Code", TxtFilter)
        else
            DimValue.SetRange("Shortcut Dimension 3 Code", TxtFilter);

        if (DimValue.FindSet() = true) then begin
            if (Rec."Distribution Setup" = true) then begin
                Clear(DistributionLine);
                GetMonthAndYear(GLEntry);
                DistributionLine.SetRange(Year, DistributionYear);
                DistributionLine.SetRange(Month, DistributionMonth);
                if (DistributionLine.FindSet() = true) then begin
                    InitDistutionRule2(DimValue, DistributionLine, Rec, LineInx, 1);
                    LineCreated := true;
                end;
            end
            else begin
                InitDistutionRule(DimValue, LineInx, 1);
                LineCreated := true;
            end;
        end;

        DimValue.SetRange("Shortcut Dimension 3 Code");
        if (TxtFilter <> '') then
            DimValue.SetFilter("Shortcut Dimension 3 Two", TxtFilter)
        else
            DimValue.SetRange("Shortcut Dimension 3 Two", TxtFilter);

        if (DimValue.FindSet() = true) then begin
            if (Rec."Distribution Setup" = true) then begin
                Clear(DistributionLine);
                GetMonthAndYear(GLEntry);
                DistributionLine.SetFilter("Shortcut Dimension 3 Two", TxtFilter);
                DistributionLine.SetRange(Year, DistributionYear);
                DistributionLine.SetRange(Month, DistributionMonth);
                if (DistributionLine.FindSet() = true) then begin
                    InitDistutionRule2(DimValue, DistributionLine, Rec, LineInx, 2);
                    LineCreated := true;
                end;
            end
            else begin
                InitDistutionRule(DimValue, LineInx, 2);
                LineCreated := true;
            end;
        end;

        DimValue.SetRange("Shortcut Dimension 3 Two");
        if TxtFilter <> '' then
            DimValue.SetFilter("Shortcut Dimension 3 Three", TxtFilter)
        else
            DimValue.SetRange("Shortcut Dimension 3 Three", TxtFilter);
        if DimValue.FindSet() then begin
            if (Rec."Distribution Setup" = true) then begin
                Clear(DistributionLine);
                GetMonthAndYear(GLEntry);
                DistributionLine.SetFilter("Shortcut Dimension 3 Three", TxtFilter);
                DistributionLine.SetRange(Year, DistributionYear);
                DistributionLine.SetRange(Month, DistributionMonth);
                if (DistributionLine.FindSet() = true) then begin
                    InitDistutionRule2(DimValue, DistributionLine, Rec, LineInx, 3);
                    LineCreated := true;
                end;
            end else begin
                InitDistutionRule(DimValue, LineInx, 3);
                LineCreated := true;
            end;
        end;

        if not LineCreated then begin
            Message('Line not generated.');
            exit;
        end;
        CurrPage.DistributionRule.Page.UpdateAmount(Amount, 0);
        Message('Line generated successfully.');
    end;

    local procedure InitDistutionRule(var DimValue: Record "Dimension Value"; var LineInx: Integer; FieldNo: Integer)
    var
        DistProject: Record "Distribution Project";
        DistRule: Record "Distribution Rule";
        GLEntry: Record "G/L Entry";
        Inx: Integer;
    begin
        repeat
            DimValue.TestField("Distribute Enable", true);
            Clear(Inx);
            if FieldNo = 1 then begin
                if DimValue."Shortcut Dimension 3 Code" <> '' then
                    DimValue.TestField("Percentage One");
                if DimValue."Shortcut Dimension 3 Two" <> '' then
                    DimValue.TestField("Percentage Two");
                if DimValue."Shortcut Dimension 3 Three" <> '' then
                    DimValue.TestField("Percentage Three");
                if (DimValue."Percentage One" + DimValue."Percentage Two" + DimValue."Percentage Three") <> 100 then
                    Error('Total precentage must be 100 to employee %1', DimValue.Code);
            end;
            if Rec."Distrubution Method" = Rec."Distrubution Method"::Proportion then begin
                if DimValue."Shortcut Dimension 3 Code" <> '' then
                    Inx += 1;
                if DimValue."Shortcut Dimension 3 Two" <> '' then
                    Inx += 1;
                if DimValue."Shortcut Dimension 3 Three" <> '' then
                    Inx += 1;
            end;

            LineInx += 10000;
            Clear(DistRule);
            DistRule.Init();
            DistRule."Entry No." := Rec."Entry No.";
            DistRule."Line No." := LineInx;
            DistRule."Shortcut Dimension 1 Code" := DimValue.Code;
            DistRule."Shortcut Dimension 2 Code" := DimValue."Shortcut Dimension 2 Code";
            DistRule."Emp. Project Count" := Inx;
            if FieldNo = 1 then begin
                DistRule."Shortcut Dimension 3 Code" := DimValue."Shortcut Dimension 3 Code";
                DistRule."Emp. Project Percentage" := DimValue."Percentage One";
            end;
            if FieldNo = 2 then begin
                DistRule."Shortcut Dimension 3 Code" := DimValue."Shortcut Dimension 3 Two";
                DistRule."Emp. Project Percentage" := DimValue."Percentage Two";
            end;
            if FieldNo = 3 then begin
                DistRule."Shortcut Dimension 3 Code" := DimValue."Shortcut Dimension 3 Three";
                DistRule."Emp. Project Percentage" := DimValue."Percentage Three";
            end;
            Clear(DistProject);
            DistProject.Get(Rec."Entry No.", DistRule."Shortcut Dimension 3 Code", DimValue."Shortcut Dimension 2 Code");
            DistRule."G/L Account No." := DistProject."G/L Account No.";
            Clear(GLEntry);
            GLEntry.Get(Rec."Entry No.");
            DistRule."Posting Date" := GLEntry."Posting Date";
            DistRule.Insert()
        until DimValue.Next() = 0;
    end;

    local procedure InitDistutionRule2(var DimValue: Record "Dimension Value"; var DistributionLine: Record "Distribution Line"; var DistributionRuleFilter: Record "Distribution Rule Filter"; var LineInx: Integer; FieldNo: Integer): Integer
    var
        DistProject: Record "Distribution Project";
        DistRule: Record "Distribution Rule";
        GLEntry: Record "G/L Entry";
        Inx: Integer;
        DistributionRuleCount: Integer;
    begin
        repeat
            // DimValue.TestField("Distribute Enable", true);
            Clear(Inx);
            if FieldNo = 1 then begin
                if DistributionLine."Shortcut Dimension 3 Code" <> '' then
                    DistributionLine.TestField("Percentage One");
                if DistributionLine."Shortcut Dimension 3 Two" <> '' then
                    DistributionLine.TestField("Percentage Two");
                if DistributionLine."Shortcut Dimension 3 Three" <> '' then
                    DistributionLine.TestField("Percentage Three");
                if (DistributionLine."Percentage One" + DistributionLine."Percentage Two" + DistributionLine."Percentage Three") <> 100 then
                    Error('Total precentage must be 100 to employee %1', DistributionLine."Shortcut Dimension 1 Code");
            end;
            if Rec."Distrubution Method" = Rec."Distrubution Method"::Proportion then begin
                if DimValue."Shortcut Dimension 3 Code" <> '' then
                    Inx += 1;
                if DimValue."Shortcut Dimension 3 Two" <> '' then
                    Inx += 1;
                if DimValue."Shortcut Dimension 3 Three" <> '' then
                    Inx += 1;
            end;

            LineInx += 10000;
            Clear(DistRule);
            DistRule.Init();
            DistRule."Entry No." := Rec."Entry No.";
            DistRule."Line No." := LineInx;
            DistRule."Shortcut Dimension 1 Code" := DistributionLine."Shortcut Dimension 1 Code";
            DistRule."Shortcut Dimension 2 Code" := DistributionLine."Shortcut Dimension 2 Code";
            DistRule."Emp. Project Count" := Inx;
            if FieldNo = 1 then begin
                DistRule."Shortcut Dimension 3 Code" := DistributionLine."Shortcut Dimension 3 Code";
                DistRule."Emp. Project Percentage" := DistributionLine."Percentage One";
            end;

            if FieldNo = 2 then begin
                DistRule."Shortcut Dimension 3 Code" := DistributionLine."Shortcut Dimension 3 Two";
                DistRule."Emp. Project Percentage" := DistributionLine."Percentage Two";
            end;

            if FieldNo = 3 then begin
                DistRule."Shortcut Dimension 3 Code" := DistributionLine."Shortcut Dimension 3 Three";
                DistRule."Emp. Project Percentage" := DistributionLine."Percentage Three";
            end;

            Clear(DistProject);
            if (DistributionRuleFilter."Distrubution Method" = DistributionRuleFilter."Distrubution Method"::Proportion) then
                DistProject.Get(Rec."Entry No.", DistributionLine."Shortcut Dimension 1 Code", DistributionLine."Shortcut Dimension 2 Code")
            else
                DistProject.Get(Rec."Entry No.", DistRule."Shortcut Dimension 3 Code", DistributionLine."Shortcut Dimension 2 Code");

            DistRule."G/L Account No." := DistProject."G/L Account No.";
            Clear(GLEntry);
            GLEntry.Get(Rec."Entry No.");
            DistRule."Posting Date" := GLEntry."Posting Date";
            DistRule.Insert();
            DistributionRuleCount += 1
        until DistributionLine.Next() = 0;
    end;

    local procedure UpdatetDistributionRuleLine(DimTwoFilter: Code[20]; DistbuteAmt: Decimal)
    var
        GLEntry: Record "G/L Entry";
        DistRule: Record "Distribution Rule";
        DistProject: Record "Distribution Project";
        UserCustManage: Codeunit "User Customize Manage";
        ShortDimOne: Code[20];
        AmuntDis: Decimal;
        CalRemAmount: Decimal;
        TotCalRemAmount: Decimal;
        EmpCount: Integer;
        Inx: Integer;
    begin
        Clear(GLEntry);
        GLEntry.Get(Rec."Entry No.");
        CalRemAmount(GLEntry);
        if RemAmount = 0 then
            Error('Remaining amount must have a value');
        if Rec."Distrubution Method" = Rec."Distrubution Method"::Manually then
            Error('Distrubution method manually selected.');
        if (Rec."Distrubution Method" = Rec."Distrubution Method"::Equally) or
            (Rec."Distrubution Method" = Rec."Distrubution Method"::Proportion) then begin
            Clear(DistProject);
            DistProject.SetRange("Entry No.", Rec."Entry No.");
            DistProject.SetFilter("Shortcut Dimension 2 Code", DimTwoFilter);
            DistProject.CalcSums("Emp. Count");
            Clear(DistRule);
            DistRule.SetRange("Entry No.", Rec."Entry No.");
            DistRule.SetFilter("Shortcut Dimension 2 Code", DimTwoFilter);
            if not DistRule.FindSet() then
                Error('Nothing to update.');
            DistRule.SetCurrentKey("Shortcut Dimension 1 Code");
            repeat
                if ShortDimOne <> DistRule."Shortcut Dimension 1 Code" then begin
                    ShortDimOne := DistRule."Shortcut Dimension 1 Code";
                    EmpCount += 1;
                end;
            until DistRule.Next() = 0;
            if EmpCount = 0 then
                Error('Emp. count must have a value.');
            Inx := DistRule.Count();
            if Rec."Distrubution Method" = Rec."Distrubution Method"::Equally then
                AmuntDis := Round(DistbuteAmt / Inx, 0.01)
            else
                AmuntDis := Round(DistbuteAmt / EmpCount, 0.01);
            DistRule.FindSet();
            DistRule.SetCurrentKey("Entry No.", "Line No.");
            repeat
                if Inx <> 1 then begin
                    if Rec."Distrubution Method" = Rec."Distrubution Method"::Equally then
                        DistRule."Amount Allocated" := AmuntDis
                    else
                        DistRule."Amount Allocated" := AmuntDis * (DistRule."Emp. Project Percentage" / 100);
                end
                else
                    DistRule."Amount Allocated" := DistbuteAmt;

                DistRule.Modify();
                DistbuteAmt -= DistRule."Amount Allocated";
                Inx -= 1;
            until DistRule.Next() = 0;

        end;
        /*
        Clear(DistRule);
        DistRule.SetRange("Entry No.", Rec."Entry No.");
        DistRule.SetFilter("Shortcut Dimension 2 Code", DimTwoFilter);
        Clear(DistProject);
        DistProject.SetRange("Entry No.", Rec."Entry No.");
        DistProject.SetFilter("Shortcut Dimension 2 Code", DimTwoFilter);
        if not DistProject.FindSet() then
            Error('Nothing to update.');
        repeat
            DistRule.SetRange("Shortcut Dimension 3 Code", DistProject."Shortcut Dimension 3 Code");
            if not DistRule.FindSet() then
                Error('Nothing to update.');
            DistProject.TestField("Project Amount");
            CalRemAmount := DistProject."Project Amount";
            Inx := DistRule.Count();
            AmuntDis := Round(DistProject."Project Amount" / Inx, 0.01);
            TotCalRemAmount += DistProject."Project Amount";
            repeat
                if Inx <> 1 then begin
                    if Rec."Distrubution Method" = Rec."Distrubution Method"::Proportion then
                        DistRule."Amount Allocated" := AmuntDis * DistRule."Emp. Project Count" * (DistRule."Emp. Project Percentage" / 100)
                    else
                        DistRule."Amount Allocated" := AmuntDis;
                end
                else
                    DistRule."Amount Allocated" := CalRemAmount;
                DistRule.Modify();
                CalRemAmount -= DistRule."Amount Allocated";
                Inx -= 1;
            until DistRule.Next() = 0;
        until DistProject.Next() = 0;
        */

    end;

    local procedure UpdateEmpCountProject()
    var
        DistRule: Record "Distribution Rule";
        DistProject: Record "Distribution Project";
        UserCustManage: Codeunit "User Customize Manage";
        Proportion: Integer;
        Equally: Integer;
    begin
        DistProject.SetRange("Entry No.", Rec."Entry No.");
        if not DistProject.FindSet() then
            exit;
        DistRule.SetRange("Entry No.", Rec."Entry No.");
        repeat
            DistRule.SetRange("Shortcut Dimension 3 Code", DistProject."Shortcut Dimension 3 Code");
            DistRule.SetRange("Shortcut Dimension 2 Code", DistProject."Shortcut Dimension 2 Code");
            DistProject."Emp. Count" := DistRule.Count;
            DistProject.Modify();
        until DistProject.Next() = 0;
        if (Rec."Distrubution Method" = Rec."Distrubution Method"::Equally) or
            (Rec."Distrubution Method" = Rec."Distrubution Method"::Proportion) then begin
            if Rec."Dimension Value" <> '' then
                UserCustManage.UpdateDistAmountEquallyProporation(Rec, 0);
            if Rec."Dimension Value One" <> '' then
                UserCustManage.UpdateDistAmountEquallyProporation(Rec, 1);
            if Rec."Dimension Value Two" <> '' then
                UserCustManage.UpdateDistAmountEquallyProporation(Rec, 2);
            if Rec."Dimension Value Three" <> '' then
                UserCustManage.UpdateDistAmountEquallyProporation(Rec, 3);
            if Rec."Dimension Value Four" <> '' then
                UserCustManage.UpdateDistAmountEquallyProporation(Rec, 4);
            if Rec."Dimension Value Five" <> '' then
                UserCustManage.UpdateDistAmountEquallyProporation(Rec, 5);
        end;
    end;

    local procedure UpdateAmountManually()
    var
        DistRule: Record "Distribution Rule";
        DistProject: Record "Distribution Project";
        UserCustManage: Codeunit "User Customize Manage";
    begin
        if Rec."Dimension Value" <> '' then
            UserCustManage.UpdateDistAmountManually(Rec, 0);
        if Rec."Dimension Value One" <> '' then
            UserCustManage.UpdateDistAmountManually(Rec, 1);
        if Rec."Dimension Value Two" <> '' then
            UserCustManage.UpdateDistAmountManually(Rec, 2);
        if Rec."Dimension Value Three" <> '' then
            UserCustManage.UpdateDistAmountManually(Rec, 3);
        if Rec."Dimension Value Four" <> '' then
            UserCustManage.UpdateDistAmountManually(Rec, 4);
        if Rec."Dimension Value Five" <> '' then
            UserCustManage.UpdateDistAmountManually(Rec, 5);
    end;

    local procedure CheckingTotalValue()
    begin
        if Rec."Distrubution Amount" <> (Rec."Distrubution Amount One" + Rec."Distrubution Amount Two" +
            Rec."Distrubution Amount Three" + Rec."Distrubution Amount Four" + Rec."Distrubution Amount Five") then
            Error('Branch distribution total must be equal to Total distribution amount.');
    end;

    local procedure GetMonthAndYear(GlEntry: Record "G/L Entry")
    var
        DistributionPostingDate: Date;
        PostingDate: Text;
        Month: Text;
        Year: Text;
    begin
        DistributionPostingDate := GLEntry."Posting Date";
        PostingDate := Format(DistributionPostingDate);// 01/10/23
        Month := CopyStr(PostingDate, 1, 2);
        Year := CopyStr(PostingDate, 7, 8);
        DistributionYear := InsStr(Year, '20', 1);
        DistributionMonth := UserCustomizedmanage.ConvertingMonthAndYear(Month);
    end;

    // local procedure InsertDistributionRuleLineFromDistributionSetup(var DistributionRule: Record "Distribution Rule"; DistributionLines: Record "Distribution Line"; DistributionRuleLineNo: Integer): Integer
    // var
    //     RuleIncrement: Integer;
    // begin
    //     DistributionRule.Init();
    //     DistributionRule."Entry No." := Rec."Entry No.";
    //     DistributionRule."Line No." := DistributionRuleLineNo + 1000;
    //     DistributionRule."Shortcut Dimension 1 Code" := DistributionLines."Shortcut Dimension 1 Code";
    //     DistributionRule."Shortcut Dimension 2 Code" := DistributionLines."Shortcut Dimension 2 Code";
    //     DistributionRule."G/L Account No." := Rec."G/L Account No.";
    //     DistributionRule.Insert();
    //     exit(DistributionRule."Line No.");
    // end;

    var
        UserCustomizedmanage: Codeunit "User Customize Manage";
        DistributionYear: Text;
        DistributionMonth: Text;
        DistributionRuleCount: Integer;
        GLAccName: Text[100];
        Description: Text[100];
        GLEntryNo: Code[20];
        DocNo: Code[20];
        GLAccNo: Code[20];
        Amount: Decimal;
        RemAmount: Decimal;
        FieldEditable: Boolean;
        DisMFieldEditable: Boolean;
        FieldGLVisible: Boolean;
        FieldDimVEdit: Boolean;
        Count: Integer;
}