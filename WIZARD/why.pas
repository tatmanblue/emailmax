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
unit why;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TdlgWhy = class(TForm)
    pbOK: TButton;
    efWhy: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgWhy: TdlgWhy;

implementation

{$R *.DFM}

end.

