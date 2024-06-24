page 50209 "Distribution Project Line"
{
    ApplicationArea = All;
    Caption = 'Distribution Project Line';
    PageType = ListPart;
    SourceTable = "Distribution Project Line";
    SourceTableView = sorting("Entry No.", "Line No.");
    DelayedInsert = true;
    AutoSplitKey = true;
    MultipleNewLines = true;

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

                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                    Editable = false;
                    Visible = false;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                    Editable = false;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                    Editable = false;
                }

                field("Amount Allocated"; Rec."Amount Allocated")
                {
                    ToolTip = 'Specifies the value of the Amount Allocated field.';
                    Editable = IsAmountAllocatedEditable;
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

                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ToolTip = 'Specifies the value of the G/L Account No. field.';
                    Editable = false;
                }
            }

            group("Allocation Details")
            {
                ShowCaption = false;
                field("Total Amount"; rec."Total Amount")
                {
                    Caption = 'Total Amount';
                    ToolTip = 'Specifies the value of the Total Amount Field';
                    Style = Strong;
                }
            }
        }
    }

    local procedure CalculateTotalAmount()
    var
        DisRule: Record "Distribution Rule";
        DisProject: Record "Distribution Project";
    begin
        Clear(DisProject);
        DisProject.SetRange("Entry No.", Rec."Entry No.");
        DisProject.CalcSums("Project Amount");
        TotalAmount := DisProject."Project Amount";
        CurrPage.Update(true);
    end;

    trigger OnAfterGetRecord()
    var
        DistributionRuleFilter: Record "Distribution Rule Filter";
    begin
        DistributionRuleFilter.Get(Rec."Entry No.");
        if (DistributionRuleFilter."Dist Single Line Amount" = true) then
            IsAmountAllocatedEditable := true
        else
            IsAmountAllocatedEditable := false;
        // CalculateTotalAmount()
    end;

    var
        TotalAmount: Decimal;
        IsAmountAllocatedEditable: Boolean;
}