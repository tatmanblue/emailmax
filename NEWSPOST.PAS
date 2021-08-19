unit newspost;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, marsCap, Menus, ExtCtrls, basepost;

type
  TwndNewsPost = class(TwndBasePost)
    ctlBkground: TImage;
    mnNotepadMenu: TMainMenu;
    mnNotepad: TMenuItem;
    mnNotepadSend: TMenuItem;
    N1: TMenuItem;
    mnNotepadClose: TMenuItem;
    mnNotepadSaveClose: TMenuItem;
    efTo: TEdit;
    efDate: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  wndNewsPost: TwndNewsPost;

implementation

{$R *.DFM}



end.
