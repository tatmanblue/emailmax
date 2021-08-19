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
unit panesend;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  basepane, StdCtrls, ExtCtrls;

type
  TwndSendEmail = class(TwndBasePane)
    Label1: TLabel;
    efSendFrom: TEdit;
    Label2: TLabel;
    efSMTP: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ckDefault: TCheckBox;
    Label6: TLabel;
    procedure efSendFromChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    m_sSendFrom : String;
    m_bFirstRun : Boolean;
  public
    { Public declarations }
    procedure CopyToProperties; override;
    procedure UpdateFields; override;
    procedure Validate; override;
    function GetEmailString: String; override;
    procedure ResetSelf; override;
  published
    property SendEmail : String read m_sSendFrom write m_sSendFrom;
  end;

var
  wndSendEmail: TwndSendEmail;

implementation

uses
   global, eglobal, alias;

{$R *.DFM}
procedure TwndSendEmail.UpdateFields;
begin
end;

procedure TwndSendEmail.CopyToProperties;
begin
   SendEmail := efSendFrom.Text;
end;

procedure TwndSendEmail.Validate;
begin
    if Length(efSendFrom.Text) = 0 then
    begin
        raise Exception.Create('An "email address" is needed for Sending Email');
    end;

    if Length(efSMTP.Text) = 0 then
    begin
        raise Exception.Create('A "Server Name" is needed for Sending Email');
    end;

    if Pos('@', efSendFrom.Text) = 0 then
    begin
        raise Exception.Create('The "email address" for Sending Email is invalid');
    end;
end;

function TwndSendEmail.GetEmailString;
var
   sRetString,
   sUserId : String;
   oAlias : TEmailAlias;
begin

   oAlias := TEmailAlias.Create;

   sUserId := Copy(efSendFrom.Text, 1, Pos(g_csAtSign, efSendFrom.Text) - 1);
   sRetString := oAlias.BuildString(efSendFrom.Text, efSmtp.Text, sUserId, g_csNA, g_cnServerSMTP, g_cnUsageSend, false, m_bFirstRun, FALSE);

   oAlias.Free;

   GetEmailString := sRetString;

end;

procedure TwndSendEmail.efSendFromChange(Sender: TObject);
begin
  inherited;
  if Pos(g_csAtSign, efSendFrom.Text) > 0 then
  begin
       efSmtp.Text := Copy(efSendFrom.Text, Pos('@', efSendFrom.Text) + 1, Length(efSendFrom.Text));
  end;
end;

procedure TwndSendEmail.ResetSelf;
begin
   efSendFrom.Text := '';
   efSMTP.Text := '';
   m_bFirstRun := FALSE;
end;


procedure TwndSendEmail.FormCreate(Sender: TObject);
begin
   inherited;
   if g_bInitialInstall then
       m_bFirstRun := TRUE
   else
       m_bFirstRun := FALSE;
end;

end.
