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

unit outbound;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, OleCtrls, wndfolder, Menus, 
  Psock, NMsmtp, ImgList, email;

type
   EOutboundMsg = class(Exception)
   end;                             

type
  TwndOutbound = class(TwndFolder)
    ctlStartup: TTimer;
    pbNow: TButton;
    efSending: TEdit;
    txtAction: TLabel;
    pbSend: TButton;
    mnOutbound: TMainMenu;
    mnOutboundMenu: TMenuItem;
    mnOutSendNow: TMenuItem;
    N1: TMenuItem;
    mnOutEdit: TMenuItem;
    mnOutDelete: TMenuItem;
    ctlSMTP: TNMSMTP;
    mnOutPopUp: TPopupMenu;
    mnPopSendNow: TMenuItem;
    N2: TMenuItem;
    mnPopOpen: TMenuItem;
    mnPopDelete: TMenuItem;
    mnOutMove: TMenuItem;
    mnPopMove: TMenuItem;
    mnOutStopSendingMail: TMenuItem;
    mnPopPrint: TMenuItem;
    mnPopPreview: TMenuItem;

    procedure ParseAddressesToList(oList : TStringList; sRawList : String);
    procedure LoadAttachmentFromFile(oAttachmentList : TStringList; sAttachmentFileName : String);
    procedure EmailSend;
    // function EmailNoParam: Variant;

    procedure FormCreate(Sender: TObject);

    procedure pbNowClick(Sender: TObject);
    procedure ctlStartupTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mnOutSendNowClick(Sender: TObject);
    procedure ctlSMTPFailure(Sender: TObject);
    procedure ctlSMTPSuccess(Sender: TObject);
    procedure mnOutEditClick(Sender: TObject);
    procedure mnOutDeleteClick(Sender: TObject);
    procedure ctlSMTPConnectionFailed(Sender: TObject);
    procedure ctlSMTPAuthenticationFailed(var Handled: Boolean);
    procedure ctlSMTPInvalidHost(var Handled: Boolean);
    procedure OnMessageMove(Sender: TObject);
    procedure mnOutStopSendingMailClick(Sender: TObject);
    procedure ctlSMTPRecipientNotFound(Recipient: String);
    procedure mnPopPrintClick(Sender: TObject);
    procedure mnPopPreviewClick(Sender: TObject);
  private

    m_bSendingMsg : Boolean;
    m_bSendingError : Boolean;

  protected
    procedure MoveMessageToFolder(nMsgIndex, nNewFolderId : Integer);

  public
    { Public declarations }
    procedure AddMessage(aMsg : TOutboundEmail);
    procedure AddMsgToListView(aMsg : TBaseEmail); override;
    procedure SetupMenuOptions;
    function CanCloseNow: Boolean; override;
  published

  end;

var
  wndOutbound: TwndOutbound;


implementation

uses
   displmsg, basfoldr, folder, alias, eglobal, wndsock, dispyn;


{$R *.DFM}

{
===============================================================

===============================================================
}
{
===============================================================

===============================================================
}
procedure TwndOutbound.SetupMenuOptions;
var
   bEnabled : Boolean;
begin
     if 0 < ctlMessages.Items.Count then
        bEnabled := TRUE
     else
        bEnabled := FALSE;

    mnOutSendNow.Enabled := bEnabled;
    mnOutEdit.Enabled := bEnabled;
    mnOutDelete.Enabled := bEnabled;
    mnOutMove.Enabled := bEnabled;
    mnPopSendNow.Enabled := bEnabled;
    mnPopOpen.Enabled := bEnabled;
    mnPopDelete.Enabled := bEnabled;
    mnPopMove.Enabled := bEnabled;

end;

procedure TwndOutbound.AddMessage(aMsg : TOutboundEmail);
begin
   if Not Assigned(aMsg) then
      raise EFolderException.Create('aMsg not assigned in TwndOutbound.AddMessage');

   AddMsgToListView(TBaseEmail(aMsg));
end;

procedure TwndOutbound.AddMsgToListView(aMsg : TBaseEmail);
var
   oItem : TListItem;
