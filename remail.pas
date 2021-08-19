unit remail;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, shellapi, result, news, Menus;

type
  TfrmRemail = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    efTo: TEdit;
    Label9: TLabel;
    efSubj: TEdit;
    ckNews: TCheckBox;
    efNewsgroup: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    cmdSave: TButton;
    cmdClose: TButton;
    efMsg: TMemo;
    pbLookupGroups: TButton;
    cbRemailer: TComboBox;
    cbNym: TComboBox;
    cbFrom: TComboBox;
    cmdReset: TButton;
    mnRemailMain: TMainMenu;
    mnFile: TMenuItem;
    mnFileSave: TMenuItem;
    mnFileClose: TMenuItem;
    mnFileReset: TMenuItem;
    procedure cmdSaveClick(Sender: TObject);
    procedure cmdCloseClick(Sender: TObject);
    procedure TestString(sString : PChar);
    procedure OnNewsGroupsClick(Sender: TObject);
    procedure pbLookupGroupsClick(Sender: TObject);
    procedure OnMainCreate(Sender: TObject);
    procedure OnMainDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mnFileCloseClick(Sender: TObject);
    procedure mnFileSaveClick(Sender: TObject);
  private
    { Private declarations }
    function WriteNymFile: Boolean;
    procedure WriteRemailerFile;
    function CallPGP(psFileName, psWho : String; bSigned : Boolean): Boolean;
  public
    { Public declarations }
  end;

var
  frmRemail: TfrmRemail;

implementation

{$R *.DFM}



procedure TfrmRemail.cmdSaveClick(Sender: TObject);
var
   dlgShow : TDlgResults;
begin
    if WriteNymFile then
    begin
       dlgShow := TDlgResults.Create(Self);
       if Length(cbRemailer.Text) > 0 then
       begin
	        WriteRemailerFile;
	        dlgShow.efResults.Lines.LoadFromFile('pass2.asc');
       end
       else
	        dlgShow.efResults.Lines.LoadFromFile('pass1.asc');

       dlgShow.ShowModal;
    end;

end;


procedure TfrmRemail.cmdCloseClick(Sender: TObject);
begin
   Close;
end;


function TfrmRemail.WriteNymFile: Boolean;
var
   oTxtFile : TextFile;
   sText : String;
begin
{
}
   AssignFile(oTxtFile, 'pass1.pgp');
   Rewrite(oTxtFile);

   sText := 'From: ' + cbFrom.Text;
   WriteLn(oTxtFile, sText);

   sText := 'To: ' + efTo.Text;
   WriteLn(oTxtFile, sText);

   sText := 'Subject: ' + efSubj.Text;
   WriteLn(oTxtFile, sText);

   if ckNews.Checked = True then
   begin
       sText := 'Newsgroups: ' + efNewsgroup.Text;
       WriteLn(oTxtFile, sText);
   end;

   WriteLn(oTxtFile, '');
   sText := efMsg.Text;
   WriteLn(oTxtFile, sText);

   CloseFile(oTxtFile);

   Result := CallPGP('pass1.pgp', cbNym.text, TRUE);

end;

procedure TfrmRemail.WriteRemailerFile;
var
    oInFile, oOutFile : TextFile;
    sReadIn : String;
begin

    AssignFile(oInFile, 'pass1.asc');
    AssignFile(oOutFile, 'pass2.pgp');
    Rewrite(oOutFile);
    Reset(oInFile);

    WriteLn(oOutFile, 'Anon-To: ' + cbNym.Text);
    WriteLn(oOutFile, 'Subject: ' + efSubj.Text);
    WriteLn(oOutFile, '');
    WriteLn(oOutFile, '**');
    WriteLn(oOutFile, '');

    while not EOF(oInFile) do
    begin
	ReadLn(oInFile, sReadIn);
	WriteLn(oOutFile, sReadIn);
    end;

    CloseFile(oInFile);
    CloseFile(oOutFile);

    CallPGP('pass2.pgp', cbRemailer.Text, FALSE);
end;

function TfrmRemail.CallPGP(psFileName, psWho : String; bSigned : Boolean): Boolean;
var
   // hProcess : Integer;
   dwExitCode : DWORD;
   stStart : TStartupInfo;
   stProc : TProcessInformation;
   bRet : Boolean;
   chText : array [0..255] of Char;
   // pText : PChar;
begin
   {we could include password in here}
   if bSigned = TRUE then
       StrPCopy(chText, 'pgp.exe -seat ' + psFileName + ' ' + psWho + ' -u' + cbFrom.Text)
   else
       StrPCopy(chText, 'pgp.exe -eat ' + psFileName + ' ' + psWho);

   // pText := chText;

   ZeroMemory(@stStart, sizeof(stStart));
   stStart.cb := sizeof(stStart);

   bRet := CreateProcess(Nil, chText, Nil, Nil, FALSE,
		  CREATE_DEFAULT_ERROR_MODE OR CREATE_NEW_CONSOLE,
		  Nil, Nil, stStart, stProc);

   if bRet then
   begin
       WaitForSingleObject(stProc.hProcess, INFINITE);
   end
   else
   begin
       dwExitCode := GetLastError;
       if dwExitCode = ERROR_BAD_FORMAT Then
	        MessageDlg('PGP is not valid' + IntToStr(dwExitCode), mtError, [mbOK], 0)
       else
	        MessageDlg('PGP Startup Error : #' + IntToStr(dwExitCode), mtError, [mbOK], 0);
   end;

   Result := bRet;
end;

procedure TfrmRemail.TestString(sString : PChar);
begin
   MessageDlg(sString, mtError, [mbOK], 0);
end;



procedure TfrmRemail.OnNewsGroupsClick(Sender: TObject);
begin
   if ckNews.Checked = TRUE then
   begin
       pbLookupGroups.Enabled := TRUE;
       efNewsgroup.Enabled := TRUE;
       efNewsgroup.Color := clWindow;
   end
   else
   begin
       pbLookupGroups.Enabled := FALSE;
       efNewsgroup.Enabled := FALSE;
       efNewsgroup.Color := clBtnFace;
   end;
end;

procedure TfrmRemail.pbLookupGroupsClick(Sender: TObject);
var
   dlgLookup : TdlgNewsgroup;
begin
   dlgLookup := TdlgNewsgroup.Create(Self);
   efNewsgroup.Text := dlgLookup.GetAGroup;
end;

procedure TfrmRemail.OnMainCreate(Sender: TObject);
begin
{
}
   cbRemailer.Items.LoadFromFile('remailer.txt');
   cbNym.Items.LoadFromFile('nym.txt');
   cbFrom.Items.LoadFromFile('rfrom.txt');
end;

procedure TfrmRemail.OnMainDestroy(Sender: TObject);
begin
{
}
   try
       cbRemailer.Items.SaveToFile('remailer.txt');
       cbNym.Items.SaveToFile('nym.txt');
       cbFrom.Items.SaveToFile('rfrom.txt');
   finally
       ;
   end;
end;

procedure TfrmRemail.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action := caFree;
end;

procedure TfrmRemail.mnFileCloseClick(Sender: TObject);
begin
   cmdCloseClick(Sender);
end;

procedure TfrmRemail.mnFileSaveClick(Sender: TObject);
begin
   cmdSaveClick(Sender);
end;


end.
