tableextension 50203 "G/L Entry" extends "G/L Entry"
{
    fields
    {
        field(50200; "Distributio Rule Applied"; Boolean)
        {
            Caption = 'Distribution Rule Applied';
            DataClassification = ToBeClassified;
        }
        field(50201; "Dist. Entry No Applied"; Integer)
        {
            Caption = 'Dist. Entry No Applied';
            DataClassification = ToBeClassified;
        }
        field(50202; "Account Category"; Enum "G/L Account Category")
        {
            Caption = 'Account Category';
            FieldClass = FlowField;
            CalcFormula = lookup("G/L Account"."Account Category" where("No." = field("G/L Account No.")));
            Editable = false;
        }
        field(50203; "Distribution Required"; Boolean)
        {
            Caption = 'Distribution Required';
            FieldClass = FlowField;
            CalcFormula = lookup("G/L Account"."Distribution Required" where("No." = field("G/L Account No.")));
            Editable = false;
        }
    }
}
