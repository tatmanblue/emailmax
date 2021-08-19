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

unit eglobal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, OleCtrls, isp3, shellapi, registry,
  basfoldr,
  wndFolder,
  folder,
  alias,
  logfile,
  filterobject,
  ExceptionHandler,
  eregistry,
  edirectory,
  helpengine,
  addressbook;

type
  TPasswordAction = (paOnStartup, paOnSend, paOnCheck, paOnPasswordForEmail);
  // TODO I liked to move this here but there will be a circular reference without other changes
  // TWindowFocused = (wfNA, wfNew, wfRead, wfForward, wfOutbound, wfInbound, wfComplete, wfTrash, wfDraft, wfUser, wfContacts);

const g_csSecureKey = 'Software\Secure';
const g_csEmailmaxVersionInfoKey = 'EmailmaxVersionInfo';
const g_csEmailmaxControlKey = 'EmailmaxControl';
const g_csApplicationTitle = 'Emailmax 2K';
const g_csOutboundName = 'Out';
const g_csInboundName = 'In';
const g_csCompleteName = 'Done';
const g_csDraftName = 'Draft';
const g_csTrashName = 'Trash';
const g_csAttachFileExt = '.emt';
const g_csHeaderFileExt = '.emh';
const g_csLogFileName = 'emailmax2k.log';
const g_cnExternalVersion = 2002;
const g_csHelpFile = 'emailmax.hlp';

const g_cnCheckPasswordOnStart = 0;
const g_cnCheckPasswordOnSendMail = 1;
const g_cnCheckPasswordOnCheckMail = 2;

{
================================================================================
FROM: wndFolder.pas
================================================================================
}
const g_cnLowMsg  = 0;
const g_cnHiMsg = 256;

const g_cnNoMail = 0;
const g_cnHaveMail = 1;

const g_csTypeMail = 'M';
const g_csTypeUsenet = 'U';

{
================================================================================
FROM: folder.pas
================================================================================
}
const g_cnMINFOLDERFIELDS = 1;
const g_cnStatusField = 1;
const g_cnIsReadField = 2;
const g_cnMsgId = 3;
const g_cnAccountField = 4;
const g_cnFromField = 5;
const g_cnToField = 6;
const g_cnCCField = 7;
const g_cnBCCField = 8;
const g_cnDateField = 9;
const g_cnSubjectField = 10;
const g_cnFileNameField = 11;
const g_cnMAXFOLDERFIELDS = 11;

// for signatures and attachments we would need two extra elements
// signature would be a referenece to a signure entry
// attachments would be file names...

const g_ccharDelimiter = '|';

const g_cnInFolder = 0;                    // Inbound, in
const g_cnOutFolder = 1;                   // Done, Complete
const g_cnToSendFolder = 2;                // Outbound, out, ready to send
const g_cnTrashFolder = 3;
const g_cnDraftFolder = 4;
const g_cnFirstUserFolder = 5;
const g_cnMaxFoldersAllowed = 99;

var
   g_oFolders : array[0..5] of TFolder;    // TODO 08.10.01 finish user defined
   g_nMaxFoldersAvail : Integer;

{
================================================================================
FROM: alias.pas
================================================================================
}
const g_cnUsageType = 1;
const g_cnEmailAddr = 2;
const g_cnServer = 3;
const g_cnServerType = 4;
const g_cnIsDefault = 5;
const g_cnLeaveOnServer = 6;
const g_cnUserId = 7;
const g_cnPassword = 8;                // always leave this as the last field
const g_cnMaxFields = 8;


const g_cnServerSMTP = 1;
const g_cnServerPOP = 0;
const g_cnUsageSend = 0;
const g_cnUsageRecv = 1;
const g_cnUsageUsenet = 2;
const g_csNA = '<NA>';
const g_csDefault = '<DEF>';
const g_csAtSign = '@';
const g_csYes = '<YES>';
const g_csNo = '<NO>';
const g_csCRLF = Chr(13) + Chr(10);

{
================================================================================
FROM: filterobject.pas
================================================================================
}
const g_cnAccount = 1;
const g_cnText = 2;
const g_cnType = 3;
const g_cnAction = 4;
const g_cnCaseSensitive = 5;
const g_csAllAccounts = 'ALL';
const g_csAllAccountsDesc = 'All Email';


{
================================================================================
FROM: addressbook.pas
================================================================================
}

