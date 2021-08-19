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

unit folder;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, syncobjs, basfoldr, email, wndFolder;


type
   EFolderExeception = class(Exception)
   private
       m_fSafeToIgnore : Boolean;
   public
       // constructor Create(sMsg : String; fSafe : Boolean); overload;
       // constructor Create(sMsg : String); overload;
   published
       property SafeToIgnore : Boolean read m_fSafeToIgnore write m_fSafeToIgnore;
   end;
{
   A folder represents the areas where mail is stored.  There are several
   default areas (In, Out, ToBeSent, Trash) and the user can define more

   format is comma delimited with the following fields defined

   8.17.01 this is old information:
   status, from, to, date, subect, messagefilename
   EG:

   1, mattr@clientlink.com, mattr@microobjects.com, test, 432dawet.emx

}
type
   TRecordStatus = (rsSent, rsError, rsNew, rsRead, rsUnimportant);
   TWindowFocused = (wfNA, wfNew, wfRead, wfForward, wfOutbound, wfInbound, wfComplete, wfTrash, wfDraft, wfUser, wfContacts);
   TFolder  = class(TBaseFolder)
   protected
       m_bFolderOpen : Boolean;

       m_frmDisplay : TwndFolder;

   public
       constructor Create;
       constructor CreateFromFile(sFileName : String);
       destructor Destroy; override;

       function GetTo: String;
       function GetCC: String;
       function GetBCC: String;
       function GetAccount: String;
       function GetIsRead : Boolean;

       function GetFrom: String;
       function GetDate: String;
       function GetSubject: String;
       function GetFileName: String;
       function GetMessageId: String;
       function GetStatus: Integer;

       procedure DeleteMsg; override;
       procedure AddMsg(sData : String); override;
       procedure AddMsgWithStatus(nStatus : Integer; sData : String); virtual;
       procedure AddMsgStatusAttached(sData : String); virtual;

       function FindMessage(sMessageId : String) : Integer;

       // CHG 1.11.02
       procedure GetAsEmailObject(var oMsg : TBaseEmail);

   published
       property FileName : String read m_sFileName write m_sFileName;
       property SetDisplayForm : TwndFolder read m_frmDisplay write m_frmDisplay default Nil;
       property IconName : String read m_sIconName write m_sIconName;
   end;

procedure InitializeFolders;
procedure DeInitializeFolders;

implementation

uses
   alias, eglobal;
{
constructor EFolderExeception.Create(sMsg : String);
begin
   inherited Create(sMsg);
end;

constructor EFolderExeception.Create(sMsg : String; fSafe : Boolean);
begin
   m_fSafeToIgnore := fSafe;
   inherited Create(sMsg);
end;
}
// CHG 1.11.02
procedure InitializeFolders;
var
   nCount : Integer;
   sFolderName : String;
begin
   // todo...we will eventuallly want to do the user folders too...
   g_nMaxFoldersAvail := g_cnDraftFolder;
   for nCount := g_cnInFolder to g_nMaxFoldersAvail do
   begin
       sFolderName := g_oDirectories.MailFolderPath + 'Folder' + Trim(IntToStr(nCount + 1)) + '.emx';
       g_oFolders[nCount] := TFolder.CreateFromFile(sFolderName);

       if Not Assigned(g_oFolders[nCount]) then
           raise EFolderExeception.Create('g_oFolders[nCount] was not created');


       // this is cheezy stuff, but until the user defined folders work
       // this will have to do
       with g_oFolders[nCount] do
       begin
           m_frmDisplay := Nil;
           case nCount of
               g_cnInFolder:
               begin
                   Name := 'In';
                   Description := 'Messages received from your accounts';
               end;
               g_cnOutFolder:
               begin
                   Name := 'Sent';
                   Description := 'Messages successfully sent by you';
               end;
               g_cnToSendFolder:
               begin
                   Name := 'Out';
                   Description := 'Message ready to be mailed';
               end;
               g_cnTrashFolder:
               begin
                   Name := 'Trash';
                   Description := 'Messages queued for deletion';
               end;
               g_cnDraftFolder:
               begin
                   Name := 'Draft';
                   Description := 'Messages you have edited but chosen not to send';
               end;
               else
               begin
                   Name := 'User Defined #' + IntToStr(nCount + 1);
                   Description := 'TODO....fix';
               end;
           end;
           g_oFolders[nCount].Id := nCount;
       end;
   end;
end;

// CHG 1.11.02
procedure DeInitializeFolders;
var
   nCount : Integer;
begin
   // todo...we will eventuallly want to do the user folders too...
   for nCount := g_cnInFolder to g_cnDraftFolder do
   begin
      if Assigned(g_oFolders[nCount]) then
         g_oFolders[nCount].Destroy;
   end;
end;

{
===============================================================
   TFolder Class implementation
===============================================================
}
constructor TFolder.Create;
begin
   inherited;
   m_bFolderOpen := FALSE;
   MinIndex := g_cnMINFOLDERFIELDS;
   MaxIndex := g_cnMAXFOLDERFIELDS;
   m_frmDisplay := NIL;
