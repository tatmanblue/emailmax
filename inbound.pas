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

unit inbound;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  wndfolder, ComCtrls, ExtCtrls, StdCtrls, OleCtrls,
  NMpop3, Menus, NMsmtp, registry, ImgList, email, Psock, alias;

const  WM_CHECKMAIL = WM_USER + 201;

type
  TwndInbound = class(TwndFolder)
    txtAction: TLabel;
    pbNow: TButton;
    ctlPop: TNMPOP3;
    mnInbound: TMainMenu;
    mnReceived: TMenuItem;
    mnReceivedOpen: TMenuItem;
    mnReceivedDelete: TMenuItem;
    N1: TMenuItem;
    mnReceivedMoveTo: TMenuItem;
    mnPopup: TPopupMenu;
    mnPopupOpen: TMenuItem;
    mnPopDelete: TMenuItem;
    N2: TMenuItem;
    mnReceivedCheckMail: TMenuItem;
    mnReceivedStopMail: TMenuItem;
    mnPopMoveTo: TMenuItem;
    mnPopupPrint: TMenuItem;
    mnPopupPreview: TMenuItem;
    txtSending: TLabel;
    procedure pbNowClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ctlPopStatus(Sender: TComponent; Status: String);
    procedure mnReceivedOpenClick(Sender: TObject);
    procedure mnReceivedDeleteClick(Sender: TObject);
    procedure mnReceivedCheckMailClick(Sender: TObject);
    procedure ctlPopConnectionFailed(Sender: TObject);
    procedure ctlPopInvalidHost(var Handled: Boolean);
    procedure mnReceivedStopMailClick(Sender: TObject);
    procedure OnMoveMessage(Sender: TObject);
    procedure ctlPopAuthenticationFailed(var Handled: Boolean);
    procedure ctlPopAuthenticationNeeded(var Handled: Boolean);
    procedure ctlPopConnectionRequired(var Handled: Boolean);
    procedure mnPopupPrintClick(Sender: TObject);
    procedure mnPopupPreviewClick(Sender: TObject);
  private
    { Private declarations }
    m_bCheckingMail,
    m_bRecvError : Boolean;

    m_oEmailAddr : TEmailAddress;
    m_nCurrentAliasIndex : Integer;

    function AskForAccountAuthentication() : Boolean;

    // 05.15.02 CheckMain function is way too long...breaking it out a bit
    // five new functions
    function PreCheckMail() : Boolean;
    function PostCheckMail() : Boolean;
    function HaveAlreadyRetrievedMsg(sFrom, sSubject, sMsgId :String; nBytes : Integer; oSrcList, oNewList : TStringList) : Boolean;
    function DisplayErrorExceptionMsg(sError : String; fDisconnect: Boolean): Boolean;

    // function EmailNoParam: Variant;
  public
    { Public declarations }
    procedure CheckMail;
    procedure SetupMenuOptions;
    procedure HandleCheckMail(var oMsg : TMessage); Message WM_CHECKMAIL;
    function CanCloseNow: Boolean; override;
  end;

var
  wndInbound: TwndInbound;

implementation

uses
   displmsg, encryption, folder, notepad, mdimax, eglobal, wndsock,
   dispyn, filterobject, wndNewMailDisplay, dlgactst;

{$R *.DFM}


procedure TwndInbound.SetupMenuOptions;
var
   bEnabled : Boolean;
begin
     if ctlMessages.Items.Count > 0 then
        bEnabled := TRUE
     else
        bEnabled := FALSE;

    mnReceivedOpen.Enabled := bEnabled;
    mnReceivedDelete.Enabled := bEnabled;
    mnReceivedMoveTo.Enabled := bEnabled;
    mnPopupOpen.Enabled := bEnabled;
    mnPopMoveTo.Enabled := bEnabled;
    mnPopDelete.Enabled := bEnabled;
    mnReceivedCheckMail.Enabled := bEnabled;
    mnReceivedStopMail.Enabled := bEnabled;
end;

procedure TwndInbound.HandleCheckMail(var oMsg : TMessage);
begin
   CheckMail;
   SetupMenuOptions;
end;

function TwndInbound.AskForAccountAuthentication() : Boolean;
var
   dlgAuthenticate : TdlgEmailAcctSetup;