const g_cnLastNameField = 1;
const g_cnFirstNameField = 2;
const g_cnNickNameId = 3;
const g_cnEmail1Field = 4;
const g_cnEmail2Field = 5;
const g_cnEmail3Field = 6;
const g_cnPhone1Field = 7;
const g_cnPhone2Field = 8;
const g_cnPhone3Field = 9;
const g_cnAddress1Field = 10;
const g_cnAddress2Field = 11;
const g_cnAddress3Field = 12;
const g_cnCityField = 13;
const g_cnStateField = 14;
const g_cnCountryField = 15;
const g_cnZipField = 16;
const g_cnNotesField = 17;
const g_cnMINADDRFIELDS = g_cnLastNameField;
const g_cnMAXADDRFIELDS = g_cnNotesField;
const g_csAddressBookFileName = 'addresses.txt';

{
================================================================================
FROM: mdimax.pas
================================================================================
}

const WM_HANDLE_STARTUP = WM_USER + 100;
const WM_HANDLE_VALIDPURCHASE = WM_USER + 101;
const WM_HANDLE_LOGIN = WM_USER + 103;
const WM_HANDLE_CHECKMAIL = WM_USER + 104;
const WM_HANDLE_SENDMAIL = WM_USER + 105;
const WM_HANDLE_MDICHILD_CLOSES = WM_USER + 106;
const WM_HANDLE_WNDPOSTCREATION = WM_USER + 107; 

const EMAILMAX_ROOT_KEY = HKEY_CURRENT_USER;
const g_csBaseKey = 'SOFTWARE\microobjects\EmailMax2k';

{
================================================================================
================================================================================
}


procedure CenterFormOverParent(oParent, oChild : TForm);
procedure DoPreWindowCreationInitialize;
procedure DragMessageToFolder(oSource : TObject; oStatus : TStatusBar; nDestFolderId : Integer);
//procedure EmailmaxWaitCursor;
//procedure EmailmaxDefaultCursor;
procedure Replace(sThis, sThat : String; var sStr : String);
function DecryptAliasPassword(sPassword : String) : String;
function EmailmaxCreateProcess(strCommandLine : String; fWaitForCompletion : Boolean; var hProcessHandle : DWORD): DWORD;
function EmailmaxShellExecute(strVerb, strCommand : String): DWORD;
function EmailmaxFileCopy(strSrc, strDest : String) : boolean;
function EncryptAliasPassword(sPassword : String) : String;
function GetVerInfo : string;
function GetEmailmaxWizardVerInfo : String;

function WizardVersionStr(pszVersion : PChar) : Integer; external 'emailex.dll';

var
  g_bShowExceptions : Boolean;
  g_bApplicationIsShutDown : Boolean;
  g_oEmailAddr : TEmailAlias;
  g_oAddressBook : TAddressBook;
  g_oSignatures : TSignatureAlias;         // not implemented
  g_oLogFile : TLogFile;
  g_oEmailFilters  : TFilterList;
  g_oExceptionHandler : TExceptionHandler;
  g_oRegistry : TERegistry;
  g_oHelpEngine : THelpEngine;
  g_oDirectories : TDirectoryControl;

implementation

uses
   mdimax, encryption;

procedure DoPreWindowCreationInitialize;
begin

   g_bApplicationIsShutDown := FALSE;
   g_oExceptionHandler := TExceptionHandler.Create();
   if Not Assigned(g_oExceptionHandler) then
      raise Exception.Create('g_oExceptionHandler not assigned in DoPreWindowCreationInitialize.');

   Application.OnException := g_oExceptionHandler.HandlerFunction;

   // TODO 05.23.02
   // maybe its time to put this code below to end of function in TwndMain.Create

   g_oHelpEngine := THelpEngine.Create;
   if Not Assigned(g_oHelpEngine) then
      raise Exception.Create('g_oHelpEngine not assigned in DoPreWindowCreationInitialize.');

   g_oRegistry := TERegistry.Create;
   if Not Assigned(g_oRegistry) then
      raise Exception.Create('g_oRegistry not assigned in DoPreWindowCreationInitialize.');

   g_oRegistry.Load();

   g_oDirectories := TDirectoryControl.Create(wndMaxMain.ctlPaths);
   if Not Assigned(g_oDirectories) then
      raise Exception.Create('g_oDirectories not assigned in DoPreWindowCreationInitialize.');

   g_bLogEncryption := FALSE;
   g_bShowExceptions := FALSE;

   if TRUE = g_oRegistry.ValueExists('OneTimeStartup') then
   begin
       if TRUE = g_oRegistry.ReadBool('OneTimeStartup') then
       begin
           g_oHelpEngine.HelpId := KEY_WHATS_NEW;
           g_oHelpEngine.Show;
           g_oRegistry.WriteBool('OneTimeStartup', FALSE);
           g_oRegistry.DeleteValue('OneTimeStartup');
       end;
   end;

   g_oAddressBook := TAddressBook.CreateFromFile(g_oDirectories.ProgramDataPath + g_csAddressBookFileName);

