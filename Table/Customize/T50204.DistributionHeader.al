table 50204 "Distribution Header"
{
    Caption = 'Distribution Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = ToBeClassified;
        }
        field(5; Year; code[20])
        {
            Caption = 'Year';
            TableRelation = "Reference Data".Code where(Type = const(Year));
        }
        field(8; Month; code[20])
        {
            Caption = 'Month';
            TableRelation = "Reference Data".Code where(Type = const(Month));
        }
        field(10; "Previous Year"; code[20])
        {
            Caption = 'Previous Year';
            TableRelation = "Reference Data".Code where(Type = const(Year));
        }
        field(11; "Previous Month"; code[20])
        {
            Caption = 'Previous Month';
            TableRelation = "Reference Data".Code where(Type = const(Month));
        }
    }
    keys
    {
        key(PK; "User ID")
        {
            Clustered = true;
        }
    }
}
