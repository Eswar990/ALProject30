pageextension 50206 "Sales Invoice Subform" extends "Sales Invoice Subform"
{
    layout
    {
        addbefore(Quantity)
        {

            field("Primary Contact No."; Rec."Primary Contact No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Primary Contact No. field.';
            }
            field("Contact Name"; Rec."Contact Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Contact Name field.';
            }
        }
        addafter("Line Discount %")
        {

            field("Amount Collected"; Rec."Amount Collected")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Amount Collected field.';
            }
        }
    }
}
