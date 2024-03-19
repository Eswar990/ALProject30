tableextension 50201 DimensionEx extends Dimension
{
    fields
    {
        field(50200; "Dimension Filter"; Boolean)
        {
            Caption = 'Dimension Filter';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                GenLedSetup: Record "General Ledger Setup";
            begin
                GenLedSetup.Get();
                if GenLedSetup."Global Dimension 2 Code" <> Rec.Code then
                    Error('You are not allowed to select this dimension, please contact system administrator.');
            end;
        }
    }
}
