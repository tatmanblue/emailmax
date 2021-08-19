// copyright (c) 2002  by microObjects inc.
//
// Emailmax source is distributed under the public
// domain license arrangements.  You are free to
// modify, edit, copy, delete, or redistribute
// the emailmax code as long as you 1) indemnify and
// hold harmless microObjects inc and its employees and
// owners from any and all liablity, directly or indirectly,
// related to the use, modification or distribution
// of this code 2) and make proper credit where
// applicable.

unit mdimax;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ToolWin, ComCtrls, OleCtnrs, ExtCtrls, StdCtrls,
  registry, folder, ImgList, eglobal, shellapi, OleCtrls, PBPathList;

type
  TPopMenuType = (pmNone, pmShowAll, pmInbound, pmOutbound, pmSent, pmTrash, pmDraft, pmUserDefined);
  TwndMaxMain = class(TForm)
    mnMaxMain: TMainMenu;
    mnFile: TMenuItem;
    mnFileExit: TMenuItem;
    ctlStatus: TStatusBar;
    ctlToolbar: TToolBar;
    mnFileNewEmail: TMenuItem;
    mnFileNewUsenet: TMenuItem;
    mnHelp: TMenuItem;
    mnHelpAbout: TMenuItem;
    mnFileBreak1: TMenuItem;
    mnFileBreak2: TMenuItem;
    mnFileSetup: TMenuItem;
    mnView: TMenuItem;
    mnViewToSend: TMenuItem;
    mnViewReceived: TMenuItem;
    mnViewTrash: TMenuItem;
    mnViewComplete: TMenuItem;
    mnViewSep1: TMenuItem;
    mnViewUser1: TMenuItem;
    mnViewUser2: TMenuItem;
    mnViewUser3: TMenuItem;
    mnViewMore: TMenuItem;
    ctlQuickBar: TPanel;
    pbNewEmail: TToolButton;
    pbFolders: TToolButton;
    mnEncrypt: TPopupMenu;
    mnEncryptPGP: TMenuItem;
    mnEncryptCeasar: TMenuItem;
    mnEncryptBeal: TMenuItem;
    pbOpenEmail: TToolButton;
    tbSep: TToolButton;
    pbSendNow: TToolButton;
    pbDelete: TToolButton;
    pbCheckMail: TToolButton;
    ctlImages: TImageList;
    pbHelp: TToolButton;
    pbSave: TToolButton;
    mnFileSave: TMenuItem;
    ToolButton1: TToolButton;
    pbEncrypt: TToolButton;
    pbDecrypt: TToolButton;
    mnViewShowToolbar: TMenuItem;
    N1: TMenuItem;
    mnViewShowIconsPanel: TMenuItem;
    mnFileSetupGenuis: TMenuItem;
    ctlSystem: TTimer;
    mnHelpContents: TMenuItem;
    mnFileBreak3: TMenuItem;
    mnFileSendMail: TMenuItem;
    mnFileCheckMail: TMenuItem;
    mnWindow: TMenuItem;
    mnWindowCascade: TMenuItem;
    mnWindowTile: TMenuItem;
    mnWindowArrangeIcons: TMenuItem;
    mnWindowSep1: TMenuItem;
    mnWindowNext: TMenuItem;
    mnWindowPrevious: TMenuItem;
    pbForward: TToolButton;
    pbReply: TToolButton;
    mnWindowClose: TMenuItem;
    mnViewShowProgress: TMenuItem;
    mnFolders: TPopupMenu;
    mnFolderNewFolder: TMenuItem;
    mnFileNew: TMenuItem;
    Folder1: TMenuItem;
    mnFileNewSubSep1: TMenuItem;
    mnHelpSep1: TMenuItem;
    mnHelpSubmitBugReport: TMenuItem;
    mnFolderSep1: TMenuItem;
    mnFolderCheck: TMenuItem;
    mnFolderSend: TMenuItem;
    mnFolderEmptyTrash: TMenuItem;
    mnFolderSep2: TMenuItem;
    mnFolderIn: TMenuItem;
    mnFolderOut: TMenuItem;
    mnFolderSent: TMenuItem;
    mnFolderTrash: TMenuItem;
    mnFolderDraft: TMenuItem;
    mnViewDraft: TMenuItem;
    mnFileSaveAs: TMenuItem;
    mnFilePrint: TMenuItem;
    mnFilePreview: TMenuItem;
    mnFilePrinterSetup: TMenuItem;
    ctlSaveAs: TSaveDialog;
    pbReadyToSend: TToolButton;
    pbPrint: TToolButton;
    mnFolderSep3: TMenuItem;
    mnFolderHelp: TMenuItem;
    mnViewShowPreview: TMenuItem;
    pnlOutbound: TPanel;
    ctlOutbound: TImage;
    txtOutbound: TLabel;
    pnlInbound: TPanel;
    txtInbound: TLabel;
    ctlReceived: TImage;
    pnlComplete: TPanel;
    txtComplete: TLabel;
    ctlComplete: TImage;
    pnlTrash: TPanel;
    txtTrash: TLabel;
    ctlTrash: TImage;
    pnlDraft: TPanel;
    txtDraft: TLabel;
    ctlDraft: TImage;
    ctlPaths: TPBPathList;
    procedure mnFileNewEmailClick(Sender: TObject);
    procedure mnFileSetupClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnHelpAboutClick(Sender: TObject);
    procedure mnViewTrashClick(Sender: TObject);
    procedure mnViewCompleteClick(Sender: TObject);
    procedure mnViewMoreClick(Sender: TObject);
    procedure mnViewToSendClick(Sender: TObject);
    procedure mnViewReceivedClick(Sender: TObject);
    procedure mnFileExitClick(Sender: TObject);
    procedure QuickBarIconMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure QuickBarIconMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbSaveClick(Sender: TObject);
    procedure pbOpenEmailClick(Sender: TObject);
    procedure pbDeleteClick(Sender: TObject);
    procedure pbCheckMailClick(Sender: TObject);
    procedure pbSendNowClick(Sender: TObject);
    procedure mnFileSaveClick(Sender: TObject);
    procedure pbEncryptClick(Sender: TObject);
    procedure pbDecryptClick(Sender: TObject);
    procedure mnViewShowToolbarClick(Sender: TObject);
    procedure mnViewShowIconsPanelClick(Sender: TObject);
    procedure mnFileSetupGenuisClick(Sender: TObject);
    procedure mnFileNewUsenetClick(Sender: TObject);
    procedure ctlSystemTimer(Sender: TObject);
    procedure mnHelpContentsClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ctlTrashDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ctlTrashDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ctlCompletedDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ctlCompletedDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ctlReceivedDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ctlReceivedDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ctlOutboundDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ctlOutboundDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure mnWindowCascadeClick(Sender: TObject);
    procedure mnWindowTileClick(Sender: TObject);
    procedure mnWindowArrangeIconsClick(Sender: TObject);
    procedure mnWindowNextClick(Sender: TObject);
    procedure mnWindowPreviousClick(Sender: TObject);
    procedure pbForwardClick(Sender: TObject);
    procedure pbReplyClick(Sender: TObject);
    procedure mnViewShowProgressClick(Sender: TObject);
    procedure mnHelpSubmitBugReportClick(Sender: TObject);
    procedure ctlQuickBarContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure mnFoldersPopup(Sender: TObject);
    procedure ctlOutboundContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure ctlReceivedContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure ctlCompletedContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure ctlTrashContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure mnFolderCheckClick(Sender: TObject);
    procedure mnFolderSendClick(Sender: TObject);
    procedure mnFolderEmptyTrashClick(Sender: TObject);
    procedure mnFolderNewFolderClick(Sender: TObject);
    procedure pbFoldersContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure mnFolderInClick(Sender: TObject);
    procedure mnFolderOutClick(Sender: TObject);
    procedure mnFolderSentClick(Sender: TObject);
    procedure mnFolderTrashClick(Sender: TObject);
    procedure pbFoldersClick(Sender: TObject);
    procedure pbFoldersMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mnFolderDraftClick(Sender: TObject);
    procedure mnViewDraftClick(Sender: TObject);
    procedure ctlDraftContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure ctlDraftDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ctlDraftDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure mnFilePrintClick(Sender: TObject);
    procedure mnFilePreviewClick(Sender: TObject);
    procedure mnFilePrinterSetupClick(Sender: TObject);
    procedure mnFileSaveAsClick(Sender: TObject);
    procedure pbReadyToSendClick(Sender: TObject);
    procedure pbPrintClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure mnFolderHelpClick(Sender: TObject);
    procedure mnViewShowPreviewClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ctlStatusDrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect);
  private
    { Private declarations }
    m_ePopupMenuType : TPopMenuType;

    m_dtLastEmailCheck,
    m_dtLastFlush : TDateTime;

    procedure SetControlStates(aControl : TControl; fState : Boolean); overload;
    procedure SetControlStates(aMenu : TMenuItem; fState : Boolean); overload;

    procedure ResetToolbarAndMenu;
    procedure RedrawToolbarAndMenu;
    procedure ResetStatusBarSizes;
    procedure SetupOutgoingToolbarAndMenu;
    procedure SetupInboundToolbarAndMenu;
    procedure SetupNewMailToolbarAndMenu;
    procedure SetupTrashToolbarAndMenu;
    procedure SetupCompleteToolbarAndMenu;
    procedure SetupReadToolbarAndMenu;
    procedure SetupDraftToolbarAndMenu;

  public
    { Public declarations }
    procedure CenterFormOverSelf(oForm : TForm);
    procedure RestoreChildWnd(wndWho : TForm);
    procedure ChildWndReceivedFocus(nWndType : TWindowFocused);
    procedure ChildWndLostFocus(nWndType : TWindowFocused);


    procedure HandleStartupIssues(var Msg: TMessage); Message WM_HANDLE_STARTUP;
    procedure HandleLogOn(var Msg : TMessage); Message WM_HANDLE_LOGIN;
    procedure HandleCheckMail(var Msg : TMessage); Message WM_HANDLE_CHECKMAIL;
    procedure HandleSendMail(var Msg : TMessage); Message WM_HANDLE_SENDMAIL;

     
  end;

