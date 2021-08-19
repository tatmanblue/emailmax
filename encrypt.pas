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

unit Encrypt;

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
       procedure Encrypt;
       procedure Decrypt;

   published
       property EncryptedString : String read m_sEncrypt write m_sEncrypt;
       property SourceString : String read m_sSource write m_sSource;


   end;

implementation

constructor TEncrypt.Create;
begin
   inherited Create;
   m_sSource := '';
   m_sEncrypt := '';
end; // constructor TEncrypt.Create;

procedure TEncrypt.Encrypt;
var
   nCount, nLen, nOffSet : Integer;
   vRandom : Variant;
begin
   nLen := Length(m_sSource);
   if nLen = 0 then
   begin
       raise EEncryptExeception.Create('(Class TEncrypt) No source has been defined.');
   end;

   m_sEncrypt := '';

   Randomize;
   vRandom := (Random * 10);
   nOffset := vRandom + 32;

   if nOffset > 255 then
       nOffset := nOffset - 255;
       
   m_sEncrypt := Chr(nOffset);
   for nCount := 1 to nLen do
   begin
       m_sEncrypt := m_sEncrypt + Chr(Ord(m_sSource[nCount]) + nOffset);
   end;

end; // procedure TEncrypt.Encrypt;

procedure TEncrypt.Decrypt;
var
   nCount, nLen, nOffSet : Integer;
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
       m_sSource := m_sSource + Chr(Ord(m_sEncrypt[nCount]) - nOffset);
   end;
end; // procedure TEncrypt.Decrypt;


end.