begin
   AskForAccountAuthentication := FALSE;
   
   if Not Assigned(m_oEmailAddr) then
      raise Exception.Create('m_oEmailAddr is not assigned in TwndInbound.AskForAccountAuthentication');

   if Not Assigned(g_oEmailAddr) then
      raise Exception.Create('g_oEmailAddr is not assigned in TwndInbound.AskForAccountAuthentication');

   AskForAccountAuthentication := FALSE;
   dlgAuthenticate := TdlgEmailAcctSetup.Create(Self);
   if Not Assigned(dlgAuthenticate) then
       raise Exception.Create('dlgAuthenticate not assigned in TwndInbound.AskForAccountAuthentication');

   CenterFormOverParent(Self, dlgAuthenticate);
   with dlgAuthenticate do
   begin
       DialogType := astPOPAuthentication;
       DialogAction := datEdit;

       Address := m_oEmailAddr.Address;
       Server := m_oEmailAddr.Server;
       UserId := m_oEmailAddr.UserId;
       Password := DecryptAliasPassword(m_oEmailAddr.Password);

       if mrOK = Display then
       begin
           if TRUE = Save then
           begin
               m_oEmailAddr.UserId := UserId;
               m_oEmailAddr.Password := EncryptAliasPassword(Password);
               g_oEmailAddr.UpdateEmailObj(m_oEmailAddr);
           end;

           ctlPop.UserId := UserId;
           ctlPop.Password := Password;
           AskForAccountAuthentication := TRUE;

           // TODO...07.01.02 is this disconnect/reconnect needed...?
           //    * if the code is not used, the user gets one chance to
           //      retry entering the information before a failure ocurrs
           //    * if the code IS USED, the call stack becomes recursive....
           {
           if TRUE = ctlPop.Connected then
           begin
               try
                   ctlPop.Disconnect;
               except
                   // dont care
               end;
           end;

           ctlPop.Connect;
           }
      end;
      Free;
   end;

end;

{
===============================================================

===============================================================
}
function TwndInbound.PreCheckMail() : Boolean;
var
   nCount, nStartIndex : Integer;

begin
   PreCheckMail := FALSE;

   m_bCheckingMail := TRUE;
   ctlPop.TimeOut := 15000;            // set to 15 secs

   mnReceivedCheckMail.Visible := FALSE;
   mnReceivedStopMail.Visible := TRUE;
   m_bRecvError := FALSE;
   mnReceivedCheckMail.Enabled := FALSE;
   if m_nCurrentAliasIndex = -1 then
       m_nCurrentAliasIndex := 0;

   if Not Assigned(g_oEmailAddr) then
      raise Exception.Create('g_oEmailAddr not assigned in TwndInbound.PreCheckMail');

   if Not Assigned(g_oFolders[g_cnTrashFolder]) then
       raise Exception.Create('g_oFolders[g_cnTrashFolder] not assigned in TwndInbound.PreCheckMail');

   if Not Assigned(g_oFolders[g_cnInFolder]) then
       raise Exception.Create('g_oFolders[g_cnInFolder] not assigned in TwndInbound.PreCheckMail');

   if mrCancel = SendMessage(Application.MainForm.Handle, WM_HANDLE_LOGIN, Integer(paOnCheck), 0) then
   begin
       Application.MessageBox('Emailmax requires a password to check mail (applies to all accounts)', 'Cannot check for mail', MB_ICONSTOP);
       m_bCheckingMail := FALSE;
       exit;
   end;

   m_oEmailAddr := TEmailAddress.Create;
   if Not Assigned(m_oEmailAddr) then
       raise Exception.Create('m_oEmailAddr not assigned in TwndInbound.PreCheckMail');

   nStartIndex := m_nCurrentAliasIndex + 1;
   for nCount := nStartIndex to g_oEmailAddr.Count do
   begin
       g_oEmailAddr.ActiveIndex := nCount - 1;
       if g_oEmailAddr.GetUseageType = g_cnUsageRecv then
       begin
           PreCheckMail := TRUE;
           // TODO 07.01.02 get an email address object and save it as part of the class
           // reference this whenever instead of relying on ActiveIndex
           m_nCurrentAliasIndex := nCount;
           g_oEmailAddr.GetEmailObject(nCount - 1, m_oEmailAddr);
           break;
       end;
   end;

end;

{
===============================================================

===============================================================
}
function TwndInbound.HaveAlreadyRetrievedMsg(sFrom, sSubject, sMsgId :String; nBytes : Integer; oSrcList, oNewList : TStringList) : Boolean;
var
   sMsgLine : String;
