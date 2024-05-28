page 50202 "Distribution Project"
{
    ApplicationArea = All;
    Caption = 'Distribution Project';
    PageType = ListPart;
    SourceTable = "Distribution Project";
    SourceTableView = sorting("Entry No.", "Shortcut Dimension 2 Code", "Shortcut Dimension 3 Code");
    DelayedInsert = true;
    AutoSplitKey = true;
    MultipleNewLines = true;
    LinksAllowed = false;
    InsertAllowed = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
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
                field("Emp. Count"; Rec."Emp. Count")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field("Project Amount"; Rec."Project Amount")
                {
                    ToolTip = 'Specifies the value of the Amount Allocated field.';
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ToolTip = 'Specifies the value of the G/L Account No. field.';
                }

                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the Line value of Distribution Project';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Branch Distributions")
            {
                ApplicationArea = All;
                Image = AmountByPeriod;
                Visible = IsVisibleBranchDistributions;
                ToolTip = 'Specifies the Value When you click Branch Distributions Action after Create the Project Lines';
                trigger OnAction()
                begin
                    UserCustomizeManage.DistributeAmountbasedOnBranch(Rec."Entry No.");
                end;
            }
            action("Allocation Employee Amount Upload")
            {
                ApplicationArea = All;
                Image = UpdateXML;
                trigger OnAction()
                var
                    DisRuleFilter: Record "Distribution Rule Filter";
                    DistributionProject: Record "Distribution Project";
                    GLEntry: Record "G/L Entry";
                    UserCustManage: Codeunit "User Customize Manage";
                begin
                    IsVisibleBranchDistributions := false;
                    DistributionProject.Copy(Rec);
                    If (DisRuleFilter.Get(Rec."Entry No.") = false) then
                        exit;
                    if ((DisRuleFilter."Dimension Value One" <> '') and (DisRuleFilter."Distrubution Amount One" = 0)) then
                        Error('Distrubution Amount One %1 Must not be Zero Please add Value', DisRuleFilter."Distrubution Amount One")
                    else
                        if ((DisRuleFilter."Dimension Value Two" <> '') and (DisRuleFilter."Distrubution Amount Two" = 0)) then
                            Error('Distrubution Amount Two %1 Must not be Zero Please add Value', DisRuleFilter."Distrubution Amount Two")
                        else
                            if ((DisRuleFilter."Dimension Value Three" <> '') and (DisRuleFilter."Distrubution Amount Three" = 0)) then
                                Error('Distrubution Amount Three %1 Must not be Zero Please add Value', DisRuleFilter."Distrubution Amount Three")
                            else
                                if ((DisRuleFilter."Dimension Value Four" <> '') and (DisRuleFilter."Distrubution Amount Four" = 0)) then
                                    Error('Distrubution Amount Four %1 Must not be Zero Please add Value', DisRuleFilter."Distrubution Amount Four")
                                else
                                    if ((DisRuleFilter."Dimension Value Five" <> '') and (DisRuleFilter."Distrubution Amount Five" = 0)) then
                                        Error('Distrubution Amount Five %1 Must not be Zero Please add Value', DisRuleFilter."Distrubution Amount Five")
                                    else
                                        UserCustManage.UploadDistributionProjectFromExcel(DistributionProject);

                    GLEntry.Get(Rec."Entry No.");
                    CalRemAmount(GLEntry);
                    if RemAmount = 0 then
                        UserCustManage.UpdateGLEntryApplied(GLEntry."Document No.", DisRuleFilter."Dimension Value",
                             GLEntry."Global Dimension 1 Code", DisRuleFilter."G/L Account No.");
                    CurrPage.Update(true);
                end;

            }

            action("Single Line Amount Updated")
            {
                ApplicationArea = All;
                Image = Balance;

                trigger OnAction()
                var
                    GLEntry: Record "G/L Entry";
                    DistributionRuleFilter: Record "Distribution Rule Filter";
                begin
                    UserCustomizeManage.InDistributionRuleAmountShouldBeUpdatedOnSingleLine(Rec);
                    if (GLEntry.Get(Rec."Entry No.") = false) then
                        exit;

                    CalRemAmount(GLEntry);
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        IsVisibleBranchDistributions := true;
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

    var
        UserCustomizeManage: Codeunit "User Customize Manage";
        Amount: Decimal;
        RemAmount: Decimal;
        IsVisibleBranchDistributions: Boolean;

}