begin
   if Not Assigned(aMsg) then
      raise EFolderException.Create('aMsg not assigned in TwndOutbound.AddMsgToListView');

   with ctlMessages.Items do
   begin
       oItem := Add;
   end;
   if Not Assigned(oItem) then
      raise EFolderException.Create('oItem not assigned in TwndOutbound.AddMsgToListView');

   with oItem do
   begin
       Caption := aMsg.SendTo;
       SubItems.Add(aMsg.Subject);                 // 0
       SubItems.Add(aMsg.From);                    // 1
       SubItems.Add(aMsg.MessageId);               // 2
   end;

   IconForMessages;
   SetupMenuOptions;
end;

{
===============================================================

===============================================================
}
procedure TwndOutbound.FormCreate(Sender: TObject);
var
   oItem : TListItem;
   nCount : Integer;
begin
   inherited;
   m_bSendingMsg := FALSE;

   FolderId := g_cnToSendFolder;

   if Not Assigned(g_oFolders[m_nFolderId]) then
      raise EFolderException.Create('g_oFolders[m_nFolderId] not assigned in TwndOutbound.FormCreate');

   g_oFolders[m_nFolderId].SetDisplayForm := Self;

   for nCount := 0 to g_oFolders[m_nFolderId].Count - 1 do
   begin
       with ctlMessages.Items do
       begin
           oItem := Add;
       end;
       with oItem do
       begin
           g_oFolders[m_nFolderId].ActiveIndex := nCount;
           Caption := g_oFolders[m_nFolderId].GetTo;
           SubItems.Add(g_oFolders[m_nFolderId].GetSubject);
           SubItems.Add(g_oFolders[m_nFolderId].GetFrom);
           SubItems.Add(g_oFolders[m_nFolderId].GetMessageId);
       end;
   end;
   SetupMenuOptions;
end;

procedure TwndOutbound.pbNowClick(Sender: TObject);
begin
   EmailSend;
   SetupMenuOptions;
end;


procedure TwndOutbound.ctlStartupTimer(Sender: TObject);
var
   oIcon : TIcon;
begin
   if not m_bSendingMsg then
   begin
       if 0 < ctlMessages.Items.Count then
           EmailSend
       else
       begin
           ctlStartup.Enabled := FALSE;
           oIcon := TIcon.Create;
           ctlIcons.GetIcon(g_cnNoMail, oIcon);
           Self.Icon := oIcon;
           oIcon.free;
       end;
   end;
end;

procedure TwndOutbound.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   if TRUE = m_bSendingMsg then
   begin
       Action := caNone;
       exit;
   end;

   Action := caFree;
   inherited;
   wndOutbound := Nil;
end;

procedure TwndOutbound.mnOutSendNowClick(Sender: TObject);
begin
   pbNowClick(Sender);
end;

procedure TwndOutbound.ctlSMTPFailure(Sender: TObject);
begin
   m_bSendingError := TRUE;
end;

procedure TwndOutbound.ctlSMTPRecipientNotFound(Recipient: String);
begin
  m_bSendingError := TRUE;
end;

procedure TwndOutbound.ctlSMTPSuccess(Sender: TObject);
begin
   m_bSendingError := FALSE;
end;

procedure TwndOutbound.mnOutEditClick(Sender: TObject);
begin
   OpenSelectedMsg;
end;


{
===============================================================

===============================================================
}
procedure TwndOutbound.MoveMessageToFolder(nMsgIndex, nNewFolderId : Integer);
begin

    if Not Assigned(g_oFolders[m_nFolderId]) then
        raise EFolderException.Create('g_oFolders[m_nFolderId] not assigned in TwndOutbound.MoveMessageToFolder');

    if Not Assigned(g_oFolders[nNewFolderId]) then
        raise EFolderException.Create('g_oFolders[nNewFolder] not assigned in TwndOutbound.MoveMessageToFolder');

    g_oFolders[nNewFolderId].AddMsgStatusAttached(g_oFolders[m_nFolderId].Strings[nMsgIndex]);
    g_oFolders[m_nFolderId].Delete(nMsgIndex);
    ctlMessages.Items.Delete(nMsgIndex);

