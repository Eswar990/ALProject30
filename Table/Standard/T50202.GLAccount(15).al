tableextension 50202 GLAccountEx extends "G/L Account"
{
    fields
    {
        field(50200; "VAT Account"; Boolean)
        {
            Caption = 'VAT Account';
            DataClassification = ToBeClassified;
        }
        modify("Account Category")
        {
            trigger OnAfterValidate()
            begin
                if (Rec."Account Category" <> Rec."Account Category"::Income) or
                    (Rec."Account Category" <> Rec."Account Category"::Expense) then
                    Rec."Distribution Required" := true
                else
                    Rec."Distribution Required" := false;
            end;
        }
        field(50201; "Distribution Required"; Boolean)
        {
            Caption = 'Distribution Required';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                UserSetup: Record "User Setup";
            begin
                UserSetup.Get(UserId);
                if not UserSetup.Distribution then
                    Error('Your not allowed change the value. Please contact system administrator.');
                if Rec."Income/Balance" = Rec."Income/Balance"::"Balance Sheet" then
                    Error('Income/Balance type must Income Statement.');
                if Rec."Account Category" <> Rec."Account Category"::Income then
                    if Rec."Account Category" <> Rec."Account Category"::Expense then
                        Error('Account Category must be Income or Expense.');
            end;
        }
    }
}
