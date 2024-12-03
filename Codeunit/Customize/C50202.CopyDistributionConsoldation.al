codeunit 50202 "Copy Distribution Consoldation"
{
    trigger OnRun()
    begin
        ImportCustomData();
    end;

    procedure ImportCustomData()
    var
        DistributionRule: Record "Distribution Rule";
        CopyDistributionRule: Record "Distribution Rule";
        GenledgerSetup: Record "General Ledger Setup";
        Currency: Record Currency;
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        CompanyNameTxt: Text;
        Date: Date;
        CalDate: Date;
        CurrencyFactor: Decimal;
        DeletionValue: Integer;
    begin
        CopyDistributionRule.ChangeCompany('Azzite Group - Consolidation');
        CopyDistributionRule.SetRange("Company Name", CompanyName);
        if (CopyDistributionRule.FindSet(false) = true) then
            CopyDistributionRule.DeleteAll();

        if (DistributionRule.FindSet(false) = true) then begin
            repeat
                CopyDistributionRule.Init();
                CopyDistributionRule.TransferFields(DistributionRule);
                if (DistributionRule."Company Name" = CompanyName) then begin
                    if (GenledgerSetup.Get() = true) then
                        if ((GenledgerSetup."LCY Code" = 'IND') or (GenledgerSetup."LCY Code" = 'INR')) then begin
                            CurrencyExchangeRate.SetRange("Currency Code", 'AED');
                            CurrencyExchangeRate.SetRange("Starting Date", DistributionRule."Posting Date");
                            if (CurrencyExchangeRate.FindLast() = true) then
                                CopyDistributionRule."Amount Allocated" := (DistributionRule."Amount Allocated" * CurrencyExchangeRate."Exchange Rate Amount")
                            else begin
                                Date := Today;
                                CalDate := Today - 1;
                                CurrencyExchangeRate.SetRange("Currency Code", 'AED');
                                CurrencyExchangeRate.SetRange("Starting Date", Date);
                                if (CurrencyExchangeRate.FindLast() = true) then begin
                                    CopyDistributionRule."Amount Allocated" := (DistributionRule."Amount Allocated" * CurrencyExchangeRate."Exchange Rate Amount")
                                end else begin
                                    CurrencyExchangeRate.SetRange("Currency Code", 'AED');
                                    CurrencyExchangeRate.SetRange("Starting Date", CalDate);
                                    if (CurrencyExchangeRate.FindLast() = true) then
                                        CopyDistributionRule."Amount Allocated" := (DistributionRule."Amount Allocated" * CurrencyExchangeRate."Exchange Rate Amount")
                                    else begin
                                        if (CurrencyExchangeRate.FindLast() = true) then
                                            CopyDistributionRule."Amount Allocated" := (DistributionRule."Amount Allocated" * CurrencyExchangeRate."Exchange Rate Amount")
                                    end;
                                end;
                            end;
                        end;
                end;
                CopyDistributionRule.Insert(false);
            until DistributionRule.Next() = 0;
        end
    end;
}