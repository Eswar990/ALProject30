pageextension 50200 DimensionValuesEx extends "Dimension Values"
{
    layout
    {
        addbefore(Totaling)
        {

            field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                Editable = FieldVisible;
            }
            field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                Editable = FieldVisible;
            }
            field("Shortcut Dimension 3 Two"; Rec."Shortcut Dimension 3 Two")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                Editable = FieldVisible;
            }
            field("Shortcut Dimension 3 Three"; Rec."Shortcut Dimension 3 Three")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                Editable = FieldVisible;
            }
            field("Percentage One"; Rec."Percentage One")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Percentage One field.';
                Editable = FieldVisible;
            }
            field("Percentage Two"; Rec."Percentage Two")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Percentage Two field.';
                Editable = FieldVisible;
            }
            field("Percentage Three"; Rec."Percentage Three")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Percentage Three field.';
                Editable = FieldVisible;
            }
            field(Year; Rec.Year)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Year field.';
            }
            field(Month; Rec.Month)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Month field.';
            }
            field("Distribute Enable"; Rec."Distribute Enable")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Distribute Enable field.';
            }
        }
    }
    var
        FieldVisible: Boolean;

    trigger OnOpenPage()
    begin

    end;

    trigger OnAfterGetCurrRecord()
    begin
        CheckVisible();
    end;

    procedure CheckVisible()
    var
        GenLedSetup: Record "General Ledger Setup";
    begin
        GenLedSetup.Get();
        if GenLedSetup."Global Dimension 1 Code" = Rec."Dimension Code" then
            FieldVisible := true;
    end;
}
