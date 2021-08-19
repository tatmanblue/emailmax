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
// applicable.KDECap, 
unit complete;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, Menus, ImgList, wndfolder, email;

type
  TwndComplete = class(TwndFolder)
    mnCompleteMenu: TMainMenu;
    mnCompleteItem: TMenuItem;
    mnCompleteItemOpen: TMenuItem;
    mnCompMoveTo: TMenuItem;
    mnCompSep1: TMenuItem;
    mnCompleteItemDelete: TMenuItem;
    mnCompleteItemDeleteAll: TMenuItem;
    mnCompletePopup: TPopupMenu;
    mnCompletePopOpen: TMenuItem;
    mnCompletePopMoveTo: TMenuItem;
    N1: TMenuItem;
    mnCompletePopDelete: TMenuItem;
    mnCompletePopDelAll: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure mnCompleteMoveClick(Sender: TObject);
    procedure mnCompleteDeleteClick(Sender: TObject);
    procedure mnCompleteDeleteAllClick(Sender: TObject);
    procedure mnCompleteOpenClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mnCompletePrintClick(Sender: TObject);
    procedure mnPreviewClick(Sender: TObject);
  private
    { Private declarations }
    procedure SetupMenuOptions;
  protected
  public
    { Public declarations }
    procedure LoadFromFileFolder; override;
    procedure AddMsgToListView(aMsg : TBaseEmail); override;
  end;

var
  wndComplete: TwndComplete;

implementation

uses
   alias, folder, foldlist, notepad, eglobal;

{$R *.DFM}
procedure TwndComplete.SetupMenuOptions;
var
   bEnabled : Boolean;
begin
     if ctlMessages.Items.Count > 0 then
        bEnabled := TRUE
     else
        bEnabled := FALSE;

    mnCompleteItemOpen.Enabled := bEnabled;
    mnCompleteItemDelete.Enabled := bEnabled;
    mnCompleteItemDeleteAll.Enabled := bEnabled;
    mnCompMoveTo.Enabled := bEnabled;

end;

procedure TwndComplete.AddMsgToListView(aMsg : TBaseEmail);
var
   oItem : TListItem;
begin
   with ctlMessages.Items do
   begin
       oItem := Add;
   end;
   with oItem do
   begin
       Caption := aMsg.SendTo;
       SubItems.Add(aMsg.Subject);
       SubItems.Add(aMsg.Date);
       SubItems.Add(aMsg.From);
       SubItems.Add(aMsg.SMTPServer);
       SubItems.Add(aMsg.MsgTextFileName);
   end;

   IconForMessages;
   SetupMenuOptions;
end;

procedure TwndComplete.LoadFromFileFolder;
var
   nCount : Integer;
   oItem : TListItem;
begin

   with ctlMessages.Items do
   begin
       for nCount := 0 to g_oFolders[m_nFolderId].Count - 1 do
       begin
           oItem := Add;
           with oItem do
           begin
               g_oFolders[m_nFolderId].ActiveIndex := nCount;
               Caption := g_oFolders[m_nFolderId].GetTo;
               SubItems.Add(g_oFolders[m_nFolderId].GetSubject);
               SubItems.Add(g_oFolders[m_nFolderId].GetDate);
               SubItems.Add(g_oFolders[m_nFolderId].GetFrom);
               SubItems.Add('');
               SubItems.Add(g_oFolders[m_nFolderId].GetFileName);
           end;
       end;
   end;
   IconForMessages;
   SetupMenuOptions;
end;

procedure TwndComplete.FormCreate(Sender: TObject);
begin
   inherited;
   FolderId := g_cnOutFolder;
   g_oFolders[m_nFolderId].SetDisplayForm := Self;
   LoadFromFileFolder;
end;

procedure TwndComplete.mnCompleteMoveClick(Sender: TObject);
begin
   MoveToAnotherFolder;
   SetupMenuOptions;
end;

procedure TwndComplete.mnCompleteDeleteClick(Sender: TObject);
begin
   inherited;
   MoveToTrash;
   SetupMenuOptions;
end;

procedure TwndComplete.mnCompleteDeleteAllClick(Sender: TObject);
var
   nCount, nMax : Integer;
   oItem : TListItem;
begin
   inherited;
   nMax := ctlMessages.Items.Count;
   for nCount := 0 to nMax - 1 do
   begin
       oItem := ctlMessages.Items[0];
       ctlMessages.ItemFocused := oItem;
       MoveToTrash;
   end;
   SetupMenuOptions;
end;

procedure TwndComplete.mnCompleteOpenClick(Sender: TObject);
begin
   OpenSelectedMsg;
end;

procedure TwndComplete.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   inherited;
   wndComplete := Nil;
end;

procedure TwndComplete.mnCompletePrintClick(Sender: TObject);
begin
  inherited;
  PrintMsg(false);
end;

procedure TwndComplete.mnPreviewClick(Sender: TObject);
begin
  inherited;
  PreviewMsg;
end;

end.
