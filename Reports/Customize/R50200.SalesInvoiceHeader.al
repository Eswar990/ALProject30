report 50200 "Sales Invoice Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layout/50200.SalesInvoiceReport.rdl';
    Caption = 'Sales Invoice Report';
    dataset
    {
        dataitem(SalesInvoiceHeader; "Sales Invoice Header")
        {
            DataItemTableView = sorting("No.");
            column(CustAddDetailsOne; CustAddDetails[1])
            {
            }
            column(CustAddDetailsTwo; CustAddDetails[2])
            {
            }
            column(CustAddDetailsThree; CustAddDetails[3])
            {
            }
            column(CustAddDetailsFour; CustAddDetails[4])
            {
            }
            column(CustAddDetailsFive; CustAddDetails[5])
            {
            }
            column(No_SalesInvoiceHeader; "No.")
            {
            }
            column(TextHead; TextHead)
            {

            }
            column(TextDescrip; TextDescrip)
            {

            }
            column(Posting_Date; Format("Posting Date", 0, '<Day,2>/<Month,2>/<Year>'))
            {

            }
            column(TextFooter; TextFooter)
            {

            }
            column(CompInfoName; CompInfo.Name)
            {

            }
            column(BankAcc_BankAccountNo; BankAcc."Bank Account No.")
            {

            }
            column(BankAcc_BankAccountName; BankAcc.Name)
            {

            }
            column(BankAcc_BankBranchNo; BankAcc."Bank Branch No.")
            {

            }
            column(BankAcc_BankCurrCode; BankAcc."Currency Code")
            {

            }
            column(BankAcc_BankIBAN; BankAcc.IBAN)
            {

            }
            column(BankAcc_SWIFTCode; BankAcc."SWIFT Code")
            {

            }
            column(CompInfoVATRegistrationNo; CompInfo."VAT Registration No.")
            {

            }
            column(CustVATRegistrationNo; CustAddDetails[7])
            {

            }
            dataitem(SalesInvoiceLine; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.");
                column(ShortcutDimCodeFour; ShortcutDimCode[4])
                {

                }
                column(Primary_Contact_No_; "Primary Contact No.")
                {

                }
                column(Contact_Name; "Contact Name")
                {

                }
                column(ShortcutDimCodeThree; ShortcutDimCode[3])
                {

                }
                column(Amount_Collected; "Amount Collected")
                {

                }
                column(Amount; Amount)
                {

                }
                column(VATAmount; VATAmount)
                {

                }
                column(Amount_Including_VAT; "Amount Including VAT")
                {

                }
                trigger OnAfterGetRecord()
                begin
                    Clear(VATAmount);
                    VATAmount := "Amount Including VAT" - Amount;
                    ShowShortcutDimCode(ShortcutDimCode);
                end;
            }
            trigger OnPreDataItem()
            begin
                CompInfo.Get();
            end;

            trigger OnAfterGetRecord()
            begin
                TextHead := 'Tax Invoice for the month of ' + Format(PrintDate, 0, '<Month Text> <Year4>');
                TextDescrip := 'Description: Payment for Aqency commission aqainst Collection of (Recovery/W.Off/Bckt7) for the month of ' +
                    Format(PrintDate, 0, '<Month Text> <Year4>');
                TextFooter := 'All bills have been raised until ' + Format(PrintDate, 0, '<Month Text> <Year4>') +
                    ' and all bill have been paid until ' + Format(CalcDate('<-1M>', PrintDate), 0, '<Month Text> <Year4>');
                BankAcc.Get("Company Bank Account Code");
                GetCustAddDetails();

            end;
        }

    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(General)
                {
                    field(PrintDate; PrintDate)
                    {
                        Caption = 'Print Date';
                        ApplicationArea = All;
                    }
                }
            }

        }
        trigger OnOpenPage()
        begin
            PrintDate := Today;
        end;
    }
    var
        CompInfo: Record "Company Information";
        BankAcc: Record "Bank Account";
        GenLedSetup: Record "General Ledger Setup";
        TextHead: Text[250];
        TextDescrip: Text[250];
        TextFooter: Text[250];
        CustAddDetails: array[7] of Text[150];
        ShortcutDimCode: array[8] of Code[20];
        CurrCode: Code[20];
        PrintDate: Date;
        VATAmount: Decimal;

    local procedure GetCustAddDetails()
    var
        Contact: Record Contact;
        Cust: Record Customer;
        Inx: Integer;
    begin
        Inx := 1;
        CustAddDetails[Inx] := SalesInvoiceHeader."Sell-to Customer No." + ' ' + SalesInvoiceHeader."Sell-to Customer Name";
        Cust.Get(SalesInvoiceHeader."Sell-to Customer No.");
        if Cust.Address <> '' then begin
            Inx += 1;
            CustAddDetails[Inx] := Cust.Address;
        end;
        if Cust."Address 2" <> '' then begin
            Inx += 1;
            CustAddDetails[Inx] := Cust."Address 2";
        end;
        if Cust.City <> '' then begin
            Inx += 1;
            CustAddDetails[Inx] := Cust.City;
        end;
        if Cust."Country/Region Code" <> '' then begin
            if CustAddDetails[Inx] <> '' then
                CustAddDetails[Inx] := CustAddDetails[Inx] + ',' + Cust."Country/Region Code"
            else
                CustAddDetails[Inx] := Cust."Country/Region Code";
        end;
        if Cust."VAT Registration No." <> '' then
            CustAddDetails[7] := Cust."VAT Registration No.";
    end;

}
