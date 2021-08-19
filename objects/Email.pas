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
unit Email;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, OleCtrls, isp3, registry, ImgList, KDECap;


// ================================================================================
// Exceptions


type
   EFolderMsg = class(Exception)
   end;

// ================================================================================
// TBaseEmail
//
type
   TEmailClassType  = (ecNA, ecUsenet, ecIn, ecSent, ecOut, ecTrash, ecDraft, ecUser);
   TBaseEmail = class(TObject)
   protected
       m_sTo,
       m_sCC,
       m_sBCC,
       m_sAccount,
       m_sFrom,
       m_sDate,
       m_sSubject,
       m_sSMTPServer,
       m_sBodyFileName,
       m_sAttachListFile,
       m_sHeaderFileName,
       m_sMessageId,
       m_sSignature : String;

       m_bRead,
       m_bOK : Boolean;

       m_nStatus : Integer;

       m_eType : TEmailClassType;

   protected
       procedure SetBodyFileName(sNewFileName : String);
       function GetFolderId() : Integer;
       function GetUniqueFileName() : String;

   public
       constructor Create; overload; virtual;
       constructor Create(oMsg : TBaseEmail); overload; virtual;
       procedure SaveAs(sFileName : String);

       function GenerateFileName: String;
       function GenerateAttachFileName: String;
       function GenerateHeaderFileName : String;
       function OutputHeaderAsString: String;

       procedure DeleteFromDisk; virtual;

       // TODO...09.08.01
       // put save to text file
       //     printing
       // functions in this class

   published
       property Account : String read m_sAccount write m_sAccount;
       property AttachmentListFileName : String read m_sAttachListFile write m_sAttachListFile;
       property BCC: String read m_sBCC write m_sBCC;
       property CC: String read m_sCC write m_sCC;
       property Date : String read m_sDate write m_sDate;
       property FolderId : Integer read GetFolderId;
       property From : String read m_sFrom write m_sFrom;
       property HeaderFileName : String read m_sHeaderFileName write m_sHeaderFileName;
       property IsRead : Boolean read m_bRead write m_bRead default FALSE;
       property IsValid : Boolean read m_bOK write m_bOK default FALSE;
       property MessageId : String read m_sMessageId write m_sMessageId;
       property MessageType : TEmailClassType read m_eType write m_eType default ecNA;
       property MsgTextFileName : String read m_sBodyFileName write SetBodyFileName;
       property SMTPServer : String read m_sSMTPServer write m_sSMTPServer;
       property SendTo : String read m_sTo write m_sTo;
       property Signature : String read m_sSignature write m_sSignature;
       property Status : Integer read m_nStatus write m_nStatus;
       property Subject : String read m_sSubject write m_sSubject;
   end;

// ================================================================================
// TUsenetEmail
//
type
   TUsenetEmail = class(TBaseEmail)
   protected
   public
       constructor Create; override;
   published
   end;


// ================================================================================
// TSentEmail
//
type
   TSentEmail = class(TBaseEmail)
   protected
   public
       constructor Create; override;
   published
   end;

// ================================================================================
// TTrashEmail
//
type
   TTrashEmail = class(TBaseEmail)
   protected
   public
       constructor Create; override;
   published
   end;

// ================================================================================
// TDraftEmail
//
type
   TDraftEmail = class(TBaseEmail)
   protected
   public
       constructor Create; override;
   published
   end;


// ================================================================================
// TOutboundEmail
//
type
   TOutboundEmail = class(TBaseEmail)
   protected
   public
       constructor Create; override;
   published
   end;


// ================================================================================
// TInboundEmail
//
type
   TInboundEmail = class(TBaseEmail)
   private
       m_bUnread : Boolean;
       m_oFileHandle : TextFile;
   public
       constructor Create; override;
   published
       property HasBeenRead : Boolean read m_bUnread write m_bUnread;
       property FileHandle : TextFile read m_oFileHandle write m_oFileHandle;
   end;

// ================================================================================
// TUserDefinedEmail
//
type
   TUserDefinedEmail = class(TBaseEmail)
   protected
   public
       constructor Create; override;
   published
   end;


implementation

uses
   eglobal;

{
===============================================================
constructor TBaseEmail.Create;
===============================================================
}
constructor TBaseEmail.Create;
begin
   inherited;
   m_bOK := FALSE;
end;


{
===============================================================
constructor TBaseEmail.Create(oMsg : TBaseEmail);
===============================================================
}

