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

unit encryption;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;


type
   EEncryptExeception = class(Exception)
   end;


type
   TEncrypt = class(TObject)
   protected
       m_sSource,
       m_sEncrypt : String;

   public
       constructor Create;
       procedure Encrypt; virtual;
       procedure Decrypt; virtual;

   published
       property EncryptedString : String read m_sEncrypt write m_sEncrypt;
       property SourceString : String read m_sSource write m_sSource;


   end;

type
   TPGPEncrypt = class(TEncrypt)
   protected
       m_sSendToId,
       m_sSignWithId,
       m_sPassword : String;
       function CreatePgpForEncrypt: String;
       function CreatePgpForDecrypt: String;
       procedure CallPgp(sPgpCommandLine : String);

   public
       constructor Create;
       procedure Encrypt; override;
       procedure Decrypt; override;
   published
       property IdToSendTo : String read m_sSendToId write m_sSendToId;
       property IdToSignWith : String read m_sSignWithId write m_sSignWithId;
       property Password : String read m_sPassword write m_sPassword;

   end;



type
   TMD5Encrypt = class(TEncrypt)
   protected
       m_sPassPhrase : String;

   public
       constructor Create;
       procedure Encrypt; override;
       procedure Decrypt; override;
   published
       property PassPhrase : String read m_sPassPhrase write m_sPassPhrase;
   end;

type
   TCesearEncrypt = class(TEncrypt)

   protected
       m_nKey : Integer;

   public
       constructor Create;
       procedure Encrypt; override;
       procedure Decrypt; override;
   published
       property KeyChar : Integer read m_nKey write m_nKey default 64; // default 'A'
   end;


function getBufferSize(src: PCHAR): integer; cdecl; external 'blowdll.dll';
function MD5Encrypt(key, src, dest : PCHAR): integer; cdecl; external 'blowdll.dll' name 'encrypt';
function MD5Decrypt(key, src, dest : PCHAR): integer; cdecl; external 'blowdll.dll' name 'decrypt';
function toggleLog(value: integer): integer; cdecl; external 'blowdll.dll';
{
   globals related to encryption are maintained here
   because this file is shared between emailmax.exe and emailex.dll
}
var
  g_bLogEncryption : boolean;

implementation


uses
   eglobal, eregistry;

{
================================================================================================

   TEncrypt


================================================================================================
}
constructor TEncrypt.Create;
begin
   inherited Create;
   m_sSource := '';
   m_sEncrypt := '';
end; // constructor TEncrypt.Create;

procedure TEncrypt.Encrypt;
var
   nCount, nLen, nOffSet, nComputedOrd : Integer;
   vRandom : Variant;
begin
   nLen := Length(m_sSource);
   if nLen = 0 then
   begin
       raise EEncryptExeception.Create('(Class TEncrypt) No source has been defined.');
   end;

   m_sEncrypt := '';

   // 01.05.02 found the password problem
   // (the caesar encryption has it right)
   // this is where the encypt bug is...
   // part a) nOffset must be between 32 and 126 for safe encryption

   Randomize;
   nCount := 0;

   repeat
      vRandom := (Random * 10);
      nOffset := vRandom + 32;
      Inc(nCount);
      if 12000 < nCount then
         raise EEncryptExeception.Create('(Class TEncrypt) Tried for 12000 times to generate a key and failed.');
         
   until (126 >= nOffset);

   m_sEncrypt := Chr(nOffset);
   for nCount := 1 to nLen do
   begin
       // part b) the sum of the ord and nOffset cannot exceed 128
       // and when it does it should wrap around to 32+
       nComputedOrd := Ord(m_sSource[nCount]) + nOffset;

       if 32 > nComputedOrd then
           nComputedOrd := nComputedOrd + 94;

       if 126 < nComputedOrd then
           nComputedOrd := nComputedOrd - 94;

       m_sEncrypt := m_sEncrypt + Chr(nComputedOrd);
   end;

end; // procedure TEncrypt.Encrypt;

