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
unit eregistry;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ToolWin, ComCtrls, OleCtnrs, ExtCtrls, StdCtrls,
  registry;


type
   TRegistryToggleFlags = (rtfOff, rtfOn);
   TRegistryAttachmentTypes = (ratMime, ratUUEncode);

   TERegistry = class(TRegistry)

   protected
       m_nCheckEmailInterval,
       m_nFileFlushInterval,
       m_nSystemRoutineInterval : Word;

       m_rtfCaesarUseNums,
       m_rtfUseToolTips,
       // m_rtfDeleteMail,
       m_rtfSysPass,
       m_rtfEmptyOnExit,
       m_rtfMaximize,
       m_rtfPostNewsViaNewsServer,
       m_rtfFoldersToolbar,
       m_rtfIconsPanel,
       m_rtfCheckEmailFlag,
       m_rtfShowPreview : TRegistryToggleFlags;

       m_ratAttachmentEncoding : TRegistryAttachmentTypes;

       m_sWorkFromDir,                 // where is emailmax installed?
       m_sPasswordOptions,
       m_sPGPPath,                     // where is pgp installed ?
       m_sWorkingPath,
       m_sPGPSigId,
       m_sCaesarDefault,
       m_sSysPassword,
       m_sBealSrc,
       m_sAttachPath,
       m_sMaxControl,
       m_sVersionInfo : String;

       m_fIsOpen : boolean;

       function GetPasswordOption(nIndex : Integer) : Integer;
       //function GetPasswordOption() : TRegistryToggleFlags;
       procedure SetPasswordOption(nIndex : Integer; eValue : Integer);
       //procedure SetPasswordOption(eValue : TRegistryToggleFlags);

       function GetSystemPassword() : String;
       procedure SetSystemPassword(sUnencyptedPassword : String);

   public
       constructor Create; overload;
       destructor Free; overload;
       procedure Load;
       procedure Save;
       procedure Flush;
       procedure Close;

   published
       property WorkFromDir : String read m_sWorkFromDir write m_sWorkFromDir;
       property PGPPath : String read m_sPGPPath write m_sPGPPath;
       property WorkingPath : String read m_sWorkingPath write m_sWorkingPath;
       property PGPSigId : String read m_sPGPSigId write m_sPGPSigId;
       property CaesarDefault : String read m_sCaesarDefault write m_sCaesarDefault;
       property SysPassword : String read GetSystemPassword write SetSystemPassword;
       property BealSrc : String read m_sBealSrc write m_sBealSrc;
       property AttachPath : String read m_sAttachPath write m_sAttachPath;
       property MaxControl : String read m_sMaxControl write m_sMaxControl;
       property VersionInfo : String read m_sVersionInfo write m_sVersionInfo;

       property AttachmentEncoding : TRegistryAttachmentTypes read m_ratAttachmentEncoding write m_ratAttachmentEncoding default ratMime;

       property PasswordOptions : String read m_sPasswordOptions write m_sPasswordOptions;

       property CaesarUseNums : TRegistryToggleFlags read m_rtfCaesarUseNums write m_rtfCaesarUseNums default rtfOff;
       property UseToolTips : TRegistryToggleFlags read m_rtfUseToolTips write m_rtfUseToolTips default rtfOff;
       // property DeleteMail : TRegistryToggleFlags read m_rtfUseToolTips write m_rtfUseToolTips default rtfOff;
       property SysPass : TRegistryToggleFlags read m_rtfSysPass write m_rtfSysPass default rtfOff;
       property EmptyOnExit : TRegistryToggleFlags read m_rtfEmptyOnExit write m_rtfEmptyOnExit default rtfOff;
       property Maximize : TRegistryToggleFlags read m_rtfMaximize write m_rtfMaximize default rtfOff;
       property PostNewsViaNewsServer : TRegistryToggleFlags read m_rtfPostNewsViaNewsServer write m_rtfPostNewsViaNewsServer default rtfOff;
       property FoldersToolbar : TRegistryToggleFlags read m_rtfFoldersToolbar write m_rtfFoldersToolbar default rtfOff;
       property IconsPanel : TRegistryToggleFlags read m_rtfIconsPanel write m_rtfIconsPanel default rtfOff;
       property CheckEmailFlag : TRegistryToggleFlags read m_rtfCheckEmailFlag write m_rtfCheckEmailFlag default rtfOff;
       property ShowPreview : TRegistryToggleFlags read m_rtfShowPreview write m_rtfShowPreview default rtfOff;

       property CheckEmailInterval : Word read m_nCheckEmailInterval write m_nCheckEmailInterval;
       property FileFlushInterval : Word read m_nFileFlushInterval write m_nFileFlushInterval;
       property SystemRoutineInterval : Word read m_nSystemRoutineInterval write m_nSystemRoutineInterval;

   end;


implementation

uses
   eglobal;

// ===============================================================================
//
// ===============================================================================
function TERegistry.GetPasswordOption(nIndex : Integer) : Integer;
//function TERegistry.GetPasswordOption() : TRegistryToggleFlags;
begin
end;

