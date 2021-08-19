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
unit addnews;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TdlgAddNewsGroup = class(TForm)
    Label1: TLabel;
    pbOK: TButton;
    pbCancel: TButton;
    efNewsGroup: TEdit;
    procedure efNewsGroupChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}


procedure TdlgAddNewsGroup.efNewsGroupChange(Sender: TObject);
begin
     if Length(Trim(efNewsGroup.TexT)) > 0 then
        pbOK.Enabled := TRUE
     else
         pbOK.Enabled := FALSE;

end;

end.
