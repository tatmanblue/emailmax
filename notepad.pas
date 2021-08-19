// copyright (c) 2002 by microObjects inc.
//
// Emailmax source is distributed under the public
// domain license arrangements.  You are free to
// modify, edit, copy, delete, or redistribute
// the emailmax code as long as you 1) indemnify amd
// hold harmless microObjects inc and its employees and
// owners from any and all liablity, directly or indirectly,
// related to the use, modification or distribution
// of this code 2) and make proper credit where
// applicable.

unit notepad;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  basepost, StdCtrls, Menus, ExtCtrls, outbound, wndfolder,
  AdvImage, email, ComCtrls, ImgList;

// TODO 1.20.02 Gid rid of these "read" vs "write" fields and use the same
// controls for the different functions
//
// Use TBaseEmail instances to store the data...probably need a "read only"
// and a modified...
//
//    Modified is used for new, reply, replyall, forward, etc...
//    read is used for read
//    duh

type
  TNotepadOptions  = (npSend, npRead, npReply, npReplyAll, npForward, npForwardReply);
  TwndNotepad = class(TwndBasePost)
    mnNotepadMenu: TMainMenu;
    mnNotepad: TMenuItem;
    mnNotepadSend: TMenuItem;
    mnNotepadForward: TMenuItem;
    mnNotepadReply: TMenuItem;
    N1: TMenuItem;
    mnNotepadClose: TMenuItem;
    N2: TMenuItem;
    mnNotepadEncrypt: TMenuItem;
    mnNotepadDecrypt: TMenuItem;
    mnEncryptPGP: TMenuItem;
    mnEncryptCeasar: TMenuItem;
    mnEncryptBeal: TMenuItem;
    ctlForward: TImage;
    ctlRead: TImage;
    ctlWrite: TImage;
    mnNotepadDecryptPGP: TMenuItem;
    mnNotepadDescryptCeasar: TMenuItem;
    mnNotepadDecryptBeal: TMenuItem;
    ctlReadPanel: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label8: TLabel;
    efReadSubj: TEdit;
    efReadTo: TEdit;
    efReadDate: TEdit;
    efReadFrom: TEdit;
    mnNotepadAttachFiles: TMenuItem;
    lblAttach: TLabel;
    efAttach: TEdit;
    ctlAttachFile: TOpenDialog;
    mnEncryptMD5: TMenuItem;
    mnNotepadDescryptMD5: TMenuItem;
    lblCC: TLabel;
    efCC: TEdit;
    lblBCC: TLabel;
    efBCC: TEdit;
    Label10: TLabel;
    efReadCC: TEdit;
    Label11: TLabel;
    efReadAttach: TEdit;
    mnNotepadSep3: TMenuItem;
    mnNotepadCC: TMenuItem;
    mnNotepadBCC: TMenuItem;
    mnNotepadPopup: TPopupMenu;
    mnPopupCC: TMenuItem;
    mnPopupBCC: TMenuItem;
    mnPopupSep1: TMenuItem;
    mnPopupAttach: TMenuItem;
    mnPopupSaveAsDraft: TMenuItem;
    mnPopupSave: TMenuItem;
    mnNotepadReplyAll: TMenuItem;
    mnNotepadSep4: TMenuItem;
    mnNotepadSaveAs: TMenuItem;
    mnNotepadSaveDraft: TMenuItem;
    pnlTo: TPanel;
    pnlCc: TPanel;
    pnlBcc: TPanel;
    pnlAttachments: TPanel;
    lvAttachments: TListView;
    ctlAttachmentIcons: TImageList;
    Panel1: TPanel;
    spltAttachments: TSplitter;
    mnAttachPopup: TPopupMenu;
    mnAttachPopupAdd: TMenuItem;
    mnAttachPopDelete: TMenuItem;
    mnAttachPopupClearAll: TMenuItem;
    mnAttachSaveAs: TMenuItem;
    procedure mnNotepadSendClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mnEncryptPGPClick(Sender: TObject);
    procedure mnNotepadSaveCloseClick(Sender: TObject);
    procedure efMsgChange(Sender: TObject);
    procedure mnNotepadForwardClick(Sender: TObject);
    procedure mnNotepadReplyClick(Sender: TObject);
    procedure mnEncryptCeasarClick(Sender: TObject);
    procedure mnNotepadDescryptCeasarClick(Sender: TObject);
    procedure efMsgKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mnNotepadAttachFilesClick(Sender: TObject);
    procedure mnEncryptMD5Click(Sender: TObject);
    procedure mnNotepadDescryptMD5Click(Sender: TObject);
    procedure mnNotepadCCClick(Sender: TObject);
    procedure mnNotepadBCCClick(Sender: TObject);
    procedure mnNotepadReplyAllClick(Sender: TObject);
    procedure mnNotepadSaveDraftClick(Sender: TObject);
    procedure mnNotepadSaveAsClick(Sender: TObject);
    procedure addrButtonsClick(Sender: TObject);
    procedure addrButtonsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure addrButtonsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mnAttachPopupClearAllClick(Sender: TObject);
    procedure mnAttachPopDeleteClick(Sender: TObject);
    procedure mnAttachPopupAddClick(Sender: TObject);
    procedure mnAttachSaveAsClick(Sender: TObject);

  private
    { Private declarations }
    m_nFolderOption : TNotepadOptions;

    m_nCCTop,
    m_nBCCTop,
    m_nSubjTop,
    m_nAttachTop : Integer;

    procedure SetupNotepadOptions;
    procedure CreateAttachmentEntry(strAttachFileName : String);

  protected
    procedure SavePostChildProc(oMsg : TBaseEmail); override;
    procedure ReAdjustSubTop();

    procedure DeleteAttachment(nIndex : Integer);
    procedure DeleteAllAttachments();

  public
    { Public declarations }
    constructor CreateWithType(AOwner: TComponent; nNotepadType : TNotepadOptions);
    constructor Create(AOwner: TComponent); override;

    procedure ReadEmail(oMsg : TBaseEmail; nOption : TNotepadOptions);
    procedure EncryptMsg;
    procedure EncryptMsgPgp;
    procedure EncryptMsgCeaser;
    procedure EncryptMsgMD5;
    procedure DecryptMsg;
    procedure DecryptMsgPgp;
    procedure DecryptMsgCeaser;
    procedure DecryptMsgMD5;
    procedure ForwardMail;
    procedure ReplyMail;

    procedure SavePost; override;
  published

  end;

