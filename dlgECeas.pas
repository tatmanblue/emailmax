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

unit dlgECeas;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, registry;

type
  TdlgEncryptCeaser = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    HelpBtn: TButton;
    txtNote: TLabel;
    Label2: TLabel;
    efChar: TEdit;
    ctlCeaserChg: TUpDown;
    procedure ctlCeaserChgClick(Sender: TObject; Button: TUDBtnType);
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
  private
    { Private declarations }
    m_nDirection : Integer;

  public
    { Public declarations }
    function DisplayModal : Integer;
  published
     property Direction : Integer  read m_nDirection write m_nDirection default 0;
  end;

implementation

{$R *.DFM}

uses
   encryption, displmsg, mdimax, eglobal, helpengine;


procedure TdlgEncryptCeaser.ctlCeaserChgClick(Sender: TObject;
  Button: TUDBtnType);
begin
   if Button = btNext then
   begin
       efChar.Tag := efChar.Tag + 1;
       if efChar.Tag > 126 then
           efChar.Tag := 32;
   end
   else
   begin
       efChar.Tag := efChar.Tag - 1;
       if efChar.Tag < 32 then
           efChar.Tag := 126;
   end;
   if efChar.Tag = 32 then
      efChar.Text := '<space>'
   else
      efChar.Text := Chr(efChar.Tag);

   ctlCeaserChg.Position := efChar.Tag;

end;

function TdlgEncryptCeaser.DisplayModal : Integer;
begin
   if m_nDirection = 0 then
   begin
       Caption := 'Preparing to Encrypt a message with Ceaser';
       txtNote.Caption := 'Pick the key character to begin the encryption with:';
   end
   else
   begin
       Caption := 'Preparing to decrypt a message with Ceaser';
       txtNote.Caption := 'Pick the key character to begin the decryption with:';
   end;

   HelpContext := KEY_ENCRYPTION_CAESAR;
   HelpFile := g_csHelpFile;


   DisplayModal := ShowModal;
end;

procedure TdlgEncryptCeaser.OKBtnClick(Sender: TObject);
var
   oCeaser : TCesearEncrypt;
begin
   // TODO...get source/dest into/from memory rather
   // than files
   //
   oCeaser := TCesearEncrypt.Create;
   with oCeaser do
   begin
       KeyChar := efChar.Tag;
       if m_nDirection = 0 then
           Encrypt
       else
           Decrypt;
       ModalResult := mrOK;
   end;
end;

procedure TdlgEncryptCeaser.FormCreate(Sender: TObject);
var
   oRegistry : TRegistry;
   sRead : String;
begin
   oRegistry := TRegistry.Create;
   with oRegistry do
   begin
       RootKey := EMAILMAX_ROOT_KEY;
       OpenKey(g_csBaseKey, TRUE);
       sRead := ReadString('CaesarDefault');
       efChar.Text := sRead[1];
       efChar.Tag := Ord(sRead[1]);
       ctlCeaserChg.Position := Ord(sRead[1]);
       CloseKey;
       Free;
   end;

end;

procedure TdlgEncryptCeaser.HelpBtnClick(Sender: TObject);
begin
   assert(NIL <> g_oHelpEngine, 'help engine is not initialized');
   g_oHelpEngine.HelpId := HelpContext;
   g_oHelpEngine.Show;

end;

end.