end;

{
===============================================================

===============================================================
}
procedure TwndOutbound.LoadAttachmentFromFile(oAttachmentList : TStringList; sAttachmentFileName : String);
var
   oListOfAttachments : TStringList;
   nCount : Integer;
   sFilePath : String;
begin
   if Not Assigned(oAttachmentList) then
      raise EFolderException.Create('oAttachmentList not assigned in TwndOutbound.LoadAttachmentFromFile');

   oListOfAttachments := TStringList.Create();

   if Not Assigned(oListOfAttachments) then
      raise EFolderException.Create('oListOfAttachments not assigned in TwndOutbound.LoadAttachmentFromFile');
   

   oListOfAttachments.LoadFromFile(sAttachmentFileName);
   oAttachmentList.Clear;
   for nCount := 0 to oListOfAttachments.Count - 1 do
   begin
       sFilePath := '';
       sFilePath := ExtractFilePath(Trim(oListOfAttachments.Strings[nCount]));
       if 0 = Length(Trim(sFilePath)) then
           oAttachmentList.Add(g_oDirectories.AttachmentPath + Trim(oListOfAttachments.Strings[nCount]))
       else
           oAttachmentList.Add(Trim(oListOfAttachments.Strings[nCount]));
   end;

   oListOfAttachments.Free;
end;

{
===============================================================

===============================================================
}
procedure TwndOutbound.ParseAddressesToList(oList : TStringList; sRawList : String);
var
   oSendMail : TMailProperties;
   nPos : Integer;
   sTmpTo : String;
begin
   if Not Assigned(oList) then
      raise EFolderException.Create('oList not assigned in TwndOutbound.ParseAddressesToList');

   if Not Assigned(g_wndWinSock) then
      raise EFolderException.Create('g_wndWinSock not assigned in TwndOutbound.ParseAddressesToList');

   oList.Clear;
   oSendMail := g_wndWinSock.SendMailProperties;
   repeat
       nPos := Pos(',', sRawList);
       if 0 = nPos then
           nPos := Pos(';', sRawList);

       if nPos > 0 then
       begin
           sTmpTo := Copy(sRawList, 1, nPos - 1);
           sRawList := Copy(sRawList, nPos + 1, Length(sRawList));
           if 0 < Length(Trim(sTmpTo)) then
               oList.Add(Trim(sTmpTo));
       end
       else
       begin
           if Length(sRawList) > 0 then
           begin
               sTmpTo := sRawList;
               if 0 < Length(Trim(sTmpTo)) then
                   oList.Add(Trim(sTmpTo));
           end;
       end;

       oSendMail.AccountName := sTmpTo;
       g_wndWinSock.SendMailProperties := oSendMail;

   until nPos <= 0;

end;

{
===============================================================

===============================================================
}
procedure TwndOutbound.EmailSend;
var
   nIndex, nMovedToDraftCount : Integer;
   nMsgIndexId, nEncodeType : Integer;
   sAppVersion, sWork : String;
   bLogOn : boolean;
   oItem : TListItem;
   oMsg : TOutboundEmail;