var
  wndMaxMain: TwndMaxMain;

function ShowSetupWizard(oOwner : TForm): integer ; external 'emailex.dll';
procedure SetApplicationTitle(newTitle : PChar);  external 'emailex.dll';

implementation

uses
   remail, email, setup, basepost, basfoldr, alias, logfile, notepad, displmsg, outbound,
   about, trash, complete, foldlist, inbound, splash, wndfolder, usenet,
   dlgpass, encryption, wndsock, filterobject, dlgShutdown, dlgSubmitBugReport, draft,
   eregistry, helpengine, wndNewMailDisplay, wndPrintPreview;


{$R *.DFM}

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.SetControlStates(aControl : TControl; fState : Boolean);
begin
   if Not Assigned(aControl) then
       exit;

   with aControl do
   begin
       Enabled := fState;
       Visible := fState;
       Update;
   end;
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.SetControlStates(aMenu : TMenuItem; fState : Boolean);
begin
   if Not Assigned(aMenu) then
       exit;

   with aMenu do
   begin
       Enabled := fState;
       Visible := fState;
       Update;
   end;
end;
{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.ResetStatusBarSizes;
begin
   ctlStatus.Panels[2].Width := 50;
   ctlStatus.Panels[1].Width := 100;
   ctlStatus.Panels[0].Width := Self.Width - 150;
end;

{
--------------------------------------------------------------------------------
   HandleLogOn
}
procedure TwndMaxMain.HandleLogOn(var Msg : TMessage);
var
   oEncrypt : TEncrypt;
   dlgPass : TdlgPassword;
   nDlgOption : Integer;
   bCheckLogin : Boolean;
begin

   if Not Assigned(g_oRegistry) then
      raise Exception.Create('g_oRegistry not assigned in TwndMaxMain.HandleLogOn');

   bCheckLogin := FALSE;

   if (paOnPasswordForEmail = TPasswordAction(Msg.wParam)) then
       bCheckLogin := TRUE
   else
       // TODO...9.18.01 PasswordOption Changes
       if ('1' = g_oRegistry.PasswordOptions[Integer(TPasswordAction(Msg.wParam)) + 1]) then
           bCheckLogin := TRUE;

   if TRUE = bCheckLogin then
   begin
       oEncrypt := TEncrypt.Create;

       if Not Assigned(oEncrypt) then
          raise Exception.Create('oEncrypt not assigned in TwndMaxMain.HandleLogOn');

       oEncrypt.EncryptedString := g_oRegistry.SysPassword;
       oEncrypt.Decrypt;

       dlgPass := TdlgPassword.Create(Self);
       CenterFormOverSelf(dlgPass);
       with dlgPass do
       begin
           ActionType := TPasswordAction(Msg.wParam);
           VerifiedPassword := oEncrypt.SourceString;
           if ActionType = paOnPasswordForEmail then
               ExtraInfo := StrPas(PChar(Msg.lParam));

           nDlgOption := Display;
       end;

       if mrCancel = nDlgOption then
       begin
           case TPasswordAction(Msg.wParam) of
               paOnStartup: Close;
           else
               Msg.Result := mrCancel;
           end;
       end
       else
           Msg.Result := mrOK;

       dlgPass.Free;
       oEncrypt.Free;

   end
   else
       Msg.Result := mrOK;


   if Assigned(wndSplash) then
   begin
      try
         wndSplash.Visible := FALSE;
         wndSplash.Close();
      except
      end;
   end;
end;

{
--------------------------------------------------------------------------------
   HandleSendMail
}
procedure TwndMaxMain.HandleSendMail(var Msg : TMessage);
begin
    mnViewToSendClick(Self);
    wndOutbound.pbNowClick(Self);
end;

{
--------------------------------------------------------------------------------
   HandleCheckMail
}
procedure TwndMaxMain.HandleCheckMail(var Msg : TMessage);
begin
    mnViewReceivedClick(Self);
    m_dtLastEmailCheck := Now;
    wndInbound.CheckMail;
end;

{
--------------------------------------------------------------------------------
   HandleStartupIssues
}
procedure TwndMaxMain.HandleStartupIssues(var Msg: TMessage);
var
   bLog, bToolTips, bViewIcons, bViewToolbar: Boolean;
   nCount : Integer;
   wndEmail : TwndNotepad;
begin

   if Not Assigned(g_oRegistry) then
      raise Exception.Create('g_oRegistry not assigned in TwndMaxMain.HandleStartupIssues');

   bViewToolbar := TRUE;
   bViewIcons := TRUE;
   if rtfOff = g_oRegistry.FoldersToolbar then
       bViewToolbar := FALSE
   else
       bViewToolbar := TRUE;

   if rtfOff = g_oRegistry.IconsPanel then
       bViewIcons := FALSE
   else
       bViewIcons := TRUE;

   if rtfOff = g_oRegistry.UseToolTips then
       bToolTips := FALSE
   else
       bToolTips := TRUE;

   if rtfOff = g_oRegistry.ShowPreview then
       mnViewShowPreview.Checked := FALSE
   else
       mnViewShowPreview.Checked := TRUE;

   bLog := FALSE;
   g_bShowExceptions := TRUE;

   if ParamCount > 0 then
   begin
       for nCount := 1 to ParamCount do
       begin
           if '+L' = ParamStr(nCount) then
               bLog := TRUE;

           if '-E' = ParamStr(nCount) then
               g_bShowExceptions := FALSE;
       end;
   end;


   // TODO 1.11.02 need to have some error handling, program error checking here
   try
       g_oLogFile := TLogFile.Create;
       if Not Assigned(g_oLogFile) then
           raise Exception.Create('log file failed to create in TwndMaxMain.HandleStartupIssues.');

       g_oLogFile.LoggingOn := bLog;
       g_oLogFile.Open;
       g_oLogFile.Write('==========================================================');
       g_oLogFile.Write('==========================================================');
       g_oLogFile.Write('Session Started...');
       g_oLogFile.Write('Emailmax Version :' + getVerInfo());
   except
       // eat the exception because we dont care...
   end;

   try
       g_oEmailAddr := TEmailAlias.Create;
       g_oEmailAddr.LoadFromFile(g_oDirectories.ProgramDataPath + 'system.txt');
   except
       // this is probably a bad thing....
       g_oLogFile.Write('Could not open System.Txt which is really needed. You will need to recreate your email account information.');
   end;

   try
       g_oEmailFilters := TFilterList.Create;
       g_oEmailFilters.LoadFromFile(g_oDirectories.ProgramDataPath + 'filters.txt');
   except
   end;


   InitializeFolders;

   ctlToolbar.Visible := bViewToolbar;
   mnViewShowToolbar.Checked := bViewToolbar;
   ctlQuickBar.Visible := bViewIcons;
   mnViewShowIconsPanel.Checked := bViewIcons;

   Self.ShowHint := bToolTips;

   ctlToolbar.Update;
   ctlQuickBar.Update;

   if g_oEmailAddr.Count = 0 then
       mnFileSetupGenuisClick(TObject(Nil));

   // 'mailto' implementation below is a bit hooky.
   // TODO....1) change mnFileNewEmailClick to call a function
   //            that takes a To String as a parameter
   //         2) new function does what mnFileNewEmailClick does now
   //         3) have this code below call new function
   if Msg.wParam <> 0 then
   begin
       mnFileNewEmailClick(Nil);
       wndEmail := Nil;
       for nCount := 0 to MDIChildCount - 1 do
       begin
           if MDIChildren[nCount] is TwndNotepad then
           begin
               wndEmail := TwndNotepad(MDIChildren[nCount]);
           end;
       end;

       if wndEmail <> Nil then
       begin
           for nCount := 1 to ParamCount do
           begin
               if Pos('mailto:', ParamStr(nCount)) > 0 then
               begin
                   wndEmail.efTo.Text := Copy(ParamStr(nCount), Pos(':', ParamStr(nCount)) + 1, Length(ParamStr(nCount)));
               end;
           end;
       end;
   end;

   // HelpAgentInitialize;
   g_wndWinSock := TwndWinsockActivity.Create(Self);
end;
{
--------------------------------------------------------------------------------
   CenterFormOverSelf
}
procedure TwndMaxMain.CenterFormOverSelf(oForm : TForm);
begin
   CenterFormOverParent(Self, oForm);
end;
{
--------------------------------------------------------------------------------
   QuickBarIconMouseDown
}
procedure TwndMaxMain.QuickBarIconMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
begin
   if (mbLeft = Button) then
   begin
       // TODO 1.19.02 This is where icons for user defined folders should get handled
       case TImage(Sender).Tag of
          0: begin
             pnlOutbound.BevelOuter := bvRaised;
             txtOutbound.Font.Style := [fsBold];
             end;
          1: begin
             pnlInbound.BevelOuter := bvRaised;
             txtInbound.Font.Style := [fsBold];
             end;
          2: begin
             pnlComplete.BevelOuter := bvRaised;
             txtComplete.Font.Style := [fsBold];
             end;
          3: begin
             pnlTrash.BevelOuter := bvRaised;
             txtTrash.Font.Style := [fsBold];
             end;
          4: begin
             pnlDraft.BevelOuter := bvRaised;
             txtDraft.Font.Style := [fsBold];
             end;

       end;
   end;
end;

{
--------------------------------------------------------------------------------
   QuickBarIconMouseUp
}
procedure TwndMaxMain.QuickBarIconMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
begin
   if (mbLeft = Button) then
   begin
       // TODO 1.19.02 This is where icons for user defined folders should get handled
       case TImage(Sender).Tag of
          0: begin
             pnlOutbound.BevelOuter := bvNone;
             txtOutbound.Font.Style := [];
             end;
          1: begin
             pnlInbound.BevelOuter := bvNone;
             txtInbound.Font.Style := [];
             end;
          2: begin
             pnlComplete.BevelOuter := bvNone;
             txtComplete.Font.Style := [];
             end;
          3: begin
             pnlTrash.BevelOuter := bvNone;
             txtTrash.Font.Style := [];
             end;
          4: begin
             pnlDraft.BevelOuter := bvNone;
             txtDraft.Font.Style := [];
             end;
      end;
   end;
end;

procedure TwndMaxMain.ChildWndLostFocus(nWndType : TWindowFocused);
begin
   if TRUE = g_bApplicationIsShutDown then
       exit;
       
   ResetToolbarAndMenu;

   RedrawToolbarAndMenu;

end;

{
--------------------------------------------------------------------------------
   ChildWndReceivedFocus
}
procedure TwndMaxMain.ChildWndReceivedFocus(nWndType : TWindowFocused);
begin
   if Not Assigned(g_oRegistry) then
      raise Exception.Create('g_oRegistry not assigned in TwndMaxMain.ChildWndReceivedFocus');

   if TRUE = g_bApplicationIsShutDown then
       exit;

   ResetToolbarAndMenu;
   if rtfOn = g_oRegistry.FoldersToolbar then
   begin
       if TRUE = mnViewShowToolbar.Checked then
       begin
           Sleep(0);
           case nWndType of
               wfNew: SetupNewMailToolbarAndMenu;
               wfRead: SetupReadToolbarAndMenu;
               wfForward: SetupNewMailToolbarAndMenu;
               wfOutbound: SetupOutgoingToolbarAndMenu;
               wfInbound: SetupInboundToolbarAndMenu;
               wfComplete: SetupCompleteToolbarAndMenu;
               wfTrash: SetupTrashToolbarAndMenu;
               wfDraft: SetupDraftToolbarAndMenu;
               // TODO...
               wfUser:
               begin
                   Exit;
               end;
           end;
       end;
   end
   else if TRUE = mnViewShowToolbar.Checked then
   begin
       Sleep(0);
       case nWndType of
           wfNew: SetupNewMailToolbarAndMenu;
           wfRead: SetupReadToolbarAndMenu;
           wfForward: SetupNewMailToolbarAndMenu;
           wfOutbound: SetupOutgoingToolbarAndMenu;
           wfInbound: SetupInboundToolbarAndMenu;
           wfComplete: SetupCompleteToolbarAndMenu;
           wfTrash: SetupTrashToolbarAndMenu;
           wfDraft: SetupDraftToolbarAndMenu;
           // TODO...
           wfUser:
               begin
                   Exit;
               end;

       end;
   end;

   if Assigned(ActiveMDIChild) then
       if ActiveMDIChild is TwndFolder then
           TwndFolder(ActiveMDIChild).TogglePreview(mnViewShowPreview.checked);

   RedrawToolbarAndMenu;

end;

{
--------------------------------------------------------------------------------
   RestoreChildWnd
}
procedure TwndMaxMain.RestoreChildWnd(wndWho : TForm);
begin
   if Not Assigned(wndWho) then
       exit;

   if Not Assigned(g_oRegistry) then
      raise Exception.Create('g_oRegistry not assigned in TwndMaxMain.RestoreChildWnd');

   if wsMaximized = wndWho.WindowState then
   begin
       wndWho.Invalidate;
       wndWho.Update;
       Self.Update;
       exit;
   end;
   
   if rtfOn = g_oRegistry.Maximize then
       wndWho.WindowState := wsMaximized
   else
       wndWho.WindowState := wsNormal;

   wndWho.SetFocus;
   wndWho.Invalidate;
   wndWho.Update;
   Self.Update;
end;

{
--------------------------------------------------------------------------------
  =====================================
  Toobar Functions
  =====================================
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
   ResetToolbar
}
procedure TwndMaxMain.ResetToolbarAndMenu;
begin
   SetControlStates(pbDelete, FALSE);
   SetControlStates(pbOpenEmail, FALSE);
   SetControlStates(pbSave, FALSE);
   SetControlStates(pbReadyToSend, FALSE);
   SetControlStates(pbPrint, FALSE);
   SetControlStates(pbEncrypt, FALSE);
   SetControlStates(pbDecrypt, FALSE);
   SetControlStates(mnFileSave, FALSE);
   SetControlStates(mnFileSaveAs, FALSE);
   SetControlStates(pbForward, FALSE);
   SetControlStates(pbReply, FALSE);
   SetControlStates(mnFilePrint, FALSE);
   SetControlStates(mnFilePreview, FALSE);

   SetControlStates(pbCheckMail, TRUE);
   SetControlStates(pbSendNow, TRUE);

    if Assigned(ctlToolbar) then
       ctlToolbar.Update;
end;

{
--------------------------------------------------------------------------------
   RedrawToolbar
}
procedure TwndMaxMain.RedrawToolbarAndMenu;
begin
   if Not Assigned(g_oRegistry) then
      raise Exception.Create('g_oRegistry not assigned in TwndMaxMain.RedrawToolbarAndMenu');

   // TODO 11.27.01 Can't this logic be simplified by
   // simply  mnViewShowToolbar.Checked = TRUE ....?

   if rtfOn = g_oRegistry.FoldersToolbar then
   begin
       if mnViewShowToolbar.Checked = TRUE then
       begin
           ctlToolbar.Update;
           pbDelete.Update;
           pbCheckMail.Update;
           pbSendNow.Update;
           pbOpenEmail.Update;
           pbEncrypt.Update;
           pbDecrypt.Update;
           pbForward.Update;
           pbReply.Update;
           pbReadyToSend.Update;
           pbPrint.Update;

       end;
   end
   else if mnViewShowToolbar.Checked = TRUE then
   begin
       ctlToolbar.Update;
       pbDelete.Update;
       pbCheckMail.Update;
       pbSendNow.Update;
       pbOpenEmail.Update;
       pbEncrypt.Update;
       pbDecrypt.Update;
       pbForward.Update;
       pbReply.Update;
       pbReadyToSend.Update;
       pbPrint.Update;

   end;

   ctlToolbar.Update;
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.SetupDraftToolbarAndMenu;
begin
   SetControlStates(pbDelete, TRUE);
   SetControlStates(pbOpenEmail, TRUE);
   SetControlStates(pbPrint, TRUE);

   SetControlStates(mnFilePrint, TRUE);
   SetControlStates(mnFilePrint, TRUE);
   SetControlStates(mnFilePreview, TRUE);
   SetControlStates(mnFilePreview, TRUE);
   SetControlStates(mnFileSaveAs, TRUE);
   SetControlStates(mnFileSaveAs, TRUE);

end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.SetupCompleteToolbarAndMenu;
begin
   SetControlStates(pbDelete, TRUE);
   SetControlStates(pbOpenEmail, TRUE);
   SetControlStates(pbPrint, TRUE);
   SetControlStates(pbForward, TRUE);

   SetControlStates(mnFilePrint, TRUE);
   SetControlStates(mnFilePreview, TRUE);
   SetControlStates(mnFileSaveAs, TRUE);

end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.SetupTrashToolbarAndMenu;
begin
   SetControlStates(pbOpenEmail, TRUE);
   SetControlStates(pbDelete, TRUE);
   SetControlStates(pbPrint, TRUE);
   SetControlStates(pbForward, TRUE);
   SetControlStates(pbReply, TRUE);

   SetControlStates(mnFilePrint, TRUE);
   SetControlStates(mnFilePreview, TRUE);
   SetControlStates(mnFileSaveAs, TRUE);

end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.SetupReadToolbarAndMenu;
begin
   SetControlStates(pbDecrypt, TRUE);
   SetControlStates(pbForward, TRUE);
   SetControlStates(pbReply, TRUE);

   SetControlStates(pbPrint, TRUE);
   SetControlStates(mnFilePrint, TRUE);
   SetControlStates(mnFilePreview, TRUE);

   SetControlStates(mnFileSaveAs, TRUE);

end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.SetupNewMailToolbarAndMenu;
begin
   SetControlStates(pbSave, TRUE);
   SetControlStates(mnFileSave, TRUE);
   SetControlStates(pbEncrypt, TRUE);
   SetControlStates(pbReadyToSend, TRUE);
   SetControlStates(pbPrint, TRUE);
   SetControlStates(mnFilePrint, TRUE);
   SetControlStates(mnFilePreview, TRUE);
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.SetupOutgoingToolbarAndMenu;
begin
   SetControlStates(pbSendNow, TRUE);
   SetControlStates(pbOpenEmail, TRUE);
   SetControlStates(pbDelete, TRUE);
   SetControlStates(pbPrint, TRUE);
   SetControlStates(pbForward, TRUE);
   SetControlStates(mnFilePrint, TRUE);
   SetControlStates(mnFilePreview, TRUE);
   SetControlStates(mnFileSaveAs, TRUE);

end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.SetupInboundToolbarAndMenu;
begin
   SetControlStates(pbCheckMail, TRUE);
   SetControlStates(pbOpenEmail, TRUE);
   SetControlStates(pbDelete, TRUE);
   SetControlStates(pbPrint, TRUE);
   SetControlStates(pbForward, TRUE);
   SetControlStates(pbReply, TRUE);
   SetControlStates(mnFilePrint, TRUE);
   SetControlStates(mnFilePreview, TRUE);
   SetControlStates(mnFileSaveAs, TRUE);

end;
{
--------------------------------------------------------------------------------
  =====================================
  Menu Handlers
  =====================================
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.mnFileNewEmailClick(Sender: TObject);
var
    wndEmail : TwndNotepad;
begin
{}
   // TODO 1.11.02 hmmm...scope for this var goes out yet the
   // window is active and around this could be a problem...
   wndEmail := TwndNotepad.Create(Self);
   if Not Assigned(wndEmail) then
      raise Exception.Create('wndEmail not assigned in TwndMaxMain.mnFileNewEmailClick');

   ChildWndReceivedFocus(wfNew);
   wndEmail.Show;
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.mnFileNewUsenetClick(Sender: TObject);
var
   wndUsenet : TwndUsenetMsg;
begin
   // TODO 1.11.02 hmmm...scope for this var goes out yet the
   // window is active and around this could be a problem...
   wndUsenet := TwndUsenetMsg.Create(Self);
   if Not Assigned(wndUsenet) then
      raise Exception.Create('wndUsenet not assigned in TwndMaxMain.mnFileNewEmailClick');
   ChildWndReceivedFocus(wfNew);
   wndUsenet.Show;
end;


{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.mnFileSaveClick(Sender: TObject);
begin
   pbSaveClick(Sender);
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.mnFileSetupClick(Sender: TObject);
var
   dlgSetup : TdlgSetup;
   bShowToolbar, bShowIconPanel, bToolTips : Boolean;
begin

   if Not Assigned(g_oRegistry) then
      raise Exception.Create('g_oRegistry not assigned in TwndMaxMain.mnFileSetupClick');

   ctlSystem.Enabled := FALSE;

   dlgSetup := TdlgSetup.Create(Self);
   CenterFormOverSelf(dlgSetup);
   dlgSetup.ShowModal;
   dlgSetup.free;

   if rtfOff = g_oRegistry.FoldersToolbar then
       bShowToolbar := FALSE
   else
       bShowToolbar := TRUE;

   if rtfOff = g_oRegistry.IconsPanel then
       bShowIconPanel := FALSE
   else
       bShowIconPanel := TRUE;

   if rtfOff = g_oRegistry.UseToolTips then
       bToolTips := FALSE
   else
       bToolTips := TRUE;

   ctlToolbar.Visible := bShowToolbar;
   mnViewShowToolbar.Checked := bShowToolbar;
   ctlQuickBar.Visible := bShowIconPanel;
   mnViewShowIconsPanel.Checked := bShowIconPanel;

   Self.ShowHint := bToolTips;

   ctlToolbar.Update;
   ctlQuickBar.Update;

   ctlSystem.Enabled := TRUE;

end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.FormCreate(Sender: TObject);
var
   vSize : Variant;
   nCount : Integer;
   bSplash, bNewMail : Boolean;
begin

   // 05.19.02 moved to here...
   DoPreWindowCreationInitialize;

   m_dtLastEmailCheck := Now;
   m_dtLastFlush := Now;

   // TODO 09.12.01...see if program was positioned elsewhere and set its location
   // there if it was
   with Screen do
   begin
       vSize := Height - (Height * 0.2);
       Self.Height := vSize;

       vSize := Width - (Width * 0.2);
       Self.Width := vSize;

       vSize := (Width div 2) - (Self.Width div 2);
       Self.Left := vSize;

       vSize := (Height div 2) - (Self.Height div 2);
       Self.Top := vSize;
   end;

   bSplash := TRUE;
   bNewMail := FALSE;

   if ParamCount > 0 then
   begin
       for nCount := 1 to ParamCount do
       begin
           if ParamStr(nCount) = '-S' then
               bSplash := FALSE;

           if Pos('mailto:', ParamStr(nCount)) > 0 then
               bNewMail := TRUE;

           if ParamStr(nCount) = '-E' then
               g_bLogEncryption := TRUE;
       end;
   end;

   if bSplash = TRUE then
   begin
       wndSplash := TwndSplash.Create(Application);
       CenterFormOverSelf(wndSplash);
       wndSplash.Show;
       wndSplash.Update;
   end
   else
       PostMessage(Handle, WM_HANDLE_LOGIN, Integer(paOnStartup), 0);

   ctlToolbar.Update;
   Update;

   ResetToolbarAndMenu;
   self.Caption := Application.Title;
   Sleep(50);
   PostMessage(Self.Handle, WM_HANDLE_STARTUP, integer(bNewMail), 0);

   if Not Assigned(g_oRegistry) then
      raise Exception.Create('g_oRegistry not assigned in TwndMaxMain.FormCreate');

   if rtfOn = g_oRegistry.ShowPreview then
       mnViewShowPreview.checked := TRUE
   else
       mnViewShowPreview.checked := FALSE;

end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.FormDestroy(Sender: TObject);
var
   nCount, nItems : Integer;
   dlgShutdown : TdlgShutdownInfo;
begin

   // TODO 1.11.02 need to handle potential for global objects not 
   // allocate here...

   g_bApplicationIsShutDown := TRUE;
   
   dlgShutdown := TdlgShutdownInfo.Create(self);
   if Assigned(dlgShutDown) then
   begin
      dlgShutdown.DialogTitle := 'Closing ' + Application.Title;
      dlgShutdown.NoticeText := 'Closing ' + Application.Title;
      dlgShutdown.Setup;
      dlgShutdown.Show();
      dlgShutdown.moreDetail('Shutting down...');
   end;

   self.Visible := false;

   if Assigned(g_wndNewMail) then
   begin
       g_wndNewMail.Close();
       g_wndNewMail.free();
   end;

   if rtfOn = g_oRegistry.EmptyOnExit then
   begin
       if Assigned(g_oFolders[g_cnTrashFolder]) then
       begin
          if Assigned(dlgShutDown) then
               dlgShutdown.moreDetail('emptying trash...');

          nItems := g_oFolders[g_cnTrashFolder].Count;
          for nCount := 0 to nItems - 1 do
          begin
             g_oFolders[g_cnTrashFolder].ActiveIndex := 0;
             g_oFolders[g_cnTrashFolder].DeleteMsg;
          end;
       end;
   end;

   if Assigned(dlgShutDown) then
       dlgShutdown.moreDetail('updating program data...');

   DeInitializeFolders;

   if Assigned(g_oEmailAddr) then
   begin
      g_oEmailAddr.SaveToFile(g_oDirectories.ProgramDataPath + 'system.txt');
      g_oEmailAddr.free;
   end;

   if Assigned(g_oRegistry) then
   begin
      // TODO 1.11.01 hmm maybe a save should be called here..
      g_oRegistry.Close;
      g_oRegistry.Free;
   end;

   if Assigned(g_oHelpEngine) then
      g_oHelpEngine.free;

   if Assigned(g_oAddressBook) then
   begin
      g_oAddressBook.FlushToFile();
      g_oAddressBook.free;
   end;

   if Assigned(dlgShutDown) then
   begin
       dlgShutdown.moreDetail('done...');
       dlgShutdown.Hide();
       dlgShutdown.free;
   end;

   if Assigned(g_oLogFile) then
   begin
      g_oLogFile.Write('Session Ended');
      g_oLogFile.Close();
      g_oLogFile.free;
   end;

end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.mnHelpAboutClick(Sender: TObject);
var
   dlgAbout : TdlgAbout;
begin
   dlgAbout := TdlgAbout.Create(Self);
   CenterFormOverSelf(dlgAbout);
   dlgAbout.ShowModal;
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.mnViewShowProgressClick(Sender: TObject);
begin
   // TODO
   // 8.09.01 How this currently works is hoky
   // it should work like this
   // stays invisible until a mail action (send/receive)
   // occurs.  Then, if FALSE = mnViewShowProgress.Checked
   // the g_wndWinSock stays hidden, otherwise it
   // becomes visible

   if Not Assigned(g_wndWinSock) then
      raise Exception.Create('g_wndWinSock not assigned in TwndMaxMain.mnViewShowProgressClick');

   if FALSE = mnViewShowProgress.Checked then
   begin
       g_wndWinSock.RemainVisible := TRUE;
       g_wndWinSock.ShowSelf(TRUE);
       mnViewShowProgress.Checked := TRUE;
   end
   else
   begin
       g_wndWinSock.RemainVisible := FALSE;
       g_wndWinSock.ShowSelf(FALSE);
       mnViewShowProgress.Checked := FALSE;
   end;
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.mnViewShowToolbarClick(Sender: TObject);
begin
   if mnViewShowToolbar.Checked = FALSE then
   begin
       ctlToolbar.Visible := TRUE;
       mnViewShowToolbar.Checked := TRUE;
   end
   else
   begin
       ctlToolbar.Visible := FALSE;
       mnViewShowToolbar.Checked := FALSE;
   end;

   ctlToolbar.Update;

end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.mnViewShowIconsPanelClick(Sender: TObject);
begin
   if mnViewShowIconsPanel.Checked = FALSE then
   begin
       ctlQuickBar.Visible := TRUE;
       mnViewShowIconsPanel.Checked := TRUE;
   end
   else
   begin
       ctlQuickBar.Visible := FALSE;
       mnViewShowIconsPanel.Checked := FALSE;
   end;

   ctlQuickBar.Update;

end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.mnViewDraftClick(Sender: TObject);
begin
   if Not Assigned(wndDraft) then
       wndDraft := TwndDraft.Create(Self);

   if Not Assigned(wndDraft) then
       raise Exception.Create('wndDraft not assigned in TwndMaxMain.mnViewDraftClick');

   if wndDraft.Visible = FALSE then
       wndDraft.Visible := TRUE;

   RestoreChildWnd(wndDraft);
   ChildWndReceivedFocus(wfDraft);

   wndDraft.Show;
   wndDraft.Invalidate;
   wndDraft.Update;

end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.mnViewTrashClick(Sender: TObject);
begin
   if wndTrash = nil then
       wndTrash := TwndTrash.Create(Self);

   if wndTrash.Visible = FALSE then
       wndTrash.Visible := TRUE;

   RestoreChildWnd(wndTrash);
   ChildWndReceivedFocus(wfTrash);

   wndTrash.Show;
   wndTrash.Invalidate;
   wndTrash.Update;

end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.mnViewCompleteClick(Sender: TObject);
begin
   if wndComplete = nil then
       wndComplete := TwndComplete.Create(Self);

   if wndComplete.Visible = FALSE then
       wndComplete.Visible := TRUE;

   RestoreChildWnd(wndComplete);
   ChildWndReceivedFocus(wfComplete);
   wndComplete.Show;
   wndComplete.Invalidate;
   wndComplete.Update;

end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.mnViewMoreClick(Sender: TObject);
var
   dlgFolderList: TdlgFolderList;
begin
   ctlSystem.Enabled := FALSE;
   try
       dlgFolderList := TdlgFolderList.Create(Self);
       CenterFormOverSelf(dlgFolderList);
       dlgFolderList.DisplayModal;
       case dlgFolderList.SelectedFolder of
           g_cnInFolder: mnViewReceivedClick(Sender);
           g_cnOutFolder: mnViewCompleteClick(Sender);
           g_cnToSendFolder: mnViewToSendClick(Sender);
           g_cnTrashFolder: mnViewTrashClick(Sender);
           g_cnDraftFolder: mnViewDraftClick(Sender);
           g_cnFirstUserFolder..g_cnMaxFoldersAllowed: MessageDlg('To be implemented...', mtInformation, [mbOK], 0);
       end;
       dlgFolderList.Free;
   except;
   end;
   ctlSystem.Enabled := TRUE;
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.mnViewToSendClick(Sender: TObject);
begin
   if Not Assigned(wndOutbound) then
       wndOutbound := TwndOutbound.Create(Self);

   if FALSE = wndOutbound.Visible then
       wndOutbound.Visible := TRUE;

   RestoreChildWnd(wndOutbound);
   ChildWndReceivedFocus(wfOutbound);
   wndOutbound.Show;
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.mnViewReceivedClick(Sender: TObject);
begin
   if Not Assigned(wndInbound) then
       wndInbound := TwndInbound.Create(Self);

   if FALSE = wndInbound.Visible THEN
       wndInbound.Visible := TRUE;

   RestoreChildWnd(wndInbound);
   ChildWndReceivedFocus(wfInbound);
   wndInbound.Show;

end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.mnFileExitClick(Sender: TObject);
begin
   Close;
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.pbForwardClick(Sender: TObject);
var
    wndEmail : TwndNotepad;
begin
   
   if Not Assigned(ActiveMDIChild) then
       exit;

   if Not (ActiveMDIChild is TwndNotepad) then
       exit;

   wndEmail := TwndNotepad(ActiveMDIChild);
   wndEmail.ForwardMail;
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.pbReplyClick(Sender: TObject);
var
    wndEmail : TwndNotepad;
begin
   if Not Assigned(ActiveMDIChild) then
       exit;

   if Not (ActiveMDIChild is TwndNotepad) then
       exit;

   wndEmail := TwndNotepad(ActiveMDIChild);
   wndEmail.ReplyMail;
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.pbSaveClick(Sender: TObject);
begin
//var
//   wndPost : TwndBasePost;
//begin
//   wndPost := TwndBasePost(ActiveMDIChild);
//   if wndPost = Nil then
//       exit;

//   wndPost.SavePost;
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.pbReadyToSendClick(Sender: TObject);
var
   wndPost : TwndBasePost;
begin
   If Not Assigned(ActiveMDIChild) then
       exit;

   if Not (ActiveMDIChild is TwndBasePost) then
       exit;

   wndPost := TwndBasePost(ActiveMDIChild);
   if Nil = wndPost then
       exit;

   // TODO 08.23.01 SavePost should save to draft
   // and a new fuction called 'Send' (or something)
   // should be created to move post to outbound folder
   wndPost.SavePost;
end;


{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.pbPrintClick(Sender: TObject);
begin
   mnFilePrintClick(Sender);
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.pbOpenEmailClick(Sender: TObject);
var
   wndActive : TwndFolder;
begin
   If Not Assigned(ActiveMDIChild) then
       exit;

   if Not (ActiveMDIChild is TwndFolder) then
       exit;

   wndActive := TwndFolder(ActiveMDIChild);
   if wndActive = Nil then
       exit;

   wndActive.OpenSelectedMsg;
end;

{
--------------------------------------------------------------------------------

}
// 05.20.02 Ha! fixed the most annoying bug around, i hope.
// apparently, I did not understand how casting works in delphi (or mayby in general)
// so I cast according to type expected for the operation.  makes sense. Duh!
procedure TwndMaxMain.pbDeleteClick(Sender: TObject);
begin
   If Not Assigned(ActiveMDIChild) then
       exit;

   if Not (ActiveMDIChild is TwndFolder) then
       exit;

   if ActiveMDIChild is TwndTrash then
       TwndTrash(ActiveMDIChild).DeleteSelectedMsg
   else
       TwndFolder(ActiveMDIChild).MoveToTrash;

end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.pbCheckMailClick(Sender: TObject);
begin
   PostMessage(Self.Handle, WM_HANDLE_CHECKMAIL, 0, 0);
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.pbSendNowClick(Sender: TObject);
begin
   PostMessage(Self.Handle, WM_HANDLE_SENDMAIL, 0, 0);
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.pbEncryptClick(Sender: TObject);
var
    wndEmail : TwndNotepad;
begin
   If Not Assigned(ActiveMDIChild) then
       exit;

   if Not (ActiveMDIChild is TwndNotepad) then
       exit;

   wndEmail := TwndNotepad(ActiveMDIChild);
   if wndEmail = Nil then
       exit;

   wndEmail.EncryptMsg;
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.pbDecryptClick(Sender: TObject);
var
    wndEmail : TwndNotepad;
begin
   If Not Assigned(ActiveMDIChild) then
       exit;

   if Not (ActiveMDIChild is TwndNotepad) then
       exit;

   wndEmail := TwndNotepad(ActiveMDIChild);
   if wndEmail = Nil then
       exit;

   wndEmail.DecryptMsg;
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.mnFileSetupGenuisClick(Sender: TObject);
var
   pcAppTitle : array[0..120] of Char;
begin
   if Not Assigned(g_oEmailAddr) then
      raise Exception.Create('g_oEmailAddr not assigned int TwndMaxMain.mnFileSetupGenuisClick');

   // we are not passing g_oEmailAddr object to the wizard...so we
   // need to save data, and reload it when the wizard is closed
   // TODO 06.05.02 pass object to wizard
   g_oEmailAddr.SaveToFile(g_oDirectories.ProgramDataPath + 'system.txt');
   StrPCopy(pcAppTitle, Application.Title + ' Wizard' + Chr(0));
   SetApplicationTitle(pcAppTitle);
   ShowSetupWizard(Self);
   g_oEmailAddr.LoadFromFile(g_oDirectories.ProgramDataPath + 'system.txt');
end;

{
--------------------------------------------------------------------------------
Our system timer fires every couple of seconds

the ideas of this timer event is:
1) check for when next check mail should occurr
2) flush data to disk so that in a crash less data loss will occur
3) TODO 06.05.02 auto send mail in outbound folder if option is checked....
}
procedure TwndMaxMain.ctlSystemTimer(Sender: TObject);
var
   nDateTimeDiff, nCount, nSystemInterval,
   nFileFlushInterval, nCheckEmailInterval : Integer;
   dtNow : TDateTime;

   // I hate embedded functions but this function is a low
   // use and TwndMaxMain is so fat now this makes it
   // easier to find
   function MinuteDiff(dtNow, dtThen : TDateTime) : Integer;
   var
       nUnused2, nUnused3,
       nThenHours, nNowHours,
       nThenMins, nNowMins : Word;
   begin
       DecodeTime(dtNow, nNowHours, nNowMins, nUnused2, nUnused3);
       DecodeTime(dtThen, nThenHours, nThenMins, nUnused2, nUnused3);

       if nThenMins > nNowMins then
           nNowMins := nNowMins + 60;

       MinuteDiff := Integer(nNowMins - nThenMins);
   end;

begin
   if Not Assigned(g_oRegistry) then
      raise Exception.Create('g_oRegistry not assigned in TwndMaxMain.ctlSystemTimer');

   ctlSystem.Enabled := FALSE;
   dtNow := Now;
   
   nCheckEmailInterval := g_oRegistry.CheckEmailInterval;
   nFileFlushInterval := g_oRegistry.FileFlushInterval;

   nSystemInterval := g_oRegistry.SystemRoutineInterval;

   ctlSystem.Interval := nSystemInterval;

   // we will only perform once action per firing of this
   // event as a means of preventing a noticable lag in application
   // performance
   nDateTimeDiff := MinuteDiff(dtNow, m_dtLastEmailCheck);
   if (0 < nCheckEmailInterval) AND
      (nCheckEmailInterval <= nDateTimeDiff) AND
      (rtfOn = g_oRegistry.CheckEmailFlag) then
   begin
       PostMessage(Self.Handle, WM_HANDLE_CHECKMAIL, 0, 0);
       ctlSystem.Enabled := TRUE;
       exit;
   end;

   nDateTimeDiff := MinuteDiff(dtNow, m_dtLastFlush);
   if (0 < nFileFlushInterval) AND
      (nFileFlushInterval <= nDateTimeDiff) then
   begin
       m_dtLastFlush := dtNow;
       // todo...we will eventuallly want to do the user folders too...
       for nCount := g_cnInFolder to g_cnDraftFolder do
       begin
           if Assigned(g_oFolders[nCount]) then
              g_oFolders[nCount].FlushToFile;
       end;

       if Assigned(g_oAddressBook) then
          g_oAddressBook.FlushToFile;
          
       ctlSystem.Enabled := TRUE;
       exit;
   end;

   ctlSystem.Enabled := TRUE;
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.mnHelpContentsClick(Sender: TObject);
var
   nCommandId : Integer;
begin
   // TODO...09.19.01  Place for dynamic help context
   if MDIChildCount = 0 then
   begin
       nCommandId := KEY_MAIN_SCREEN;
   end
   else
   begin
       nCommandId := KEY_FOLDERS;

       if Self.ActiveMDIChild is TwndBasePost then
           nCommandId := KEY_CREATE_EMAIL_EDITOR;
   end;


   if Not Assigned(g_oHelpEngine) then
       raise Exception.Create('Help Engine never created');
       
   g_oHelpEngine.HelpId := nCommandId;
   g_oHelpEngine.Show;


end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
   nCount : Integer;
   bCanClose : Boolean;
   oWnd : TForm;
begin
{ for each basepost window open...query until a) all have been queried or
  one of those queried say no to closing...
}

   bCanClose := TRUE;
   for nCount := Self.MDIChildCount - 1 downto 0 do
   begin
       oWnd := Self.MDIChildren[nCount];
       
       if NIL = oWnd then
           continue;

       if Not Assigned(oWnd) then
           continue;

       if oWnd is TwndBasePost then
       begin
           bCanClose := TwndBasePost(oWnd).CanCloseNow();
       end;

       if oWnd is TwndFolder then
       begin
           bCanClose := TwndFolder(oWnd).CanCloseNow();
       end;

       if bCanClose = FALSE then
           break;
   end;

   CanClose := bCanClose;