procedure TEncrypt.Decrypt;
var
   nComputedOrd, nCount, nLen, nOffSet : Integer;
begin
   nLen := Length(m_sEncrypt);
   if nLen < 1 then
   begin
       raise EEncryptExeception.Create('No encrypted source has been defined');
   end;

   if nLen = 1 then
   begin
       raise EEncryptExeception.Create('An Invalid encrypted source has been defined');
   end;

   m_sSource := '';
   nOffset := Ord(m_sEncrypt[1]);

   for nCount := 2 to nLen do
   begin
       // part c, the difference of ord and nOffset cannot be less
       // than 32 and when it does it should wrap
       nComputedOrd := Ord(m_sEncrypt[nCount]) - nOffset;

       if 32 > nComputedOrd then
           nComputedOrd := nComputedOrd + 94;

       // in theory this if statement should never evaluate to true
       if 126 < nComputedOrd then
           nComputedOrd := nComputedOrd - 94;

       m_sSource := m_sSource + Chr(nComputedOrd);
   end;
end; // procedure TEncrypt.Decrypt;


{
================================================================================================

   TPGPEncrypt


================================================================================================
}

constructor TPGPEncrypt.Create;
begin
   inherited;
end;

procedure TPGPEncrypt.Encrypt;
begin
   if Length(IdToSendTo) = 0 then
       raise EEncryptExeception.Create('PGP User Id is required to encrypt.');

   CallPgp(CreatePgpForEncrypt);
end;

procedure TPGPEncrypt.Decrypt;
begin
   if Length(IdToSendTo) = 0 then
       raise EEncryptExeception.Create('PGP User Id is required to encrypt.');

   CallPgp(CreatePgpForDecrypt);
end;

function TPGPEncrypt.CreatePgpForEncrypt: String;
begin
   {TODO...option for including password in here}
   if Length(Trim(IdToSignWith)) > 0 then
       CreatePgpForEncrypt := 'pgp.exe -seat .\pgp.txt ' + IdToSendTo + ' -u' + IdToSignWith
   else
       CreatePgpForEncrypt := 'pgp.exe -eat .\pgp.txt ' + IdToSendTo;
end;

function TPGPEncrypt.CreatePgpForDecrypt: String;
begin
   CreatePgpForDecrypt := 'pgp.exe .\pgp.asc ' + IdToSendTo;
end;

procedure TPGPEncrypt.CallPgp(sPgpCommandLine : String);
var
   dwExitCode : DWORD;
   stStart : TStartupInfo;
   stProc : TProcessInformation;
   bRet : Boolean;
   chText : array [0..255] of Char;
   chCurDir : array [0..255] of Char;