begin

   // here's how this works,
   // get the first message in the list and send it.
   // when done, enable the timer to call this function again

   // TODO....08.27.01 as part of attachments need to get from system settings
   // IE registry
   nEncodeType := 0;
   nMovedToDraftCount := 0;
   nMsgIndexId := -1;
   sAppVersion := getVerInfo();
   oMsg := NIL;

   if 0 = ctlMessages.Items.Count then
   begin
       pbNow.Enabled := TRUE;
       Exit;
   end;

   if SendMessage(Application.MainForm.Handle, WM_HANDLE_LOGIN, Integer(paOnCheck), 0) = mrCancel then
   begin
       Application.MessageBox('Emailmax requires a password to send mail (applies to all accounts)', 'Cannot send mail', MB_ICONSTOP);
       exit;
   end;

   if Not Assigned(g_oFolders[m_nFolderId]) then
      raise EFolderException.Create('g_oFolders[m_nFolderId] not assigned in TwndOutbound.EmailSend');

   if Not Assigned(g_oLogFile) then
      raise Exception.Create('g_oLogFile not assigned in TwndOutbound.EmailSend');

   if Not Assigned(g_oEmailAddr) then
      raise Exception.Create('g_oEmailAddr not assigned in TwndOutbound.EmailSend');

   if Not Assigned(g_wndWinSock) then
      raise Exception.Create('g_wndWinSock not assigned in TwndOutbound.EmailSend');

   oItem := ctlMessages.Items[0];

   if Not Assigned(oItem) then
      raise Exception.Create('oItem not assigned in TwndOutbound.EmailSend');

   nMsgIndexId := oItem.Index;
   g_oFolders[m_nFolderId].ActiveIndex := nMsgIndexId;
   oMsg := TOutboundEmail.Create();
   if Not Assigned(oMsg) then
       raise Exception.Create('oMsg was not Assigned in TwndOutbound.EmailSend');

   g_oFolders[m_nFolderId].GetAsEmailObject(TBaseEmail(oMsg));


   if FALSE = oMsg.IsValid then
       raise Exception.Create('oMsg.IsValid is FALSE in TwndOutbound.EmailSend');

   ctlStartup.Enabled := FALSE;
   pbNow.Enabled := FALSE;

   m_bSendingError := FALSE;
   efSending.Text := 'Sending email to ' + oItem.Caption;

   with ctlSmtp do
   begin

       // Note: set ctlSmtp.ReportLevel to 16 for debug and trace messages
       // default is 1 as of 07.18.02

       m_bSendingMsg := TRUE;
       nIndex := g_oEmailAddr.EmailAliasIndex(oMsg.From, g_cnServerSMTP);
       g_oEmailAddr.ActiveIndex := nIndex;
       Host := g_oEmailAddr.GetServerName;
       if 0 < Length(Trim(g_oEmailAddr.GetUserId)) then
           UserId := Trim(g_oEmailAddr.GetUserId);

       with PostMessage do
       begin

           // 05.23.02  access violations are occurring this code...
           g_wndWinSock.SendingEmail := TRUE;

           FromAddress := oMsg.From;              // g_oFolders[m_nFolderId].GetFrom;
           Subject := oMsg.Subject;               // g_oFolders[m_nFolderId].GetSubject;
           ReplyTo := oMsg.From;                  // g_oFolders[m_nFolderId].GetFrom;
           LocalProgram := g_csApplicationTitle;
           Body.LoadFromFile(oMsg.MsgTextFileName);

           ParseAddressesToList(ToAddress, oMsg.SendTo);
           ParseAddressesToList(ToCarbonCopy, oMsg.CC);
           ParseAddressesToList(ToBlindCarbonCopy, oMsg.BCC);

           Attachments.Clear;
           if FileExists(oMsg.AttachmentListFileName) then
           begin
               if 0 = nEncodeType then
                   EncodeType := uuMime
               else
                   EncodeType := uuCode;
               try
                   LoadAttachmentFromFile(Attachments, oMsg.AttachmentListFileName);
               except
                   // 8.20.01 failure occurs because there is no path
                   // in the attachment file. PostMessage is probably
                   // looking in the working directory as a result.
                   // the solution is to read the attachment list file (create a TStringList),
                   // add the each item into Attachments with the correct
                   // path prepended...fix implemented in procedure
                   // LoadAttachmentFromFile
                   Attachments.Clear;
               end;
           end;
       end;

       FinalHeader.Values['X-Mailer'] := 'Emailmax2k V' + sAppVersion;
       m_bSendingMsg := TRUE;
       Port := 25;
       try
           try
               Connect;
           finally
               try

                   SendMail;

                   // 05.23.02 moved code to here
                   MoveMessageToFolder(nMsgIndexId, g_cnOutFolder);
                   m_bSendingMsg := FALSE;

               except
                   on e: Exception do
                   begin
                       bLogOn := g_oLogFile.LoggingOn;
                       g_oLogFile.LoggingOn := TRUE;

                       if TRUE = m_bSendingError then
                       begin
                          if Assigned(oMsg) then
                          begin

                              sWork := g_csCRLF + '------------------>' +
                                       'Error Message Message' + g_csCRLF +
                                       'TO: "' + oMsg.SendTo + '"' + g_csCRLF +
                                       'CC: "' + oMsg.CC + '"' +  g_csCRLF +
                                       'BCC: "' + oMsg.BCC + '"' +  g_csCRLF +
                                       'From: "' + oMsg.From + '"' +  g_csCRLF +
                                       'Subject: "' + oMsg.Subject + '"' +  g_csCRLF +
                                       'Error was: ';
                           end
                           else
                              sWork := 'oMsg was not assigned. Exception was ';

                       end
                       else
                       begin
                          sWork := 'Exception in sending an email, does not seem to be email related.  Exception ';
                       end;

                       g_oLogFile.Write(sWork + e.Message);
                       g_oLogFile.Flushfile();
                       g_oLogFile.LoggingOn := bLogOn;

                       // 05.23.02...no matter what the exception, we're going to move
                       // the current email to the draft folder.
                       MoveMessageToFolder(nMsgIndexId, g_cnDraftFolder);
                       Inc(nMovedToDraftCount);

                   end;
               end;

               Disconnect;
           end;
       except
           on e: Exception do
           begin
               bLogOn := g_oLogFile.LoggingOn;
               g_oLogFile.LoggingOn := TRUE;

               if Assigned(oMsg) then
               begin

                   sWork := g_csCRLF + '------------------>' +
                            'Error Message Message' + g_csCRLF +
                            'TO: "' + oMsg.SendTo + '"' + g_csCRLF +
                            'CC: "' + oMsg.CC + '"' +  g_csCRLF +
                            'BCC: "' + oMsg.BCC + '"' +  g_csCRLF +
                            'From: "' + oMsg.From + '"' +  g_csCRLF +
                            'Subject: "' + oMsg.Subject + '"' +  g_csCRLF +
                            'Error was: ';
               end
               else
                   sWork := 'oMsg was not assigned. Exception was ';
                        
               g_oLogFile.Write(sWork + e.Message);
               g_oLogFile.Flushfile;
               g_oLogFile.LoggingOn := bLogOn
           end;
       end;

       g_wndWinSock.SendingEmail := FALSE;
       m_bSendingMsg := FALSE;
   end;


   if Assigned(oMsg) then
   begin
       oMsg.Free;
       oMsg := NIL;
   end;

   if 0 < nMovedToDraftCount then
   begin
       MessageDlg('Errors were encountered when sending 1 or more emails.  These emails are now in the draft folder.', mtWarning, [mbOK], 0);
   end;

   ctlStartup.Enabled := TRUE;
   pbNow.Enabled := TRUE;
   efSending.Text := 'Idle';
   SetupMenuOptions;
