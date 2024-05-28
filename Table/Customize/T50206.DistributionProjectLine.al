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

        field(5; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = UserCustManage.GetFieldCaption(3, '');
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          Blocked = CONST(false));
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