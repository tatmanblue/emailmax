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
unit dlgEMD5;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TdlgMD5Handler = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    HelpBtn: TButton;
    txtWho: TLabel;
    efEncryptPhase: TEdit;
    txtType: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
  private
    { Private declarations }
    FDirection : Integer;
  public
    { Public declarations }
  published
       property Direction : Integer read FDirection write FDirection;
  end;

implementation

{$R *.DFM}

uses
   eglobal, helpengine;

procedure TdlgMD5Handler.FormCreate(Sender: TObject);
begin
   FDirection := 0;
end;

procedure TdlgMD5Handler.FormShow(Sender: TObject);
var
   typeName : String;
begin
   if FDirection = 0 then
   begin
       typeName := 'Encrypt';
   end
   else
   begin
       typeName := 'Decrypt';
   end;

   Self.Caption := typeName + Self.Caption;
   txtType.Caption := typeName + txtType.Caption;
   HelpContext := KEY_ENCRYPTION_MD5;
   HelpFile := g_csHelpFile;


end;

procedure TdlgMD5Handler.HelpBtnClick(Sender: TObject);
begin
   assert(NIL <> g_oHelpEngine, 'help engine is not initialized');
   g_oHelpEngine.HelpId := HelpContext;
   g_oHelpEngine.Show;

end;

end.
