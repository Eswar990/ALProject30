pageextension 50204 GLAccountCardEx extends "G/L Account Card"
{
    layout
    {
        addafter("Omit Default Descr. in Jnl.")
        {
            field("VAT Account"; Rec."VAT Account")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the VAT Account field.';
            }
            field("Distribution Required"; Rec."Distribution Required")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Distribution Required field.';
            }
        }
    }
}
