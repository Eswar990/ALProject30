pageextension 50203 DimensionsEx extends Dimensions
{
    layout
    {
        addafter(Blocked)
        {

            field("Dimension Filter"; Rec."Dimension Filter")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Dimension Filter field.';
            }
        }
    }
}
