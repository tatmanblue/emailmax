// copyright (c) 2000 by microObjects inc.
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

unit pgpencrp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  basepost, marsCap, StdCtrls, Menus, ExtCtrls, basencrp;

Type
   TPGPEncryption = class(TBaseEncryption)
   private
       m_sSendToId,
       m_sSignWithId,
       m_sPassword : String;
       function CreatePgpForEncrypt: String;
       function CreatePgpForDecrypt: String;
       procedure CallPgp(sPgpCommandLine : String);
   public
       procedure Encrypt; override;
       procedure Decrypt; override;
   published
       property IdToSendTo : String read m_sSendToId write m_sSendToId;
       property IdToSignWith : String read m_sSignWithId write m_sSignWithId;
       property Password : String read m_sPassword write m_sPassword;

   end;


implementation

procedure TPGPEncryption.Encrypt;
begin
   if Length(IdToSendTo) = 0 then
       raise TEcnryptException.Create('PGP User Id is required to encrypt.');

   CallPgp(CreatePgpForEncrypt);
end;

procedure TPGPEncryption.Decrypt;
begin
   if Length(IdToSendTo) = 0 then
       raise TEcnryptException.Create('PGP User Id is required to encrypt.');

   CallPgp(CreatePgpForDecrypt);
end;

function TPGPEncryption.CreatePgpForEncrypt: String;
begin
   {we could include password in here}
   if Length(Trim(IdToSignWith)) > 0 then
       CreatePgpForEncrypt := 'pgp.exe -seat .\pgp.txt ' + IdToSendTo + ' -u' + IdToSignWith
   else
       CreatePgpForEncrypt := 'pgp.exe -eat .\pgp.txt ' + IdToSendTo;
end;

function TPGPEncryption.CreatePgpForDecrypt: String;
begin
   CreatePgpForDecrypt := 'pgp.exe .\pgp.asc ' + IdToSendTo;
end;

procedure TPGPEncryption.CallPgp(sPgpCommandLine : String);
var
   dwExitCode : DWORD;
   stStart : TStartupInfo;
   stProc : TProcessInformation;
   bRet : Boolean;
   chText : array [0..255] of Char;
begin

   StrPCopy(chText, sPgpCommandLine);

   ZeroMemory(@stStart, sizeof(stStart));
   stStart.cb := sizeof(stStart);

   bRet := CreateProcess(Nil, chText, Nil, Nil, FALSE, CREATE_DEFAULT_ERROR_MODE OR CREATE_NEW_CONSOLE, Nil, Nil, stStart, stProc);

   if bRet then
   begin
       WaitForSingleObject(stProc.hProcess, INFINITE);
   end
   else
   begin
       dwExitCode := GetLastError;
       if dwExitCode = ERROR_BAD_FORMAT Then
	        raise TEcnryptException.Create('The system does not recognize PGP as a valid program (#' + IntToStr(dwExitCode) + '). Maybe PGP is not installed correctly.')
       else
           raise TEcnryptException.Create('PGP Startup Error : #' + IntToStr(dwExitCode));
   end;

end;

end.
