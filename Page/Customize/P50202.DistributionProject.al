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
            }
        }
    }



}
