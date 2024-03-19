pageextension 50208 UserSetupEx extends "User Setup"
{
    layout
    {
        addafter("Register Time")
        {

            field(Distribution; Rec.Distribution)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Distribution field.';
            }
        }
    }
}
