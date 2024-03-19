page 50207 "Reference Data List"
{
    ApplicationArea = All;
    Caption = 'Reference Data List';
    PageType = List;
    SourceTable = "Reference Data";
    UsageCategory = None;
    SourceTableView = sorting("Sorting Value");
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Sorting Value"; Rec."Sorting Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }
}
