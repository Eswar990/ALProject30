pageextension 50201 GeneralLedgerEntriesEx extends "General Ledger Entries"
{
    layout
    {
        addafter(Amount)
        {
            field("Distributio Rule Applied"; Rec."Distributio Rule Applied")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Distributio Rule Applied field.';
            }
            field("Dist. Entry No Applied"; Rec."Dist. Entry No Applied")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Dist. Entry No Applied field.';
            }
            field("Account Category"; Rec."Account Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Account Category field.';
            }
        }
    }
    actions
    {
        addafter(Dimensions)
        {
            action("Distribution Rule")
            {
                ApplicationArea = All;
                Image = Allocate;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;
                trigger OnAction()
                var
                    DisRuleFilter: Record "Distribution Rule Filter";
                    GenLedSetup: Record "General Ledger Setup";
                    DisRulePageFilter: Page "Distribution Rule Filter";
                    UserCustManage: Codeunit "User Customize Manage";
                    GLAccNo: code[20];
                    AssEntryNo: Integer;
                    AppAssEntryNo: Boolean;
                begin
                    Rec.TestField("Distribution Required", true);
                    Rec.TestField("Global Dimension 1 Code", '');
                    Clear(AppAssEntryNo);
                    if Rec.Amount = 0 then
                        exit;
                    if Rec."Dist. Entry No Applied" = 0 then begin
                        AssEntryNo := Rec."Entry No.";
                        AppAssEntryNo := true;
                    end
                    else
                        AssEntryNo := Rec."Dist. Entry No Applied";
                    if not DisRuleFilter.Get(AssEntryNo) then begin
                        Clear(DisRuleFilter);
                        DisRuleFilter.Init();
                        DisRuleFilter."Entry No." := Rec."Entry No.";
                        DisRuleFilter."Sales Invoice" := UserCustManage.CheckSalesInvoice(Rec."Document No.");
                        if not DisRuleFilter."Sales Invoice" then begin
                            GLAccNo := Rec."G/L Account No.";
                            DisRuleFilter."G/L Amount" := UserCustManage.GetGLDebitAmount(Rec."Document No.", Rec."Global Dimension 2 Code",
                                Rec."Global Dimension 1 Code", GLAccNo);
                        end;
                        if Rec."Global Dimension 2 Code" <> '' then begin
                            GenLedSetup.Get();
                            DisRuleFilter."Dimension Filter Exsist" := true;
                            DisRuleFilter."Dimension Filter" := GenLedSetup."Global Dimension 2 Code";
                            DisRuleFilter."Dimension Value" := Rec."Global Dimension 2 Code";
                        end;
                        DisRuleFilter."G/L Account No." := GLAccNo;
                        DisRuleFilter.Insert();
                    end
                    else begin
                        DisRuleFilter."Sales Invoice" := UserCustManage.CheckSalesInvoice(Rec."Document No.");
                        if not DisRuleFilter."Sales Invoice" then begin
                            GLAccNo := Rec."G/L Account No.";
                            DisRuleFilter."G/L Amount" := UserCustManage.GetGLDebitAmount(Rec."Document No.", Rec."Global Dimension 2 Code",
                                Rec."Global Dimension 1 Code", GLAccNo);
                        end;
                        if Rec."Global Dimension 2 Code" <> '' then begin
                            GenLedSetup.Get();
                            DisRuleFilter."Dimension Filter Exsist" := true;
                            DisRuleFilter."Dimension Filter" := GenLedSetup."Global Dimension 2 Code";
                            DisRuleFilter."Dimension Value" := Rec."Global Dimension 2 Code";
                        end;
                        DisRuleFilter."G/L Account No." := GLAccNo;
                        DisRuleFilter.Modify();
                    end;
                    if AppAssEntryNo then
                        UserCustManage.UpdateGLEntryAppEntryNo(AssEntryNo, Rec."Document No.", Rec."Global Dimension 2 Code",
                            Rec."Global Dimension 1 Code", GLAccNo);
                    UserCustManage.InitDistributionProjectLine(AssEntryNo, Rec."Document No.", DisRuleFilter."Negative Allocation",
                        Rec."Global Dimension 2 Code", Rec."Global Dimension 1 Code", GLAccNo);
                    Commit();
                    Clear(DisRuleFilter);
                    DisRuleFilter.SetRange("Entry No.", AssEntryNo);
                    DisRulePageFilter.InitPageDetails(Rec);
                    DisRulePageFilter.SetTableView(DisRuleFilter);
                    DisRulePageFilter.SetRecord(DisRuleFilter);
                    DisRulePageFilter.Editable(true);
                    DisRulePageFilter.RunModal();
                end;
            }
        }
    }
}