end;

constructor TFolder.CreateFromFile(sFileName : String);
begin
   inherited Create;
   MinIndex := g_cnMINFOLDERFIELDS;
   MaxIndex := g_cnMAXFOLDERFIELDS;
   m_sFileName := sFileName;
   m_frmDisplay := NIL;
   m_CriticalSection := TCriticalSection.Create;
   try
       LoadFromFile(m_sFileName);
   except
       // do not care
   end;
end;

// CHG 1.11.02
destructor TFolder.Destroy;
begin
   SaveToFile(m_sFileName);

   inherited;
end;

// CHG 1.11.02
procedure TFolder.GetAsEmailObject(var oMsg : TBaseEmail);
begin
   if NOT Assigned(m_CriticalSection) then
      raise EFolderExeception.Create('m_CriticalSection not assigned in GetAsEmailObject');

   m_CriticalSection.Enter;
   IsIndexValid;
   try
       if NOT Assigned(oMsg) then
           oMsg := TBaseEmail.Create;

       if NOT Assigned(oMsg) then
           raise EFolderExeception.Create('oMsg was not assigned so oMsg was created but create failed');

       with oMsg do
       begin
           IsValid := TRUE;

           Account := GetAccount();
           BCC := GetBCC();
           CC := GetCC();
           Date := GetDate();
           SendTo := GetTo();
           From := GetFrom();
           IsRead := GetIsRead();
           Status := GetStatus();
           Subject := GetSubject();
           MessageId := GetMessageId();

           // SMTPServer :=
           // MessageType := GetMessageType();
           //Signature : String read m_sSignature write m_sSignature;

           // TODO...09.19.01 user defined folders....
           case Self.Id of
               g_cnInFolder: MessageType := ecIn;
               g_cnOutFolder: MessageType := ecSent;
               g_cnToSendFolder: MessageType := ecOut;
               g_cnTrashFolder: MessageType := ecTrash;
               g_cnDraftFolder: MessageType := ecDraft;
               else MessageType := ecUser;
           end;

           MsgTextFileName := GetFileName();
           GenerateAttachFileName();
           GenerateHeaderFileName();
       end;
   except
       oMsg.IsValid := FALSE;
       m_CriticalSection.Leave;
       raise;
   end;

   m_CriticalSection.Leave;

end;

function TFolder.GetCC: String;
var
   sText : String;
begin
   IsIndexValid;
   sText := Strings[m_nActiveIndex];
   GetCC := GetElement(sText, g_cnCCField);
end;

function TFolder.GetBCC: String;
var
   sText : String;
begin
   IsIndexValid;
   sText := Strings[m_nActiveIndex];
   GetBCC := GetElement(sText, g_cnBCCField);
end;

function TFolder.GetAccount: String;
var
   sText : String;
begin
   IsIndexValid;
   sText := Strings[m_nActiveIndex];
   GetAccount := GetElement(sText, g_cnAccountField);
end;

function TFolder.GetIsRead : Boolean;
var
   sText : String;
begin
   IsIndexValid;
   sText := Strings[m_nActiveIndex];
   if g_csYES = GetElement(sText, g_cnIsReadField) then
       GetIsRead := TRUE
   else
       GetIsRead := FALSE;
end;

function TFolder.GetTo: String;
var
   sText : String;
begin
   IsIndexValid;
   sText := Strings[m_nActiveIndex];
   GetTo := GetElement(sText, g_cnToField);
end;

function TFolder.GetFrom: String;
var
   sText : String;
begin
   IsIndexValid;
   sText := Strings[m_nActiveIndex];
   GetFrom := GetElement(sText, g_cnFromField);
end;

function TFolder.GetDate: String;
var
   sText : String;
begin
   IsIndexValid;
   sText := Strings[m_nActiveIndex];
   GetDate := GetElement(sText, g_cnDateField);
end;

function TFolder.GetSubject: String;
var
   sText : String;
begin
   IsIndexValid;
   sText := Strings[m_nActiveIndex];
   GetSubject := GetElement(sText, g_cnSubjectField);
end;

function TFolder.GetFileName: String;
var
   sText : String;
begin
   IsIndexValid;
   sText := Strings[m_nActiveIndex];
   GetFileName := GetElement(sText, g_cnFileNameField);
end;

function TFolder.GetMessageId: String;
var
   sText : String;
begin
   IsIndexValid;
   sText := Strings[m_nActiveIndex];
   GetMessageId := GetElement(sText, g_cnMsgId);
end;

function TFolder.GetStatus: Integer;
var
   sText : String;
begin
   IsIndexValid;
   sText := Strings[m_nActiveIndex];
   GetStatus := StrToInt(GetElement(sText, g_cnStatusField));
end;

// ----------------------------------------------------------------------------
// procedure TFolder.DeleteMsg;
//
// Physical removal of the message:
//    the attachments are removed from the harddrive
//    the header file is removed from the harddrive
//    the message body itself is removed from the harddrive
// ----------------------------------------------------------------------------
// CHG 1.11.02
procedure TFolder.DeleteMsg;
var
   oMsg : TBaseEmail;