implementation

uses
   eglobal, alias, displmsg, folder, dlgEPGP, dlgSelDc, mdimax, encryption,
   dlgECeas, dlgEMD5, savemsg, dlgAddEmailAddr;

{$R *.DFM}
{
  ==================================================================
  Developer Defined Functions -- Private, Public, etc...
  ==================================================================
}
procedure TwndNotepad.CreateAttachmentEntry(strAttachFileName : String);
var
   oItem : TListItem;
   sFileNameOnly : String;
begin
    if Length(Trim(efAttach.Text)) > 0 then
        efAttach.Text := efAttach.Text + ';';
    efAttach.Text := efAttach.Text + strAttachFileName;

    oItem := lvAttachments.Items.Add();
    if Not Assigned(oItem) then
       raise Exception.Create('oItem in TwndNotepad.CreateAttachmentEntry is not assigned.');
       
    sFileNameOnly := ExtractFileName(strAttachFileName);
    oItem.Caption := sFileNameOnly;
    oItem.ImageIndex := 0;
    pnlAttachments.Visible := TRUE;
    spltAttachments.Visible := TRUE;

end;

procedure TwndNotepad.ReAdjustSubTop();
begin

   ctlEditPanel.Height := efSubj.Top + efSubj.Height + 10;

   if (FALSE = efCC.Visible) AND
      (TRUE = efBCC.Visible) then
   begin
       efBCC.Top := m_nCCTop;
       lblBCC.Top := m_nCCTop;
       pnlBcc.Top := m_nCCTop;
       efSubj.Top := m_nBCCTop;
       lblSubj.Top := m_nBCCTop;
       efAttach.Top := m_nSubjTop;
       lblAttach.Top := m_nSubjTop;
       ctlEditPanel.Height := efSubj.Top + efSubj.Height + 10;
       exit;
   end;

   if (FALSE = efCC.Visible) AND
      (FALSE = efBCC.Visible) then
   begin
       efSubj.Top := m_nCCTop;
       lblSubj.Top := m_nCCTop;
       efAttach.Top := m_nBCCTop;
       lblAttach.Top := m_nBCCTop;
       ctlEditPanel.Height := efSubj.Top + efSubj.Height + 10;
       exit;
   end;

   if (TRUE = efCC.Visible) AND
      (FALSE = efBCC.Visible) then
   begin
       efSubj.Top := m_nBCCTop;
       lblSubj.Top := m_nBCCTop;
       efAttach.Top := m_nSubjTop;
       lblAttach.Top := m_nSubjTop;
       ctlEditPanel.Height := efSubj.Top + efSubj.Height + 10;
       exit;
   end;

   if (TRUE = efCC.Visible) AND
      (TRUE = efBCC.Visible) then
   begin
       efBCC.Top := m_nBCCTop;
       lblBCC.Top := m_nBCCTop;
       pnlBCC.Top := m_nBCCTop;
       efSubj.Top := m_nSubjTop;
       lblSubj.Top := m_nSubjTop;
       efAttach.Top := m_nAttachTop;
       lblAttach.Top := m_nAttachTop;
       ctlEditPanel.Height := efSubj.Top + efSubj.Height + 10;
       exit;
   end;
end;

procedure TwndNotepad.SavePostChildProc(oMsg : TBaseEmail);
begin
   if Not Assigned(oMsg) then
      raise Exception.Create('oMsg not assigned in TwndNotepad.SavePostChildProc');

   with oMsg do
   begin
       CC := efCC.Text;
       BCC := efBCC.Text;
   end;