// ===============================================================================
//
// ===============================================================================
procedure TERegistry.SetPasswordOption(nIndex : Integer; eValue : Integer);
//procedure TERegistry.SetPasswordOption(eValue : TRegistryToggleFlags);
begin
end;

// ===============================================================================
//
// ===============================================================================
function TERegistry.GetSystemPassword() : String;
begin
end;

// ===============================================================================
//
// ===============================================================================
procedure TERegistry.SetSystemPassword(sUnencyptedPassword : String);
begin
end;

// ===============================================================================
//
// ===============================================================================
constructor TERegistry.Create;
begin
   inherited;
   m_fIsOpen := false;
end;

// ===============================================================================
//
// ===============================================================================
destructor TERegistry.Free;
begin
   try
       // just in case, catch all
       CloseKey;
   except
   end;
end;


// ===============================================================================
//
// ===============================================================================
procedure TERegistry.Load;
begin
    try
       // Just in case we were already open
       // and caller forgot to close us first
       try
           Close;
       except
       end;

       RootKey := EMAILMAX_ROOT_KEY;
       OpenKey(g_csBaseKey, TRUE);
       m_fIsOpen := true;

       m_sWorkFromDir := ReadString('WorkFromDir');
       if 0 = Length(Trim(m_sWorkFromDir)) then
           m_sWorkFromDir := ReadString('WorkingPath');

       if 0 = ReadInteger('FoldersToolbar') then
           m_rtfFoldersToolbar := rtfOff
       else
           m_rtfFoldersToolbar := rtfOn;

       if 0 = ReadInteger('IconsPanel') then
           m_rtfIconsPanel := rtfOff
       else
           m_rtfIconsPanel := rtfOn;

       if 0 = ReadInteger('UseToolTips') then
           m_rtfUseToolTips := rtfOff
       else
           m_rtfUseToolTips := rtfOn;

       if 0 = ReadInteger('Maximize') then
           m_rtfMaximize := rtfOff
       else
           m_rtfMaximize := rtfOn;

       if 0 = ReadInteger('EmptyOnExit')then
           m_rtfEmptyOnExit := rtfOff
       else
           m_rtfEmptyOnExit := rtfOn;

       if 0 = ReadInteger('CheckEmailFlag') then
           m_rtfCheckEmailFlag := rtfOff
       else
           m_rtfCheckEmailFlag := rtfOn;

       m_nCheckEmailInterval := abs(ReadInteger('CheckEmailInterval'));
       m_nFileFlushInterval := abs(ReadInteger('FileFlushInterval'));
       m_nSystemRoutineInterval := abs(ReadInteger('SystemRoutineInterval'));

       m_sPGPPath := ReadString('PGPPath');

       // TODO...9.18.01 get PasswordOptions working right
       m_sPasswordOptions := ReadString('PasswordOptions');
       if 0 = Length(m_sPasswordOptions) then
           m_sPasswordOptions := '000';

       m_sSysPassword := ReadString('SysPassword');

       if 0 = ReadInteger('ShowPreview') then
           m_rtfShowPreview := rtfOff
       else
           m_rtfShowPreview := rtfOn;

    except
       m_rtfFoldersToolbar := rtfOn;
       m_rtfUseToolTips := rtfOn;
       m_rtfIconsPanel := rtfOn;

       m_rtfEmptyOnExit := rtfOff;
       m_rtfMaximize := rtfOff;
       m_rtfCheckEmailFlag := rtfOff;
       m_rtfShowPreview := rtfOff;
       // m_rtfDeleteMail := rtfOff

       m_nCheckEmailInterval := 0;
       m_nFileFlushInterval := 0;
       m_nSystemRoutineInterval := 1500;

       m_sWorkFromDir := '';
       m_sPGPPath := '';
       m_sSysPassword := '';

       // TODO...9.18.01 get PasswordOptions working right
       m_sPasswordOptions := '000';
    end;

end;

// ===============================================================================
//
// ===============================================================================
procedure TERegistry.Save;
begin
   try
       try
           Close;
       except
       end;

       RootKey := EMAILMAX_ROOT_KEY;
       OpenKey(g_csBaseKey, TRUE);
       m_fIsOpen := true;
       WriteString('WorkFromDir', m_sWorkFromDir);
       WriteString('WorkingPath', m_sWorkFromDir);

       // TODO 1.11.02 complete TERegistry.Save
       //
   except
       MessageDlg('Unable to save application settings.  This may mean that your user account for this PC is not authorized to save application settings.', mtWarning, [mbOK], 0);
   end;
end;

// ===============================================================================
//
// ===============================================================================
procedure TERegistry.Flush;
begin
    Save();
end;

// ===============================================================================
//
// ===============================================================================
procedure TERegistry.Close;
begin
    try
       // close can never call save because save calls close...
       // 
       CloseKey;
    except
    end;
end;


end.
