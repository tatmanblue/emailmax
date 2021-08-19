// copyright (c) 2002 by microObjects inc.
//
// Emailmax source is distributed under the public
// domain license arrangements.  You are free to
// modify, edit, copy, delete, or redistribute
// the emailmax code as long as you 1) indemnify and hold harmless
// microObjects inc and its employees and owners
// from any and all liablity, directly or indirectly,
// related to the use, modification or distribution
// of this code 2) and make proper credit where
// applicable.

unit draft;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  wndfolder, ImgList, StdCtrls, ComCtrls, ExtCtrls, Menus;

type
  TwndDraft = class(TwndFolder)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  wndDraft: TwndDraft;

implementation

uses
   eglobal;

{$R *.DFM}

procedure TwndDraft.FormCreate(Sender: TObject);
begin
   inherited;
   
   FolderId := g_cnDraftFolder;
   if Not Assigned(g_oFolders[m_nFolderId]) then
       raise Exception.Create('g_oFolders[m_nFolderId] not assigned in TwndInbound.FormCreate');

   g_oFolders[m_nFolderId].SetDisplayForm := Self;
   LoadFromFileFolder;

end;

end.
