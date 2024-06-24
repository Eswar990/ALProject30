table 50206 "Distribution Project Line"
{
    Caption = 'Distribution Project Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }

        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }

        field(4; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin

            end;
        }

        field(5; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = UserCustManage.GetFieldCaption(3, '');
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          Blocked = CONST(false));
        }

        field(6; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            var
                UserCustManage: Codeunit "User Customize Manage";
                ShortDimCodeTwo: Code[20];
                ShortDimCodeThree: Code[20];
            begin
                UserCustManage.GetDimValueAssigned(Rec."Shortcut Dimension 1 Code", ShortDimCodeTwo, ShortDimCodeThree);
                Rec.Validate("Shortcut Dimension 2 Code", ShortDimCodeTwo);
                Rec.Validate("Shortcut Dimension 3 Code", ShortDimCodeThree);
            end;
        }

        field(8; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }

        field(10; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";
            Editable = false;
        }

        field(11; "Amount Allocated"; Decimal)
        {
            Caption = 'Amount Allocated';
            DecimalPlaces = 2 : 5;
        }

        Field(21; "Total Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Distribution Project Line"."Amount Allocated" where("Entry No." = field("Entry No.")));
            Editable = false;
            Caption = 'Total Amount';
        }
        field(15; "Emp. Project Count"; Integer)
        {
            Caption = 'Emp. Project Count';
        }
        field(16; "Emp. Project Percentage"; Decimal)
        {
            Caption = 'Emp. Project Percentage';
        }
        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
    }
    keys
    {
        key(PK; "Entry No.", "Line No.")
        {
            Clustered = true;
        }
        key(PK1; "Shortcut Dimension 3 Code")
        {

        }
    }

    var
        UserCustManage: Codeunit "User Customize Manage";
}