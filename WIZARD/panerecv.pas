// copyright (c) 2002  by microObjects inc.
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
unit panerecv;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  basepane, StdCtrls, ExtCtrls;

type
  TwndReceivePane = class(TwndBasePane)
    rbYes: TRadioButton;
    rbNo: TRadioButton;
    label1: TLabel;
    efWho: TEdit;
    Label2: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    efPop: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    efPassword: TEdit;
    Label7: TLabel;
    procedure rbYesClick(Sender: TObject);
    procedure rbNoClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure pbDifferentClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure CopyToProperties; override;
    procedure UpdateFields; override;
    procedure Validate; override;
    function GetEmailString: String; override;
    procedure ResetSelf; override;

  end;

var
  wndReceivePane: TwndReceivePane;

implementation

uses
   global, encryption, panesend, why, eglobal, alias;

{$R *.DFM}

procedure TwndReceivePane.UpdateFields;
var
   nPos : Integer;
begin
  efWho.Text := TwndSendEmail(wndPanes[0]).SendEmail;
  nPos := Pos(g_csAtSign, efWho.Text);
  efPop.Text := Copy(efWho.Text, nPos + 1, Length(efWho.Text));
end;

procedure TwndReceivePane.CopyToProperties;
begin
{}
end;

procedure TwndReceivePane.Validate;
begin
   if rbYes.Checked = TRUE then
   begin
       if Length(efWho.Text) = 0 then
           raise Exception.Create('Contact Support.  Serious error occurred.');

       if Length(efPop.Text) = 0 then
           raise Exception.Create('A Pop Domain is required if you want to received email from the account');

       if Length(efPassword.Text) = 0 then
           raise Exception.Create('A password is required for POP access');
                      
   end;
end;

function TwndReceivePane.GetEmailString: String;
var
   sRetString,
   sUserId : String;
   oAlias : TEmailAlias;
begin
   if rbYes.Checked = TRUE then
   begin
       oAlias := TEmailAlias.Create;

       sUserId := Copy(efWho.Text, 1, Pos(g_csAtSign, efWho.Text) - 1);

       sRetString := oAlias.BuildString(efWho.Text, efPop.Text, sUserId, efPassword.Text, g_cnServerPOP, g_cnUsageRecv, TRUE, FALSE, TRUE);

       oAlias.Free;
   end
   else
       sRetString := '';

   GetEmailString := sRetString;

end;

procedure TwndReceivePane.rbYesClick(Sender: TObject);
begin
   inherited;
   efPop.Enabled := TRUE;
   efPassword.Enabled := TRUE;
end;

procedure TwndReceivePane.rbNoClick(Sender: TObject);
begin
  inherited;
   efPop.Enabled := FALSE;
   efPassword.Enabled := FALSE;
end;

procedure TwndReceivePane.FormActivate(Sender: TObject);
begin
  inherited;
  efWho.Text := TwndSendEmail(wndPanes[0]).SendEmail;
end;

procedure TwndReceivePane.pbDifferentClick(Sender: TObject);
var
   dlgWhy : TdlgWhy;
begin
   dlgWhy := TdlgWhy.Create(Self);
   with dlgWhy do
   begin
       ShowModal;
       free;
   end;
end;

procedure TwndReceivePane.ResetSelf;
begin
   rbYes.Checked := TRUE;
   efPop.Text := '';
   efPassword.Text := '';
end;


end.
