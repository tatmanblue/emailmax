// copyright (c) 2002 by microObjects inc.
//
// Emailmax source is distributed under the public
// domain license arrangements.  You are free to
// modify, edit, copy, delete, or redistribute
// the emailmax code as long as you 1) indemnify and
// hold harmless microObjects inc and its employees and
// owners from any and all liablity, directly or indirectly,
// related to the use, modification or distribution
// of this code 2) and make proper credit where
// applicable.

unit result;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Clipbrd;

type
  TdlgResults = class(TForm)
    Panel1: TPanel;
    cmdQuick: TButton;
    cmdClose: TButton;
    efResults: TMemo;
    Label1: TLabel;
    procedure pbCloseClick(Sender: TObject);
    procedure pbQuickClick(Sender: TObject);
    procedure cmdCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgResults: TdlgResults;

implementation

{$R *.DFM}

procedure TdlgResults.pbQuickClick(Sender: TObject);
var
    ctlClipboard : TClipboard;
begin
    ctlClipboard := TClipboard.Create;
    with ctlClipboard do
    begin
        Clear;
        AsText := efResults.Text;
    end;
    Close;
end;


procedure TdlgResults.pbCloseClick(Sender: TObject);
begin
   Close;
end;

procedure TdlgResults.cmdCloseClick(Sender: TObject);
begin
{}
end;


end.