constructor TBaseEmail.Create(oMsg : TBaseEmail);
begin
   Create;
   if NOT Assigned(oMsg) then
       raise EFolderMsg.Create('oMsg is not assigned in TBaseEmail.Create');
       
   Account := oMsg.Account;
   AttachmentListFileName := oMsg.AttachmentListFileName;
   BCC := oMsg.BCC;
   CC := oMsg.CC;
   Date := oMsg.Date;
   From := oMsg.From;
   HeaderFileName := oMsg.HeaderFileName;
   IsRead := oMsg.IsRead;
   IsValid := oMsg.IsValid;
   MessageId := oMsg.MessageId;
   MessageType := oMsg.MessageType;
   MsgTextFileName := oMsg.MsgTextFileName;
   SMTPServer := oMsg.SMTPServer;
   SendTo := oMsg.SendTo;
   Signature := oMsg.Signature;
   Status := oMsg.Status;
   Subject := oMsg.Subject;

end;

{
===============================================================
function TBaseEmail.SetBodyFileName
===============================================================
}
procedure TBaseEmail.SetBodyFileName(sNewFileName : String);
begin
   m_sBodyFileName := sNewFileName;
   GenerateHeaderFileName;
   GenerateAttachFileName;
end;

{
===============================================================
function TBaseEmail.GetFolderId() : Integer;
===============================================================
}
function TBaseEmail.GetFolderId() : Integer;
begin
   case m_eType of
       ecIn: GetFolderId := g_cnInFolder;
       ecSent: GetFolderId := g_cnOutFolder;
       ecOut: GetFolderId := g_cnToSendFolder;
       ecTrash: GetFolderId := g_cnTrashFolder;
       ecDraft: GetFolderId := g_cnDraftFolder;
       ecUser: GetFolderId := -1;
       ecNA, ecUsenet: GetFolderId := -1;
       else GetFolderId := -1;
   end;
end;

{
===============================================================
function TBaseEmail.DeleteFromDisk;
===============================================================
}
procedure TBaseEmail.DeleteFromDisk;
var
   oListOfAttachments : TStringList;
   nCount : Integer;
   sFilePath : String;
begin
   // open attachment file and delete all files listed

   oListOfAttachments := TStringList.Create();
   if Assigned(oListOfAttachments) then
   begin
      try
          oListOfAttachments.LoadFromFile(AttachmentListFileName);
          for nCount := 0 to oListOfAttachments.Count - 1 do
          begin
             sFilePath := '';
             sFilePath := ExtractFilePath(Trim(oListOfAttachments.Strings[nCount]));
             try
                if 0 = Length(Trim(sFilePath)) then
                   DeleteFile(g_oDirectories.AttachmentPath + Trim(oListOfAttachments.Strings[nCount]))
                else
                   DeleteFile(Trim(oListOfAttachments.Strings[nCount]));
              except
              // dont care
              end;
          end;

         oListOfAttachments.Free;

      except
       // dont care
      end;
   end;

   try
       if FileExists(AttachmentListFileName) then
           DeleteFile(AttachmentListFileName);
   except
       // dont care
   end;

   // delete header file
   try
       DeleteFile(HeaderFileName);
   except
       // dont care
   end;

   // delete message file
   try
       DeleteFile(MsgTextFileName);
   except
   end;

   m_sBodyFileName := '';
   // TODO...08.27.01
   // really need to do something to invalidate this object so that it
   // cannot be used in its current state....
end;

{
===============================================================

===============================================================
}
function TBaseEmail.GetUniqueFileName() : String;
var
   sFileName : String;
   pchFileName : PChar;
   chFileName : array [0..320] of char;
   oFile : TextFile;
   nAttempts : Integer;
begin

   pchFileName := @chFileName[0];
   ZeroMemory(pchFileName, 320);
   nAttempts := 0;
   
   repeat
       Inc(nAttempts);
       if 32000 <= nAttempts then
           raise Exception.Create('Attempted 32,000 times to generate a unique file name and it failed.');

       // generate file name in mail location
       GetTempFileName(PChar(g_oDirectories.MailFolderPath), PChar('abc'), 0, pchFileName);
       
       // filename may include mail location directory information, remove it
       sFileName := StrPas(pchFileName);

       // erase temporary file created by GetTempFileName under some OSes
       AssignFile(oFile, sFileName);
       try
          Erase(oFile);
       except
          // dont care
       end;

       // give it the emailmax name
       sFileName := ChangeFileExt(sFileName, '.emx');
        
       // if it does not already exist, then we're done, otherwise
       // try again
   until FALSE = FileExists(sFileName);

   GetUniqueFileName := sFileName;
end;

{
===============================================================
function TBaseEmail.GenerateFileName: String;
===============================================================
}
function TBaseEmail.GenerateFileName: String;
begin

   MsgTextFileName := ChangeFileExt(GetUniqueFileName(), '.emx');

   GenerateFileName := MsgTextFileName;
end;

