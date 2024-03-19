tableextension 50204 SalesLineEx extends "Sales Line"
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

            trigger OnLookup()
            begin
                LookupContactList();
            end;

            trigger OnValidate()
            var
                Cont: Record Contact;
            begin
                "Contact Name" := '';
                if "Primary Contact No." <> '' then begin
                    Cont.Get("Primary Contact No.");
                    if Cont.Type = Cont.Type::Person then begin
                        "Contact Name" := Cont.Name;
                        exit;
                    end;

                end;
            end;
        }
        field(50202; "Contact Name"; Text[100])
        {
            Caption = 'Contact Name';
        }
    }
    var
        Text003: Label 'Contact %1 %2 is not related to customer %3 %4.';

    local procedure LookupContactList()
    var
        ContactBusinessRelation: Record "Contact Business Relation";
        Cont: Record Contact;
        TempCust: Record Customer temporary;
        IsHandled: Boolean;
    begin
        Cont.FilterGroup(2);
        if ContactBusinessRelation.FindByRelation(ContactBusinessRelation."Link to Table"::Customer, Rec."Sell-to Customer No.") then
            Cont.SetRange("Company No.", ContactBusinessRelation."Contact No.")
        else
            Cont.SetRange("Company No.", '');

        if "Primary Contact No." <> '' then
            if Cont.Get("Primary Contact No.") then;
        if PAGE.RunModal(0, Cont) = ACTION::LookupOK then
            Validate("Primary Contact No.", Cont."No.");
    end;

    local procedure CheckCustomerContactRelation(Cont: Record Contact)
    var
        ContBusRel: Record "Contact Business Relation";
        Cust: Record Customer;
    begin
        Cust.Get(Rec."Sell-to Customer No.");
        ContBusRel.FindOrRestoreContactBusinessRelation(Cont, Rec, ContBusRel."Link to Table"::Customer);
        if Cont."Company No." <> ContBusRel."Contact No." then
            Error(Text003, Cont."No.", Cont.Name, Cust."No.", Cust.Name);
    end;
}
