tableextension 50206 "Sales Invoice Line" extends "Sales Invoice Line"
{
    fields
    {
        field(50200; "Amount Collected"; Decimal)
        {
            Caption = 'Amount Collected';
            DataClassification = ToBeClassified;
        }
        field(50201; "Primary Contact No."; Code[20])
        {
            Caption = 'Primary Contact No.';
            TableRelation = Contact;
        }
        field(50202; "Contact Name"; Text[100])
        {
            Caption = 'Contact Name';
        }
    }
}
