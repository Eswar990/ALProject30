codeunit 50201 "Text File Manage"
{
    procedure CreateCSVFile()
    var
        InStr: InStream;
        OutStr: OutStream;
        TempBlob: Codeunit "Temp Blob";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        FileName: Text;
        ToRecipients: List of [Text];
        CRLF: Text[2];
    begin
        CRLF[1] := 13;
        CRLF[2] := 10;
        Clear(OutStr);
        FileName := 'EcoFile' + '.csv';
        TempBlob.CreateOutStream(OutStr, TextEncoding::Windows);
        OutStr.WriteText('Dcument No' + ',' + 'D000000023' + CRLF);
        Clear(InStr);
        TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        DownloadFromStream(InStr, 'Download File', 'D:\Home\', 'Home', FileName);
        ToRecipients.Add('');
        EmailMessage.Create(ToRecipients, '', '', false);
        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);

    end;

}
