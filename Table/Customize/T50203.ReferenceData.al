table 50203 "Reference Data"
{
    Caption = 'Rate Card Reference';
    DataClassification = ToBeClassified;
    LookupPageId = "Reference Data List";
    DrillDownPageId = "Reference Data List";

    fields
    {
        field(1; "Type"; Enum "Reference Type")
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(10; "Sorting Value"; Code[10])
        {
            Caption = 'Sorting Value';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Type", "Code")
        {
            Clustered = true;
        }
        key(PK1; Description)
        {

        }
        key(PK2; "Sorting Value")
        {

        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; Code, Description)
        {

        }
    }
}