end;

procedure TwndOutbound.mnOutDeleteClick(Sender: TObject);
begin
   MoveToTrash;
   SetupMenuOptions;
end;

procedure TwndOutbound.ctlSMTPConnectionFailed(Sender: TObject);
var
   dlgConnect : TdlgDisplayMessage;
begin
   dlgConnect := TdlgDisplayMessage.Create(Self);
   with dlgConnect do
   begin
       MessageType := dmtWarn;
       DialogTitle := 'Connection Error';
       NoticeText := 'Unable to connect.';
       m_oDetailItems.Add(g_csApplicationTitle + ' was unable to connect to the SMTP server to send');
       m_oDetailItems.Add('your email.  This could be caused by several things:');
       m_oDetailItems.Add('1) You did not setup the account correctly');
       m_oDetailItems.Add('2) Your PC is not properly connected to the internet');
       m_oDetailItems.Add('3) The SMTP server is down');
       Display;
       Free;
   end;
end;

procedure TwndOutbound.ctlSMTPAuthenticationFailed(var Handled: Boolean);
var
   dlgConnect : TdlgDisplayMessage;
begin
   dlgConnect := TdlgDisplayMessage.Create(Self);
   with dlgConnect do
   begin
       MessageType := dmtWarn;
       DialogTitle := 'Connection Error';
       NoticeText := 'Unable to connect.';
       m_oDetailItems.Add(g_csApplicationTitle + ' was unable to receive authorization to the SMTP');
       m_oDetailItems.Add('server to send email.  This could be caused by several things:');
       m_oDetailItems.Add('1) You did not setup the account correctly.');
       m_oDetailItems.Add('2) Your PC is not properly connected to the internet.');
       m_oDetailItems.Add('2) You are required to supply a User Id for this account.');
       Display;
       Free;
   end;
