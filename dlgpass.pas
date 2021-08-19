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

unit dlgpass;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, AdvImage, eglobal;

type
  TdlgPassword = class(TForm)
    pbOK: TButton;
    pbCancel: TButton;
    txtLogon: TLabel;
    Label1: TLabel;
    efPassword: TEdit;
    txtAction: TLabel;
    txtAttempts: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure efPasswordChange(Sender: TObject);
    procedure pbOKClick(Sender: TObject);
  private
    { Private declarations }
    m_nAttempts : Integer;
    m_nActionType : TPasswordAction;
    m_sVerifiedPassword,
    m_sPassword,
    m_sExtraInfo : String;
  public
    { Public declarations }
    function Display : Integer;
  published
     property ActionType : TPasswordAction read m_nActionType write m_nActionType default paOnStartup;
     property Password : String read m_sPassword write m_sPassword;
     property ExtraInfo : String read m_sExtraInfo write m_sExtraInfo;
     property VerifiedPassword : String read m_sVerifiedPassword write m_sVerifiedPassword;
  end;

implementation

{$R *.DFM}

procedure TdlgPassword.FormCreate(Sender: TObject);
begin
   txtLogon.Caption := g_csApplicationTitle + ' Log On';
   m_nAttempts := 0;
end;

function TdlgPassword.Display : Integer;
var
   nRet : Integer;
begin
   case ActionType of
       paOnStartup: txtAction.Caption := 'Start up requires password verification';
       paOnSend: txtAction.Caption := 'Sending email requires password verification';
       paOnCheck: txtAction.Caption := 'Checking email requires password verification';
       paOnPasswordForEmail: txtAction.Caption := 'Account <' + m_sExtraInfo + '> requires password verification';
   end;

   nRet := ShowModal;
   Display := nRet;
end;

procedure TdlgPassword.efPasswordChange(Sender: TObject);
begin
   if Length(efPassword.Text) > 0 then
       pbOK.Enabled := TRUE
   else
       pbOK.Enabled := FALSE;
end;

procedure TdlgPassword.pbOKClick(Sender: TObject);
begin
   if VerifiedPassword = efPassword.Text then
       ModalResult := mrOK
   else
   begin
       m_nAttempts := m_nAttempts + 1;
       if m_nAttempts > 3 then
       begin
           ModalResult := mrCancel;
       end;
           
       txtAttempts.Caption := 'Log on attempts:' + IntToStr(m_nAttempts);
   end;
end;

end.
