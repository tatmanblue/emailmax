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
unit dlgshutdown;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  displmsg, StdCtrls, ExtCtrls;

type
  TdlgShutdownInfo = class(TdlgDisplayMessage)
  private
    { Private declarations }

  public
    { Public declarations }
    procedure moreDetail(additionalText : String);
  end;

implementation

{$R *.DFM}

procedure TdlgShutdownInfo.moreDetail(additionalText : String);
begin
   txtDetails.Lines.Add(additionalText);
end;

end.