end;

procedure TwndNotepad.SavePost;
var
   oFile : TextFile;
   sSource, sWork, sFileName : String;
begin
   inherited;
   // save attachments
   // TODO 1.20.02 we should be able
   // to "simpify by using a TStringList instead
   sFileName := Copy(m_sSourceFileName, 1, Pos('.', m_sSourceFileName) - 1) + g_csAttachFileExt;
   if Length(Trim(efAttach.Text)) > 0 then
   begin
       sSource := efAttach.Text;
       AssignFile(oFile, sFileName);

       Rewrite(oFile);
       while Pos(';', sSource) > 0 do
       begin
           sWork := Copy(sSource, 1, Pos(';', sSource) - 1);
           WriteLn(oFile, sWork);
           sWork := sSource;
           sSource := Copy(sWork, Pos(';', sWork) + 1, Length(sWork));
       end;

       if Length(Trim(sSource)) > 0 then
           WriteLn(oFile, sSource);

       CloseFile(oFile);
   end;
end;

procedure TwndNotepad.ReadEmail(oMsg : TBaseEmail; nOption : TNotepadOptions);
var
   nCount : Integer;
   oAttachList : TStringList;
begin

   if NOT Assigned(oMsg) then
       raise Exception.Create('Invalid Message Object was passed to the message editor.');

   // hmmm problems with this?
   if Assigned(m_oMsg) then
   begin
       m_oMsg.free;
       m_oMsg := NIL;
   end;

   m_nFolderOption := nOption;
   m_oMsg := TBaseEmail.Create(oMsg);

   if NOT Assigned(m_oMsg) then
       raise Exception.Create('Invalid Message Object was passed to the message editor.');

   SetupNotepadOptions;

   with oMsg do
   begin
       m_sSourceFileName := MsgTextFileName;
       if m_nFolderOption = npRead then
       begin
           efReadTo.Text := SendTo;
           efReadCC.Text := CC;
           efReadSubj.Text := Subject;
           efReadDate.Text := Date;
           efReadFrom.Text := From;
           Caption := 'Read an email from ' + From + ': ' + Subject;
       end
       else
           Caption := 'Edit an email To ' + SendTo + ': ' + Subject;

        // TODO...since we now have m_oMsg, why store the information
        // in both edit fields? instead, just keep referencing m_oMsg (defined in basepost)

        efTo.Text := SendTo;
        // problem: when you reply your only replying to whom the message
        // originated....
        efCC.Text := CC;
        if 0 < Length(Trim(efCC.Text)) then
        begin
           efCC.Visible := TRUE;
           efCC.Enabled := TRUE;
           lblCC.Visible := FALSE;
           pnlCC.Visible := TRUE;
           mnNotepadCC.Checked := TRUE;
        end;

        // there is never a BCC on a received email, however,
        // if this email was created locally, then there would be
        if g_csNA <> BCC then
           efBCC.Text := BCC
        else
           efBCC.Text := '';

        if 0 < Length(Trim(efBCC.Text)) then
        begin
           efBCC.Visible := TRUE;
           efBCC.Enabled := TRUE;
           lblBCC.Visible := FALSE;
           pnlBCC.Visible := TRUE;
           mnNotepadBCC.Checked := TRUE;
        end;


        efSubj.Text := Subject;
        efDate.Text := Date;
        for nCount := 0 to cbFrom.Items.Count - 1 do
        begin
            if cbFrom.Items[nCount] = From then
            begin
                cbFrom.ItemIndex := nCount;
                break;
            end;
        end;

        efMsg.Lines.LoadFromFile(m_sSourceFileName);

        if FileExists(AttachmentListFileName) then
        begin
           oAttachList := TStringList.Create;
           if Not Assigned(oAttachList) then
              raise Exception.Create('Failed to create oAttachList (TStringList) in TwndNotepad.ReadEmail');

           oAttachList.LoadFromFile(AttachmentListFileName);
           if 0 < oAttachList.Count then
           begin
               for nCount := 0 to oAttachList.Count - 1 do
               begin
                  CreateAttachmentEntry(oAttachList.Strings[nCount]);
               end;

               // modify the attachment menu
               mnAttachPopupAdd.Visible := FALSE;
               mnAttachSaveAs.Visible := TRUE;
               mnAttachPopupClearAll.Visible := FALSE;

               // TODO 1.20.02 temp
               mnAttachPopDelete.Visible := FALSE;

               // TODO 1.20.02 the notepad "main menu" needs
               // options for handling attachments too

           end;
        end;
    end;

    ReAdjustSubTop();
    m_bChanged := FALSE;
end;