end;


{
--------------------------------------------------------------------------------
  =====================================
  Drag and Drop Routines
  =====================================
--------------------------------------------------------------------------------

}

procedure TwndMaxMain.ctlReceivedDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
   if ActiveMDIChild is TwndInbound then
       Accept := FALSE
   else
       Accept := TRUE;
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.ctlOutboundDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
   if ActiveMDIChild is TwndOutbound then
       Accept := FALSE
   else
       Accept := TRUE;
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.ctlCompletedDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
   if ActiveMDIChild is TwndComplete then
       Accept := FALSE
   else
       Accept := TRUE;

end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.ctlDraftDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
   if ActiveMDIChild is TwndDraft then
       Accept := FALSE
   else
       Accept := TRUE;
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.ctlTrashDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
   if ActiveMDIChild is TwndTrash then
       Accept := FALSE
   else
       Accept := TRUE;
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.ctlOutboundDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
   DragMessageToFolder(Source, ctlStatus, g_cnToSendFolder);
   ctlStatus.SimpleText := 'Message moved to ' + g_csOutboundName;
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.ctlReceivedDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
   DragMessageToFolder(Source, ctlStatus, g_cnInFolder);
   ctlStatus.SimpleText := 'Message moved to ' + g_csInboundName;
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.ctlCompletedDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
   DragMessageToFolder(Source, ctlStatus, g_cnOutFolder);
   ctlStatus.SimpleText := 'Message moved to ' + g_csCompleteName;
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.ctlDraftDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
   DragMessageToFolder(Source, ctlStatus, g_cnDraftFolder);
   ctlStatus.SimpleText := 'Message moved to ' + g_csDraftName;
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.ctlTrashDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
   DragMessageToFolder(Source, ctlStatus, g_cnTrashFolder);
   ctlStatus.SimpleText := 'Message moved to ' + g_csTrashName;
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.mnWindowCascadeClick(Sender: TObject);
begin
   Self.Cascade;
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.mnWindowTileClick(Sender: TObject);
begin
   Self.Tile;
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.mnWindowArrangeIconsClick(Sender: TObject);
begin
   Self.ArrangeIcons;
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.mnWindowNextClick(Sender: TObject);
begin
   Self.Next;
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.mnWindowPreviousClick(Sender: TObject);
begin
   Self.Previous;
