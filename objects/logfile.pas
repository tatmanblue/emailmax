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
unit logfile;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SyncObjs;

type
   TLogFile = class(TObject)
   private
       m_oFile : TextFile;
       m_bDoLogging : Boolean;

       m_CriticalSection : TCriticalSection;

   public
       constructor Create;
        
       destructor Destroy; override;

       procedure Open;
       procedure Flushfile;
       procedure Close;
       procedure Write(sLine : String);
   published
       property LoggingOn : Boolean read m_bDoLogging write m_bDoLogging default FALSE;

   end;


implementation

uses
   eglobal;

{
================================================================================
Log
================================================================================
}
procedure TLogFile.Open;
begin

   AssignFile(m_oFile, g_oDirectories.ProgramDataPath + g_csLogFileName);

   if TRUE = FileExists(g_oDirectories.ProgramDataPath + g_csLogFileName) then
   begin
       try
          Append(m_oFile);
       except
          Rewrite(m_oFile);
          Append(m_oFile);
       end;
   end
   else
       Rewrite(m_oFile);

end;

// CHG 1.11.02
procedure TLogFile.FlushFile;
begin

   Flush(m_oFile);
end;

// CHG 1.11.02
procedure TLogFile.Close;
begin
   CloseFile(m_oFile);
end;

// CHG 1.11.02
procedure TLogFile.Write(sLine : String);
var
   sOutput : String;
   dtNow : TDateTime;
begin
   if TRUE = LoggingOn then
   begin
      if Not Assigned(m_CriticalSection) then
         raise Exception.Create('log file Critical Section not assigned');

       m_CriticalSection.Enter;
       try
          dtNow := Now;
          sOutput := DateTimeToStr(dtNow) + '>>' + sLine;
          WriteLn(m_oFile, sOutput);
          FlushFile;
       except
          // dont care
       end;

       m_CriticalSection.Leave;  
   end;
end;

// CHG 1.11.02
constructor TLogFile.Create;
begin
   inherited;
   m_CriticalSection := TCriticalSection.Create;
end;

// CHG 1.11.02
destructor TLogFile.Destroy;
begin
   if Assigned(m_CriticalSection) then
      m_CriticalSection.free;

   inherited;
end;

end.