{
===============================================================
function TBaseEmail.GenerateAttachFileName: String;
===============================================================
}
function TBaseEmail.GenerateAttachFileName: String;
begin
   if 0 = Length(Trim(MsgTextFileName)) then
       GenerateFileName;

   AttachmentListFileName := ChangeFileExt(MsgTextFileName, '.emt');
   {
   if Assigned(g_oLogFile) then
       g_oLogFile.Write('Attachment File Name Generated "' + AttachmentListFileName + '"');
   }
   GenerateAttachFileName := AttachmentListFileName;
end;

{
===============================================================
function TBaseEmail.GenerateHeaderFileName: String;
===============================================================
}
function TBaseEmail.GenerateHeaderFileName: String;
begin
   if 0 = Length(Trim(MsgTextFileName)) then
       GenerateFileName;

   HeaderFileName := ChangeFileExt(MsgTextFileName, '.emh');
   GenerateHeaderFileName := HeaderFileName;
end;

{
===============================================================
function TBaseEmail.OutputHeaderAsString: String;
===============================================================
}
function TBaseEmail.OutputHeaderAsString: String;
var
   sMessageId,
   sRead,
   sRetString : String;
   nPos : Integer;
begin

   if TRUE = IsRead then
       sRead := g_csYES
   else
       sRead := g_csNO;

   if 0 <= Length(Trim(m_sMessageId)) then
   begin
       sMessageId := FloatToStr(Now);
       nPos := Pos('.', sMessageId);
       m_sMessageId := Copy(sMessageId, 1, nPos - 1) + Copy(sMessageId, nPos + 1, Length(sMessageId));
   end;

   // TODO...fix parsing bug
   // this is the hack
   m_sTo := m_sTo + ' ';
   m_sCC := m_sCC + ' ';
   m_sBCC := m_sBCC + ' ';

   // do not need to include status here...its created separately
   sRetString := sRead + g_ccharDelimiter + ' ' +
                 m_sMessageId + g_ccharDelimiter + ' ' +
                 m_sAccount + g_ccharDelimiter + ' ' +
                 m_sFrom + g_ccharDelimiter + ' ' +
                 m_sTo + g_ccharDelimiter + ' ' +
                 m_sCC + g_ccharDelimiter + ' ' +
                 m_sBCC + g_ccharDelimiter + ' ' +
                 m_sDate + g_ccharDelimiter + ' ' +
                 m_sSubject + g_ccharDelimiter + ' ' +
                 m_sBodyFileName ;

   OutputHeaderAsString := sRetString;
end;

{
===============================================================
function TBaseEmail.SaveAs(sFileName : String);
===============================================================
}
procedure TBaseEmail.SaveAs(sFileName : String);
var
   oInputFile : TextFile;
   oOutputFile : TextFile;
   sLine : String;
begin

   AssignFile(oOutputFile, sFileName);

   Rewrite(oOutputFile);

   GenerateHeaderFileName;         // assuming we have a valid message body
   AssignFile(oInputFile, HeaderFileName);

   Reset(oInputFile);

   while NOT Eof(oInputFile) do
   begin
       ReadLn(oInputFile, sLine);
       WriteLn(oOutputFile, sLine);
       Flush(oOutputFile);
   end;

   CloseFile(oInputFile);

   AssignFile(oInputFile, MsgTextFileName);

   Reset(oInputFile);
   WriteLn(oOutputFile, '');

   while NOT Eof(oInputFile) do
   begin
       ReadLn(oInputFile, sLine);
       WriteLn(oOutputFile, sLine);
       Flush(oOutputFile);
   end;

   CloseFile(oInputFile);   

   CloseFile(oOutputFile);

end;

{
===============================================================
constructor TUsenetEmail.Create;
===============================================================
}
constructor TUsenetEmail.Create;
begin
   inherited;
   m_eType := ecUsenet;
end;

{
===============================================================
constructor TInboundEmail.Create;
===============================================================
}
constructor TInboundEmail.Create;
begin
   inherited;
   m_bUnread := FALSE;
   m_eType := ecIn;
end;

{
===============================================================
constructor TDraftEmail.Create;
===============================================================
}
constructor TDraftEmail.Create;
begin
   inherited;
   m_eType := ecDraft;
end;

{
===============================================================
constructor TOutboundEmail.Create;
===============================================================
}
constructor TOutboundEmail.Create;
begin
   inherited;
   m_eType := ecOut;
end;

{
===============================================================
constructor TSentEmail.Create;
===============================================================
}
constructor TSentEmail.Create;
begin
   inherited;
   m_eType := ecSent;
end;

{
===============================================================
constructor TTrashEmail.Create;
===============================================================
}
constructor TTrashEmail.Create;
begin
   inherited;
   m_eType := ecTrash;
end;

{
===============================================================
constructor TUserDefinedEmail.Create;
===============================================================
}
constructor TUserDefinedEmail.Create;
begin
   inherited;
   m_eType := ecUser;
end;



end.