end;


{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.mnHelpSubmitBugReportClick(Sender: TObject);
var
   oDlg : TdlgSubmitBug;
begin
//
//
//
   oDlg := TdlgSubmitBug.Create(Self);
   if Not Assigned(oDlg) then
       raise Exception.Create('oDlg not assigned in TwndMaxMain.mnHelpSubmitBugReportClick');
       
   CenterFormOverParent(Self, oDlg);
   oDlg.ShowModal;

end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.ctlQuickBarContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
   Handled := FALSE;
   m_ePopupMenuType := pmNone;
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.mnFoldersPopup(Sender: TObject);
begin

   if TToolButton(Sender) = pbFolders then
       m_ePopupMenuType := pmShowAll;

   mnFolderSep1.Visible := FALSE;
   mnFolderCheck.Visible := FALSE;
   mnFolderSend.Visible := FALSE;
   mnFolderEmptyTrash.Visible := FALSE;
   mnFolderSep2.Visible := FALSE;
   mnFolderIn.Visible := FALSE;
   mnFolderOut.Visible := FALSE;
   mnFolderSent.Visible := FALSE;
   mnFolderTrash.Visible := FALSE;
   mnFolderDraft.Visible := FALSE;

   case m_ePopupMenuType of
       pmNone, pmShowAll:
       begin
           mnFolderSep1.Visible := TRUE;
           mnFolderCheck.Visible := TRUE;
           mnFolderSend.Visible := TRUE;
           mnFolderEmptyTrash.Visible := TRUE;
           mnFolderSep2.Visible := TRUE;
           mnFolderIn.Visible := TRUE;
           mnFolderOut.Visible := TRUE;
           mnFolderSent.Visible := TRUE;
           mnFolderTrash.Visible := TRUE;
           mnFolderDraft.Visible := TRUE;
       end;
       pmInbound:
       begin
           mnFolderSep1.Visible := TRUE;
           mnFolderCheck.Visible := TRUE;
       end;
       pmOutbound:
       begin
           mnFolderSep1.Visible := TRUE;
           mnFolderSend.Visible := TRUE;
       end;
       pmSent:
       begin
       end;
       pmTrash:
       begin
           mnFolderSep1.Visible := TRUE;
           mnFolderEmptyTrash.Visible := TRUE;
       end;
       pmDraft:
       begin
           mnFolderSep1.Visible := TRUE;
           mnFolderDraft.Visible := TRUE;
       end;
       pmUserDefined:
       begin
       end;
   end;

   // back to default
   // the problem solved here is the toolbar dropdown button
   // does not fire an event (as part of the control, there
   // probably is a windows message) for us to set
   // m_ePopupMenuType to pmShowAll so we assume.
   // aint goin' a hurt anything
   m_ePopupMenuType := pmShowAll;

end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.ctlOutboundContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
   m_ePopupMenuType := pmOutbound;
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.ctlReceivedContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
   m_ePopupMenuType := pmInbound;
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.ctlCompletedContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
   m_ePopupMenuType := pmSent;
end;

procedure TwndMaxMain.ctlDraftContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
{
--------------------------------------------------------------------------------

}
   m_ePopupMenuType := pmDraft;
end;


{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.ctlTrashContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
   m_ePopupMenuType := pmTrash;
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.pbFoldersContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
   m_ePopupMenuType := pmTrash;
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.mnFolderInClick(Sender: TObject);
begin
   mnViewReceivedClick(Sender);
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.mnFolderOutClick(Sender: TObject);
begin
   mnViewToSendClick(Sender);
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.mnFolderSentClick(Sender: TObject);
begin
   mnViewCompleteClick(Sender);
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.mnFolderTrashClick(Sender: TObject);
begin
   mnViewTrashClick(Sender);
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.mnFolderDraftClick(Sender: TObject);
begin
   mnViewDraftClick(Sender);
end;


{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.mnFolderNewFolderClick(Sender: TObject);
begin
//
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.mnFolderCheckClick(Sender: TObject);
begin
    mnViewReceivedClick(Sender);
    wndInbound.CheckMail;
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.mnFolderSendClick(Sender: TObject);
begin
    mnViewToSendClick(Sender);
    wndOutbound.pbNowClick(Sender);
end;

{
--------------------------------------------------------------------------------

}
procedure TwndMaxMain.mnFolderEmptyTrashClick(Sender: TObject);
begin
   if Not Assigned(wndTrash) then
       wndTrash := TwndTrash.Create(Self);

   if Not Assigned(wndTrash) then
       raise Exception.Create('wndTrash not assigned in TwndMaxMain.mnFolderEmptyTrashClick');

   if wndTrash.Visible = FALSE then
       wndTrash.Visible := TRUE;

   ChildWndReceivedFocus(wfTrash);
   wndTrash.Show;

   wndTrash.EmptyTrash;
end;

{
--------------------------------------------------------------------------------

}

procedure TwndMaxMain.pbFoldersClick(Sender: TObject);
begin
   m_ePopupMenuType := pmShowAll;
   mnViewMoreClick(Sender);
end;

procedure TwndMaxMain.pbFoldersMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   m_ePopupMenuType := pmShowAll;
end;

procedure TwndMaxMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   if Not Assigned(g_oRegistry) then
      raise Exception.Create('g_oRegistry not assigned in TwndMaxMain.FormClose');

   // its possible that the shutdown message comes at a time
   // when the timer is busy doing his thing.  We use the
   // ctlSystem.Enabled property to tell if its doing something.
   // if ctlSystem.Enabled = false then the event fired.
   // TODO:  its better programming sense to use a critical section
   // or other tool.   Check into it.  Potential for shutdown to
   // fail if someting causes timer to never get set to true

   if 0 < abs(g_oRegistry.SystemRoutineInterval) then
   begin
       while FALSE = ctlSystem.Enabled do
       begin
           Sleep(0);
       end;
   end;
end;

procedure TwndMaxMain.FormDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin

   if Source Is TwndWinSockActivity then
       Accept := TRUE;

   if Source Is TwndMaxMain then
   begin
       Accept := TRUE;
   end;
end;

procedure TwndMaxMain.mnFilePrinterSetupClick(Sender: TObject);
begin

   if NOT Assigned(wndPrintOrPreview) then
       wndPrintOrPreview := TwndPrintOrPreview.Create(wndMaxMain);

   with wndPrintOrPreview do
   begin
       wndPrintOrPreview.Setup;
   end;

end;


procedure TwndMaxMain.mnFilePrintClick(Sender: TObject);
var
   bAndIncludeSetup : boolean;
begin
   if Sender = mnFilePrint then
       bAndIncludeSetup := true
   else
       bAndIncludeSetup := false;

   if ActiveMDIChild is TwndFolder then
       TwndFolder(ActiveMDIChild).PrintMsg(bAndIncludeSetup);

   if ActiveMDIChild is TwndBasePost then
       TwndBasePost(ActiveMDIChild).PrintMsg(bAndIncludeSetup);
       
end;

procedure TwndMaxMain.mnFilePreviewClick(Sender: TObject);
begin
   if ActiveMDIChild is TwndFolder then
       TwndFolder(ActiveMDIChild).PreviewMsg;

   if ActiveMDIChild is TwndBasePost then
       TwndBasePost(ActiveMDIChild).PreviewMsg;

end;

procedure TwndMaxMain.mnFileSaveAsClick(Sender: TObject);
var
   bHaveMessage : boolean;
   dlgMsg : TdlgDisplayMessage;
begin

   bHaveMessage := FALSE;

   if ActiveMDIChild is TwndFolder then
       bHaveMessage := TwndFolder(ActiveMDIChild).IsMessageSelected;

   if ActiveMDIChild is TwndBasePost then
       bHaveMessage := TwndBasePost(ActiveMDIChild).IsMessageSelected;

   if FALSE = bHaveMessage then
   begin
       dlgMsg := TdlgDisplayMessage.Create(Self);
       with dlgMsg do
       begin
           MessageType := dmtInfo;
           NoticeText := 'Information needed.';
           m_oDetailItems.Add('You have selected to save a message to a text file.  However, no message was selected.  Please select a message to save as text');
           DialogTitle := 'Please select a message.';
           Display;
           free;
       end;
       exit;
   end;

   with ctlSaveAs do
   begin
       InitialDir := g_oDirectories.UserDataPath;
       if true = Execute then
       begin
           if ActiveMDIChild is TwndFolder then
               TwndFolder(ActiveMDIChild).SaveMsgAs(FileName);

           if ActiveMDIChild is TwndBasePost then
               TwndBasePost(ActiveMDIChild).SaveMsgAs(FileName);

           dlgMsg := TdlgDisplayMessage.Create(Self);
           with dlgMsg do
           begin
               MessageType := dmtInfo;
               NoticeText := 'Message Saved.';
               m_oDetailItems.Add('Your message has been saved to the file "' + FileName + '".');
               DialogTitle := 'Message Saved.';
               Display;
               free;
           end;

       end;


   end;
end;

procedure TwndMaxMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
   if Ord(Key) = VK_F1 then
   begin
       mnHelpContentsClick(Sender);
   end;
end;

procedure TwndMaxMain.mnFolderHelpClick(Sender: TObject);
begin
   if Not Assigned(g_oHelpEngine) then
       raise Exception.Create('g_oHelpEngine not assigned in TwndMaxMain.mnFolderHelpClick');
       
   g_oHelpEngine.HelpId := KEY_MAIN_QUICKBAR;
   g_oHelpEngine.Show;

end;

procedure TwndMaxMain.mnViewShowPreviewClick(Sender: TObject);
var
   fTogglePreview : boolean;
begin

   if Not (ActiveMDIChild is TwndFolder) then
       exit;

   if FALSE = mnViewShowPreview.checked then
       fTogglePreview := TRUE
   else
       fTogglePreview := FALSE;

   mnViewShowPreview.Checked := fTogglePreview;
   TwndFolder(ActiveMDIChild).TogglePreview(fTogglePreview);


end;

procedure TwndMaxMain.FormResize(Sender: TObject);
begin
   ResetStatusBarSizes;
end;

procedure TwndMaxMain.ctlStatusDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
begin
//
{
with StatusBar1.Canvas do
  begin
    Brush.Color := clRed;
    FillRect(Rect);
    Font.Color := clYellow;
    ImageList1.Draw(StatusBar1.Canvas,Rect.Left,Rect.Top,Panel.Index);
    TextOut(Rect.left + 30, Rect.top + 2, 'Panel' + IntToStr(Panel.Index));
  end;
end;
}
end;

end.
