page 50204 "Month Setup"
{
    ApplicationArea = All;
    Caption = 'Month Setup';
    PageType = List;
    SourceTable = "Reference Data";
    SourceTableView = where(Type = const(Month));
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Sorting Value"; Rec."Sorting Value")
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }
}