procedure TwndNotepad.SetupNotepadOptions;
begin
   ctlEditPanel.Visible := TRUE;
   ctlReadPanel.Visible := FALSE;

   mnNotepadSend.Visible := FALSE;
   mnNotepadReply.Visible := FALSE;
   mnNotepadForward.Visible := FALSE;
   mnNotepadEncrypt.Enabled := FALSE;
   mnNotepadDecrypt.Enabled := FALSE;
   mnNotepadAttachFiles.Enabled := FALSE;
   mnNotepadAttachFiles.Visible := FALSE;
   mnNotepadBCC.Visible := FALSE;
   mnNotepadCC.Visible := FALSE;
   mnNotepadReplyAll.Visible := FALSE;
   mnNotepadSaveDraft.Visible := FALSE;
   mnNotepadSaveAs.Visible := FALSE;
   mnNotepadReplyAll.Enabled := FALSE;
   mnNotepadSaveDraft.Enabled := FALSE;
   mnNotepadSaveAs.Enabled := FALSE;
   lblCC.Visible := FALSE;
   lblBCC.Visible := FALSE;
   pnlCC.Visible := FALSE;
   pnlBCC.Visible := FALSE;

   ctlWrite.Visible := FALSE;
   ctlForward.Visible := FALSE;
   ctlRead.Visible := FALSE;
   efMsg.ReadOnly := FALSE;
   efAttach.ReadOnly := FALSE;

   case m_nFolderOption of
       npSend:
       begin
           NotepadType := wfNew;
           mnNotepadSend.Visible := TRUE;
           ctlWrite.Visible := TRUE;
           mnNotepadEncrypt.Enabled := TRUE;
           efDate.Text := DateTimeToStr(Now);
           mnNotepadAttachFiles.Enabled := TRUE;
           mnNotepadAttachFiles.Visible := TRUE;
           mnNotepadBCC.Visible := TRUE;
           mnNotepadCC.Visible := TRUE;
           mnNotepadSaveDraft.Visible := TRUE;
           mnNotepadSaveAs.Visible := TRUE;
           mnNotepadSaveDraft.Enabled := TRUE;
           mnNotepadSaveAs.Enabled := TRUE;
           efCC.Visible := FALSE;
           lblCC.Visible := FALSE;
           pnlCC.Visible := FALSE;
           efBCC.Visible := FALSE;
           lblBCC.Visible := FALSE;
           pnlBCC.Visible := FALSE;

           if Not Assigned(m_oMsg) then
               // TODO..this should go in draft folder...
               m_oMsg := TOutboundEmail.Create;
           
       end;
       npRead:
       begin
           NotepadType := wfRead;
           mnNotepadDecrypt.Enabled := TRUE;
           ctlRead.Visible := TRUE;
           efMsg.ReadOnly := TRUE;
           ctlEditPanel.Visible := FALSE;
           ctlReadPanel.Visible := TRUE;
           mnNotepadReply.Visible := TRUE;
           mnNotepadForward.Visible := TRUE;
           mnNotepadReply.Enabled := TRUE;
           mnNotepadForward.Enabled := TRUE;
           mnNotepadReplyAll.Visible := TRUE;
           mnNotepadSaveAs.Visible := TRUE;
           mnNotepadReplyAll.Enabled := TRUE;
           mnNotepadSaveAs.Enabled := TRUE;
           efAttach.ReadOnly := TRUE;
       end;
       npReply:
       begin
           efCC.Text := '';
           efBCC.Text := '';
       end;
       npReplyAll:
       begin
           efBCC.Text := '';
           NotepadType := wfNew;
           ctlForward.Visible := TRUE;
           mnNotepadSend.Visible := TRUE;
           mnNotepadEncrypt.Enabled := TRUE;
           m_sSourceFileName := '';
           mnNotepadAttachFiles.Enabled := TRUE;
           mnNotepadAttachFiles.Visible := TRUE;
           mnNotepadBCC.Visible := TRUE;
           mnNotepadCC.Visible := TRUE;
           mnNotepadSaveDraft.Visible := TRUE;
           mnNotepadSaveAs.Visible := TRUE;
           mnNotepadSaveDraft.Enabled := TRUE;
           mnNotepadSaveAs.Enabled := TRUE;
           if 0 = Length(Trim(efReadCC.Text)) then
           begin
               efCC.Visible := FALSE;
               lblCC.Visible := FALSE;
               pnlCC.Visible := FALSE;
           end
           else
           begin
               efCC.Visible := TRUE;
               lblCC.Visible := FALSE;
               pnlCC.Visible := TRUE;
           end;
           efBCC.Visible := FALSE;
           lblBCC.Visible := FALSE;
           pnlBCC.Visible := FALSE;
       end;
       npForward..npForwardReply:
       begin
           NotepadType := wfForward;
           ctlForward.Visible := TRUE;
           mnNotepadSend.Visible := TRUE;
           mnNotepadEncrypt.Enabled := TRUE;
           m_sSourceFileName := '';
           mnNotepadAttachFiles.Enabled := TRUE;
           mnNotepadAttachFiles.Visible := TRUE;
           mnNotepadBCC.Visible := TRUE;
           mnNotepadCC.Visible := TRUE;
           mnNotepadSaveDraft.Visible := TRUE;
           mnNotepadSaveAs.Visible := TRUE;
           mnNotepadSaveDraft.Enabled := TRUE;
           mnNotepadSaveAs.Enabled := TRUE;
           efCC.Visible := FALSE;
           lblCC.Visible := FALSE;
           pnlCC.Visible := FALSE;
           efBCC.Visible := FALSE;
           lblBCC.Visible := FALSE;
           pnlBCC.Visible := FALSE;

       end;
   end;

   ReAdjustSubTop;
   Update;
