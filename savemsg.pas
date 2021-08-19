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

unit savemsg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  basepost, StdCtrls, Menus, ExtCtrls;

type
   TSaveMsg = class(TStringList)
   protected
       m_sFileName : String;
   public
       procedure SaveToFile(const FileName : String); override;
   published
       property FileName : String Read m_sFileName write m_sFileName;
end;

implementation

procedure TSaveMsg.SaveToFile(const FileName : String);
var
   nCount : Integer;
   sBufferLine, sCurrentLine : String;
   oFile : TextFile;
begin
   if Length(Trim(FileName)) > 0 then
       m_sFileName := FileName;

   if Length(Trim(m_sFileName)) = 0 then
      exit;

   sBufferLine := '';
   AssignFile(oFile, m_sFileName);

   Rewrite(oFile);
   for nCount := 0 to Count - 1 do
   begin
        sBufferLine := sBufferLine + Strings[nCount];

        if Length(sBufferLine) > 80 then
        begin
            while Length(sBufferLine) > 80 do
            begin
                 sCurrentLine := Copy(sBufferLine, 1, 80);
                 sBufferLine := Copy(sBufferLine, 81, Length(sBufferLine));
                 WriteLn(oFile, sCurrentLine);
            end;
        end;

        sCurrentLine := sBufferLine;
        sBufferLine := '';
        WriteLn(oFile, sCurrentLine);
   end;

   CloseFile(oFile);
   
end;

end.
