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
unit paneconf;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  basepane, StdCtrls, ExtCtrls;

type
  TwndConfirm = class(TwndBasePane)
    Label1: TLabel;
    ckDoAnother: TCheckBox;
    Label2: TLabel;
    procedure ckDoAnotherClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure CopyToProperties; override;
    procedure UpdateFields; override;
    procedure Validate; override;
    function IsUserDone: Boolean; virtual;
    function GetEmailString: String; override;
    procedure ResetSelf; override;

  end;

var
  wndConfirm: TwndConfirm;

implementation

{$R *.DFM}
uses
   global, mainwiz;

procedure TwndConfirm.CopyToProperties;
begin
end;

procedure TwndConfirm.UpdateFields;
begin
end;

procedure TwndConfirm.Validate;
begin
end;

function TwndConfirm.GetEmailString: String;
begin
   GetEmailString := ''; 
end;

function TwndConfirm.IsUserDone : Boolean;
begin
   if ckDoAnother.Checked then
       IsUserDone := FALSE
   else
       IsUserDone := TRUE;
end;

procedure TwndConfirm.ResetSelf;
begin
//
end;

procedure TwndConfirm.ckDoAnotherClick(Sender: TObject);
begin
   inherited;
   if ckDoAnother.Checked = TRUE then
       SendMessage(dlgWizard.Handle, g_cmsgCREATE_MORE, 1, 0)
   else
      SendMessage(dlgWizard.Handle, g_cmsgCREATE_MORE, 0, 0)
end;

end.
