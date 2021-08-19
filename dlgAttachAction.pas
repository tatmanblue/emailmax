// copyright (c) 2002 by microObjects inc.
//
// Emailmax source is distributed under the public
// domain license arrangements.  You are free to
// modify, edit, copy, delete, or redistribute
// the emailmax code as long as you 1) indemnify
// microObjects inc and its employees and owners
// from any and all liablity, directly or indirectly,
// related to the use, modification or distribution
// of this code 2) and make proper credit where
// applicable.
unit dlgAttachAction;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, folder, registry, ExtCtrls, eglobal;

type
  TAttachActionType = (aaOpen, aaSaveAs, aaDelete, aaUser);
  TdlgAttachmentAction = class(TForm)
    pbOK: TButton;
    pbCancel: TButton;
    rbActions: TRadioGroup;
    efOtherCommand: TEdit;
    Label1: TLabel;
    ctlWarning: TImage;
    txtWarning: TLabel;
    ctlWarningTimer: TTimer;
    txtFile: TLabel;
    ctlSaveAs: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure rbActionsClick(Sender: TObject);
    procedure ctlWarningTimerTimer(Sender: TObject);
    procedure pbCancelClick(Sender: TObject);
    procedure pbOKClick(Sender: TObject);
  private
    { Private declarations }
    m_strFile : string;
    m_nAttachmentListIndex : Integer;

    procedure SetFileName(strFileName : String);
    procedure SetFullFileName(strFullName : String);
    function Open(): boolean;
    function SaveAs(): boolean;
    function Delete(): boolean;
    function OtherCommand(): boolean;
  public
    { Public declarations }
  published
     property DisplayName : String write SetFileName;
     property FullFileName : String write SetFullFileName;
     property AttachmentListIndex : Integer write m_nAttachmentListIndex;
  end;

var
  dlgAttachmentAction: TdlgAttachmentAction;

implementation

uses
   shellapi;

{$R *.DFM}

function TdlgAttachmentAction.Open(): boolean;
var
   hInst : DWORD;
begin

   hInst := EmailmaxShellExecute('open', m_strFile);
   if 32 > hInst then
   begin
      MessageDlg('Unable to open the file "' + m_strFile + '".  Make sure that any file associations needed are setup correctly', mtInformation, [mbOK], 0);
      Open := FALSE;
   end
   else
      Open := TRUE;
end;

function TdlgAttachmentAction.SaveAs(): boolean;
var
   oSrcFile, oDestFile : File;
   szBuf: array[1..2048] of Char;
   nBytesRead, nBytesWritten: Integer;
begin
   ctlSaveAs.FileName := m_strFile;
   if TRUE = ctlSaveAs.Execute then
   begin
      try
        AssignFile(oSrcFile, m_strFile);
        AssignFile(oDestFile, ctlSaveAs.FileName);
        Reset(oSrcFile, 1);
        if FileExists(ctlSaveAs.FileName) then
           Reset(oDestFile, 1)
        else
           Rewrite(oDestFile, 1);

        repeat
            BlockRead(oSrcFile, szBuf, SizeOf(szBuf), nBytesRead);
            BlockWrite(oDestFile, szBuf, nBytesRead, nBytesWritten);
        until (nBytesRead = 0) or (nBytesWritten <> nBytesRead);

        CloseFile(oDestFile);
        CloseFile(oSrcFile);

        SaveAs := TRUE;
     except
        on e : Exception do
        begin
            MessageDlg('Saving the file to "' +  ctlSaveAs.FileName + '" failed. Error: ' + e.Message, mtWarning, [mbOK], 0);
            SaveAs := FALSE;
        end;
     end;
   end
   else
      SaveAs := FALSE;
end;

function  TdlgAttachmentAction.Delete(): boolean;
begin
   Delete := FALSE;
   if mrYes = MessageDlg('Are you sure you want to delete "' + m_strFile + '"? Click yes to delete the file and no to leave the file on your computer.', mtConfirmation, [mbYes, mbNo], 0) then
   begin
      if FileExists(m_strFile) then
      begin
          try
             DeleteFile(m_strFile);
             Delete := TRUE;
          except
             MessageDlg('Failed to delete "' + m_strFile + '".', mtInformation, [mbOK], 0);
          end;
      end;
   end;
end;

function TdlgAttachmentAction.OtherCommand(): boolean;
var
   hInst : DWORD;
   strCommand : String;
begin
   strCommand := Trim(efOtherCommand.Text) + ' ' + m_strFile;
   hInst := EmailmaxShellExecute('open', strCommand);
   if 32 > hInst then
   begin
      MessageDlg('Unable to open the file "' + strCommand + '".  Make sure that any file associations needed are setup correctly', mtInformation, [mbOK], 0);
      OtherCommand := FALSE;
   end
   else
      OtherCommand := TRUE;
end;

procedure TdlgAttachmentAction.SetFullFileName(strFullName : String);
begin
   if 0 = Length(Trim(ExtractFilePath(strFullName))) then
      m_strFile := g_oDirectories.AttachmentPath + strFullName
   else
      m_strFile := strFullName;
end;

procedure TdlgAttachmentAction.SetFileName(strFileName : String);
begin
   txtFile.Caption := strFileName;
end;

procedure TdlgAttachmentAction.FormCreate(Sender: TObject);
var
   szCaption : array [0..128] of Char;
begin
   // because rbActions does not have a title, text, or caption property
   // we gotta use the windows way of setting this
   ZeroMemory(@szCaption, sizeof(szCaption));
   StrPCopy(szCaption, 'Your options for this attachment');
   SetWindowText(rbActions.Handle, szCaption);
end;

procedure TdlgAttachmentAction.rbActionsClick(Sender: TObject);
begin
   with efOtherCommand do
   begin
      Enabled := FALSE;
      Color := clInactiveCaptionText;
   end;

   ctlWarning.Visible := FALSE;
   txtWarning.Visible := FALSE;
   ctlWarningTimer.Enabled := FALSE;

   if (0 = rbActions.ItemIndex) OR
      (3 = rbActions.ItemIndex) then
   begin
      ctlWarning.Visible := TRUE;
      txtWarning.Visible := TRUE;
      ctlWarningTimer.Enabled := TRUE;
   end;

   if 3 = rbActions.ItemIndex then
   begin
      with efOtherCommand do
      begin
         Enabled := TRUE;
         Color := clwindow;
      end;
   end;
end;

procedure TdlgAttachmentAction.ctlWarningTimerTimer(Sender: TObject);
begin
   if TRUE = txtWarning.Visible then
   begin
      if clWindowText = txtWarning.Font.Color then
         txtWarning.Font.Color := clRed
      else
         txtWarning.Font.Color := clWindowText;
   end;
end;

procedure TdlgAttachmentAction.pbCancelClick(Sender: TObject);
begin
   ModalResult := mrCancel;
end;

procedure TdlgAttachmentAction.pbOKClick(Sender: TObject);
var
   fOK : boolean;
begin
   fOK := FALSE;
   case rbActions.ItemIndex of
      0: fOK := Open();
      1: fOK := SaveAs();
      2: fOK := Delete();
      3: fOK := OtherCommand();
   end;

   if TRUE = fOK then
      ModalResult := mrOK;

end;

end.
