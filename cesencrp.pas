// copyright (c) 2000 by microObjects inc.
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
unit cesencrp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  basepost, StdCtrls, Menus, ExtCtrls, basencrp;

Type
   TCeaserEncryption = class(TBaseEncryption)
   private
       m_nKey : Integer;
   public
       procedure Encrypt; override;
       procedure Decrypt; override;
   published
       property KeyChar : Integer read m_nKey write m_nKey default 64; // default 'A'
   end;

implementation
{
   Ceaser is simple letter substitution... 'A' becomes 'n' etc...
   valid ascii ranges are 32 - 126.

   Here's how encrypt will work

   Assume key is D

   D is + 3 from A.  (A is base)
   Every char value will be changed by +3
   Obviously, any value over 126 will exceed the value ascii range, so
   in that case we will substract 94 (126 - 32) to get the encrypted value
}

procedure TCeaserEncryption.Encrypt;
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

procedure TCeaserEncryption.Decrypt;
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
