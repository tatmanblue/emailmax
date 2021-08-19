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
unit about;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, AdvImage, ShellApi, jpeg;

type
  TdlgAbout = class(TForm)
    pbOK: TButton;
    txtType: TStaticText;
    Label1: TLabel;
    Label2: TLabel;
    txtVersion: TStaticText;
    ctlImage: TImage;
    procedure pbOKClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.DFM}

uses
    eglobal;

procedure TdlgAbout.pbOKClick(Sender: TObject);
begin
   Close;
end;

procedure TdlgAbout.FormPaint(Sender: TObject);
begin
   Canvas.Brush.Color := clWhite;
end;

procedure TdlgAbout.FormCreate(Sender: TObject);
begin
   txtType.Caption := 'Freeware Version';
   txtVersion.Caption := getVerInfo();
   self.Caption := 'About ' + Application.Title;
end;

procedure TdlgAbout.Label2Click(Sender: TObject);
begin
    ShellExecute(Self.Handle, 'open' + Chr(0), 'www.microobjects.com' + Chr(0), 0, 0, SW_NORMAL);
end;

end.