begin
    HaveAlreadyRetrievedMsg := FALSE;

    if Not Assigned(oSrcList) then
      raise Exception.Create('oSrcList not assigned in TwndInbound.HaveAlreadyRetrievedMsg');

    if Not Assigned(oNewList) then
      raise Exception.Create('oNewList not assigned in TwndInbound.HaveAlreadyRetrievedMsg');

    sMsgLine := Trim(sFrom) + '|';
    sMsgLine := sMsgLine + Trim(sSubject) + '|';
    sMsgLine := sMsgLine + Trim(sMsgId) + '|';

    // 07.18.02 Resolve
    // There is a temptation to take out the bytes in the check because we
    // seem to get variations in byte size for some messages (most large spam crap)
    // We get bytes from ctlPop.Summary...bastards...in otherwords the byte size from
    // ctpPop.Summary control is not reliable
    //
    // the problem is, sometimes there really are two identical messages in the
    // inbox and their byte sizes are different.  A long time ago byte was added to the
    // check for that reason.
    sMsgLine := sMsgLine + Trim(IntToStr(nBytes));

    // find the message on sMsgLines, if its in here
    // do not retrieve it....
    // copy line to oSaveLines
    if -1 < oSrcList.IndexOf(sMsgLine) then
        HaveAlreadyRetrievedMsg := TRUE;

    oNewList.Add(sMsgLine);

end;

{
===============================================================

===============================================================
}
procedure TwndInbound.CheckMail;
var
   sTo, sCC, sDate: String;
   actionType : TActionTypes;
   nCount, nHeadRowCount : Integer;
   bFoundMsgToDelete, bUserAbort, bFound, bHaveRetrievedMsg, bAnyMsgRetrieved : Boolean;
   oReceiveMail : TMailProperties;
   oReceivingThis : TInboundEmail;
   oMsgLines, oSaveLines : TStringList;
   oFilters : TFilterList;
