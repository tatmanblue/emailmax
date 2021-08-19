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

unit splash;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, StdCtrls, AdvImage, jpeg;

type
  TwndSplash = class(TForm)
    Panel1: TPanel;
    ctlShutdown: TTimer;
    txtType: TLabel;
    txtVersion: TLabel;
    ctlImage: TImage;
    Panel2: TPanel;
    Panel3: TPanel;
    ctlProgress: TProgressBar;
    Label1: TLabel;
    procedure ctlShutdownTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  wndSplash: TwndSplash;

implementation

{$R *.DFM}
uses
   eglobal;

procedure TwndSplash.ctlShutdownTimer(Sender: TObject);
begin
   if ctlProgress.Position = 100 then
   begin
       ctlShutdown.Enabled := FALSE;
       PostMessage(Application.MainForm.Handle, WM_HANDLE_LOGIN, Integer(paOnStartup), 0);
       Self.Visible := FALSE;
       Self.Close;
   end;

   ctlProgress.Position := ctlProgress.Position + 20;
end;

procedure TwndSplash.FormCreate(Sender: TObject);
begin
   txtType.Caption := 'Freeware/GNU Version';

   txtVersion.Caption := GetVerInfo();
end;

end.
