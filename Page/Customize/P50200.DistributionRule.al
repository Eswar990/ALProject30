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
                    begin
                        CheckingAllocation();
                    end;
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ToolTip = 'Specifies the value of the G/L Account No. field.';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Line No."; Rec."Line No.")
                {

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
            action("Allocation Amount Upload")
            {
                ApplicationArea = All;
                Image = UpdateXML;
                trigger OnAction()
                var
                    DisRuleFilter: Record "Distribution Rule Filter";
                    DistRule: Record "Distribution Rule";
                    GLEntry: Record "G/L Entry";
                    UserCustManage: Codeunit "User Customize Manage";
                begin
                    DistRule.Copy(Rec);
                    UserCustManage.UploadDistributionRuleFromExcel(DistRule);
                    DisRuleFilter.Get(Rec."Entry No.");
                    GLEntry.Get(Rec."Entry No.");
                    CalRemAmount(GLEntry);
                    if RemAmount = 0 then
                        UserCustManage.UpdateGLEntryApplied(GLEntry."Document No.", DisRuleFilter."Dimension Value",
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

    var
        Amount: Decimal;
        RemAmount: Decimal;
        AmountAlloEdit: Boolean;

    local procedure InitPageDetails(var GLEntry: Record "G/L Entry")
    begin
        Amount := GLEntry.Amount;
        CalRemAmount(GLEntry);
    end;

    local procedure CalRemAmount(GLEntry: Record "G/L Entry")
    var
        DisRule: Record "Distribution Rule";
    begin
        Clear(DisRule);
        DisRule.SetRange("Entry No.", GLEntry."Entry No.");
        DisRule.CalcSums("Amount Allocated");
        RemAmount := Amount - DisRule."Amount Allocated";
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
        DistProject.Get(Rec."Entry No.", Rec."Shortcut Dimension 3 Code", Rec."Shortcut Dimension 2 Code");
        ProjAmount := DistProject."Project Amount";
        Clear(DistRule);
        DistRule.SetRange("Entry No.", Rec."Entry No.");
        DistRule.SetRange("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 3 Code");
        DistRule.FindSet();
        repeat
            if DistRule."Line No." <> Rec."Line No." then
                ProjAmount := ProjAmount - DistRule."Amount Allocated"
            else
                ProjAmount := ProjAmount - Rec."Amount Allocated";
        until DistRule.Next() = 0;
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

    procedure UpdateAmount(PassAmt: Decimal; PassRemAmt: Decimal)
    begin
        Amount := PassAmt;
        RemAmount := PassRemAmt;
        CurrPage.Update(true);
    end;
}
