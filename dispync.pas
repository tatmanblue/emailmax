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
unit dispync;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  displmsg, StdCtrls, ExtCtrls;

type
  TdlgDisplayYesNoCancel = class(TdlgDisplayMessage)
    pbNo: TButton;
    pbYes: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    txtYesAction: TLabel;
    txtNoAction: TLabel;
    txtCancelAction: TLabel;
    procedure pbYesClick(Sender: TObject);
    procedure pbNoClick(Sender: TObject);
    procedure pbCloseClick(Sender: TObject);
  private
    { Private declarations }
    m_sYesOption, m_sNoOption, m_sCancelOption : String;
  public
    { Public declarations }
    property YesOptionText : String read m_sYesOption write m_sYesOption;
    property NoOptionText : String read m_sNoOption write m_sNoOption;
    property CancelOptionText : String read m_sCancelOption write m_sCancelOption;

    function DisplayModal : Integer;
    procedure Setup; override;
  end;

var
  dlgDisplayYesNoCancel: TdlgDisplayYesNoCancel;

implementation

{$R *.DFM}

procedure TdlgDisplayYesNoCancel.pbYesClick(Sender: TObject);
begin
   inherited;
   ModalResult := mrYes;
end;

procedure TdlgDisplayYesNoCancel.pbNoClick(Sender: TObject);
begin
   inherited;
   ModalResult := mrNo;
end;

procedure TdlgDisplayYesNoCancel.pbCloseClick(Sender: TObject);
begin
   inherited;
   ModalResult := mrCancel;
end;

function TdlgDisplayYesNoCancel.DisplayModal : Integer;
begin
   Setup;
   DisplayModal := ShowModal;
end;

procedure TdlgDisplayYesNoCancel.Setup; 
begin
   inherited Setup;
   txtYesAction.Caption := m_sYesOption;
   txtNoAction.Caption := m_sNoOption;
   txtCancelAction.Caption := m_sCancelOption;

end;

end.
