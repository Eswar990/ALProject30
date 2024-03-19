page 50208 "Distribution Entries"
{
    ApplicationArea = All;
    Caption = 'Distribution Entries';
    PageType = List;
    SourceTable = "G/L Entry";
    SourceTableView = sorting("Entry No.") order(descending);
    UsageCategory = Tasks;
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the entry''s posting date.';
                }
                field("Distributio Rule Applied"; Rec."Distributio Rule Applied")
                {
                    ToolTip = 'Specifies the value of the Distributio Rule Applied field.';
                }
                field("Distribution Required"; Rec."Distribution Required")
                {
                    ToolTip = 'Specifies the value of the Distribution Required field.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the Document Type that the entry belongs to.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the entry''s Document No.';
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ToolTip = 'Specifies the number of the account that the entry has been posted to.';
                }
                field("G/L Account Name"; Rec."G/L Account Name")
                {
                    ToolTip = 'Specifies the name of the account that the entry has been posted to.';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the number of the entry, as assigned from the specified number series when the entry was created.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies a description of the entry.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ToolTip = 'Specifies the code for Shortcut Dimension 3, which is one of dimension codes that you set up in the General Ledger Setup window.';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the Amount of the entry.';
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ToolTip = 'Specifies the total of the ledger entries that represent credits.';
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ToolTip = 'Specifies the total of the ledger entries that represent debits.';
                }
                field("Dist. Entry No Applied"; Rec."Dist. Entry No Applied")
                {
                    ToolTip = 'Specifies the value of the Dist. Entry No Applied field.';
                }
                field("Account Category"; Rec."Account Category")
                {
                    ToolTip = 'Specifies the value of the Account Category field.';
                }

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Distribution Rule")
            {
                ApplicationArea = All;
                Image = Allocate;
                Promoted = true;
                PromotedCategory = Process;
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
                        if DisRuleFilter."Sales Invoice" then
                            if Rec."Dimension Set ID" = 0 then begin
                                GLAccNo := Rec."G/L Account No.";
                                DisRuleFilter."G/L Amount" := UserCustManage.GetGLCreditAmount(Rec."Document No.", Rec."Global Dimension 2 Code",
                                             Rec."Global Dimension 1 Code", GLAccNo);
                            end;
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
                        if DisRuleFilter."Sales Invoice" then
                            if Rec."Dimension Set ID" = 0 then begin
                                GLAccNo := Rec."G/L Account No.";
                                DisRuleFilter."G/L Amount" := UserCustManage.GetGLCreditAmount(Rec."Document No.", Rec."Global Dimension 2 Code",
                                             Rec."Global Dimension 1 Code", GLAccNo);
                            end;
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
                    if DisRuleFilter."Sales Invoice" then begin
                        if AppAssEntryNo then
                            UserCustManage.UpdateGLEntryAppEntryNo(AssEntryNo, Rec."Document No.", '',
                                '', '');
                        UserCustManage.InitDistributionProjectLine(AssEntryNo, Rec."Document No.", DisRuleFilter."Negative Allocation",
                            '', '', '');
                    end
                    else begin
                        if AppAssEntryNo then
                            UserCustManage.UpdateGLEntryAppEntryNo(AssEntryNo, Rec."Document No.", Rec."Global Dimension 2 Code",
                                Rec."Global Dimension 1 Code", GLAccNo);
                        UserCustManage.InitDistributionProjectLine(AssEntryNo, Rec."Document No.", DisRuleFilter."Negative Allocation",
                            Rec."Global Dimension 2 Code", Rec."Global Dimension 1 Code", GLAccNo);
                    end;
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
    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.SetFilter("Account Category", '%1|%2', Rec."Account Category"::Income, Rec."Account Category"::Expense);
        Rec.FilterGroup(0);
    end;
}
