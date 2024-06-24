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
                    Editable = FieldDimVEdit;
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
                field("Distribution Method"; Rec."Distribution Method")
                {
                    ToolTip = 'Specifies Distribution Method field.';
                    Editable = IsFieldEditableDistributionMethod;
                    trigger OnValidate()
                    var
                        GLEntry: Record "G/L Entry";
                    begin
                        if (Rec."Distribution Method" = Rec."Distribution Method"::Manually) then
                            IsVisibleEmployeeDistributionAction := false
                        else
                            IsVisibleEmployeeDistributionAction := true;

                        GLEntry.Get(Rec."Entry No.");
                        CalRemAmount(GLEntry);
                        CurrPage.DistributionRule.Page.UpdateAmount(Amount, RemAmount);
                    end;
                }
                field("Distribution Amount"; Rec."Distribution Amount")
                {
                    ToolTip = 'Specifies the value of the Amount Distribute field.';
                    Visible = FieldEditable;
                }

                field("Distribution Setup"; Rec."Distribution Setup")
                {
                    ToolTip = 'Specifies Distribution Method Setup';
                }
                field("Dist Single Line Amount"; Rec."Dist Single Line Amount")
                {
                    ToolTip = 'Specifies the value of the Distribution Single Line Amount';
                }
            }
            group("Branch Distribution")
            {

                field("Dimension Value One"; Rec."Dimension Value One")
                {
                    ToolTip = 'Specifies the value of the Dimension Value One field.';
                    Editable = FieldDimVEdit;
                    trigger OnValidate()
                    var
                        GLEntry: Record "G/L Entry";
                    begin
                        GLEntry.Get(Rec."Entry No.");
                        CalRemAmount(GLEntry);
                        CurrPage.DistributionRule.Page.UpdateAmount(Amount, RemAmount);
                    end;
                }
                field("Distribution Amount One"; Rec."Distribution Amount One")
                {
                    ToolTip = 'Specifies the value of the Distribution Amount One field.';
                    Editable = FieldDimVEdit;
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
                    Editable = FieldDimVEdit;
                    trigger OnValidate()
                    var
                        GLEntry: Record "G/L Entry";
                    begin
                        GLEntry.Get(Rec."Entry No.");
                        CalRemAmount(GLEntry);
                        CurrPage.DistributionRule.Page.UpdateAmount(Amount, RemAmount);
                    end;
                }
                field("Distribution Amount Two"; Rec."Distribution Amount Two")
                {
                    ToolTip = 'Specifies the value of the Distribution Amount Two field.';
                    Editable = FieldDimVEdit;
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
                    Editable = FieldDimVEdit;
                    trigger OnValidate()
                    var
                        GLEntry: Record "G/L Entry";
                    begin
                        GLEntry.Get(Rec."Entry No.");
                        CalRemAmount(GLEntry);
                        CurrPage.DistributionRule.Page.UpdateAmount(Amount, RemAmount);
                    end;
                }
                field("Distribution Amount Three"; Rec."Distribution Amount Three")
                {
                    ToolTip = 'Specifies the value of the Distribution Amount Three field.';
                    Editable = FieldDimVEdit;
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
                    Editable = FieldDimVEdit;
                    trigger OnValidate()
                    var
                        GLEntry: Record "G/L Entry";
                    begin
                        GLEntry.Get(Rec."Entry No.");
                        CalRemAmount(GLEntry);
                        CurrPage.DistributionRule.Page.UpdateAmount(Amount, RemAmount);
                    end;
                }
                field("Distribution Amount Four"; Rec."Distribution Amount Four")
                {
                    ToolTip = 'Specifies the value of the Distribution Amount Four field.';
                    Editable = FieldDimVEdit;
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
                    Editable = FieldDimVEdit;
                    trigger OnValidate()
                    var
                        GLEntry: Record "G/L Entry";
                    begin
                        GLEntry.Get(Rec."Entry No.");
                        CalRemAmount(GLEntry);
                        CurrPage.DistributionRule.Page.UpdateAmount(Amount, RemAmount);
                    end;
                }
                field("Distribution Amount Five"; Rec."Distribution Amount Five")
                {
                    ToolTip = 'Specifies the value of the Distribution Amount Five field.';
                    Editable = FieldDimVEdit;
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
                Caption = 'Employee Line';
                SubPageLink = "Entry No." = field("Entry No.");
                // Editable = FieldEditable;
                Editable = IsEditableDistributionLinkParts;
            }
            part(DistributionRule; "Distribution Rule")
            {
                Caption = 'Project Line';
                SubPageLink = "Entry No." = field("Entry No.");
                Editable = IsEditableDistributionLinkParts;
                // Visible = IsVisibleDistributionRule;
            }

            part(DistributionProjectLine; "Distribution Project Line")
            {
                Caption = 'Combined Project Line';
                SubPageLink = "Entry No." = field("Entry No.");
                Editable = IsEditableDistributionLinkParts;
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
                Visible = IsVisibleEmployeeDistributionAction;
                trigger OnAction()
                var
                    GLEntry: Record "G/L Entry";
                    DistributionLines: Record "Distribution Line";
                    DistributionProject: Record "Distribution Project";
                    DistributionRule: Record "Distribution Rule";
                    BranchCodeList: List of [Text];
                    BranchCodeListTwo: List of [Text];
                    IntegerOfList: Integer;
                    IntegerOfListTwo: Integer;
                    DistributionProjectLineNo: Integer;
                    DistributionRuleLineNo: Integer;
                    ProjectIncrementValue: Integer;
                    DistRuleIncrementValue: Integer;
                    EmployeeCount: Integer;
                    ValueOfText: Text;
                    BranchCode: Text;
                    DimensionValueOne: Text;
                    DimensionValueTwo: Text;
                    DimensionValueThree: Text;
                    DimensionValueFour: Text;
                    DimensionValueFive: Text;
                begin
                    // CheckingTotalValue()
                    EmployeeDistributionAction := true;
                    VisibilityOfDistributionRuleFilterFileds();
                    if (Rec."Distribution Method" = Rec."Distribution Method"::Manually) then
                        Error('This Action Will Not Works Distribution Method is Manually Please Remove');

                    if Rec."Sales Invoice" then
                        if Rec."G/L Amount" <> 0 then
                            UpdateAmountManually();
                    GLEntry.Get(Rec."Entry No.");
                    CalRemAmount(GLEntry);
                    CurrPage.DistributionRule.Page.UpdateAmount(Amount, RemAmount);

                    /*Employee Distribution Entries*/

                    if ((Rec."Dimension Value One" = '') and (Rec."Distribution Amount One" = 0) and (Rec."Dimension Value Two" = '') and (Rec."Distribution Amount Two" = 0) and (Rec."Dimension Value Three" = '') and (Rec."Distribution Amount Three" = 0) and (Rec."Dimension Value Four" = '') and (Rec."Distribution Amount Four" = 0) and (Rec."Dimension Value Five" = '') and (Rec."Distribution Amount Five" = 0)) then begin
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
                                if (BranchCodeListTwo.IndexOf(ValueOfText) = 0) then
                                    BranchCodeListTwo.Add(ValueOfText);
                            end;

                            for IntegerOfListTwo := 1 to BranchCodeListTwo.Count do begin
                                if (BranchCode = '') then
                                    BranchCode := BranchCodeListTwo.Get(IntegerOfListTwo)
                                else
                                    BranchCode += '|' + BranchCodeListTwo.Get(IntegerOfListTwo)
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
                                        DistributionProject."Project Amount" := Round(Rec."Distribution Amount" / EmployeeCount, 0.01);
                                        DistributionProject."Project Line" := true;
                                        DistributionProject."Line No." := DistributionProjectLineNo + 1000;
                                        DistributionProject."Emp. Count" := UserCustomizedmanage.GetEmployeeCountFromDistributionSetup(DistributionYear, DistributionMonth, DistributionLines."Shortcut Dimension 1 Code", BranchCode);
                                        DistributionProject."G/L Account No." := GLEntry."G/L Account No.";
                                        DistributionProject.Insert(false);
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
                                            DistributionRule."Document No." := GLEntry."Document No.";
                                            DistributionRule.Modify(false);
                                        end;

                                        if (DistributionLines."Shortcut Dimension 3 Two" <> '') then begin
                                            DistRuleIncrementValue += 1;
                                            DistributionRuleLineNo := UserCustomizedmanage.InsertDistributionRuleLineFromDistributionSetup(Rec, DistributionRule, DistributionLines, DistributionRuleLineNo);
                                            DistributionRule."Shortcut Dimension 3 Code" := DistributionLines."Shortcut Dimension 3 Two";
                                            DistributionRule."Emp. Project Percentage" := DistributionLines."Percentage Two";
                                            DistributionRule."Posting Date" := GLEntry."Posting Date";
                                            DistributionRule."Document No." := GLEntry."Document No.";
                                            DistributionRule.Modify(false);
                                        end;

                                        if (DistributionLines."Shortcut Dimension 3 Three" <> '') then begin
                                            DistRuleIncrementValue += 1;
                                            DistributionRuleLineNo := UserCustomizedmanage.InsertDistributionRuleLineFromDistributionSetup(Rec, DistributionRule, DistributionLines, DistributionRuleLineNo);
                                            DistributionRule."Shortcut Dimension 3 Code" := DistributionLines."Shortcut Dimension 3 Three";
                                            DistributionRule."Emp. Project Percentage" := DistributionLines."Percentage Three";
                                            DistributionRule."Posting Date" := GLEntry."Posting Date";
                                            DistributionRule."Document No." := GLEntry."Document No.";
                                            DistributionRule.Modify(false);
                                        end;
                                        Clear(ProjectIncrementValue);
                                        Clear(DistRuleIncrementValue);
                                    until DistributionLines.Next() = 0;
                                end;
                            end;
                            Clear(DistributionYear);
                            Clear(DistributionMonth);

                            for IntegerOfListTwo := 1 to BranchCodeListTwo.Count do begin
                                if (DimensionValueOne = '') then begin
                                    Clear(Rec."Distribution Amount One");
                                    DimensionValueOne := BranchCodeListTwo.Get(IntegerOfListTwo);
                                    DistributionProject.SetRange("Entry No.", Rec."Entry No.");
                                    DistributionProject.SetRange("Shortcut Dimension 2 Code", DimensionValueOne);
                                    if (DistributionProject.FindSet(false) = true) then
                                        repeat
                                            Rec."Distribution Amount One" += DistributionProject."Project Amount";
                                        until DistributionProject.Next() = 0;
                                    Rec."Dimension Value One" := DimensionValueOne;
                                end else begin
                                    if (DimensionValueTwo = '') then begin
                                        Clear(Rec."Distribution Amount Two");
                                        DimensionValueTwo := BranchCodeListTwo.Get(IntegerOfListTwo);
                                        DistributionProject.SetRange("Entry No.", Rec."Entry No.");
                                        DistributionProject.SetRange("Shortcut Dimension 2 Code", DimensionValueTwo);
                                        if (DistributionProject.FindSet(false) = true) then
                                            repeat
                                                Rec."Distribution Amount Two" += DistributionProject."Project Amount";
                                            until DistributionProject.Next() = 0;
                                        Rec."Dimension Value Two" := DimensionValueTwo;
                                    end else begin
                                        if (DimensionValueThree = '') then begin
                                            Clear(Rec."Distribution Amount Three");
                                            DimensionValueThree := BranchCodeListTwo.Get(IntegerOfListTwo);
                                            DistributionProject.SetRange("Entry No.", Rec."Entry No.");
                                            DistributionProject.SetRange("Shortcut Dimension 2 Code", DimensionValueThree);
                                            if (DistributionProject.FindSet(false) = true) then
                                                repeat
                                                    Rec."Distribution Amount Three" += DistributionProject."Project Amount";
                                                until DistributionProject.Next() = 0;
                                            Rec."Dimension Value Three" := DimensionValueThree;
                                        end else begin
                                            if (DimensionValueFour = '') then begin
                                                Clear(Rec."Distribution Amount Four");
                                                DimensionValueFour := BranchCodeListTwo.Get(IntegerOfListTwo);
                                                DistributionProject.SetRange("Entry No.", Rec."Entry No.");
                                                DistributionProject.SetRange("Shortcut Dimension 2 Code", DimensionValueFour);
                                                if (DistributionProject.FindSet(false) = true) then
                                                    repeat
                                                        Rec."Distribution Amount Four" += DistributionProject."Project Amount";
                                                    until DistributionProject.Next() = 0;
                                                Rec."Dimension Value Four" := DimensionValueFour;
                                            end else begin
                                                if (DimensionValueFive = '') then begin
                                                    Clear(Rec."Distribution Amount Five");
                                                    DimensionValueFive := BranchCodeListTwo.Get(IntegerOfListTwo);
                                                    DistributionProject.SetRange("Entry No.", Rec."Entry No.");
                                                    DistributionProject.SetRange("Shortcut Dimension 2 Code", DimensionValueFive);
                                                    if (DistributionProject.FindSet(false) = true) then
                                                        repeat
                                                            Rec."Distribution Amount Five" += DistributionProject."Project Amount";
                                                        until DistributionProject.Next() = 0;
                                                    Rec."Dimension Value Five" := DimensionValueFive;
                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                            end;

                        end;
                    end
                    else
                        Error('Please delete the Dimension Value Code, Dimension Value Amount, Employee Lines and Project Lines');
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
                    AzzDistributionRule: Record "Distribution Rule";
                    DistributionLine: Record "Distribution Line";
                    LineNo: Integer;
                    RoundTotalProjectAmount: Decimal;
                    TotalProjectAmount: Decimal;
                    AddRoundTotalProjectAmount: Decimal;
                    SubRoundTotalProjectAmount: Decimal;
                begin
                    Clear(GLEntry);
                    GLEntry.Get(Rec."Entry No.");
                    CalRemAmount(GLEntry);
                    if (RemAmount = 0) then
                        Error('Remaining amount must have a value');

                    Distributionproject.Reset();
                    Distributionproject.SetRange("Entry No.", Rec."Entry No.");
                    if (Distributionproject.FindSet(false) = false) then
                        exit
                    else
                        repeat
                            Distributionproject.TestField("Project Amount");
                            AzzDistributionRule.SetRange("Entry No.", Rec."Entry No.");
                            AzzDistributionRule.SetRange("Shortcut Dimension 1 Code", Distributionproject."Shortcut Dimension 3 Code");
                            AzzDistributionRule.SetRange("Shortcut Dimension 2 Code", Distributionproject."Shortcut Dimension 2 Code");
                            if (AzzDistributionRule.FindSet(false) = true) then
                                repeat
                                    AzzDistributionRule."Amount Allocated" := Round((Distributionproject."Project Amount") * (AzzDistributionRule."Emp. Project Percentage" / 100), 0.01);
                                    AzzDistributionRule.Modify(false);
                                until AzzDistributionRule.Next() = 0;

                            RoundTotalProjectAmount += Distributionproject."Project Amount";
                        until Distributionproject.Next() = 0;
                    UserCustomizedmanage.CalculateAndUpdateRemainingAmountonDistributionLines(GLEntry);
                    if (Rec."Dist Single Line Amount" = false) then
                        UserCustomizedmanage.CombineProjectCodeAndAmount(AzzDistributionRule, Distributionproject);

                    if (RoundTotalProjectAmount) <> (Rec."Distribution Amount") then begin
                        AddRoundTotalProjectAmount := (RoundTotalProjectAmount + 10);
                        SubRoundTotalProjectAmount := (RoundTotalProjectAmount - 10);
                        if ((RoundTotalProjectAmount > AddRoundTotalProjectAmount) or (RoundTotalProjectAmount < SubRoundTotalProjectAmount)) then
                            Error('Total project is %1 amount must be equal to Distribution amount %2.', (RoundTotalProjectAmount), Rec."Distribution Amount");
                    end;

                    RemAmount := 0;
                    CurrPage.DistributionRule.Page.UpdateAmount(Amount, RemAmount);
                    UserCustomizedmanage.UpdateGLEntryApplied(GLEntry."Document No.", GLEntry."Global Dimension 2 Code", GLEntry."Global Dimension 1 Code",
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
        FieldDimVEdit := true;
        IsEditableDistributionLinkParts := true;
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

        if (GLEntry."Distributio Rule Applied" = true) then begin
            FieldDimVEdit := false;
            IsEditableDistributionLinkParts := false;
        end;

        if Rec."Sales Invoice" then begin
            Rec."Distribution Amount" := Amount;
            Rec."Distribution Method" := Rec."Distribution Method"::Manually;
            FieldEditable := false;
            IsFieldEditableDistributionMethod := false;
            if Rec."Distribution Amount" = 0 then
                Rec."Distribution Amount" := Rec."G/L Amount";
        end
        else
            Rec."Distribution Amount" := Rec."G/L Amount";

        if not Rec."Sales Invoice" then
            if Rec."Dimension Filter Exsist" then begin
                FieldEditable := false;
                IsFieldEditableDistributionMethod := true;
            end
            else
                IsFieldEditableDistributionMethod := true;

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
                Rec."Distribution Amount One" := Rec."Distribution Amount";
            end;
        end;

        if (Rec."Distribution Method" = Rec."Distribution Method"::Manually) then
            IsVisibleEmployeeDistributionAction := false
        else
            IsVisibleEmployeeDistributionAction := true;

        if (Rec."Dist Single Line Amount" = false) then
            IsVisibleDistributionRule := true;

        Rec.Modify();
        CurrPage.DistributionRule.Page.UpdateAmount(Amount, RemAmount);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        GLEntry: Record "G/L Entry";
    begin
        GLEntry.Get(Rec."Entry No.");
        CalRemAmount(GLEntry);
        if (RemAmount <> 0) then begin
            Message('Distribution amount not fully applied.');
            UserCustomizedmanage.UpdateGLEntryUnApplied(GLEntry."Document No.", GLEntry."Global Dimension 2 Code",
                GLEntry."Global Dimension 1 Code", Rec."G/L Account No.");
        end
        else
            if not UserCustomizedmanage.CheckDistProjectExist(Rec."Entry No.") then
                UserCustomizedmanage.UpdateGLEntryUnApplied(GLEntry."Document No.", GLEntry."Global Dimension 2 Code",
                     GLEntry."Global Dimension 1 Code", Rec."G/L Account No.");

    end;

    procedure InitPageDetails(var GLEntry: Record "G/L Entry")
    begin
        DocNo := GLEntry."Document No.";
        Description := GLEntry.Description;
    end;

    local procedure CalRemAmount(GLEntry: Record "G/L Entry")
    var
        DistributionRule: Record "Distribution Rule";
        DistributionProject: Record "Distribution Project";
    begin
        Clear(DistributionProject);
        DistributionProject.SetRange("Entry No.", GLEntry."Entry No.");
        DistributionProject.CalcSums("Project Amount");
        Amount := DistributionProject."Project Amount";
        Clear(DistributionRule);
        DistributionRule.SetRange("Entry No.", GLEntry."Entry No.");
        DistributionRule.CalcSums("Amount Allocated");
        RemAmount := Amount - DistributionRule."Amount Allocated";
    end;

    local procedure UpdateAmountManually()
    var
        DistRule: Record "Distribution Rule";
        DistProject: Record "Distribution Project";
    begin
        if Rec."Dimension Value" <> '' then
            UserCustomizedmanage.UpdateDistAmountManually(Rec, 0);
        if Rec."Dimension Value One" <> '' then
            UserCustomizedmanage.UpdateDistAmountManually(Rec, 1);
        if Rec."Dimension Value Two" <> '' then
            UserCustomizedmanage.UpdateDistAmountManually(Rec, 2);
        if Rec."Dimension Value Three" <> '' then
            UserCustomizedmanage.UpdateDistAmountManually(Rec, 3);
        if Rec."Dimension Value Four" <> '' then
            UserCustomizedmanage.UpdateDistAmountManually(Rec, 4);
        if Rec."Dimension Value Five" <> '' then
            UserCustomizedmanage.UpdateDistAmountManually(Rec, 5);
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

    local procedure VisibilityOfDistributionRuleFilterFileds()
    begin
        if (EmployeeDistributionAction = true) then begin
            IsEditableDistributionLinkParts := false;
            IsFieldEditableDistributionMethod := false;
            FieldDimVEdit := false;
        end else
            IsEditableDistributionLinkParts := true;
    end;

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
        IsFieldEditableDistributionMethod: Boolean;
        FieldGLVisible: Boolean;
        FieldDimVEdit: Boolean;
        IsVisibleEmployeeDistributionAction: Boolean;
        IsEditableDistributionLinkParts: Boolean;
        EmployeeDistributionAction: Boolean;
        IsVisibleDistributionRule: Boolean;
}