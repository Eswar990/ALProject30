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

        field(18; "Distribution Method"; Option)
        {
            Caption = 'Distribution Method';
            OptionMembers = " ",/*Equally,Proportion,*/Manually;
            trigger OnValidate()
            var
                UserCustManage: Codeunit "User Customize Manage";
            begin
                UserCustManage.CheckDistRuleExist(Rec."Entry No.");
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

        field(25; "Distribution Amount"; Decimal)
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
            begin
                /* In this Dimension Will give only Respected Dimension Values*/

                if ((Rec."Distribution Method" = Rec."Distribution Method"::Manually)) then begin
                    if ("Distribution Setup" = true) then begin
                        if (("Dimension Value One" <> '')) then
                            UserCustManage.CreateProjectDistFromDistributionLine(Rec."Entry No.", Rec."Dimension Value One", xRec."Dimension Value One", Rec."G/L Account No.", 1);
                    end else begin
                        if "Dimension Value One" = '' then
                            "Distribution Amount One" := 0;
                        UserCustManage.CreateProjectDistRuleFilter(Rec."Entry No.", Rec."Dimension Value One", xRec."Dimension Value One", Rec."G/L Account No.");
                    end;
                end else
                    Error('Please Fill Distribution Method Manually');
            end;
        }

        field(33; "Distribution Amount One"; Decimal)
        {
            Caption = 'Distribution Amount One';
        }

        field(35; "Dimension Value Two"; Code[20])
        {
            Caption = 'Dimension Value Two';
            TableRelation = "Dimension Value".Code where("Dimension Code" = field("Dimension Filter"));
            trigger OnValidate()
            begin
                /* In this Dimension Will give only Respected Dimension Values*/

                if ((Rec."Distribution Method" = Rec."Distribution Method"::Manually)) then begin
                    if ("Distribution Setup" = true) then begin
                        if ("Dimension Value Two" <> '') then
                            UserCustManage.CreateProjectDistFromDistributionLine(Rec."Entry No.", Rec."Dimension Value Two", xRec."Dimension Value Two", Rec."G/L Account No.", 2);
                    end else begin
                        if "Dimension Value Two" = '' then
                            "Distribution Amount Two" := 0;
                        UserCustManage.CreateProjectDistRuleFilter(Rec."Entry No.", Rec."Dimension Value Two", xRec."Dimension Value Two", Rec."G/L Account No.");
                    end;
                end else
                    Error('Please Fill Distribution Method Manually');
            end;
        }

        field(36; "Distribution Amount Two"; Decimal)
        {
            Caption = 'Distribution Amount Two';
        }

        field(40; "Dimension Value Three"; Code[20])
        {
            Caption = 'Dimension Value Three';
            TableRelation = "Dimension Value".Code where("Dimension Code" = field("Dimension Filter"));
            trigger OnValidate()
            begin
                /* In this Dimension Will give only Respected Dimension Values*/

                if ((Rec."Distribution Method" = Rec."Distribution Method"::Manually)) then begin
                    if ("Distribution Setup" = true) then begin
                        if ("Dimension Value Three" <> '') then
                            UserCustManage.CreateProjectDistFromDistributionLine(Rec."Entry No.", Rec."Dimension Value Three", xRec."Dimension Value Three", Rec."G/L Account No.", 3);
                    end else begin
                        if "Dimension Value Three" = '' then
                            "Distribution Amount Three" := 0;
                        UserCustManage.CreateProjectDistRuleFilter(Rec."Entry No.", Rec."Dimension Value Three", xRec."Dimension Value Three", Rec."G/L Account No.");
                    end;
                end else
                    Error('Please Fill Distribution Method Manually');
            end;
        }

        field(42; "Distribution Amount Three"; Decimal)
        {
            Caption = 'Distribution Amount Three';
        }

        field(45; "Dimension Value Four"; Code[20])
        {
            Caption = 'Dimension Value Four';
            TableRelation = "Dimension Value".Code where("Dimension Code" = field("Dimension Filter"));
            trigger OnValidate()
            begin
                /* In this Dimension Will give only Respected Dimension Values*/

                if ((Rec."Distribution Method" = Rec."Distribution Method"::Manually)) then begin
                    if ("Distribution Setup" = true) then begin
                        if ("Dimension Value Four" <> '') then
                            UserCustManage.CreateProjectDistFromDistributionLine(Rec."Entry No.", Rec."Dimension Value Four", xRec."Dimension Value Four", Rec."G/L Account No.", 4);
                    end else begin
                        if "Dimension Value Four" = '' then
                            "Distribution Amount Four" := 0;
                        UserCustManage.CreateProjectDistRuleFilter(Rec."Entry No.", Rec."Dimension Value Four", xRec."Dimension Value Four", Rec."G/L Account No.");
                    end;
                end else
                    Error('Please Fill Distribution Method Manually');
            end;
        }

        field(47; "Distribution Amount Four"; Decimal)
        {
            Caption = 'Distribution Amount Four';
        }

        field(50; "Dimension Value Five"; Code[20])
        {
            Caption = 'Dimension Value Five';
            TableRelation = "Dimension Value".Code where("Dimension Code" = field("Dimension Filter"));
            trigger OnValidate()
            begin
                /* In this Dimension Will give only Respected Dimension Values*/

                if ((Rec."Distribution Method" = Rec."Distribution Method"::Manually)) then begin
                    if ("Distribution Setup" = true) then begin
                        if ("Dimension Value Five" <> '') then
                            UserCustManage.CreateProjectDistFromDistributionLine(Rec."Entry No.", Rec."Dimension Value Five", xRec."Dimension Value Five", Rec."G/L Account No.", 4);
                    end else begin
                        if "Dimension Value Four" = '' then
                            "Distribution Amount Four" := 0;
                        UserCustManage.CreateProjectDistRuleFilter(Rec."Entry No.", Rec."Dimension Value Five", xRec."Dimension Value Five", Rec."G/L Account No.");
                    end;
                end else
                    Error('Please Fill Distribution Method Manually');
            end;
        }

        field(52; "Distribution Amount Five"; Decimal)
        {
            Caption = 'Distribution Amount Five';
        }

        field(53; "Distribution Setup"; Boolean)
        {
            Caption = 'Distribution Setup';
        }

        field(54; "Dist Single Line Amount"; Boolean)
        {
            Caption = 'Distribution Single Line Amount';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        myInt: Integer;
    begin

    end;

    var
        UserCustManage: Codeunit "User Customize Manage";
        GLAccNo: Code[20];
}