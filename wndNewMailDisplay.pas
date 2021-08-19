// copyright (c) 2002 by microObjects inc.
//
// Emailmax source is distributed under the public
// domain license arrangements.  You are free to
// modify, edit, copy, delete, or redistribute
// the emailmax code as long as you 1) indemnify and hold harmless
// microObjects inc and its employees and owners
// from any and all liablity, directly or indirectly,
// related to the use, modification or distribution
// of this code 2) and make proper credit where
// applicable.
unit wndNewMailDisplay;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, AdvImage, StdCtrls, jpeg;

type
  TwndNewMail = class(TForm)
    ctrlTimer: TTimer;
    lblClose: TLabel;
    Label1: TLabel;
    ctlImage: TImage;
    procedure FormCreate(Sender: TObject);
    procedure ctrlTimerTimer(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure lblCloseClick(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure ctlImageClick(Sender: TObject);
    procedure Label1Click(Sender: TObject);
  private
    { Private declarations }
    m_bScrollingUp : Boolean;

  public
    { Public declarations }
  end;

var
  g_wndNewMail: TwndNewMail;

implementation

uses
    eglobal, mdimax;

{$R *.DFM}

procedure TwndNewMail.FormCreate(Sender: TObject);
begin
   m_bScrollingUp := TRUE;
   Self.Top := Screen.DesktopTop + Screen.DesktopHeight;
   Self.Left := Screen.DesktopWidth - Self.Width - 5;
end;

procedure TwndNewMail.ctrlTimerTimer(Sender: TObject);
begin
    if Screen.Height >= (Self.Top + Self.Width + 15) then
        ctrlTimer.Enabled := FALSE
    else
        Self.Top := Self.Top - 10;
end;

procedure TwndNewMail.FormPaint(Sender: TObject);
begin
    Canvas.Brush.Color := clWhite;
end;

procedure TwndNewMail.lblCloseClick(Sender: TObject);
begin
    //TODO...01.03.02 is it efficient to keep this in memory

    // 06.05.02
    // theres a bug in delphi or windows xp or something but
    // a minimized window is showing as having a state of wsNormal...
    // so this code is useless....use API call
    if TRUE = IsIconic(Application.MainForm.Handle) then
    begin

        // none of this works...piece of shit
        SendMessage(Application.MainForm.Handle, WM_SYSCOMMAND, SC_RESTORE, 0);
        Application.MainForm.WindowState := wsNormal;
        Application.MainForm.Refresh;
    end;

    Self.Hide;

end;

procedure TwndNewMail.FormClick(Sender: TObject);
begin
   Self.Hide;
end;

procedure TwndNewMail.ctlImageClick(Sender: TObject);
begin
   Self.Hide;
end;

procedure TwndNewMail.Label1Click(Sender: TObject);
begin
   Self.Hide;
end;

end.