end;

procedure TwndOutbound.ctlSMTPInvalidHost(var Handled: Boolean);
var
   dlgConnect : TdlgDisplayMessage;
begin
   dlgConnect := TdlgDisplayMessage.Create(Self);
   with dlgConnect do
   begin
       MessageType := dmtWarn;
       DialogTitle := 'Connection Error';
       NoticeText := 'Unable to connect.';
       m_oDetailItems.Add(g_csApplicationTitle + ' was unable to connect to the SMTP server to send');
       m_oDetailItems.Add('your email.  This could be caused by several things:');
       m_oDetailItems.Add('1) You did not setup the account correctly');
       m_oDetailItems.Add('2) Your PC is not properly connected to the internet');
       m_oDetailItems.Add('3) The SMTP server is down');
       Display;
       Free;
   end;
end;

procedure TwndOutbound.OnMessageMove(Sender: TObject);
begin
  MoveToAnotherFolder;
  SetupMenuOptions;
end;

procedure TwndOutbound.mnOutStopSendingMailClick(Sender: TObject);
begin
   ctlSmtp.Abort;
   mnOutStopSendingMail.Enabled := FALSE;
end;

function TwndOutbound.CanCloseNow: Boolean;
// var
//   dlgConfirmClose : TdlgDisplayYesNo;
//   bCheckForClose : boolean;
begin
   CanCloseNow := TRUE;
   exit;

{
   CanCloseNow := FALSE;

   bCheckForClose := m_bSendingMsg;

   if FALSE = bCheckForClose then
   begin
       if 0 < ctlMessages.Items.Count then
           bCheckForClose := TRUE;
   end;


   if TRUE = bCheckForClose then
   begin
       CanCloseNow := FALSE;
       dlgConfirmClose := TdlgDisplayYesNo.Create(Self);
       CenterFormOverParent(Self, dlgConfirmClose);

       if TRUE = m_bSendingMsg then
       begin
           with dlgConfirmClose do
           begin
               YesOptionText := 'Stop Sending Mail and close.';
               NoOptionText := 'No, I have changed my mind.  Do not close.';
               MessageType := dmtQuestion;
               DialogTitle := 'Confirm Stop of Sending Mail';
               NoticeText := 'Confirm...';
               m_oDetailItems.Add('To close, sending mail will have to stop.');
               m_oDetailItems.Add('Do you want to stop sending mail and close.');
               if DisplayModal = mrYes then
               begin
                   mnOutStopSendingMailClick(Nil);
                   CanCloseNow := TRUE;
               end;
           end;
       end
       else
       begin
           with dlgConfirmClose do
           begin
               YesOptionText := 'Go ahead and close Emailmax2K.';
               NoOptionText := 'Do not close now.';
               MessageType := dmtQuestion;
               DialogTitle := 'Confirm Closing Emailmax2K';
               NoticeText := 'Confirm...';
               m_oDetailItems.Add('You have unsent messages.');
               m_oDetailItems.Add('Do you want to close Emailmax2K?');
               if DisplayModal = mrYes then
               begin
                   CanCloseNow := TRUE;
               end;
           end;
       end;
   end
   else
       CanCloseNow := TRUE;
}
end;

procedure TwndOutbound.mnPopPrintClick(Sender: TObject);
begin
  PrintMsg(false);
end;

procedure TwndOutbound.mnPopPreviewClick(Sender: TObject);
begin
  PreviewMsg;
end;

end.