begin
   bAnyMsgRetrieved := FALSE;
   bUserAbort := FALSE;
   bFoundMsgToDelete := FALSE;
   oReceiveMail := Nil;

   if TRUE = m_bCheckingMail then
       exit;

   // 05.15.02 CheckMail function is getting way too long...breaking out
   bFound := PreCheckMail();

   if TRUE = bFound then
   begin
       mnReceivedStopMail.Enabled := TRUE;

       ctlPop.Host := m_oEmailAddr.Server;
       ctlPop.UserID := m_oEmailAddr.UserId;
       ctlPop.Password := DecryptAliasPassword(m_oEmailAddr.Password);

       txtSending.Caption := 'checking mail for:' + m_oEmailAddr.Address;

       if Not Assigned(g_wndWinSock) then
          raise Exception.Create('g_wndWinSock not assigned in TwndInbound.CheckMail');

       oReceiveMail := g_wndWinSock.ReceiveMailProperties;
       g_wndWinSock.ReceivingEmail := TRUE;

       // open up the storage file for g_oEmailAddr.GetEmailAddress
       // the file name is g_oEmailAddr.GetEmailAddress + '.log'
       // we use this to compare what is on the server, vs what
       // we retrieved last time.  We only retrieve items not
       // found in our local file (oMsgLines).  Once the get
       // is done, oSaveLines is saved as that file.

       oFilters := TFilterList.Create();
       if Not Assigned(oFilters) then
           raise Exception.Create('oFilters is NIL in TwndInbound.CheckMail');

       oMsgLines := TStringList.Create;
       if Not Assigned(oMsgLines) then
           raise Exception.Create('oMsgLines is NIL in TwndInbound.CheckMail');

       oSaveLines := TStringList.Create;
       if Not Assigned(oSaveLines) then
           raise Exception.Create('oSaveLines is NIL in TwndInbound.CheckMail');

       if Not Assigned(g_oEmailFilters) then
          raise Exception.Create('g_oEmailFilters not assigned in TwndInbound.CheckMail');

       g_oEmailFilters.GetSubSet(m_oEmailAddr.Address, oFilters);

       try
           oMsgLines.LoadFromFile(g_oDirectories.ProgramDataPath + Trim(m_oEmailAddr.Address) + '.log');
       except
           // we do not care if the file load succeeded or not
       end;

       with ctlPop do
       begin
           // Note: set ctlPop.ReportLevel to 16 for trace and debug data from the control
           // defaults to 1 as of 07.18.02

           AttachFilePath := g_oDirectories.AttachmentPath;
           oReceiveMail.AccountName := m_oEmailAddr.Address;
           oReceiveMail.MaxItems := 0;
           oReceiveMail.CurrentItem := 0;
           g_wndWinSock.ReceiveMailProperties := oReceiveMail;

           try
               Connect;
               List;
               for nCount := 1 to MailCount do
               begin
                   //what was this code meant to do?
                   if (nCount > MailCount) then
                       g_oLogFile.Write('nCount is not <= MailCount in Inbound');

                   oReceiveMail.MaxItems := MailCount;
                   oReceiveMail.CurrentItem := nCount;
                   g_wndWinSock.ReceiveMailProperties := oReceiveMail;

                   GetSummary(nCount);

                   actionType := oFilters.FilterApplies(Summary.Subject);

                   // 05.15.02 flag indicating we have a message to delete
                   if (atDelete = actionType) then
                       bFoundMsgToDelete := TRUE;

                   bHaveRetrievedMsg := HaveAlreadyRetrievedMsg(Trim(Summary.From), Trim(Summary.Subject), Trim(Summary.MessageId), Summary.Bytes, oMsgLines, oSaveLines);

                   // TODO... 05.15.02 do we really want to do this for each loop reiteration?
                   oSaveLines.SaveToFile(g_oDirectories.ProgramDataPath + Trim(m_oEmailAddr.Address) + '.log');

                   if (FALSE = bHaveRetrievedMsg) and
                      ((atNormal = actionType) or (atToTrash = actionType)) then
                   begin
                       // 07.18.02 TODO...evaluate options to "resolve" this exception.
                       // Traced an exception into the following line 'GetMailMessage(nCount)'.
                       // The exception is a list index out of bounds exception and
                       // and the GetMailMessage function is part of the FastNet controls, which
                       // source code is not available for.
                       //
                       // it seems like, unless we can identify a potiental email upfront,
                       // the only option is to catch the exception, and keep on going.
                       // However, seeing how this FastNet code is having a problem, would
                       // it that be indicative of more problems to come and it would
                       // just be best to quit checking mail (which we does now).
                       //

                       GetMailMessage(nCount);

                       for nHeadRowCount := 0 to MailMessage.Head.Count - 1 do
                       begin
                           if 'DATE:' = Uppercase(Copy(MailMessage.Head[nHeadRowCount], 1, 5)) then
                           begin
                               sDate := Copy(MailMessage.Head[nHeadRowCount], 6, Length(MailMessage.Head[nHeadRowCount]));
                           end;
                           if 'TO:' = Uppercase(Copy(MailMessage.Head[nHeadRowCount], 1, 3)) then
                           begin
                               sTo := Copy(MailMessage.Head[nHeadRowCount], 4, Length(MailMessage.Head[nHeadRowCount]));
                               // TODO...could this be on multiple rows
                           end;

                           if 'CC:' = UpperCase(Copy(MailMessage.Head[nHeadRowCount], 1, 3)) then
                           begin
                               sCC := Copy(MailMessage.Head[nHeadRowCount], 4, Length(MailMessage.Head[nHeadRowCount]));
                               // TODO...could this be on multiple rows
                           end;

                       end; // for nHeadRowCount := 0 to MailMessage.Head.Count - 1 do


                       oReceivingThis := TInboundEmail.Create;

                       // 05.12.02 for clarity...using with clause
                       with oReceivingThis do
                       begin
                           // filenames should include the complete path here...
                           GenerateFileName;
                           GenerateHeaderFileName;

                           if 0 = Length(Trim(ExtractFilePath(HeaderFileName))) then
                               if Assigned(g_oLogFile) then
                                   g_oLogFile.Write('Looks like file path not included for  mail message file names in TwndInbound.CheckMail');

                           MailMessage.Head.SaveToFile(HeaderFileName);

                           Account := m_oEmailAddr.Address;
                           From := MailMessage.From;
                           SendTo := sTo;
                           CC := sCC;
                           BCC := g_csNA;
                           Subject := MailMessage.Subject;
                           Date := sDate;

                           MailMessage.Body.SaveToFile(MsgTextFileName);
                           if 0 < MailMessage.Attachments.Count then
                           begin
                               GenerateAttachFileName;
                               MailMessage.Attachments.SaveToFile(AttachmentListFileName);
                           end;

                           // something to think about...
                           // filters may want to apply to more than trash and in folders
                           // TODO 1.11.02 change to accept obj instead of string
                           if atToTrash = actionType then
                               g_oFolders[g_cnTrashFolder].AddMsg(OutputHeaderAsString)
                           else
                               g_oFolders[g_cnInFolder].AddMsg(OutputHeaderAsString);

                           free;
                       end;

                       bAnyMsgRetrieved := TRUE;

                   end; // if bRetrieveMsg = FALSE then

               end; // for nCount := 1 to MailCount do

               // delete mail only after all mail has been retrieved.
               // delete used to occur while retrieving but this is not to
               // internet protocol spec.
               //
               // Because filter options allow individual mail messages to be deleted with
               // with the remaining messages staying on the server, we have to reread
               // all the messages and delete them accordingly.  For performance, we will
               // only execute this code if FALSE = g_oEmailAddr.GetLeaveOnServer or
               // if atDelete = actionType was detected
               //
               // there is one problem with this approach...what if new mail arrives
               // between the first list and the second...we will not list again
               if (FALSE = g_oEmailAddr.GetLeaveOnServer) or (TRUE = bFoundMsgToDelete) then
               begin
                   for nCount := MailCount downto 1 do
                   begin
                       actionType := oFilters.FilterApplies(Summary.Subject);
                       if (FALSE = g_oEmailAddr.GetLeaveOnServer) or (atDelete = actionType) then
                       begin
                           DeleteMailMessage(nCount);
                       end;
                   end;
               end;

               Disconnect;
           except
               on oAbort : EAbortError do
               begin
                   bUserAbort := TRUE;
               end;

               on oError : Exception do
               begin
                   DisplayErrorExceptionMsg(oError.Message, TRUE);
               end;
           end; // except
       end; // with ctlPop do

       // 09.24.01  catch all
       // 05.12.02  added exception handler
       if TRUE = ctlPop.Connected then
       begin
           try
              ctlPop.Disconnect;
           except
              // dont care
           end;
       end;

       g_wndWinSock.ReceivingEmail := FALSE;
       oFilters.Free;

       // 05.12.02 catch all
       oSaveLines.SaveToFile(g_oDirectories.ProgramDataPath + Trim(m_oEmailAddr.Address) + '.log');
       oSaveLines.Free;
       oMsgLines.free;
   end
   else // if bFound = TRUE then
       m_nCurrentAliasIndex := -1;


   // 05.15.02 CheckMail function is getting way too long, breaking it out
   PostCheckMail();

   if Nil <> oReceiveMail then
   begin
       oReceiveMail.CurrentItem := 0;
       oReceiveMail.MaxItems := 0;
       oReceiveMail.LastDateTime := Now;
       g_wndWinSock.ReceiveMailProperties := oReceiveMail;
   end;

   if TRUE = bAnyMsgRetrieved then
   begin
       if Not Assigned(g_wndNewMail) then
       begin
           // 05.15.02 No parent...need desktop to be parent
           // 06.24.02 changed
           g_wndNewMail := TwndNewMail.Create(Application.MainForm.Parent);
       end;

       // TODO...05.15.02 need to only show window when emailmax is not active...?
       g_wndNewMail.Show();
   end;

   // what if there are more then 1 receiving account setup...
   // need to check them too
   if (m_nCurrentAliasIndex < g_oEmailAddr.Count) AND
      (TRUE = bFound) AND
      (FALSE = bUserAbort) then
       PostMessage(Self.Handle, WM_CHECKMAIL, 0, 0)
   else
       m_nCurrentAliasIndex := -1;

