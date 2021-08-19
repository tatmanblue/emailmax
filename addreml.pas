// copyright (c) 2002 by microObjects inc.
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
unit addreml;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TdlgAddRemailer = class(TForm)
    pbOK: TButton;
    pbCancel: TButton;
    Label1: TLabel;
    Label2: TLabel;
    efSendAddress: TEdit;
    Label3: TLabel;
    efSendServer: TEdit;
    ckDefault: TCheckBox;
    procedure OnDataChange(Sender: TObject);
    procedure OnSendAddressChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TdlgAddRemailer.OnDataChange(Sender: TObject);
begin
    if (Length(Trim(efSendAddress.Text)) > 0) and
    (Length(Trim(efSendServer.Text)) > 0) then
    begin
       pbOK.Enabled := TRUE;
    end
    else
    begin
       pbOK.Enabled := FALSE;
    end;
end;

procedure TdlgAddRemailer.OnSendAddressChange(Sender: TObject);
begin
    if Pos('@', efSendAddress.Text) > 0 then
    begin
       efSendServer.Text := Copy(efSendAddress.Text, Pos('@', efSendAddress.Text) + 1, Length(efSendAddress.Text));
    end;
    OnDataChange(Sender);
end;

end.