end;

procedure TwndNotepad.ForwardMail;
begin
   mnNotepadForwardClick(Nil);
end;

procedure TwndNotepad.ReplyMail;
begin
   mnNotepadReplyClick(Nil);
end;

procedure TwndNotepad.EncryptMsg;
var
   dlgSelect : TdlgSelectDecrypt;
begin
   dlgSelect := TdlgSelectDecrypt.Create(Self);
   CenterFormOverParent(Self, dlgSelect);
   with dlgSelect do
   begin
       SuggestedItem := 0;
       if DisplayModal = mrOK then
       begin
           case SelectedItem of
               0: EncryptMsgPgp;
               1: EncryptMsgCeaser;
               2: EncryptMsgMD5;
               3: exit;
           end;
       end;
       free;
   end;
end;

procedure TwndNotepad.DecryptMsg;
var
   dlgSelect : TdlgSelectDecrypt;
   sLine : String;
begin
   dlgSelect := TdlgSelectDecrypt.Create(Self);
   CenterFormOverParent(Self, dlgSelect);
   with dlgSelect do
   begin
       sLine := efMsg.Lines[0];
       sLine := sLine + efMsg.Lines[1];
       sLine := sLine + efMsg.Lines[2];
       sLine := sLine + efMsg.Lines[3];

       if Pos('BEGIN PGP MESSAGE', sLine) > 0 then
           SuggestedItem := 0
       else
           SuggestedItem := 1;

       Direction := 1;

       if DisplayModal = mrOK then
       begin
           case SelectedItem of
               0: DecryptMsgPgp;
               1: DecryptMsgCeaser;
               2: DecryptMsgMD5;
               3: exit;
           end;
       end;
       free;
   end;
end;

procedure TwndNotepad.DecryptMsgMD5;
var
  dlgMD5Handler: TdlgMD5Handler;
  oMD5 : TMD5Encrypt;
  sourceStr, passPhraseStr : String;
  lineCount : Integer;
begin
   dlgMD5Handler := TdlgMD5Handler.Create(Self);
   dlgMD5Handler.Direction := 1;
   if dlgMD5Handler.ShowModal = mrOK then
   begin
       passPhraseStr := dlgMD5Handler.efEncryptPhase.Text;

// ===================================================================================================
       g_bLogEncryption := true;
// ===================================================================================================

       oMD5 := TMD5Encrypt.Create();

       if Not Assigned(oMD5) then
          raise Exception.Create('oMsg5 is not assigned in DecryptMsgMD5');

       with oMD5 do
       begin
           efMsg.WordWrap := false;
           for lineCount := 0 to efMsg.Lines.Count do
               sourceStr := sourceStr + efMsg.Lines[lineCount];

           EncryptedString := efMsg.Lines.Text;
           PassPhrase := passPhraseStr;
           Decrypt;
           efMsg.Lines.Text := SourceString;
           efMsg.WordWrap := true;
           free;

       end;
   end;

end;

procedure TwndNotepad.DecryptMsgPgp;
var
   oPGP : TPGPEncrypt;
begin
    efMsg.Lines.SaveToFile('.\pgp.asc');
    oPGP := TPGPEncrypt.Create;
    if Not Assigned(oPGP) then
       raise Exception.Create('oPGP is not assigned in DecryptMsgPGP');
    try
       oPGP.IdToSendTo := 'na';
       oPGP.Decrypt
    finally
       try
           efMsg.Lines.LoadFromFile('.\pgp');
       except
       end;
    end;
    oPGP.Free;
    DeleteFile('.\pgp.asc');
    DeleteFile('.\pgp');
end;

procedure TwndNotepad.DecryptMsgCeaser;
var
   dlgEncrypt : TdlgEncryptCeaser;
begin
   efMsg.Lines.SaveToFile('.\ceaser.asc');
   dlgEncrypt := TdlgEncryptCeaser.Create(Self);
   dlgEncrypt.Direction := 1;
   if dlgEncrypt.DisplayModal = mrOK then
   begin
       efMsg.Lines.LoadFromFile('.\ceaser.txt');
   end;
   dlgEncrypt.Free;
   DeleteFile('.\ceaser.asc');
   DeleteFile('.\ceaser.txt');
end;

