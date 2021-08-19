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

unit dlgEPGP;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TdlgPgpEncrypt = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    HelpBtn: TButton;
    txtWho: TLabel;
    Label2: TLabel;
    efEncryptTo: TEdit;
    efSignedBy: TEdit;
    ctlImage: TImage;
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

var
  dlgPgpEncrypt: TdlgPgpEncrypt;

implementation

uses
   encryption, displmsg, mdimax, eglobal, helpengine;

{$R *.DFM}
function TdlgPgpEncrypt.DisplayModal : Integer;
begin
   if m_nDirection = 0 then
   begin
       Caption := 'Preparing to Encrypt a message with PGP';
       txtWho.Caption := 'Encrypt To:';
   end
   else
   begin
       Caption := 'Preparing to decrypt a message with PGP';
       txtWho.Caption := 'PGP User Id:';
   end;

   HelpContext := KEY_ENCRYPTION_PGP;
   HelpFile := g_csHelpFile;
   DisplayModal := ShowModal;
end;


procedure TdlgPgpEncrypt.OKBtnClick(Sender: TObject);
var
   oPGP : TPGPEncrypt;
   dlgMsg : TdlgDisplayMessage;
begin
   if Length(Trim(efEncryptTo.Text)) = 0 then
   begin
       dlgMsg := TdlgDisplayMessage.Create(Self);
       with dlgMsg do
       begin
           NoticeText := 'PGP Requirements';
           if m_nDirection = 0 then
           begin
               DialogTitle := 'PGP Encryption Requirements';
               m_oDetailItems.Add('In order to encrypt a message with PGP ');
           end
           else
           begin
               DialogTitle := 'PGP Decryption Requirements';
               m_oDetailItems.Add('In order to decrypt a message with PGP ')
           end;

           m_oDetailItems.Add('a user id is required.  And, you also must');
           m_oDetailItems.Add('have this receiptants public key installed');
           m_oDetailItems.Add('in your PGP key ring.');
           Display;
           free;
       end;
       ModalResult := mrNone;
       exit;
   end;

   oPGP := TPGPEncrypt.Create;
   with oPGP do
   begin
       IdToSendTo := efEncryptTo.Text;
       IdToSignWith := efSignedBy.Text;
       if m_nDirection = 0 then
           Encrypt
       else
           Decrypt;
       ModalResult := mrOK;
       Free;
   end;
end;

procedure TdlgPgpEncrypt.FormCreate(Sender: TObject);
begin
   wndMaxMain.CenterFormOverSelf(Self);
end;


procedure TdlgPgpEncrypt.HelpBtnClick(Sender: TObject);
begin
   assert(NIL <> g_oHelpEngine, 'help engine is not initialized');
   g_oHelpEngine.HelpId := HelpContext;
   g_oHelpEngine.Show;
end;

end.
