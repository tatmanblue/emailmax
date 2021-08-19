// copyright (c) 2002 by microObjects inc.
//
// Emailmax source is distributed under the public
// domain license arrangements.  You are free to
// modify, edit, copy, delete, or redistribute
// the emailmax code as long as you 1) indemnify and hold harmless
// microObjects inc and its employees and owners
// from any and all liablity, directly or indirectly,
// related to the use, modification or distribution
// of this code 2) and make proper credit where
// applicable.
program emailmax;
{
   Some things to do:
      1)  There are some redundant/duplicate objects...
             FolderMsg, Etc... maybe consolidate them, or
             make otherwise make it less confusing

}




uses
  Forms,
  mdimax in 'mdimax.pas' {wndMaxMain},
  news in 'news.pas' {dlgNewsgroup},
  result in 'result.pas' {dlgResults},
  setup in 'setup.pas' {dlgSetup},
  alias in 'alias.pas',
  displmsg in 'displmsg.pas' {dlgDisplayMessage},
  outbound in 'outbound.pas' {wndOutbound},
  dispync in 'dispync.pas' {dlgDisplayYesNoCancel},
  folder in 'folder.pas',
  basfoldr in 'basfoldr.pas',
  wndfolder in 'wndfolder.pas' {wndFolder},
  about in 'about.pas' {dlgAbout},
  inbound in 'inbound.pas' {wndInbound},
  trash in 'trash.pas' {wndTrash},
  complete in 'complete.pas' {wndComplete},
  foldlist in 'foldlist.pas' {dlgFolderList},
  dispyn in 'dispyn.pas' {dlgDisplayYesNo},
  basepost in 'basepost.pas' {wndBasePost},
  notepad in 'notepad.pas' {wndNotepad},
  splash in 'splash.pas' {wndSplash},
  dlgEPGP in 'dlgEPGP.pas' {dlgPgpEncrypt},
  dlgSelDc in 'dlgSelDc.pas' {dlgSelectDecrypt},
  usenet in 'usenet.pas' {wndUsenetMsg},
  addreml in 'addreml.pas' {dlgAddRemailer},
  addnews in 'addnews.pas' {dlgAddNewsGroup},
  eglobal in 'eglobal.pas',
  dlgECeas in 'dlgECeas.pas' {dlgEncryptCeaser},
  dlgactst in 'dlgactst.pas' {dlgEmailAcctSetup},
  savemsg in 'savemsg.pas',
  dlgpass in 'dlgpass.pas' {dlgPassword},
  wndsock in 'wndsock.pas' {wndWinSockActivity},
  dlgattch in 'dlgattch.pas' {dlgAttachFiles},
  filterobject in 'objects\filterobject.pas',
  dlgEMD5 in 'dlgEMD5.pas' {dlgMD5Handler},
  encryption in 'objects\encryption.pas',
  dlgshutdown in 'dlgshutdown.pas' {dlgShutdownInfo},
  logfile in 'objects\logfile.pas',
  dlgSubmitBugReport in 'dlgSubmitBugReport.pas' {dlgSubmitBug},
  Email in 'objects\Email.pas',
  dlgspamctl in 'dlgspamctl.pas' {dlgSpamControl},
  basesetuptab in 'objects\basesetuptab.pas' {dlgBaseSetupTab},
  wndPrintPreview in 'wndPrintPreview.pas' {wndPrintOrPreview},
  eregistry in 'objects\eregistry.pas',
  ExceptionHandler in 'objects\ExceptionHandler.pas',
  helpengine in 'objects\helpengine.pas',
  DsgnIntf in '..\..\..\..\Program Files\Borland\Delphi5\Source\Toolsapi\dsgnintf.pas',
  draft in 'draft.pas' {wndDraft},
  dlgAddEmailAddr in 'dlgAddEmailAddr.pas' {dlgAddEmailAddress},
  wndNewMailDisplay in 'wndNewMailDisplay.pas' {wndNewMail},
  addressbook in 'objects\addressbook.pas',
  dlgSelectAttach in 'dlgSelectAttach.pas' {dlgSelectAttachments},
  dlgAttachAction in 'dlgAttachAction.pas' {dlgAttachmentAction},
  edirectory in 'objects\edirectory.pas',
  dlgNewEmailAddress in 'dlgNewEmailAddress.pas' {NewEmailAddress};

{$R *.res}

begin
  Application.Initialize;
  //DoPreWindowCreationInitialize;
  // do not use eglobal g_csApplicationTitle constant...import problems
  Application.Title := 'Emailmax 2K';
  Application.HelpFile := 'Emailmax.hlp';
  Application.CreateForm(TwndMaxMain, wndMaxMain);
  Application.Run;
end.
