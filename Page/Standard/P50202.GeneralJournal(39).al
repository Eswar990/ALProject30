pageextension 50202 GeneralJournalEx extends "General Journal"
{
    layout
    {
        modify("Shortcut Dimension 1 Code")
        {
            trigger OnAfterValidate()
            var
                UserCustManage: Codeunit "User Customize Manage";
                ShortDimCodeTwo: Code[20];
                ShortDimCodeThree: Code[20];
            begin
                UserCustManage.GetDimValueAssigned(Rec."Shortcut Dimension 1 Code", ShortDimCodeTwo, ShortDimCodeThree);
                Rec.Validate("Shortcut Dimension 2 Code", ShortDimCodeTwo);
                ShortcutDimCode[3] := ShortDimCodeThree;
                Rec.ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                Rec.Modify();
            end;
        }
    }
}
