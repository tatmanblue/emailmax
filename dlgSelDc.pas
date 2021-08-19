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

unit dlgSelDc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TdlgSelectDecrypt = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    HelpBtn: TButton;
    txtDirections: TLabel;
    rbPGP: TRadioButton;
    rbCeasar: TRadioButton;
    rbBeal: TRadioButton;
    rbMD5: TRadioButton;
    procedure rbPGPClick(Sender: TObject);
    procedure rbCeasarClick(Sender: TObject);
    procedure rbBealClick(Sender: TObject);
    procedure rbMD5Click(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
  private
    { Private declarations }
    m_nDirection,
    m_nSuggested,
    m_nSelected : Integer;
  public
    { Public declarations }
     function DisplayModal: Integer;
  published
     property SuggestedItem : Integer read m_nSuggested write m_nSuggested default 0;
     property SelectedItem : Integer read m_nSelected write m_nSelected default 0;
     property Direction : Integer read m_nDirection write m_nDirection default 0;

  end;

var
  dlgSelectDecrypt: TdlgSelectDecrypt;

implementation

{$R *.DFM}
uses
   eglobal, helpengine;

function TdlgSelectDecrypt.DisplayModal: Integer;
begin
   case m_nSuggested of
       0:
       begin
           rbPGP.Font.Style := [fsBold];
           rbPGP.Checked := TRUE;
       end;
       1:
       begin
           rbCeasar.Font.Style := [fsBold];
           rbCeasar.Checked := TRUE;
       end;
       2:
       begin
           rbMD5.Font.Style := [fsBold];
           rbMD5.Checked := TRUE;
       end;
       3:
       begin
           rbBeal.Font.Style := [fsBold];
           rbBeal.Checked := TRUE;
       end;
   end;

   if m_nDirection = 0 then
   begin
       Self.Caption := 'Select Encryption Method';
       txtDirections.Caption := 'You have selected to encrypt a message.  Please select the appropriate type of encryption.';
   end
   else
   begin
       Self.Caption := 'Select Decryption Method';
       txtDirections.Caption := 'You have selected to decrypt a message.  Please select the appropriate type of decryption.';
   end;

   HelpContext := KEY_ENCRYPTION;
   HelpFile := g_csHelpFile;
   DisplayModal := ShowModal;
end;

procedure TdlgSelectDecrypt.rbPGPClick(Sender: TObject);
begin
   m_nSelected := 0;
end;

procedure TdlgSelectDecrypt.rbCeasarClick(Sender: TObject);
begin
   m_nSelected := 1;
end;

procedure TdlgSelectDecrypt.rbMD5Click(Sender: TObject);
begin
   m_nSelected := 2;
end;

procedure TdlgSelectDecrypt.rbBealClick(Sender: TObject);
begin
   m_nSelected := 3;
end;

procedure TdlgSelectDecrypt.HelpBtnClick(Sender: TObject);
begin
   assert(NIL <> g_oHelpEngine);
   g_oHelpEngine.HelpId := HelpContext;
   g_oHelpEngine.Show;
end;

end.