end;

{
===============================================================

===============================================================
}
// 05.15.02 CheckMail function is getting way too long, breaking it out
function TwndInbound.DisplayErrorExceptionMsg(sError : String; fDisconnect: Boolean): Boolean;
var
   dlgDisplayMsg : TdlgDisplayMessage;
begin
   if Not Assigned(ctlPop) then
      raise Exception.Create('ctlPop not assigned in TwndInbound.DisplayErrorExceptionMsg');

   dlgDisplayMsg := TdlgDisplayMessage.Create(Self);
   CenterFormOverParent(Self, dlgDisplayMsg);
   with dlgDisplayMsg do
   begin
       MessageType := dmtWarn;
       DialogTitle := g_csApplicationTitle;
       NoticeText := 'Check Mail Error';
       m_oDetailItems.Add('An error was encounter while attempting to check');
       m_oDetailItems.Add('mail for <' + ctlPop.UserID + '>.  The error encountered ');
       // 09.24.01 added this message when
       if (TRUE = ctlPop.BeenCanceled) or (TRUE = ctlPop.BeenTimedOut) then
           m_oDetailItems.Add('was "a time out or cancel action error"')
       else
           m_oDetailItems.Add('was "' + sError + '"');
       m_oDetailItems.Add('');

       // disconnect before showing message so that we avoid another exception
       // later on
       try
          if TRUE = fDisconnect then
              ctlPop.Disconnect;
       except;
       end;

       Display;
       Free;
   end;

   DisplayErrorExceptionMsg := TRUE;
