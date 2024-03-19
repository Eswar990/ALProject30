tableextension 50200 DimensionValueEx extends "Dimension Value"
{
    fields
    {
        field(50200; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin

            end;
        }
        field(50201; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = UserCustManage.GetFieldCaption(3, 'One');
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          Blocked = CONST(false));
        }

        field(50202; "Shortcut Dimension 3 Two"; Code[20])
        {
            CaptionClass = UserCustManage.GetFieldCaption(3, 'Two');
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          Blocked = CONST(false));
        }
        field(50203; "Shortcut Dimension 3 Three"; Code[20])
        {
            CaptionClass = UserCustManage.GetFieldCaption(3, 'Three');
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          Blocked = CONST(false));
        }
        field(50205; "Percentage One"; Decimal)
        {
            Caption = 'Percentage One';
        }
        field(50206; "Percentage Two"; Decimal)
        {
            Caption = 'Percentage Two';
        }
        field(50207; "Percentage Three"; Decimal)
        {
            Caption = 'Percentage Three';
        }
        field(50208; Year; code[20])
        {
            Caption = 'Year';
            TableRelation = "Reference Data".Code where(Type = const(Year));
            Editable = false;
        }
        field(50209; Month; code[20])
        {
            Caption = 'Month';
            TableRelation = "Reference Data".Code where(Type = const(Month));
            Editable = false;
        }
        field(50210; "Distribute Enable"; Boolean)
        {
            Caption = 'Distribute Enable';
            Editable = false;
        }
    }
    var
        UserCustManage: Codeunit "User Customize Manage";
}
