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

unit edirectory;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ToolWin, ComCtrls, OleCtnrs, ExtCtrls, StdCtrls,
  registry, folder, ImgList, shellapi, OleCtrls, PBPathList;

type
   TDirectoryControl = class(TObject)

   private
       m_ctlPathsRef: TPBPathList;

       m_sAttachPath,                // where do incoming attachments get saved
                                     // if the user overrides in setup, then
                                     // the value comes from the registry
       m_sMailFolderPath,            // where does mail get saved
       m_sProgramPath,               // Location of EXE (install dir)
       m_sProgramDataPath,           // where is system.txt, filters.txt, etc...
       m_sLogFilePath,               // where does the log file get written
       m_sUserDataPath,              // users My Documents
       m_sEncryptPath : String;      // where does default encryption work occur...
                                     // (if user overrides in setup, then
                                     // the value comes from registry

   public
      constructor Create; overload;
      constructor Create(ctlPaths: TPBPathList); overload;

      procedure Initialize(ctlPaths: TPBPathList);

   published
      property AttachmentPath : String read m_sAttachPath;
      property EncryptionPath : String read m_sEncryptPath;
      property LogfilePath : String read m_sLogFilePath;
      property MailFolderPath : String read m_sMailFolderPath;
      property ProgramDataPath : String read m_sProgramDataPath;
      property ProgramPath : String read m_sProgramPath;
      property UserDataPath : String read m_sUserDataPath;
   end;

implementation

uses
    FileCtrl, eglobal, eregistry;

constructor TDirectoryControl.Create();
begin
   inherited;
end;

constructor TDirectoryControl.Create(ctlPaths : TPBPathList);
begin
   Create;

   Initialize(ctlPaths);

end;

procedure TDirectoryControl.Initialize(ctlPaths: TPBPathList);
begin
   if Not Assigned(ctlPaths) then
      raise Exception.Create('ctlPaths is not assigned in TDirectoryControl.Create.');

   //
   //if Not Assigned(g_oRegistry) then
   //   raise Exception.Create('g_oRegistry is not assigned in TDirectoryControl.Create.');

   // create this stuff and if its already there, no big deal...one hopes
   CreateDir(ctlPaths['%APPDATA%'] + '\microobjects');
   CreateDir(ctlPaths['%APPDATA%'] + '\microobjects\emailmax2k');

   m_sUserDataPath := ctlPaths['%PERSONAL%'];
   m_sEncryptPath := ctlPaths['%APPDATA%'] + '\microobjects\emailmax2k\Temp';
   m_sAttachPath := ctlPaths['%APPDATA%'] + '\microobjects\emailmax2k\Attach';
   m_sMailFolderPath := ctlPaths['%APPDATA%'] + '\microobjects\emailmax2k\Mail';
   m_sProgramDataPath := ctlPaths['%APPDATA%'] + '\microobjects\emailmax2k\Data';
   m_sLogFilePath := m_sProgramDataPath;

   if Not Assigned(g_oRegistry) then
      m_sProgramPath := ExtractFilePath(Application.ExeName)
   else
      m_sProgramPath := g_oRegistry.WorkFromDir;

   if FALSE = DirectoryExists(m_sEncryptPath) then
       if FALSE = CreateDir(m_sEncryptPath) then
           raise Exception.Create('Cannot create ' + m_sEncryptPath);

   if FALSE = DirectoryExists(m_sAttachPath) then
       if FALSE = CreateDir(m_sAttachPath) then
           raise Exception.Create('Cannot create ' + m_sAttachPath);

   if FALSE = DirectoryExists(m_sMailFolderPath) then
       if FALSE = CreateDir(m_sMailFolderPath) then
           raise Exception.Create('Cannot create ' + m_sMailFolderPath);

   if FALSE = DirectoryExists(m_sProgramDataPath) then
       if FALSE = CreateDir(m_sProgramDataPath) then
           raise Exception.Create('Cannot create ' + m_sProgramDataPath);

   if FALSE = DirectoryExists(m_sLogFilePath) then
       if FALSE = CreateDir(m_sLogFilePath) then
           raise Exception.Create('Cannot create ' + m_sLogFilePath);

   m_sEncryptPath := m_sEncryptPath + '\';
   m_sAttachPath := m_sAttachPath  + '\';
   m_sMailFolderPath := m_sMailFolderPath + '\';
   m_sProgramDataPath := m_sProgramDataPath + '\';
   m_sLogFilePath := m_sLogFilePath + '\';
   m_sUserDataPath :=  m_sUserDataPath + '\';
   m_sProgramPath := m_sProgramPath + '\';

end;


end.
