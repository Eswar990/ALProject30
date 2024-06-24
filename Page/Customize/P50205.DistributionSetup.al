page 50205 "Distribution Setup"
{
    ApplicationArea = All;
    Caption = 'Distribution Setup';
    PageType = Card;
    SourceTable = "Distribution Header";
    InsertAllowed = false;
    UsageCategory = Tasks;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                group(From)
                {
                    field("Previous Year"; Rec."Previous Year")
                    {
                        ToolTip = 'Specifies the value of the Previous Year field.';
                    }
                    field("Previous Month"; Rec."Previous Month")
                    {
                        ToolTip = 'Specifies the value of the Previous Year field.';
                    }
                }
                Group(To)
                {
                    field(Year; Rec.Year)
                    {
                        ToolTip = 'Specifies the value of the Year field.';
                    }
                    field(Month; Rec.Month)
                    {
                        ToolTip = 'Specifies the value of the Month field.';
                    }
                }
            }
            part(Line; "Distribution Subfrom")
            {
                Caption = 'Line';
                SubPageLink = Year = field(Year), Month = field(Month);
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Copy From Emp.")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = CopyBudget;
                // Visible = false;
                trigger OnAction()
                var
                    UserCustManage: Codeunit "User Customize Manage";
                begin
                    Rec.TestField(Year);
                    Rec.TestField(Month);
                    UserCustManage.CopyFromDimValueOne(Rec.Year, Rec.Month);
                    CurrPage.Update(true);
                end;
            }
            action("Copy From Pre. Details")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = CopyDocument;
                trigger OnAction()
                var
                    UserCustManage: Codeunit "User Customize Manage";
                begin
                    Rec.TestField(Year);
                    Rec.TestField(Month);
                    Rec.TestField("Previous Year");
                    Rec.TestField("Previous Month");
                    UserCustManage.CopyFromPreviousDetails(Rec.Year, Rec.Month, Rec."Previous Year", Rec."Previous Month");
                    CurrPage.Update(true);
                end;
            }
            action("Update Emp. Details")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = UpdateDescription;
                trigger OnAction()
                var
                    UserCustManage: Codeunit "User Customize Manage";
                begin
                    Rec.TestField(Year);
                    Rec.TestField(Month);
                    UserCustManage.UpdateToDimValueOne(Rec.Year, Rec.Month);
                    CurrPage.Update(true);
                end;
            }
        }
    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        Rec.Year := '';
        Rec.Month := '';
        Rec."Previous Year" := '';
        Rec."Previous Month" := '';
        Rec.Modify();
    end;
}
