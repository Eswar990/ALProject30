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
            begin
                UserCustManage.CreateProjectDistRuleFilter(Rec."Entry No.", Rec."Dimension Value", xRec."Dimension Value", Rec."G/L Account No.");
            end;
        }

        field(18; "Distribution Method"; Option)
        {
            Caption = 'Distribution Method';
            OptionMembers = " ",/*Equally,Proportion,*/Manually;
            trigger OnValidate()
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
                        if (Rec."Sales Invoice" = true) then begin
                            if ((Rec."Distribution Options" = Rec."Distribution Options"::"Single Project") or (Rec."Distribution Options" = Rec."Distribution Options"::"Multiple Project")) then begin
                                if (("Dimension Value One" <> '')) then
                                    UserCustManage.CreateProjectDistFromDistributionLine(Rec."Entry No.", Rec."Dimension Value One", xRec."Dimension Value One", Rec."G/L Account No.", 1)
                                else begin
                                    if ((Rec."Dimension Value One" <> Rec."Dimension Value Two") or (Rec."Dimension Value One" <> Rec."Dimension Value Three") or (Rec."Dimension Value One" <> Rec."Dimension Value Four") or (Rec."Dimension Value One" <> Rec."Dimension Value Five")) then begin
                                        IsBoolean := UserCustManage.DeleteAndSendErrorDistributionProjectAndDistributionRuleLines(Rec."Entry No.", xRec."Dimension Value One", 0);
                                        if (IsBoolean = false) then
                                            Error('%1 Dimension value already exist', "Dimension Value One");
                                    end;

                                    Clear(IsBoolean);
                                    if (xRec."Dimension Value One" <> Rec."Dimension Value One") then begin
                                        IsBoolean := UserCustManage.DeleteAndSendErrorDistributionProjectAndDistributionRuleLines(Rec."Entry No.", xRec."Dimension Value One", 1);
                                        if (IsBoolean = false) then
                                            Message('Distribution Project and Distribution Rule Lines are Deleted');
                                    end;

                                    Clear(IsBoolean);
                                end;
                            end else
                                Error('Please Fill Distribution Options Either Single Project Or Multiple Project');
                        end else begin
                            if (Rec."Sales Invoice" = false) then begin
                                if (("Dimension Value One" <> '')) then
                                    UserCustManage.CreateProjectDistFromDistributionLine(Rec."Entry No.", Rec."Dimension Value One", xRec."Dimension Value One", Rec."G/L Account No.", 1)
                                else begin
                                    if ((Rec."Dimension Value One" <> Rec."Dimension Value Two") or (Rec."Dimension Value One" <> Rec."Dimension Value Three") or (Rec."Dimension Value One" <> Rec."Dimension Value Four") or (Rec."Dimension Value One" <> Rec."Dimension Value Five")) then begin
                                        IsBoolean := UserCustManage.DeleteAndSendErrorDistributionProjectAndDistributionRuleLines(Rec."Entry No.", xRec."Dimension Value One", 0);
                                        if (IsBoolean = false) then
                                            Error('%1 Dimension value already exist', "Dimension Value One");
                                    end;

                                    Clear(IsBoolean);
                                    if (xRec."Dimension Value One" <> Rec."Dimension Value One") then begin
                                        IsBoolean := UserCustManage.DeleteAndSendErrorDistributionProjectAndDistributionRuleLines(Rec."Entry No.", xRec."Dimension Value One", 1);
                                        if (IsBoolean = false) then
                                            Message('Distribution Project and Distribution Rule Lines are Deleted');
                                    end;

                                    Clear(IsBoolean);
                                end;
                            end;
                        end;
                    end else
                        Error('Distribution Setup Must be True');
                end else
                    Error('Please Fill Distribution Method Manually');
            end;
        }

        field(33; "Distribution Amount One"; Decimal)
        {
            Caption = 'Distribution Amount One';
            trigger OnValidate()
            begin
                CheckDistributionAmounts();
            end;
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
                        if (Rec."Sales Invoice" = true) then begin
                            if ((Rec."Distribution Options" = Rec."Distribution Options"::"Single Project") or (Rec."Distribution Options" = Rec."Distribution Options"::"Multiple Project")) then begin
                                if (("Dimension Value Two" <> '')) then
                                    UserCustManage.CreateProjectDistFromDistributionLine(Rec."Entry No.", Rec."Dimension Value Two", xRec."Dimension Value Two", Rec."G/L Account No.", 2)
                                else begin
                                    if ((Rec."Dimension Value Two" <> Rec."Dimension Value One") or (Rec."Dimension Value Two" <> Rec."Dimension Value Three") or (Rec."Dimension Value Two" <> Rec."Dimension Value Four") or (Rec."Dimension Value Two" <> Rec."Dimension Value Five")) then begin
                                        IsBoolean := UserCustManage.DeleteAndSendErrorDistributionProjectAndDistributionRuleLines(Rec."Entry No.", xRec."Dimension Value Two", 0);
                                        if (IsBoolean = false) then
                                            Error('%1 Dimension value already exist', "Dimension Value Two");
                                    end;

                                    Clear(IsBoolean);
                                    if (xRec."Dimension Value Two" <> Rec."Dimension Value Two") then begin
                                        IsBoolean := UserCustManage.DeleteAndSendErrorDistributionProjectAndDistributionRuleLines(Rec."Entry No.", xRec."Dimension Value Two", 1);
                                        if (IsBoolean = false) then
                                            Message('Distribution Project and Distribution Rule Lines are Deleted');
                                    end;

                                    Clear(IsBoolean);
                                end;
                            end else
                                Error('Please Fill Distribution Options Either Single Project Or Multiple Project');
                        end else begin
                            if (Rec."Sales Invoice" = false) then begin
                                if (("Dimension Value Two" <> '')) then
                                    UserCustManage.CreateProjectDistFromDistributionLine(Rec."Entry No.", Rec."Dimension Value Two", xRec."Dimension Value Two", Rec."G/L Account No.", 2)
                                else begin
                                    if ((Rec."Dimension Value Two" <> Rec."Dimension Value One") or (Rec."Dimension Value Two" <> Rec."Dimension Value Three") or (Rec."Dimension Value Two" <> Rec."Dimension Value Four") or (Rec."Dimension Value Two" <> Rec."Dimension Value Five")) then begin
                                        IsBoolean := UserCustManage.DeleteAndSendErrorDistributionProjectAndDistributionRuleLines(Rec."Entry No.", xRec."Dimension Value Two", 0);
                                        if (IsBoolean = false) then
                                            Error('%1 Dimension value already exist', "Dimension Value Two");
                                    end;

                                    Clear(IsBoolean);
                                    if (xRec."Dimension Value Two" <> Rec."Dimension Value Two") then begin
                                        IsBoolean := UserCustManage.DeleteAndSendErrorDistributionProjectAndDistributionRuleLines(Rec."Entry No.", xRec."Dimension Value Two", 1);
                                        if (IsBoolean = false) then
                                            Message('Distribution Project and Distribution Rule Lines are Deleted');
                                    end;

                                    Clear(IsBoolean);
                                end;
                            end;
                        end;
                    end else
                        Error('Distribution Setup Must be True');
                end else
                    Error('Please Fill Distribution Method Manually');
            end;
        }

        field(36; "Distribution Amount Two"; Decimal)
        {
            Caption = 'Distribution Amount Two';
            trigger OnValidate()
            begin
                CheckDistributionAmounts();
            end;
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
                        if (Rec."Sales Invoice" = true) then begin
                            if ((Rec."Distribution Options" = Rec."Distribution Options"::"Single Project") or (Rec."Distribution Options" = Rec."Distribution Options"::"Multiple Project")) then begin
                                if (("Dimension Value Three" <> '')) then
                                    UserCustManage.CreateProjectDistFromDistributionLine(Rec."Entry No.", Rec."Dimension Value Three", xRec."Dimension Value Three", Rec."G/L Account No.", 3)
                                else
                                    Error('Distribution Value One Must be a Value');
                            end else
                                Error('Please Fill Distribution Options Either Single Project Or Multiple Project');
                        end else begin
                            if (Rec."Sales Invoice" = false) then begin
                                if (("Dimension Value Three" <> '')) then
                                    UserCustManage.CreateProjectDistFromDistributionLine(Rec."Entry No.", Rec."Dimension Value Three", xRec."Dimension Value Three", Rec."G/L Account No.", 3)
                                else
                                    Error('Distribution Value One Must be a Value');
                            end;
                        end;
                    end else
                        Error('Distribution Setup Must be True');
                end else
                    Error('Please Fill Distribution Method Manually');
            end;
        }

        field(42; "Distribution Amount Three"; Decimal)
        {
            Caption = 'Distribution Amount Three';
            trigger OnValidate()
            begin
                CheckDistributionAmounts();
            end;
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
                        if (Rec."Sales Invoice" = true) then begin
                            if ((Rec."Distribution Options" = Rec."Distribution Options"::"Single Project") or (Rec."Distribution Options" = Rec."Distribution Options"::"Multiple Project")) then begin
                                if (("Dimension Value Four" <> '')) then
                                    UserCustManage.CreateProjectDistFromDistributionLine(Rec."Entry No.", Rec."Dimension Value Four", xRec."Dimension Value Four", Rec."G/L Account No.", 4)
                                else
                                    Error('Distribution Value One Must be a Value');
                            end else
                                Error('Please Fill Distribution Options Either Single Project Or Multiple Project');
                        end else begin
                            if (Rec."Sales Invoice" = false) then begin
                                if (("Dimension Value Four" <> '')) then
                                    UserCustManage.CreateProjectDistFromDistributionLine(Rec."Entry No.", Rec."Dimension Value Four", xRec."Dimension Value Four", Rec."G/L Account No.", 4)
                                else
                                    Error('Distribution Value One Must be a Value');
                            end;
                        end;
                    end else
                        Error('Distribution Setup Must be True');
                end else
                    Error('Please Fill Distribution Method Manually');
            end;
        }

        field(47; "Distribution Amount Four"; Decimal)
        {
            Caption = 'Distribution Amount Four';
            trigger OnValidate()
            begin
                CheckDistributionAmounts();
            end;
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
                        if (Rec."Sales Invoice" = true) then begin
                            if ((Rec."Distribution Options" = Rec."Distribution Options"::"Single Project") or (Rec."Distribution Options" = Rec."Distribution Options"::"Multiple Project")) then begin
                                if (("Dimension Value One" <> '')) then
                                    UserCustManage.CreateProjectDistFromDistributionLine(Rec."Entry No.", Rec."Dimension Value Five", xRec."Dimension Value Five", Rec."G/L Account No.", 5)
                                else
                                    Error('Distribution Value One Must be a Value');
                            end else
                                Error('Please Fill Distribution Options Either Single Project Or Multiple Project');
                        end else begin
                            if (Rec."Sales Invoice" = false) then begin
                                if (("Dimension Value One" <> '')) then
                                    UserCustManage.CreateProjectDistFromDistributionLine(Rec."Entry No.", Rec."Dimension Value Five", xRec."Dimension Value Five", Rec."G/L Account No.", 5)
                                else
                                    Error('Distribution Value One Must be a Value');
                            end;
                        end;
                    end else
                        Error('Distribution Setup Must be True');
                end else
                    Error('Please Fill Distribution Method Manually');
            end;
        }

        field(52; "Distribution Amount Five"; Decimal)
        {
            Caption = 'Distribution Amount Five';
            trigger OnValidate()
            begin
                CheckDistributionAmounts();
            end;
        }

        field(53; "Distribution Setup"; Boolean)
        {
            Caption = 'Distribution Setup';
        }

        field(54; "Dist Single Line Amount"; Boolean)
        {
            Caption = 'Distribution Single Line Amount';
        }

        field(55; "Distribution Options"; Option)
        {
            Caption = 'Distribution Options';
            OptionMembers = "","Single Project","Multiple Project";
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    local procedure CheckDistributionAmounts()
    var
        DimensionAmount: Decimal;
    begin
        DimensionAmount := ((Rec."Distribution Amount One") + (Rec."Distribution Amount Two") + (Rec."Distribution Amount Three") + (Rec."Distribution Amount Four") + (Rec."Distribution Amount Five"));
        if (DimensionAmount > Rec."Distribution Amount") then
            Error('Please Check The Distribution Amount');
    end;

    var
        UserCustManage: Codeunit "User Customize Manage";
        GLAccNo: Code[20];
        IsBoolean: Boolean;
}