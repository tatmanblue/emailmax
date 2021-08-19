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

unit trash;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  wndfolder, ComCtrls, ExtCtrls, Menus, ImgList, StdCtrls,
  email;

type
  TwndTrash = class(TwndFolder)
    mnActions: TPopupMenu;
    mnActionEmpty: TMenuItem;
    N1: TMenuItem;
    mnActionMove: TMenuItem;
    mnTrashMain: TMainMenu;
    mnTrashBasket: TMenuItem;
    mnTrashEmpty: TMenuItem;
    mnTrashMove: TMenuItem;
    procedure mnTrashMoveClick(Sender: TObject);
    procedure mnTrashEmptyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    procedure DoEmptyTrash;
    procedure LoadFromFileFolder; override;
    procedure AddMsgToListView(aMsg : TBaseEmail); override;
  public
    { Public declarations }
    procedure UserToDeleteMsg; override;
    procedure SetupMenuOptions;
    procedure EmptyTrash;
  end;

var
  wndTrash: TwndTrash;

implementation

uses
   alias, folder, foldlist, dispyn, eglobal;

{$R *.DFM}

procedure TwndTrash.SetupMenuOptions;
var
   bEnabled : Boolean;
begin
    if ctlMessages.Items.Count > 0 then
       bEnabled := TRUE
    else
       bEnabled := FALSE;
       
    mnActionEmpty.Enabled := bEnabled;
    mnActionMove.Enabled := bEnabled;
    mnTrashEmpty.Enabled := bEnabled;
    mnTrashMove.Enabled := bEnabled;

end;

procedure TwndTrash.AddMsgToListView(aMsg : TBaseEmail);
var
   oItem : TListItem;
begin
   // TODO..07.03.02 found another instance where code belongs in
   // parent class...duh

   if Not Assigned(aMsg) then
      raise Exception.Create('aMsg not Assigned in TwndTrash.AddMsgToListView');

   with ctlMessages.Items do
   begin
       oItem := Add;
   end;
   with oItem do
   begin
       Caption := aMsg.SendTo;
       SubItems.Add(aMsg.Subject);
       SubItems.Add(aMsg.From);
   end;

   IconForMessages;
   SetupMenuOptions;
end;


procedure TwndTrash.LoadFromFileFolder;
var
   nCount : Integer;
   oItem : TListItem;
begin
   // TODO..07.03.02 found another instance where code belongs in
   // parent class...duh
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
               SubItems.Add(g_oFolders[m_nFolderId].GetFrom);
           end;
       end;
   end;
   IconForMessages;
   SetupMenuOptions;
end;


procedure TwndTrash.mnTrashMoveClick(Sender: TObject);
begin
  MoveToAnotherFolder;
  SetupMenuOptions;
end;

procedure TwndTrash.mnTrashEmptyClick(Sender: TObject);
begin
   DoEmptyTrash;
end;

procedure TwndTrash.FormCreate(Sender: TObject);
begin
  inherited;
  FolderId := g_cnTrashFolder;
  g_oFolders[m_nFolderId].SetDisplayForm := Self;
  LoadFromFileFolder;

end;

procedure TwndTrash.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   inherited;
   wndTrash := Nil; 
end;

procedure TwndTrash.UserToDeleteMsg;
begin
   DeleteSelectedMsg;
   IconForMessages;
   SetupMenuOptions;

end;

procedure TwndTrash.EmptyTrash;
begin
   DoEmptyTrash;
end;

procedure TwndTrash.DoEmptyTrash;
var
   dlgConfirm : TdlgDisplayYesNo;
   nRet, nCount, nItems : Integer;
begin
   if 0 = ctlMessages.Items.Count then
       exit;

   dlgConfirm := TdlgDisplayYesNo.Create(Self);

   with dlgConfirm do
   begin
       YesOptionText := 'Empty all of the email messages in "Trash".';
       NoOptionText := 'Do not delete any of the email messages.';
       DialogTitle := 'Confirm Emptying the trash basket...';
       m_oDetailItems.Add('You have chosen to empty the trash basket.' +
                          Chr(13) + Chr(10) +
                          'Please choose the desired action you wish to take' +
                          ' from the options below.' +
                          Chr(13) + Chr(10) +
                          'Note: once made, your choice cannot be undone.');
       NoticeText := 'Confirmation Required';
       Setup;
       nRet := DisplayModal;
       free;
   end;

   if nRet = IDYES then
   begin
       nItems := ctlMessages.Items.Count;
       g_oLogFile.Write('Deleting ' + IntToStr(nItems) + 'from trash folder in function DoEmptyTrash');
       for nCount := 0 to nItems - 1 do
       begin
           try
               ctlMessages.Items.Delete(0);
               g_oFolders[m_nFolderId].ActiveIndex := 0;
               g_oFolders[m_nFolderId].DeleteMsg;
           except
               on oError : Exception do
               begin
                  g_oLogFile.Write('DoEmptyTrash exception: ' + oError.Message);
               end;
           end;
       end;
       g_oLogFile.Write('Completed Deleting items in DoEmptyTrash');
   end;
   IconForMessages;
   SetupMenuOptions;
end;

procedure TwndTrash.FormActivate(Sender: TObject);
begin
  inherited;
  //
end;

end.
