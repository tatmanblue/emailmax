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
unit basepane;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TwndBasePane = class(TForm)
    pbDifferent: TButton;
    procedure pbDifferentClick(Sender: TObject);
  public
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Validate; virtual; abstract;
    function GetEmailString: String; virtual; abstract;
    procedure CopyToProperties; virtual; abstract;
    procedure UpdateFields; virtual; abstract;
    procedure ResetSelf; virtual; abstract;
  end;

var
  wndBasePane: TwndBasePane;

implementation

{$R *.DFM}

uses
   why;

procedure TwndBasePane.pbDifferentClick(Sender: TObject);
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

end.
