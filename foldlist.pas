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

unit foldlist;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, ImgList, Menus;

type
  TdlgFolderList = class(TForm)
    Panel1: TPanel;
    pbOK: TButton;
    pbCancel: TButton;
    Panel2: TPanel;
    lvFolders: TListView;
    ctlImages: TImageList;
    mnItemsPopup: TPopupMenu;
    mnListIcon: TMenuItem;
    mnListList: TMenuItem;
    mnListReport: TMenuItem;
    procedure FormCreate(Sender: TObject);
    // procedure lbFolderListDblClick(Sender: TObject);
    procedure pbOKClick(Sender: TObject);
    procedure pbCancelClick(Sender: TObject);
    procedure lvFoldersClick(Sender: TObject);
    procedure lvFoldersDblClick(Sender: TObject);
    procedure mnListReportClick(Sender: TObject);
    procedure mnListListClick(Sender: TObject);
    procedure mnListIconClick(Sender: TObject);
    // procedure lbFolderListClick(Sender: TObject);
  private
    { Private declarations }
    m_nFolderId : Integer;
    m_nExcludeFolders : Integer;
  public
    { Public declarations }
    procedure DisplayModal;
  published
     property SelectedFolder : Integer read m_nFolderId write m_nFolderId default -1;
     property ExcludeFolder : Integer read m_nExcludeFolders write m_nExcludeFolders;
  end;

implementation

uses
   alias, folder, eglobal, helpengine;
{$R *.DFM}

procedure TdlgFolderList.DisplayModal;
var
   nCount : Integer;
   oItem : TListItem;
begin
   for nCount := 0 to High(g_oFolders) - 1 do
   begin
       oItem := lvFolders.Items.Add;

       oItem.Caption := g_oFolders[nCount].Name;
       if g_cnFirstUserFolder > nCount then
           oItem.ImageIndex := nCount
       else
           oItem.ImageIndex := g_cnFirstUserFolder;

       //oItem.

       oItem.SubItems.Add(g_oFolders[nCount].Description);
   end;
   HelpContext := KEY_FOLDERS;
   HelpFile := g_csHelpFile;
   ShowModal;
end;

procedure TdlgFolderList.FormCreate(Sender: TObject);
begin
   m_nFolderId := -1;
end;


procedure TdlgFolderList.pbOKClick(Sender: TObject);
begin

   if NIL = lvFolders.Selected then
       exit;

   m_nFolderId := lvFolders.Selected.Index;
   ModalResult := m_nFolderId;
   Self.Close();
end;

procedure TdlgFolderList.pbCancelClick(Sender: TObject);
begin
   m_nFolderId := -1;
   ModalResult := m_nFolderId;
   Self.Close();
end;


procedure TdlgFolderList.lvFoldersClick(Sender: TObject);
begin
   if NIL = lvFolders.Selected then
   begin
       pbOK.Enabled := FALSE;
       exit;
   end;

   pbOK.Enabled := TRUE;

end;

procedure TdlgFolderList.lvFoldersDblClick(Sender: TObject);
begin
   pbOKClick(Sender);
end;

procedure TdlgFolderList.mnListReportClick(Sender: TObject);
begin
   lvFolders.ViewStyle := vsReport;
   mnListIcon.Checked := FALSE;
   mnListList.Checked := FALSE;
   mnListReport.Checked := TRUE;   
end;

procedure TdlgFolderList.mnListListClick(Sender: TObject);
begin
   lvFolders.ViewStyle := vsList;
   mnListIcon.Checked := FALSE;
   mnListList.Checked := TRUE;
   mnListReport.Checked := FALSE;
end;

procedure TdlgFolderList.mnListIconClick(Sender: TObject);
begin
   lvFolders.ViewStyle := vsIcon;
   mnListIcon.Checked := TRUE;
   mnListList.Checked := FALSE;
   mnListReport.Checked := FALSE;
end;

end.