procedure TwndNotepad.EncryptMsgMD5;
var
  dlgMD5Handler: TdlgMD5Handler;
  sourceStr, passPhraseStr : String;
  oMD5 : TMD5Encrypt;
  lineCount : Integer;

begin
   dlgMD5Handler := TdlgMD5Handler.Create(Self);
   dlgMD5Handler.Direction := 0;
   if dlgMD5Handler.ShowModal = mrOK then
   begin
// ===================================================================================================
       g_bLogEncryption := true;
// ===================================================================================================

       passPhraseStr := dlgMD5Handler.efEncryptPhase.Text;
       oMD5 := TMD5Encrypt.Create();
       if Not Assigned(oMD5) then
          raise Exception.Create('oMsg5 is not assigned in EncryptMsgMD5');

       with oMD5 do
       begin

           efMsg.WordWrap := false;
           for lineCount := 0 to efMsg.Lines.Count do
               sourceStr := sourceStr + efMsg.Lines[lineCount];

           SourceString := sourceStr;
           PassPhrase := passPhraseStr;
           Encrypt;
           efMsg.Lines.Text := EncryptedString;
           efMsg.WordWrap := true;
           free;
       end;
   end;

end;

procedure TwndNotepad.EncryptMsgPgp;
var
   dlgEncrypt : TdlgPgpEncrypt;
begin
   inherited;
   efMsg.Lines.SaveToFile('.\pgp.txt');
   dlgEncrypt := TdlgPgpEncrypt.Create(Self);
   dlgEncrypt.Direction := 0;
   if dlgEncrypt.DisplayModal = mrOK then
   begin
       efMsg.Lines.LoadFromFile('.\pgp.asc');
   end;
   dlgEncrypt.Free;
   DeleteFile('.\pgp.asc');
   DeleteFile('.\pgp.txt');

end;

procedure TwndNotepad.EncryptMsgCeaser;
var
   dlgEncrypt : TdlgEncryptCeaser;
begin
   efMsg.Lines.SaveToFile('.\ceaser.txt');
   dlgEncrypt := TdlgEncryptCeaser.Create(Self);
   dlgEncrypt.Direction := 0;
   if dlgEncrypt.DisplayModal = mrOK then
   begin
       efMsg.Lines.LoadFromFile('.\ceaser.asc');
   end;
   dlgEncrypt.Free;
   DeleteFile('.\ceaser.asc');
   DeleteFile('.\ceaser.txt');
end;

{
  ==================================================================
  Form Events
  ==================================================================
}

constructor TwndNotepad.CreateWithType(AOwner: TComponent; nNotepadType : TNotepadOptions);
begin
   m_nFolderOption := nNotepadType;
   inherited Create(AOwner);
end;

constructor TwndNotepad.Create(AOwner: TComponent);
begin
   m_nFolderOption := npSend;
   inherited Create(AOwner);
end;

procedure TwndNotepad.FormCreate(Sender: TObject);
begin
   m_oMsg := NIL;

   inherited;

   m_nCCTop := efCC.Top;
   m_nBCCTop := efBCC.Top;
   m_nSubjTop := efSubj.Top;
   m_nAttachTop := efAttach.Top;

   SetupNotepadOptions;

   // hmmm...why do this (below)
   Self.Width := 620;
   try
       if cbFrom.ItemIndex > -1 then
           efTo.SetFocus;
   except
   end;
end;

procedure TwndNotepad.mnNotepadSendClick(Sender: TObject);
begin
   SavePost;
end;

procedure TwndNotepad.mnEncryptPGPClick(Sender: TObject);
begin
   EncryptMsgPgp;
end;

procedure TwndNotepad.mnNotepadSaveCloseClick(Sender: TObject);
begin
   inherited;

   // TODO...save is changing to save in draft...there
   // will be a new function that puts it in the outbound folder
   // eval in conjuction to function mnNotepadSaveDraftClick
   mnNotepadSendClick(Sender);
   Close;
end;

procedure TwndNotepad.mnNotepadSaveDraftClick(Sender: TObject);
begin
  inherited;
   // TODO...save is changing to save in draft...there

   // will be a new function that puts it in the outbound folder
end;

procedure TwndNotepad.mnNotepadSaveAsClick(Sender: TObject);
begin
  inherited;
//
end;

procedure TwndNotepad.efMsgChange(Sender: TObject);
begin
   inherited;
   if efMsg.Lines.Count > 25 then
       efMsg.ScrollBars := ssVertical
   else
       efMsg.ScrollBars := ssNone;
end;

procedure TwndNotepad.mnNotepadForwardClick(Sender: TObject);
var
   nCount : Integer;