end;

{
===============================================================

===============================================================
}
// 05.15.02 CheckMail function is getting way too long, breaking it out
function TwndInbound.PostCheckMail(): Boolean;
begin
   mnReceivedCheckMail.Visible := TRUE;
   mnReceivedCheckMail.Enabled := TRUE;
   mnReceivedStopMail.Visible := TRUE;
   mnReceivedStopMail.Enabled := FALSE;
   g_wndWinSock.ReceivingEmail := FALSE;
   m_bCheckingMail := FALSE;
   txtSending.Caption := 'idle...mail last checked on ' + FormatDateTime('m/d/yy h:nn am/pm', Now);
   PostCheckMail := TRUE;
   m_oEmailAddr.Free();
   m_oEmailAddr := NIL;
end;

{
===============================================================

===============================================================
}
procedure TwndInbound.pbNowClick(Sender: TObject);
begin
   if FALSE = m_bCheckingMail then
   begin
       CheckMail;
   end;

end;

procedure TwndInbound.FormCreate(Sender: TObject);
begin
   inherited;
   m_bCheckingMail := FALSE;
   m_bRecvError := FALSE;
   m_nCurrentAliasIndex := -1;
   m_oEmailAddr := NIL;
   FolderId := g_cnInFolder;

   if Not Assigned(g_oFolders[m_nFolderId]) then
       raise Exception.Create('g_oFolders[m_nFolderId] not assigned in TwndInbound.FormCreate');

   g_oFolders[m_nFolderId].SetDisplayForm := Self;
   LoadFromFileFolder;
end;

procedure TwndInbound.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   if TRUE = m_bCheckingMail then
   begin
       Action := caNone;
       exit;
   end;

   inherited;
   wndInbound := Nil;
end;

procedure TwndInbound.mnReceivedOpenClick(Sender: TObject);
begin
   OpenSelectedMsg;
end;

procedure TwndInbound.mnReceivedDeleteClick(Sender: TObject);
begin
   MoveToTrash;
   SetupMenuOptions;
end;

procedure TwndInbound.mnReceivedCheckMailClick(Sender: TObject);
begin
   CheckMail;
end;

procedure TwndInbound.mnReceivedStopMailClick(Sender: TObject);
begin
   if FALSE = m_bCheckingMail then
       exit;

   if TRUE = ctlPop.Connected then
   begin
       ctlPop.Reset;
       ctlPop.TimeOut := 5;            // set very low
       ctlPop.Abort;
       assert(g_oLogFile <> NIL, 'g_oLogFile is NIL in TwndInbound.mnReceivedStopMailClick');
       g_oLogFile.Write('Aborting reception of email');
       g_oLogFile.Flushfile();
   end;

   mnReceivedStopMail.Enabled := FALSE;
end;

procedure TwndInbound.OnMoveMessage(Sender: TObject);
begin
     MoveToAnotherFolder;
     SetupMenuOptions;
end;

function TwndInbound.CanCloseNow: Boolean;
var
   dlgConfirmClose : TdlgDisplayYesNo;
begin

   if TRUE = m_bCheckingMail then
   begin
       CanCloseNow := FALSE;
       dlgConfirmClose := TdlgDisplayYesNo.Create(Self);
       CenterFormOverParent(Self, dlgConfirmClose);
       with dlgConfirmClose do
       begin
           YesOptionText := 'Stop Checking Mail and close.';
           NoOptionText := 'No, I have changed my mind.  Do not close.';
           MessageType := dmtQuestion;
           DialogTitle := 'Confirm Stop of Checking Mail';
           NoticeText := 'Confirm...';
           m_oDetailItems.Add('To close, Checking mail will have to stop.');
           m_oDetailItems.Add('Do you want to stop Checking mail and close.');
           if DisplayModal = mrYes then
           begin
               mnReceivedStopMailClick(Nil);
               CanCloseNow := TRUE;
           end;
           free;
       end;
   end
   else
       CanCloseNow := TRUE;