begin
   try
       StrPCopy(chCurDir, g_oRegistry.PGPPath);
   except
       StrPCopy(chCurDir, '.\');
   end;

   StrPCopy(chText, sPgpCommandLine);

   ZeroMemory(@stStart, sizeof(stStart));
   stStart.cb := sizeof(stStart);

   bRet := CreateProcess(Nil, chText, Nil, Nil, FALSE, CREATE_DEFAULT_ERROR_MODE OR CREATE_NEW_CONSOLE, Nil, chCurDir, stStart, stProc);

   if bRet then
   begin
       // TODO....should not be infinite
       // rather some level of timeout
       WaitForSingleObject(stProc.hProcess, INFINITE);
   end
   else
   begin
       dwExitCode := GetLastError;
       if dwExitCode = ERROR_BAD_FORMAT Then
	        raise EEncryptExeception.Create('The system does not recognize PGP as a valid program (#' + IntToStr(dwExitCode) + '). Maybe PGP is not installed correctly.')
       else
           raise EEncryptExeception.Create('PGP Startup Error : #' + IntToStr(dwExitCode));
   end;

   // TODO...1.03.02
   // release handles from create process...
   end;

{
================================================================================================

   TMD5Encrypt


================================================================================================
}
constructor TMD5Encrypt.Create;
begin
   inherited;
end;

procedure TMD5Encrypt.Encrypt;
var
   systemKey, systemSrc, systemResult : PCHAR;
   key, src : string;
   resultSize : integer;
begin
   key := PassPhrase;
   src := SourceString;

   GetMem(systemKey, length(key) + 1);
   StrCopy(systemKey, PCHAR(key + Chr(0)));

   GetMem(systemSrc, length(src) + 1);
   StrCopy(systemSrc, PCHAR(src + Chr(0)));

   if g_bLogEncryption then
       toggleLog(1)
   else
       toggleLog(0);

   resultSize := getBufferSize(systemSrc);
   GetMem(systemResult, resultSize + 1);

   MD5Encrypt(systemKey, systemSrc, systemResult);

   EncryptedString := StrPas(systemResult);

   FreeMem(systemKey);
   FreeMem(systemSrc);
   FreeMem(systemResult);
end;

procedure TMD5Encrypt.Decrypt;
var
   systemKey, systemSrc, systemResult : PCHAR;
   key, src : string;
   resultSize : integer;
begin
   key := PassPhrase;
   src := EncryptedString;

   GetMem(systemKey, length(key) + 1);
   StrCopy(systemKey, PCHAR(key + Chr(0)));

   GetMem(systemSrc, length(src) + 1);
   StrCopy(systemSrc, PCHAR(src + Chr(0)));

   if g_bLogEncryption then
       toggleLog(1)
   else
       toggleLog(0);

   resultSize := getBufferSize(systemSrc);
   GetMem(systemResult, resultSize + 1);

   MD5Decrypt(systemKey, systemSrc, systemResult);

   SourceString := StrPas(systemResult);

   FreeMem(systemKey);
   FreeMem(systemSrc);
   FreeMem(systemResult);
end;

{
================================================================================================

   TCesearEncrypt


   TODO...replace file i/o with memory stream
================================================================================================
}
constructor TCesearEncrypt.Create;
begin
   inherited;
end;

procedure TCesearEncrypt.Encrypt;
var
   oIn, oOut : TextFile;
   sSrcLine, sDestLine : String;
   nPos, nSrcAscii, nDestAscii : Integer;
begin
   AssignFile(oIn, '.\ceaser.txt');
   AssignFile(oOut, '.\ceaser.asc');
   Reset(oIn);
   Rewrite(oOut);
   while not EOF(oIn) do
   begin
       sDestLine := '';
       ReadLn(oIn, sSrcLine);
       for nPos := 1 to Length(sSrcLine) do
       begin
           nSrcAscii := Ord(sSrcLine[nPos]);
           nDestAscii := nSrcAscii + (m_nKey - 64);

           if nDestAscii < 32 then
               nDestAscii := nDestAscii + 94;

           if nDestAscii > 126 then
               nDestAscii := nDestAscii - 94;

           sDestLine := sDestLine + Chr(nDestAscii);
       end;
       WriteLn(oOut, sDestLine);
   end;
   CloseFile(oIn);
   CloseFile(oOut);
end;

procedure TCesearEncrypt.Decrypt;
var
   oIn, oOut : TextFile;
   sSrcLine, sDestLine : String;
   nPos, nSrcAscii, nDestAscii : Integer;
begin
   AssignFile(oIn, '.\ceaser.asc');
   AssignFile(oOut, '.\ceaser.txt');
   Reset(oIn);
   Rewrite(oOut);
   while not EOF(oIn) do
   begin
       sDestLine := '';
       ReadLn(oIn, sSrcLine);
       for nPos := 1 to Length(sSrcLine) do
       begin
           nSrcAscii := Ord(sSrcLine[nPos]);
           nDestAscii := nSrcAscii - (m_nKey - 64);

           if nDestAscii < 32 then
               nDestAscii := nDestAscii + 94;

           if nDestAscii > 126 then
               nDestAscii := nDestAscii - 94;

           sDestLine := sDestLine + Chr(nDestAscii);
       end;
       WriteLn(oOut, sDestLine);
   end;
   CloseFile(oIn);
   CloseFile(oOut);
end;


end.