begin
   inherited;
   // from should be in the cbFrom list of entries
   // and to should be blank

   m_nFolderOption := npForward;
   SetupNotepadOptions;

   // TODO...move m_oMsg to Outbound/Draft...
   // reference the m_oMsg rather than the fields

   // its safe to assume we are reading a message
   efTo.Text := '';
   efCC.Text := '';
   efBCC.Text := '';
   if 0 = Pos('FWD:', Uppercase(efReadSubj.Text)) then
       efSubj.Text := 'FWD: ' + efReadSubj.Text;

   efDate.Text := DateToStr(Now);
   for nCount := 0 to cbFrom.Items.Count - 1 do
   begin
       if cbFrom.Items[nCount] = efReadTo.Text then
       begin
           cbFrom.ItemIndex := nCount;
           break;
       end;
   end;

   efMsg.Lines.Insert(0, 'On' + efReadDate.Text + ' ' + efReadFrom.Text + ' wrote:');
   efMsg.Lines.Insert(0, '--------------------------------------------------------');
   efMsg.Lines.Insert(0, '');
   efMsg.Lines.Insert(0, '');
   efMsg.Lines.Insert(0, '');
   wndMaxMain.ChildWndReceivedFocus(m_nType);

   ctlEditPanel.Visible := TRUE;
   ctlReadPanel.Visible := FALSE;

end;

procedure TwndNotepad.mnNotepadReplyClick(Sender: TObject);
var
   nCount : Integer;
begin
  inherited;
  // from should be in the cbFrom list of entries
  // and to should be the original from...
   m_nFolderOption := npForwardReply;
   SetupNotepadOptions;

   // TODO...move m_oMsg to Outbound/Draft...
   // reference the m_oMsg rather than the fields

   efTo.Text := efReadFrom.Text;
   efCC.Text := '';
   efBCC.Text := '';
   if 0 = Pos('RE:', Uppercase(efReadSubj.Text)) then
       efSubj.Text := 'RE: ' + efReadSubj.Text;

   efDate.Text := DateToStr(Now);
   for nCount := 0 to cbFrom.Items.Count - 1 do
   begin
       if cbFrom.Items[nCount] = efReadTo.Text then
       begin
           cbFrom.ItemIndex := nCount;
           break;
       end;
   end;

   efMsg.Lines.Insert(0, 'On' + efReadDate.Text + ' ' + efReadFrom.Text + ' wrote:');
   efMsg.Lines.Insert(0, '--------------------------------------------------------');
   efMsg.Lines.Insert(0, '');
   efMsg.Lines.Insert(0, '');
   efMsg.Lines.Insert(0, '');
   wndMaxMain.ChildWndReceivedFocus(m_nType);

   ctlEditPanel.Visible := TRUE;
   ctlReadPanel.Visible := FALSE;

   // 05.18.02
   // remove all attachments, hide attachment panel
   DeleteAllAttachments();

end;

procedure TwndNotepad.mnNotepadReplyAllClick(Sender: TObject);
var
   nCount : Integer;
begin
  inherited;
  // from should be in the cbFrom list of entries
  // and to should be the original from...
   m_nFolderOption := npReplyAll;
   SetupNotepadOptions;

   // TODO...move m_oMsg to Outbound/Draft...
   // reference the m_oMsg rather than the fields

   efTo.Text := efReadFrom.Text;
   efCC.Text := efReadCC.Text;
   efBCC.Text := '';
   if 0 = Pos('RE:', Uppercase(efReadSubj.Text)) then
       efSubj.Text := 'RE: ' + efReadSubj.Text;

   efDate.Text := DateToStr(Now);
   for nCount := 0 to cbFrom.Items.Count - 1 do
   begin
       if cbFrom.Items[nCount] = efReadTo.Text then
       begin
           cbFrom.ItemIndex := nCount;
           break;
       end;
   end;

   efMsg.Lines.Insert(0, 'On' + efReadDate.Text + ' ' + efReadFrom.Text + ' wrote:');
   efMsg.Lines.Insert(0, '--------------------------------------------------------');
   efMsg.Lines.Insert(0, '');
   efMsg.Lines.Insert(0, '');
   efMsg.Lines.Insert(0, '');
   wndMaxMain.ChildWndReceivedFocus(m_nType);

   ctlEditPanel.Visible := TRUE;
   ctlReadPanel.Visible := FALSE;

end;


procedure TwndNotepad.mnEncryptCeasarClick(Sender: TObject);
begin
   inherited;
   EncryptMsgCeaser;
end;

procedure TwndNotepad.mnNotepadDescryptCeasarClick(Sender: TObject);
begin
   inherited;
   DecryptMsgCeaser;
end;

procedure TwndNotepad.efMsgKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (Key = VK_TAB) and
      (Shift = [ssShift]) then
   begin
      Key := 0;
      efSubj.SetFocus;
   end;

   if (Key <> VK_TAB) and
      (m_nFolderOption <> npRead) then
       m_bChanged := TRUE;

end;

procedure TwndNotepad.mnNotepadAttachFilesClick(Sender: TObject);
begin
   with ctlAttachFile do
   begin
       if Execute = TRUE then
           CreateAttachmentEntry(FileName);
   end;
end;