begin
   if Not Assigned(m_CriticalSection) then
      raise EFolderException.Create('m_CriticalSection was not assigned in TFolder.DeleteMsg');

   m_CriticalSection.Enter;
   {
   if Assigned(g_oLogFile) then
      g_oLogFile.Write('Entered TFolder.DeleteMsg');
   }
   try
       IsIndexValid;
       oMsg := TBaseEmail.Create();
       if Not Assigned(oMsg) then
          raise EFolderException.Create('Failed to create oMsg in TFolder.DeleteMsg (hows that for confusion?)');
       {
       if Assigned(g_oLogFile) then
          g_oLogFile.Write('Getting message Object');
       }
       
       GetAsEmailObject(oMsg);

       {
       if Assigned(g_oLogFile) then
          g_oLogFile.Write('File Deleted "' + oMsg.MsgTextFileName + '"');
       }

       oMsg.DeleteFromDisk();
       oMsg.free;
       {
       if Assigned(g_oLogFile) then
          g_oLogFile.Write('Message Object deleted files and now freed the msg object');
       }
       
   except
       on oError : Exception do
       begin
          if Assigned(g_oLogFile) then
             g_oLogFile.Write('Exeception in TFolder.DeleteMsg : ' + oError.Message);

          m_CriticalSection.Leave;
          raise;
       end;
   end;

   m_CriticalSection.Leave;
   {
   if Assigned(g_oLogFile) then
      g_oLogFile.Write('Calling inherited method from TFolder.DeleteMsg');
   }
   inherited;
end;

// ----------------------------------------------------------------------------
// Creates a Message Object that is passed to the
// view (TWndFolder based window) which it
// then adds to its list
// ----------------------------------------------------------------------------
procedure TFolder.AddMsg(sData : String);
begin
   AddMsgWithStatus(Ord(rsUnimportant), sData);
end;

// Creates a Message Object that is passed to the
// view (TWndFolder based window) which it
// then adds to its list
procedure TFolder.AddMsgWithStatus(nStatus : Integer; sData : String);
begin
   sData := Trim(IntToStr(nStatus)) + g_ccharDelimiter + ' ' +
            sData;

   AddMsgStatusAttached(sData);
end;

// Creates a Message Object that is passed to the
// view (TWndFolder based window) which it
// then adds to its list
// CHG 1.11.02
procedure TFolder.AddMsgStatusAttached(sData : String);
var
   oMsg : TBaseEmail;
begin
   if Not Assigned(m_CriticalSection) then
      raise EFolderException.Create('m_CriticalSection was not assigned in TFolder.AddMsgStatusAttached.');


   m_CriticalSection.Enter;
   try
       Add(sData);

       if Assigned(m_frmDisplay) then
       begin

          oMsg := TBaseEmail.Create;
          if Not Assigned(oMsg) then
             raise EFolderException.Create('oMsg was not created in TFolder.AddMsgStatusAttached');

          with oMsg do
          begin
              MessageId := GetElement(sData, g_cnMsgId);
              Account := GetElement(sData, g_cnAccountField);
              SendTo := GetElement(sData, g_cnToField);
              CC := GetElement(sData, g_cnCCField);
              BCC := GetElement(sData, g_cnBCCField);
              if g_csYES = GetElement(sData, g_cnIsReadField) then
                  IsRead := TRUE
              else
                  IsRead := FALSE;

              From := GetElement(sData, g_cnFromField);
              Date := GetElement(sData, g_cnDateField);
              Subject := GetElement(sData, g_cnSubjectField);
              MsgTextFileName := GetElement(sData, g_cnFileNameField);

          end;

          m_frmDisplay.AddMsgToListView(oMsg);
          oMsg.Free;
       end;

   except
       m_CriticalSection.Leave;
       raise;
   end;
   m_CriticalSection.Leave;
end;

function TFolder.FindMessage(sMessageId : String) : Integer;
var
   nCount, nSavedIndex : Integer;
   sLookupId : String;
   bFound : Boolean;
begin
   if Not Assigned(m_CriticalSection) then
      raise EFolderException.Create('m_CriticalSection was not assigned in TFolder.FindMessage');

   m_CriticalSection.Enter;

   try
       nSavedIndex := m_nActiveIndex;
       bFound := FALSE;
       // search through the list until we find a match

       for nCount := 0 to Self.Count - 1 do
       begin
           sLookupId := GetElement(Self.Strings[nCount], g_cnMsgId);
           If Trim(sLookupId) = Trim(sMessageId) then
           begin
               bFound := TRUE;
               break;
           end;
       end;

       if TRUE = bFound then
           FindMessage := nCount
       else
           FindMessage := -1;

       m_nActiveIndex := nSavedIndex;
   except
       m_CriticalSection.Leave;
       raise;
   end;
   m_CriticalSection.Leave;
end;

end.
