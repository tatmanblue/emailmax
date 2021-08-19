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

unit basesetuptab;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ComCtrls;

type
  TdlgBaseSetupTab = class(TForm)
  private
    { Private declarations }
  protected
    m_nHelpId : Integer;
  public
    { Public declarations }
    procedure Load; virtual; abstract;
    procedure Save; virtual; abstract;
  published
    property HelpId : Integer read m_nHelpId write m_nHelpId default 0;
  end;

implementation

{$R *.DFM}


end.
