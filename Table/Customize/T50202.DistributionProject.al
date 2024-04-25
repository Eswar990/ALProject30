table 50202 "Distribution Project"
{
    Caption = 'Distribution Project';
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
        }
        field(5; "Shortcut Dimension 3 Code"; Code[20])
        {
            // CaptionClass = UserCustManage.GetFieldCaption(3, '');
            Caption = 'Project Code/ Employee Code';
            // TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
            //                                               Blocked = CONST(false));
        }
        field(11; "Project Amount"; Decimal)
        {
            Caption = 'Amount To Be Allocated';
            DecimalPlaces = 2 : 5;
            trigger OnValidate()
            begin
                UserCustManage.CheckDistRuleExist(Rec."Entry No.");
            end;
        }
        field(15; "Project Line"; Boolean)
        {
            Caption = 'Project Line';
            trigger OnValidate()
            begin
            end;
        }
        field(16; "Line No."; Integer)
        {
            Caption = 'Line No.';
            trigger OnValidate()
            begin
            end;
        }
        field(19; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin

            end;
        }
        field(20; "Emp. Count"; Integer)
        {
            Caption = 'Emp. Count';
            Editable = false;
        }
        field(21; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Entry No.", "Shortcut Dimension 3 Code", "Shortcut Dimension 2 Code")
        {
            Clustered = true;
        }
        key(PK1; "Entry No.", "Shortcut Dimension 2 Code", "Shortcut Dimension 3 Code")
        {
        }
    }
    trigger OnDelete()
    begin
        //UserCustManage.CheckDistRuleExist(Rec."Entry No.");
    end;

    var
        UserCustManage: Codeunit "User Customize Manage";



}