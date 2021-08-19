// copyright (c) 2002 by microObjects inc.
//
// Emailmax source is distributed under the public
// domain license arrangements.  You are free to
// modify, edit, copy, delete, or redistribute
// the emailmax code as long as you 1) indemnify
// microObjects inc and its employees and owners
// from any and all liablity, directly or indirectly,
// related to the use, modification or distribution
// of this code 2) and make proper credit where
// applicable.
unit alias;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, basfoldr;

//
// Exceptions
//
type
   EEmailAias = class(Exception)
   end;

//
// Single Email address entry
//
//
type
   TEmailAddress = class(TObject)
   private
       m_sAddress,
       m_sServer,
       m_sUserId,
       m_sEncryptedPassword : String;
       m_nIndex,
       m_nServerType,
       m_nUsageType : Integer;
       m_bIsDefault,
       m_bLeaveOnServer : Boolean;
   public
   published
       property Address : String read m_sAddress write m_sAddress;
       property IndexId : Integer read m_nIndex write m_nIndex;
       property IsDefault : Boolean read m_bIsDefault write m_bIsDefault default FALSE;
       property LeaveOnServer : boolean read m_bLeaveOnServer write m_bLeaveOnServer default TRUE;
       property Password : String read m_sEncryptedPassword write m_sEncryptedPassword;
       property Server : String read m_sServer write m_sServer;
       property ServerType : Integer read m_nServerType write m_nServerType;
       property UsageType : Integer read m_nUsageType write m_nUsageType;
       property UserId : String read m_sUserId write m_sUserId;
   end;

//
// Email Alias
// Group of TEmailAddress
// function assist in extracting data
type
   TEmailAlias = class(TBaseFolder)
   protected
   public
       constructor Create;
       
       // helper functions
       function GetEmailAddress : String;
       function GetServerName : String;
       function GetAccountName : String;
       function GetUserId : String;
       function GetServerType : Integer;
       function GetPasswordNoEncrypt : String;
       function GetUseageType : Integer;
       function IsDefault : Boolean;
       function GetLeaveOnServer : Boolean;

       function FindAliasFromEmail(sEmailAddr : String) : Integer;
       function EmailAliasIndex(sEmailAddr : String; nType : Integer) : Integer;

       // item entry/update functions
       function BuildString(sEmailAddr, sServer, sUserId, sPassword : String; nServerType, nUsageType : Integer; bEncrypt, bDefault, bLeaveOnServer : Boolean) : string;
       function AddEmailAddr(sEmailAddr, sServer, sUserId, sPassword : String; nServerType, nUsageType : Integer; bEncrypt, bDefault, bLeaveOnServer : Boolean) : integer;
       function AddEmailObj(oAddress : TEmailAddress) : integer;
       function UpdateEmailAddr(nSendListIndex : Integer; sEmailAddr, sServer, sUserId, sPassword : String; nServerType, nUsageType : Integer; bEncrypt, bDefault, bLeaveOnServer: Boolean) : integer;
       function UpdateEmailObj(oAddress : TEmailAddress) : integer;

       // item update helper functions
       procedure ResetAllDefaults(nUsageType : Integer);

       procedure GetEmailObject(nIndex : Integer; var oAlias : TEmailAddress);

   published
   end;

type
   TSignatureAlias = class(TStringList)
   end;


implementation

uses
   encryption, eglobal;

{
======================================================
CLASS: TEmailAddress
======================================================
}
{
======================================================
CLASS: TEmailAlias
======================================================
}
// Create
constructor TEmailAlias.Create;
begin
   inherited;
   // 7.23.01 Adding user id to email account
   MaxIndex := g_cnMaxFields;
end;

// LeaveOnServer
function TEmailAlias.GetLeaveOnServer : Boolean;
var
   sText : String;
begin
   IsIndexValid;
   sText := Strings[m_nActiveIndex];
   if g_csYes = UpperCase(Trim(GetElement(sText, g_cnLeaveOnServer))) then
       GetLeaveOnServer := TRUE
   else
       GetLeaveOnServer := FALSE;

end;

// GetUseageType
function TEmailAlias.GetUseageType : Integer;
var
   sText : String;
begin
   IsIndexValid;
   GetUseageType := -1;
   sText := Strings[m_nActiveIndex];
   if UpperCase(trim(GetElement(sText, g_cnUsageType))) = 'S' then
       GetUseageType := g_cnUsageSend;

   if UpperCase(trim(GetElement(sText, g_cnUsageType))) = 'R' then
       GetUseageType := g_cnUsageRecv;

   if UpperCase(trim(GetElement(sText, g_cnUsageType))) = 'U' then
       GetUseageType := g_cnUsageUsenet;
end;

// GetEmailAddress
function TEmailAlias.GetEmailAddress : String;
var
   sText : String;