procedure TwndNotepad.mnEncryptMD5Click(Sender: TObject);
begin
   EncryptMsgMD5;
end;

procedure TwndNotepad.mnNotepadDescryptMD5Click(Sender: TObject);
begin
   DecryptMsgMD5;
end;

procedure TwndNotepad.mnNotepadCCClick(Sender: TObject);
begin
   if TRUE = mnNotepadCC.Checked then
   begin
       mnNotepadCC.Checked := FALSE;
       mnPopupCC.Checked := FALSE;
       efCC.Visible := FALSE;
       efCC.Text := '';
       lblCC.Visible := FALSE;
       pnlCC.Visible := FALSE;
   end
   else
   begin
       mnNotepadCC.Checked := TRUE;
       mnPopupCC.Checked := TRUE;
       efCC.Visible := TRUE;
       lblCC.Visible := FALSE;
       pnlCC.Visible := TRUE;
   end;
   ReAdjustSubTop;
   Update;
end;

procedure TwndNotepad.mnNotepadBCCClick(Sender: TObject);
begin
   if TRUE = mnNotepadBCC.Checked then
   begin
       mnNotepadBCC.Checked := FALSE;
       mnPopupBCC.Checked := FALSE;
       efBCC.Visible := FALSE;
       efBCC.Text := '';
       lblBCC.Visible := FALSE;
       pnlBCC.Visible := FALSE;
   end
   else
   begin
       mnNotepadBCC.Checked := TRUE;
       mnPopupBCC.Checked := TRUE;
       efBCC.Visible := TRUE;
       lblBCC.Visible := FALSE;
       pnlBCC.Visible := TRUE;
   end;

   ReAdjustSubTop;
   Update;
end;

procedure TwndNotepad.addrButtonsClick(Sender: TObject);
var
    dlgEmail : TdlgAddEmailAddress;
begin
  dlgEmail := TdlgAddEmailAddress.Create(Self);
  if Not Assigned(dlgEmail) then
     raise Exception.Create('dlgEmail not assigned in TwndNotepad.addrButtonsClick');

  wndMaxMain.CenterFormOverSelf(dlgEmail);

  dlgEmail.ToField := Trim(efTo.Text);
  dlgEmail.CCField := Trim(efCC.Text);
  dlgEmail.BCCField := Trim(efBCC.Text);

  if mrOK = dlgEmail.ShowModal() then
  begin
      efTo.Text := dlgEmail.ToField;
      efCC.Text := dlgEmail.CCField;
      efBCC.Text := dlgEmail.BCCField;

      // tricking toggles to hide/show field
      if 0 < Length(Trim(efCC.Text)) then
          mnNotepadCC.Checked := FALSE
      else
          mnNotepadCC.Checked := TRUE;

      mnNotepadCCClick(Sender);


      if 0 < Length(Trim(efBCC.Text)) then
          mnNotepadBCC.Checked := FALSE
      else
          mnNotepadBCC.Checked := TRUE;

      mnNotepadBCCClick(Sender);


  end;

  dlgEmail.Free();
end;

procedure TwndNotepad.addrButtonsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//  inherited;
  TPanel(Sender).BevelOuter := bvLowered;
end;

procedure TwndNotepad.addrButtonsMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//  inherited;
  TPanel(Sender).BevelOuter := bvRaised;
end;

procedure TwndNotepad.mnAttachPopupClearAllClick(Sender: TObject);
begin

   if mrNo = MessageDlg('Are you sure you want to remove all attachments from this email?', mtConfirmation, [mbYes, mbNo], 0) then
       exit;

   DeleteAllAttachments();
end;

procedure TwndNotepad.mnAttachPopDeleteClick(Sender: TObject);
begin
   if NIL = lvAttachments.ItemFocused then
   begin
       MessageDlg('Please select an attachment to delete', mtInformation, [mbOK], 0);
       exit;
   end;

   if mrNo = MessageDlg('Are you sure you want to remove attached file ' + lvAttachments.ItemFocused.Caption + '?', mtConfirmation, [mbYes, mbNo], 0) then
       exit;

   DeleteAttachment(lvAttachments.ItemFocused.Index);

end;

procedure TwndNotepad.mnAttachPopupAddClick(Sender: TObject);
begin
//  inherited;
   mnNotepadAttachFilesClick(Sender);
end;

procedure TwndNotepad.mnAttachSaveAsClick(Sender: TObject);
begin
// TODO
end;

procedure TwndNotepad.DeleteAttachment(nIndex : Integer);
begin
   lvAttachments.Items.Delete(nIndex);

   if 0 = lvAttachments.Items.Count then
   begin
       pnlAttachments.Visible := FALSE;
       spltAttachments.Visible := FALSE;
   end;

end;

procedure TwndNotepad.DeleteAllAttachments();
var
   nCount : Integer;
begin
   for nCount := 1 to lvAttachments.Items.Count do
   begin
       DeleteAttachment(0);
   end;

   efAttach.Text := '';
end;


end.