end;

procedure TwndInbound.ctlPopAuthenticationFailed(var Handled: Boolean);
begin
  if Not Assigned(g_oLogFile) then
     raise Exception.Create('g_oLogFile not assigned in ctlPopAuthenticationFailed');

  g_oLogFile.Write('procedure TwndInbound.ctlPopAuthenticationFailed entered');
  g_oLogFile.Flushfile();
  Handled := AskForAccountAuthentication();
end;

procedure TwndInbound.ctlPopAuthenticationNeeded(var Handled: Boolean);
begin
  if Not Assigned(g_oLogFile) then
     raise Exception.Create('g_oLogFile not assigned in ctlPopAuthenticationNeeded');

  g_oLogFile.Write('procedure TwndInbound.ctlPopAuthenticationNeeded entered');
  g_oLogFile.Flushfile();
  Handled := AskForAccountAuthentication();
end;

procedure TwndInbound.ctlPopConnectionRequired(var Handled: Boolean);
begin
  if Not Assigned(g_oLogFile) then
     raise Exception.Create('g_oLogFile not assigned in ctlPopConnectionRequired');

  // TODO 06.24.02 add a handler so that the user has a chance to retry
  g_oLogFile.Write('procedure TwndInbound.ctlPopConnectionRequired entered');
  g_oLogFile.Flushfile();
  Handled := FALSE;
end;

procedure TwndInbound.ctlPopConnectionFailed(Sender: TObject);
var
   dlgConnect : TdlgDisplayMessage;
begin
  if Not Assigned(g_oLogFile) then
     raise Exception.Create('g_oLogFile not assigned in ctlPopConnectionRequired');

   g_oLogFile.Write('procedure TwndInbound.ctlPopConnectionFailed entered');
   g_oLogFile.Flushfile();
   dlgConnect := TdlgDisplayMessage.Create(Self);

   if Not Assigned(dlgConnect) then
      raise Exception.Create('dlgConnect not assigned in ctlPopConnectionFailed');

   with dlgConnect do
   begin
       MessageType := dmtWarn;
       DialogTitle := 'Connection Error';
       NoticeText := 'Unable to connect.';
       m_oDetailItems.Add(g_csApplicationTitle + ' was unable to retrieve your email.');
       m_oDetailItems.Add('This could be caused by:');
       m_oDetailItems.Add('1) Your PC is not properly connected to the internet');
       m_oDetailItems.Add('2) The POP server is down or your ISP is down.');
       Display;
       Free;
   end;

end;

procedure TwndInbound.ctlPopInvalidHost(var Handled: Boolean);
var
   dlgConnect : TdlgDisplayMessage;
begin
  if Not Assigned(g_oLogFile) then
     raise Exception.Create('g_oLogFile not assigned in ctlPopConnectionRequired');

   g_oLogFile.Write('procedure TwndInbound.ctlPopInvalidHost entered');
   g_oLogFile.Flushfile();
   Handled := FALSE;
   dlgConnect := TdlgDisplayMessage.Create(Self);
   with dlgConnect do
   begin
       MessageType := dmtWarn;
       DialogTitle := 'Connection Error';
       NoticeText := 'Unable to connect.';
       m_oDetailItems.Add(g_csApplicationTitle + ' was unable to retrieve');
       m_oDetailItems.Add('your email.  This could be caused by several things:');
       m_oDetailItems.Add('1) You did not setup the account correctly');
       m_oDetailItems.Add('2) The POP server is down');
       Display;
       Free;
   end;
end;

procedure TwndInbound.ctlPopStatus(Sender: TComponent; Status: String);
begin
  if Not Assigned(g_oLogFile) then
     raise Exception.Create('g_oLogFile not assigned in ctlPopConnectionRequired');

   g_oLogFile.Write('procedure TwndInbound.ctlPopStatus entered--status "' + Status + '"');
   g_oLogFile.Flushfile();

end;

procedure TwndInbound.mnPopupPrintClick(Sender: TObject);
begin
  PrintMsg(false);
end;

procedure TwndInbound.mnPopupPreviewClick(Sender: TObject);
begin
  PreviewMsg;
end;

end.