end;

procedure Replace(sThis, sThat: String; var sStr : String);
var
   nPos : Integer;
   sWork, sComplete : String;
begin
  sWork := sStr;
  nPos := Pos(sThis, sWork);
  sComplete := Copy(sWork, 0, nPos - 1);
  sComplete := sComplete + sThat + Copy(sWork, nPos + 1, Length(sWork));
  sStr := sComplete;

end;

procedure DragMessageToFolder(oSource : TObject; oStatus : TStatusBar; nDestFolderId : Integer);
var
   ctlMessages : TListView;
   oItem : TlistItem;
   oActiveFolder : TwndFolder;
   sMsg : String;
   nFromFolderId : Integer;
begin
   try
       oActiveFolder := (Application.MainForm.ActiveMdiChild as TwndFolder);
       nFromFolderId := oActiveFolder.FolderId;
       ctlMessages := (oSource as TListView);
       oItem := ctlMessages.ItemFocused;
       sMsg := g_oFolders[nFromFolderId].Strings[oItem.Index];
       // TODO...use TBaseEmail object
       g_oFolders[nDestFolderId].AddMsgStatusAttached(sMsg);
       g_oFolders[nFromFolderId].Delete(oItem.Index);
       ctlMessages.Items.Delete(oItem.Index);
   except
   end
end;

procedure CenterFormOverParent(oParent, oChild : TForm);
begin
   if Not Assigned(oChild) then
       raise Exception.Create('oChild not Assigned in CenterFormOverParent.');

   if Not Assigned(oParent) then
       raise Exception.Create('oParent not Assigned in CenterFormOverParent.');

   oChild.Left := oParent.Left + (oParent.Width div 2) - (oChild.Width div 2);
   oChild.Top := oParent.Top + (oParent.Height div 2) - (oChild.Height div 2);
end;
{
procedure EmailmaxWaitCursor;
begin
   try
       Screen.Cursor := Screen.Cursors[crHourGlass];
   except
   end;
end;

procedure EmailmaxDefaultCursor;
begin
   try
       Screen.Cursor := Screen.Cursors[crDefault];
   except
   end;
end;
}

function EmailmaxShellExecute(strVerb, strCommand : String): DWORD;
var
   szCommand, szFile : array[0..254] of char;
begin
   ZeroMemory(@szCommand, 254);
   ZeroMemory(@szFile, 254);
   StrPCopy(szCommand, strVerb);
   StrPCopy(szFile, strCommand);

   EmailmaxShellExecute := ShellExecute(Application.Handle, szCommand, szFile, 0, 0, SW_NORMAL);
end;

function EmailmaxCreateProcess(strCommandLine : String; fWaitForCompletion : Boolean; var hProcessHandle : DWORD): DWORD;
var
   dwExitCode : DWORD;
   stStart : TStartupInfo;
   stProc : TProcessInformation;
   fRet : Boolean;
   chText : array [0..255] of Char;
begin

   dwExitCode := 0;

   if 254 < Length(Trim(strCommandLine)) then
       raise Exception.Create('strCommandLine, passed to EmailmaxCreateProcess, exceeds 254 chars');

   StrPCopy(chText, Trim(strCommandLine));

   ZeroMemory(@stStart, sizeof(stStart));
   stStart.cb := sizeof(stStart);

   fRet := CreateProcess(Nil, chText, Nil, Nil, FALSE, CREATE_DEFAULT_ERROR_MODE, Nil, Nil, stStart, stProc);

   if fRet then
   begin
       hProcessHandle := stProc.hProcess;
       if TRUE = fWaitForCompletion then
       begin
           WaitForSingleObject(hProcessHandle, INFINITE);
           CloseHandle(hProcessHandle);
       end;
   end
   else
   begin
       dwExitCode := GetLastError();
   end;

   EmailmaxCreateProcess := dwExitCode;

end;

function EmailmaxFileCopy(strSrc, strDest : String) : boolean;
var
   oSrcFile, oDestFile : File;
   szBuf: array[1..2048] of Char;
   nBytesRead, nBytesWritten: Integer;
