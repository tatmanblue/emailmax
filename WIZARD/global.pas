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
unit global;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, registry, basepane, edirectory, PbPathList;

var
   wndPanes : array[0..3] of TwndBasePane;
   g_nMaxPanes : Integer;
   g_oSytemFile : TStringList;
   g_oPath : String;
   g_bInitialInstall : Boolean;
   g_sApplicationTitle : String;
   g_oDirectories : TDirectoryControl;


const
   g_cnFirstPane = 0;
   g_cnSecondPane = 1;
   g_cnThirdPane = 2;
   g_cnFourthPane = 3;
   g_cmsgCREATE_MORE = WM_USER + 100;

function ShowSetupWizard(oParent : TForm) : Integer; export;
function ShowSetupWizardNoParent : Integer; export;
procedure SetApplicationTitle(newTitle : PChar); export;
function InstallCreateDirs : Integer ; export;
function WizardVersionStr(var pszVersion : PChar) : Integer; export;

function GetDllVerInfo() : String;

implementation

uses
   mainwiz;

function ShowSetupWizardNoParent() : Integer; export;
begin

   g_bInitialInstall := TRUE;

   dlgWizard := TdlgWizard.Create(Application);
   dlgWizard.ShowModal;
   ShowSetupWizardNoParent := dlgWizard.ModalResult;
   dlgWizard.free;

end;

function ShowSetupWizard(oParent : TForm) : Integer;
var
   vSize : variant;
begin
   if NIL = oParent then
       raise Exception.Create('Invalid Parent Component passed to "ShowSetupWizard"');

   g_bInitialInstall := FALSE;

   dlgWizard := TdlgWizard.Create(oParent);
   vSize := (oParent.Width div 2) - (dlgWizard.Width div 2);
   dlgWizard.Left := vSize;
   vSize := (oParent.Height div 2) - (dlgWizard.Height div 2);
   dlgWizard.Top := vSize;
   dlgWizard.ShowModal;
   ShowSetupWizard := dlgWizard.ModalResult;
   dlgWizard.free;
end;


function WizardVersionStr(var pszVersion : PChar) : Integer; export;
var
   strLocalVersion : String;
begin
   if Not Assigned(pszVersion) then
       exit;

   strLocalVersion := GetDllVerInfo();
   WizardVersionStr := Length(strLocalVersion);
   StrPCopy(pszVersion, strLocalVersion);
   
end;

{
  The purpose of InstallCreateDirs is to create the
  directories the installation will need...since
  we are using an old version of wise, it will not be
  able figure out application data directories from
  the shell interface.  InstallCreateDirs writes
  the values to the registry which the wise installation
  script reads from

}
function InstallCreateDirs() : Integer; export;
var
   oRegistry : TRegistry;
begin

   // hack of year
   // because the dlg creates the control for the path stuff
   // we'll create him here.
   dlgWizard := TdlgWizard.Create(Application);

   oRegistry := TRegistry.Create;

   with oRegistry do
   begin
       RootKey := HKEY_CURRENT_USER;
       OpenKey('SOFTWARE\microobjects\EmailMax2kInstall', TRUE);
       WriteString('DataPath', g_oDirectories.ProgramDataPath);
       WriteString('MailPath', g_oDirectories.MailFolderPath);

       CloseKey();
   end;

   // and we'll delete him here
   dlgWizard.free;
   InstallCreateDirs := 0;
end;

function EntryPoint11(hWnd : HWND) : LongInt; export;
begin
   InstallCreateDirs();
   EntryPoint11 := 1;
end;


procedure SetApplicationTitle(newTitle : PChar);
begin
   if Not Assigned(newTitle) then
       exit;
       
   g_sApplicationTitle := StrPas(newTitle);
end;

function GetDllVerInfo : string;
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
     dwVerInfoSize := GetFileVersionInfoSize(PChar('emailex.dll'), dwGetInfoSizeJunk);
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


end.
