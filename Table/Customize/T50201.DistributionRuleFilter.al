table 50201 "Distribution Rule Filter"
{
    Caption = 'Distribution Rule Filter';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
        }
        field(15; "Dimension Filter"; Code[20])
        {
            Caption = 'Dimension';
            TableRelation = Dimension.Code where("Dimension Filter" = const(true));
            trigger OnValidate()
            begin
                Rec.Validate("Dimension Value", '');
            end;
        }
        field(17; "Dimension Value"; Code[20])
        {
            Caption = 'Dimension Value';
            TableRelation = "Dimension Value".Code where("Dimension Code" = field("Dimension Filter"));
            trigger OnValidate()
            var
                UserCustManage: Codeunit "User Customize Manage";
            begin
                UserCustManage.CreateProjectDistRuleFilter(Rec."Entry No.", Rec."Dimension Value", xRec."Dimension Value", Rec."G/L Account No.");
            end;
        }
        field(18; "Distrubution Method"; Option)
        {
            Caption = 'Distribution Method';
            OptionMembers = " ",Equally,Proportion,Manually;
            trigger OnValidate()
            var
                UserCustManage: Codeunit "User Customize Manage";
            begin
                UserCustManage.CheckDistRuleExist(Rec."Entry No.");
                if ("Distrubution Method" = "Distrubution Method"::" ") or
                    ("Distrubution Method" = "Distrubution Method"::Manually) then begin
                    if "Dimension Value" <> '' then
                        UserCustManage.UpdateDistAmoutOther(Rec, 0);
                    if "Dimension Value One" <> '' then
                        UserCustManage.UpdateDistAmoutOther(Rec, 1);
                    if "Dimension Value Two" <> '' then
                        UserCustManage.UpdateDistAmoutOther(Rec, 2);
                    if "Dimension Value Three" <> '' then
                        UserCustManage.UpdateDistAmoutOther(Rec, 3);
                    if "Dimension Value Four" <> '' then
                        UserCustManage.UpdateDistAmoutOther(Rec, 4);
                    if "Dimension Value Five" <> '' then
                        UserCustManage.UpdateDistAmoutOther(Rec, 5);
                end;
                if ("Distrubution Method" = "Distrubution Method"::Equally) or
                    ("Distrubution Method" = "Distrubution Method"::Proportion) then begin
                    if "Dimension Value" <> '' then
                        UserCustManage.UpdateDistAmountEquallyProporation(Rec, 0);
                    if "Dimension Value One" <> '' then
                        UserCustManage.UpdateDistAmountEquallyProporation(Rec, 1);
                    if "Dimension Value Two" <> '' then
                        UserCustManage.UpdateDistAmountEquallyProporation(Rec, 2);
                    if "Dimension Value Three" <> '' then
                        UserCustManage.UpdateDistAmountEquallyProporation(Rec, 3);
                    if "Dimension Value Four" <> '' then
                        UserCustManage.UpdateDistAmountEquallyProporation(Rec, 4);
                    if "Dimension Value Five" <> '' then
                        UserCustManage.UpdateDistAmountEquallyProporation(Rec, 5);
                end;
            end;
        }
        field(20; "Negative Allocation"; Boolean)
        {
            Caption = 'Negative Allocation';
        }
        field(21; "Sales Invoice"; Boolean)
        {
            Caption = 'Sales Invoice';
        }
        field(22; "G/L Amount"; Decimal)
        {
            Caption = 'G/L Amount';
        }
        field(25; "Distrubution Amount"; Decimal)
        {
            Caption = 'Distribution Amount';
            Editable = false;
        }
        field(27; "Dimension Filter Exsist"; Boolean)
        {
            Caption = 'Dimension Filter Exsist';
            Editable = false;
        }
        field(28; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";
            Editable = false;
        }
        field(32; "Dimension Value One"; Code[20])
        {
            Caption = 'Dimension Value One';
            TableRelation = "Dimension Value".Code where("Dimension Code" = field("Dimension Filter"));
            trigger OnValidate()
            var
                UserCustManage: Codeunit "User Customize Manage";
            begin
                if "Dimension Value One" = '' then
                    "Distrubution Amount One" := 0;
                UserCustManage.CreateProjectDistRuleFilter(Rec."Entry No.", Rec."Dimension Value One", xRec."Dimension Value One", Rec."G/L Account No.");
            end;
        }
        field(33; "Distrubution Amount One"; Decimal)
        {
            Caption = 'Distribution Amount One';
        }
        field(35; "Dimension Value Two"; Code[20])
        {
            Caption = 'Dimension Value Two';
            TableRelation = "Dimension Value".Code where("Dimension Code" = field("Dimension Filter"));
            trigger OnValidate()
            var
                UserCustManage: Codeunit "User Customize Manage";
            begin
                if "Dimension Value Two" = '' then
                    "Distrubution Amount Two" := 0;
                UserCustManage.CreateProjectDistRuleFilter(Rec."Entry No.", Rec."Dimension Value Two", xRec."Dimension Value Two", Rec."G/L Account No.");
            end;
        }
        field(36; "Distrubution Amount Two"; Decimal)
        {
            Caption = 'Distribution Amount Two';
        }
        field(40; "Dimension Value Three"; Code[20])
        {
            Caption = 'Dimension Value Three';
            TableRelation = "Dimension Value".Code where("Dimension Code" = field("Dimension Filter"));
            trigger OnValidate()
            var
                UserCustManage: Codeunit "User Customize Manage";
            begin
                if "Dimension Value Three" = '' then
                    "Distrubution Amount Three" := 0;
                UserCustManage.CreateProjectDistRuleFilter(Rec."Entry No.", Rec."Dimension Value Three", xRec."Dimension Value Three", Rec."G/L Account No.");
            end;
        }
        field(42; "Distrubution Amount Three"; Decimal)
        {
            Caption = 'Distribution Amount Three';
        }
        field(45; "Dimension Value Four"; Code[20])
        {
            Caption = 'Dimension Value Four';
            TableRelation = "Dimension Value".Code where("Dimension Code" = field("Dimension Filter"));
            trigger OnValidate()
            var
                UserCustManage: Codeunit "User Customize Manage";
            begin
                if "Dimension Value Four" = '' then
                    "Distrubution Amount Four" := 0;
                UserCustManage.CreateProjectDistRuleFilter(Rec."Entry No.", Rec."Dimension Value Four", xRec."Dimension Value Four", Rec."G/L Account No.");
            end;
        }
        field(47; "Distrubution Amount Four"; Decimal)
        {
            Caption = 'Distribution Amount Four';
        }
        field(50; "Dimension Value Five"; Code[20])
        {
            Caption = 'Dimension Value Five';
            TableRelation = "Dimension Value".Code where("Dimension Code" = field("Dimension Filter"));
            trigger OnValidate()
            var
                UserCustManage: Codeunit "User Customize Manage";
            begin
                if "Dimension Value Five" = '' then
                    "Distrubution Amount Five" := 0;
                UserCustManage.CreateProjectDistRuleFilter(Rec."Entry No.", Rec."Dimension Value Five", xRec."Dimension Value Five", Rec."G/L Account No.");
            end;
        }
        field(52; "Distrubution Amount Five"; Decimal)
        {
            Caption = 'Distribution Amount Five';
        }

        field(53; "Distribution Setup"; Boolean)
        {
            Caption = 'Distribution Setup';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    var
        GLAccNo: Code[20];
}
