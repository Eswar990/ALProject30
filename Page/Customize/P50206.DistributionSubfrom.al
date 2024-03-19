page 50206 "Distribution Subfrom"
{
    ApplicationArea = All;
    Caption = 'Distribution Subfrom';
    PageType = ListPart;
    SourceTable = "Distribution Line";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Year; Rec.Year)
                {
                    ToolTip = 'Specifies the value of the Year field.';
                }
                field(Month; Rec.Month)
                {
                    ToolTip = 'Specifies the value of the Month field.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }
                field("Percentage One"; Rec."Percentage One")
                {
                    ToolTip = 'Specifies the value of the Percentage One field.';
                }
                field("Shortcut Dimension 3 Two"; Rec."Shortcut Dimension 3 Two")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }
                field("Percentage Two"; Rec."Percentage Two")
                {
                    ToolTip = 'Specifies the value of the Percentage Two field.';
                }
                field("Shortcut Dimension 3 Three"; Rec."Shortcut Dimension 3 Three")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }
                field("Percentage Three"; Rec."Percentage Three")
                {
                    ToolTip = 'Specifies the value of the Percentage Three field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Update From Excel")
            {
                ApplicationArea = All;
                Image = Excel;
                trigger OnAction()
                var
                    UserCustManage: Codeunit "User Customize Manage";
                begin
                    UserCustManage.UpdateDisSetupLineXL(Rec.Year, Rec.Month);
                end;
            }

        }
    }
}