begin
   IsIndexValid;
   sText := Strings[m_nActiveIndex];
   GetEmailAddress := trim(GetElement(sText, g_cnEmailAddr));
end;

//GetAccountName
function TEmailAlias.GetAccountName : String;
var
   sText : String;
   nPos : Integer;
begin

   sText := GetEmailAddress;
   nPos := Pos('@', sText);
   if (nPos > 0) then
   begin
       sText := Copy(sText, 1, nPos - 1);
   end;

   GetAccountName := sText;

end;

// GetServerName
function TEmailAlias.GetServerName : String;
var
   sText : String;
begin
   IsIndexValid;
   sText := Strings[m_nActiveIndex];
   GetServerName := trim(GetElement(sText, g_cnServer));
end;

// GetServerType
function TEmailAlias.GetServerType : Integer;
var
   sText : String;
begin
   IsIndexValid;
   sText := Strings[m_nActiveIndex];
   if UpperCase(trim(GetElement(sText, g_cnServerType))) = 'P' then
       GetServerType := g_cnServerPOP
   else
       GetServerType := g_cnServerSMTP;

end;

// GetUserId
function TEmailAlias.GetUserId : String;
var
   sText : String;
begin
   IsIndexValid;
   sText := Strings[m_nActiveIndex];
   GetUserId := Trim(GetElement(sText, g_cnUserId));
end;

// GetPasswordNoEncrypt
function TEmailAlias.GetPasswordNoEncrypt : String;
var
   sText,
   sPassword : String;
begin
   IsIndexValid;
   sText := Strings[m_nActiveIndex];
   sPassword := trim(GetElement(sText, g_cnPassword));

   if g_csNA = sPassword then
       GetPasswordNoEncrypt := ''
   else
       GetPasswordNoEncrypt := sPassword;
end;

function TEmailAlias.FindAliasFromEmail(sEmailAddr : String) : Integer;
var
   nCount : Integer;
   sUserEmail : String;
begin
   FindAliasFromEmail := -1;

   // is this right? ... minindex and maxindex refer
   // to the fields in a row....but by using it here,
   // we are limited ourselves to using the first 5 entries in
   // the SMPT list of send froms....
   // for nCount := MinIndex to MaxIndex do
   for nCount := 0 to Self.Count - 1 do
   begin
       ActiveIndex := nCount;
       sUserEmail := GetEmailAddress;
       if sUserEmail = sEmailAddr then
       begin
           FindAliasFromEmail := nCount;
           break;
       end;
   end;
end;

function TEmailAlias.EmailAliasIndex(sEmailAddr : String; nType : Integer) : Integer;
var
   nCount : Integer;
   sUserEmail : String;
   nUserType : Integer;
begin
   EmailAliasIndex := -1;

   // is this right? ... minindex and maxindex refer
   // to the fields in a row....but by using it here,
   // we are limited ourselves to using the first 5 entries in
   // the SMPT list of send froms....
   // for nCount := MinIndex to MaxIndex do
   for nCount := 0 to Self.Count do
   begin
       ActiveIndex := nCount;
       sUserEmail := GetEmailAddress;
       nUserType := GetServerType;
       if (sUserEmail = sEmailAddr) and (nUserType = nType) then
       begin
           EmailAliasIndex := nCount;
           break;
       end;
   end;
end;

function TEmailAlias.AddEmailAddr(sEmailAddr, sServer, sUserId, sPassword : String; nServerType, nUsageType : Integer; bEncrypt, bDefault, bLeaveOnServer : Boolean) : Integer;
var
   sWork : String;
begin

   sWork := BuildString(sEmailAddr, sServer, sUserId, sPassword, nServerType, nUsageType, bEncrypt, bDefault, bLeaveOnServer);

   AddEmailAddr := Add(sWork);
end;

function TEmailAlias.UpdateEmailAddr(nSendListIndex : Integer; sEmailAddr, sServer, sUserId, sPassword : String; nServerType, nUsageType : Integer; bEncrypt, bDefault, bLeaveOnServer : Boolean) : integer;
var
   sWork : String;
   nIndex : Integer;
begin
   // order of data
   // UsageType, EmailAddr, Server, ServerType, Password
   nIndex := nSendListIndex;

   sWork := BuildString(sEmailAddr, sServer, sUserId, sPassword, nServerType, nUsageType, bEncrypt, bDefault, bLeaveOnServer);

   Strings[nIndex] := sWork;
   UpdateEmailAddr := nIndex;
end;

function TEmailAlias.IsDefault : Boolean;
var
   sText,
   sDefault : String;
begin
   IsDefault := FALSE;
   sText := Strings[m_nActiveIndex];

   sDefault := trim(GetElement(sText, g_cnIsDefault));

   if g_csDefault = Trim(Uppercase(sDefault)) then
       IsDefault := TRUE;
end;

