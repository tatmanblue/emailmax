unit spamctl;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls;

type
  TdlgSpamControl = class(TForm)
    pbOK: TButton;
    pbCancel: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgSpamControl: TdlgSpamControl;

implementation

{$R *.DFM}

end.
