page 50200 "Distribution Rule"
{
    ApplicationArea = All;
    Caption = 'Distribution Rule';
    PageType = ListPart;
    SourceTable = "Distribution Rule";
    SourceTableView = sorting("Entry No.", "Line No.");
    DelayedInsert = true;
    AutoSplitKey = true;
    MultipleNewLines = true;
    LinksAllowed = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                    Editable = false;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                    Editable = false;
                }
                field("Emp. Project Count"; Rec."Emp. Project Count")
                {
                    ToolTip = 'Specifies the value of the Emp. Project Count field.';
                    Visible = false;
                }
                field("Emp. Project Percentage"; Rec."Emp. Project Percentage")
                {
                    ToolTip = 'Specifies the value of the Emp. Project Percentage field.';
                    Visible = false;
                }
                field("Amount Allocated"; Rec."Amount Allocated")
                {
                    ToolTip = 'Specifies the value of the Amount Allocated field.';
                    trigger OnValidate()
                    var
                        GLEntry: Record "G/L Entry";
                        DistributionRuleFilter: Record "Distribution Rule Filter";
                    begin
                        if (GLEntry.Get(Rec."Entry No.") = false) then
                            exit;

                        if (DistributionRuleFilter.Get(Rec."Entry No.") = false) then
                            exit;

                        if (DistributionRuleFilter."Dist Single Line Amount" = true) then begin
                            CalculateEachLineReminingAmount(GLEntry);
                        end else begin
                            CheckingAllocation();
                            CalRemAmount(GLEntry);
                        end;

                        if RemAmount = 0 then
                            UserCustomizedmanage.UpdateGLEntryApplied(GLEntry."Document No.", DistributionRuleFilter."Dimension Value",
                                 GLEntry."Global Dimension 1 Code", DistributionRuleFilter."G/L Account No.");
                        CurrPage.Update(true);
                    end;
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ToolTip = 'Specifies the value of the G/L Account No. field.';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                    Editable = false;
                }
            }
            group("Allocation Details")
            {
                ShowCaption = false;
                field(Amount; Amount)
                {
                    Caption = 'Amount';
                    Editable = false;
                    ApplicationArea = All;
                    Style = Strong;
                }
                field(RemAmount; RemAmount)
                {
                    Caption = 'Remaining Amount';
                    Editable = false;
                    ApplicationArea = All;
                    Style = Strong;
                }
            }
        }

    }
    actions
    {
        area(Processing)
        {
            action("Allocation Project Amount Upload")
            {
                ApplicationArea = All;
                Image = UpdateXML;
                trigger OnAction()
                var
                    DisRuleFilter: Record "Distribution Rule Filter";
                    AzzDistributionRule: Record "Distribution Rule";
                    Distributionproject: Record "Distribution Project";
                    GLEntry: Record "G/L Entry";
                begin
                    AzzDistributionRule.Copy(Rec);
                    UserCustomizedmanage.UploadDistributionRuleFromExcel(AzzDistributionRule);
                    DisRuleFilter.Get(Rec."Entry No.");
                    GLEntry.Get(Rec."Entry No.");
                    CalRemAmount(GLEntry);
                    if RemAmount = 0 then
                        UserCustomizedmanage.UpdateGLEntryApplied(GLEntry."Document No.", DisRuleFilter."Dimension Value",
                             GLEntry."Global Dimension 1 Code", DisRuleFilter."G/L Account No.");

                    CurrPage.Update(true);
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        AmountAlloEdit := false;
    end;

    trigger OnAfterGetCurrRecord()
    begin

    end;

    trigger OnDeleteRecord(): Boolean
    begin
        RemAmount := RemAmount + Rec."Amount Allocated";
        CurrPage.Update(true);
    end;

    procedure UpdateAmount(PassAmt: Decimal; PassRemAmt: Decimal)
    begin
        Amount := PassAmt;
        RemAmount := PassRemAmt;
        CurrPage.Update(true);
    end;


    local procedure InitPageDetails(var GLEntry: Record "G/L Entry")
    begin
        Amount := GLEntry.Amount;
        CalRemAmount(GLEntry);
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

    local procedure CalculateEachLineReminingAmount(GLEntry: Record "G/L Entry")
    var
        DistributionRule: Record "Distribution Rule";
        DistributionProject: Record "Distribution Project";
    begin
        Clear(DistributionProject);
        DistributionProject.SetRange("Entry No.", GLEntry."Entry No.");
        DistributionProject.CalcSums("Project Amount");
        Amount := DistributionProject."Project Amount";
        DistributionRuleAmount += Rec."Amount Allocated";
        RemAmount := Amount - DistributionRuleAmount;
    end;

    local procedure CheckingAllocation()
    var
        DistRuleFilter: Record "Distribution Rule Filter";
        DistRule: Record "Distribution Rule";
        DistProject: Record "Distribution Project";
        ProjAmount: Decimal;
    begin
        DistRuleFilter.Get(Rec."Entry No.");
        if DistRuleFilter."Negative Allocation" then begin
            if Rec."Amount Allocated" > 0 then
                Error('Allocated amount be negative.');
        end else begin
            if Rec."Amount Allocated" < 0 then
                Error('Allocated amount be positive.');
        end;

        DistProject.Get(Rec."Entry No.", Rec."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 2 Code");
        ProjAmount := DistProject."Project Amount";
        Clear(DistRule);
        DistRule.SetRange("Entry No.", Rec."Entry No.");
        DistRule.SetRange("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
        DistRule.FindSet();
        repeat
            if DistRule."Line No." <> Rec."Line No." then
                ProjAmount := ProjAmount - DistRule."Amount Allocated"
            else
                ProjAmount := ProjAmount - Rec."Amount Allocated";
        until DistRule.Next() = 0;

        if (DistRuleFilter."Sales Invoice" = true) then
            exit;

        if DistRuleFilter."Negative Allocation" then begin
            if ProjAmount > 0 then
                Error('Project amount %1 exceeded by %2.', DistProject."Project Amount", Abs(ProjAmount));
        end
        else begin
            if ProjAmount < 0 then
                Error('Project amount %1 exceeded by %2.', DistProject."Project Amount", Abs(ProjAmount));
        end;

        if Abs(Rec."Amount Allocated") > Abs(RemAmount) then
            Error('Amount to be allocate is %1', RemAmount);

        if Rec."Amount Allocated" <> 0 then
            RemAmount := RemAmount - Rec."Amount Allocated"
        else
            RemAmount := RemAmount + xRec."Amount Allocated";
        CurrPage.Update(true);
    end;

    var
        UserCustomizedmanage: Codeunit "User Customize Manage";
        Amount: Decimal;
        RemAmount: Decimal;
        DistributionRuleAmount: Decimal;
        AmountAlloEdit: Boolean;
}