//
// This function sets all entries in system.txt, IsDefault field to no or <NA>
//
//
procedure TEmailAlias.ResetAllDefaults(nUsageType : Integer);
var
   nUsage, nCount, nMax : Integer;
   oItem : TEmailAddress;
begin

   if Not Assigned(g_oEmailAddr) then
      raise Exception.Create('g_oEmailAddr not assigned in TEmailAlias.ResetAllDefaults');

   oItem := TEmailAddress.Create;
   if Not Assigned(oItem) then
      raise Exception.Create('oItem not assigned in TEmailAlias.ResetAllDefaults');

   nMax := g_oEmailAddr.GetCount - 1;
   for nCount := 0 to nMax do
   begin
       g_oEmailAddr.GetEmailObject(nCount, oItem);
       nUsage := oItem.UsageType;
       if nUsage = nUsageType then
       begin
           oItem.IsDefault := FALSE;
           UpdateEmailObj(oItem);
       end;
   end;
end;

function TEmailAlias.AddEmailObj(oAddress : TEmailAddress) : integer;
begin
   if Not Assigned(oAddress) then
      raise Exception.Create('oAddress not assigned in TEmailAlias.UpdateEmailObj');

   with oAddress do
   begin
      oAddress.IndexId := AddEmailAddr(Address, Server, UserId, Password, ServerType, UsageType, FALSE, IsDefault, LeaveOnServer);
   end;

   AddEmailObj := oAddress.IndexId;
end;

function TEmailAlias.UpdateEmailObj(oAddress : TEmailAddress) : integer;
begin
   if Not Assigned(oAddress) then
      raise Exception.Create('oAddress not assigned in TEmailAlias.UpdateEmailObj');

   with oAddress do
   begin
       UpdateEmailAddr(IndexId, Address, Server, UserId, Password, ServerType, UsageType, FALSE, IsDefault, LeaveOnServer);
   end;

   UpdateEmailObj := oAddress.IndexId;
   
end;

function TEmailAlias.BuildString(sEmailAddr, sServer, sUserId, sPassword : String; nServerType, nUsageType : Integer; bEncrypt, bDefault, bLeaveOnServer : Boolean) : string;
var
   sWork : String;
   oEncrypt : TEncrypt;
begin

   // string format

   // setup usage type
   case nUsageType of
       g_cnUsageSend: sWork := 'S' + g_ccharDelimiter + ' ';
       g_cnUsageRecv: sWork := 'R' + g_ccharDelimiter + ' ';
       g_cnUsageUsenet: sWork := 'U' + g_ccharDelimiter + ' ';
   end;

   // setup email address
   sWork := sWork + Trim(sEmailAddr) + g_ccharDelimiter + ' ';

   // set server field
   sWork := sWork + Trim(sServer) + g_ccharDelimiter + ' ';

   // setup server type
   if nServerType = g_cnServerPOP then
       sWork := sWork + 'P' + g_ccharDelimiter + ' '
   else
       sWork := sWork + 'S' + g_ccharDelimiter + ' ';

   // setup is default
   if bDefault = TRUE then
       sWork := sWork + g_csDefault + g_ccharDelimiter + ' '
   else
       sWork := sWork + g_csNA + g_ccharDelimiter + ' ';

   // setup delete from server
   if nServerType = g_cnServerPOP then
   begin
       if TRUE = bLeaveOnServer then
           sWork := sWork + g_csYes + g_ccharDelimiter + ' '
       else
           sWork := sWork + g_csNo + g_ccharDelimiter + ' ';
   end
   else
       sWork := sWork + g_csNA + g_ccharDelimiter + ' ';

   // setup user id
   sWork := sWork + sUserId + g_ccharDelimiter + ' ';

   // setup password
   if bEncrypt = TRUE then
   begin
       if 0 < Length(Trim(sPassword)) then
       begin
           oEncrypt := TEncrypt.Create;
           oEncrypt.SourceString := sPassword;
           oEncrypt.Encrypt;
           sWork := sWork + oEncrypt.EncryptedString;
           oEncrypt.free;
       end
       else
           sWork := sWork + g_csNA;
   end
   else
       sWork := sWork + sPassword;

   sWork := sWork + ' ';

   BuildString := sWork;
end;

procedure TEmailAlias.GetEmailObject(nIndex : Integer; var oAlias : TEmailAddress);
begin
   ActiveIndex := nIndex;
   if Not Assigned(oAlias) then
      oAlias := TEmailAddress.Create();

   if Not Assigned(oAlias) then
      raise Exception.Create('oAlias is not assigned in TEmailAlias.GetObjectFromAlias');

   oAlias.IndexId := nIndex;
   oAlias.Address := GetEmailAddress;
   oAlias.Server := GetServerName;
   oAlias.Password := GetPasswordNoEncrypt;
   oAlias.ServerType := GetServerType;
   oAlias.UsageType := GetUseageType;
   oAlias.UserId := GetUserId;
   oAlias.IsDefault := IsDefault;
end;


end.
