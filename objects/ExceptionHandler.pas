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
unit ExceptionHandler;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, OleCtrls, isp3;

type
   TExceptionHandler = class(TObject)
   protected
       m_oHandlerFunc : TExceptionEvent;
   public
       constructor Create; 
       procedure EmailmaxException(Sender : TObject; E: Exception);
   published
       property HandlerFunction : TExceptionEvent read m_oHandlerFunc write m_oHandlerFunc;
   end;

implementation

uses
   eglobal, logfile;

constructor TExceptionHandler.Create;
begin
   inherited;
   HandlerFunction := EmailmaxException;
end;

procedure TExceptionHandler.EmailmaxException(Sender : TObject; E: Exception);
var
   fLogStatus : Boolean;
begin
   // TODO...9.15.01 This is stupid
   // if the global loging object does not exist
   // then either create it or create a local instance
   if Assigned(g_oLogFile) then
   begin
       fLogStatus := g_oLogFile.LoggingOn;
       g_oLogFile.LoggingOn := TRUE;
       try
           g_oLogFile.Write('EXCEPTION CAUGHT: "' + E.Message + '" in "' + Sender.ClassName + '"');
       except
           g_oLogFile.Write('Could not log exception');
       end;
       g_oLogFile.Flushfile();
       g_oLogFile.LoggingOn := fLogStatus;

       if TRUE = g_bShowExceptions then
       begin
           Application.ShowException(E);
       end;
   end
   else
   begin
       E.Message := E.Message + '(forced)';
       Application.ShowException(E);
   end;

end;


end.