begin

  AssignFile(oSrcFile, strSrc);
  AssignFile(oDestFile, strDest);
  Reset(oSrcFile, 1);
  if FileExists(strDest) then
     Reset(oDestFile, 1)
  else
     Rewrite(oDestFile, 1);

  repeat
      BlockRead(oSrcFile, szBuf, SizeOf(szBuf), nBytesRead);
      BlockWrite(oDestFile, szBuf, nBytesRead, nBytesWritten);
  until (nBytesRead = 0) or (nBytesWritten <> nBytesRead);

  CloseFile(oDestFile);
  CloseFile(oSrcFile);

  EmailmaxFileCopy := TRUE;
end;

function getVerInfo : string;
var
    dwVerInfoSize,                 // holds the size of the version info resource
    dwGetInfoSizeJunk : DWORD;     // a junk variable, its value is ignored
    pVersionInfo,                  // points to the version info resource
    Translation,     // holds version info translation table
    InfoPointer : Pointer;     // a pointer to version information
    VersionInfoSize : UINT;    // holds the size of version information
    VersionValue : string;     // holds the version info request string
begin
     // Fill Program Version
     // retrieve the size of the version information resource, if one exists
     dwVerInfoSize := GetFileVersionInfoSize(PChar(Application.ExeName), dwGetInfoSizeJunk);
     // retrieve enough memory to hold the version resource
     GetMem(pVersionInfo, dwVerInfoSize);
     try
        // retrieve the version resource for the selected file
        GetFileVersionInfo(PChar(Application.ExeName), 0, dwVerInfoSize, pVersionInfo);
        // retrieve a pointer to the translation table
        VerQueryValue(pVersionInfo, '\\VarFileInfo\\Translation', Translation, VersionInfoSize);
        // initialize the version value request string
        VersionValue := '\\StringFileInfo\\' +
                        intToHex(loWord(longInt(Translation^)),4) +
                        intToHex(hiWord(longInt(Translation^)),4) +
                        '\\';
        // retrieve file version
        VerQueryValue(pVersionInfo, PChar(VersionValue + 'FileVersion'), InfoPointer, VersionInfoSize);
        result := string(PChar(InfoPointer));
        // retrieve and display file build flags
        if VerQueryValue(pVersionInfo, '\', InfoPointer, VersionInfoSize) then
        begin
           if BOOL(TVSFixedFileInfo(InfoPointer^).dwFileFlags and VS_FF_DEBUG) then
              result := result + '(Debug)';

           if BOOL(TVSFixedFileInfo(InfoPointer^).dwFileFlags and VS_FF_PRERELEASE) then
              result := result + '(Pre-Release)';
           if BOOL(TVSFixedFileInfo(InfoPointer^).dwFileFlags and VS_FF_PATCHED) then
              result := result + '(Patched)';
           if BOOL(TVSFixedFileInfo(InfoPointer^).dwFileFlags and VS_FF_PRIVATEBUILD) then
              result := result + '(Private Build)';
           if BOOL(TVSFixedFileInfo(InfoPointer^).dwFileFlags and VS_FF_INFOINFERRED) then
              result := result + '(Information Inferred)';
           if BOOL(TVSFixedFileInfo(InfoPointer^).dwFileFlags and VS_FF_SPECIALBUILD) then
              result := result + '(Special Build)';
        end;
     finally
        freeMem(pVersionInfo);
     end;
end;

function DecryptAliasPassword(sPassword : String) : String;
var
   oPassword : TEncrypt;
begin
   oPassword := TEncrypt.Create;
   if Not Assigned(oPassword) then
      raise Exception.Create('oPassword not assigned in DecryptAliasPassword');

   oPassword.EncryptedString := sPassword;
   oPassword.Decrypt;
   DecryptAliasPassword := oPassword.SourceString;
   oPassword.free();
end;

function EncryptAliasPassword(sPassword : String) : String;
var
   oPassword : TEncrypt;
begin
   oPassword := TEncrypt.Create;
   if Not Assigned(oPassword) then
      raise Exception.Create('oPassword not assigned in EncryptAliasPassword');

   oPassword.SourceString := sPassword;
   oPassword.Encrypt;
   EncryptAliasPassword := oPassword.EncryptedString;
   oPassword.free();
end;

function GetEmailmaxWizardVerInfo : String;
var
   strVersion : String;
   szVersion : array[0..255] of Char;
begin
   ZeroMemory(@szVersion, sizeof(szVersion));

   WizardVersionStr(szVersion);
   strVersion := StrPas(szVersion);
   GetEmailmaxWizardVerInfo := strVersion;
end;

end.
