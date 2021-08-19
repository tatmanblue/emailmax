// copyright (c) 2001 by microObjects inc.
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

unit wndfolder;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, OleCtrls, isp3, registry, ImgList, KDECap,
  email, Menus;


const WM_USER_PRESSED_DELETE = WM_USER + 332;
const WM_USER_PRESSED_ENTER = WM_USER + 333;

type
  TwndFolder = class(TForm)
    ctlIcons: TImageList;
    ctlListViewIcons: TImageList;
    pnlPreview: TPanel;
    Panel2: TPanel;
    ctrlPreviewBody: TMemo;
    ctlSplitter: TSplitter;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblFrom: TLabel;
    lblSubj: TLabel;
    lblCC: TLabel;
    lblTo: TLabel;
    Panel1: TPanel;
    ctlAttach: TImage;
    mnAttachPopup: TPopupMenu;
    mnAttachFile1: TMenuItem;
    mnAttachFile2: TMenuItem;
    mnAttachFile3: TMenuItem;
    mnAttachFile4: TMenuItem;
    mnAttachSep1: TMenuItem;
    mnAttachSave: TMenuItem;
    mnAttachFileMore: TMenuItem;
    pnlTop: TPanel;
    ctlTop: TPanel;
    ctlMessages: TListView;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ctlMessagesClick(Sender: TObject);
    procedure ctlMessagesDblClick(Sender: TObject);
    procedure ctlMessagesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ctlMessagesDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ctlMessagesDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ctlMessagesSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ctlAttachClick(Sender: TObject);
    procedure mnAttachFileHandlerClick(Sender: TObject);
    procedure mnAttachFileMoreClick(Sender: TObject);
    procedure mnAttachSaveClick(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  protected
    m_nFolderId : Integer;

    // TODO 08.06.02 TWindowFocused
    // is really TWindowFocused but circular reference problems:  and Im too lazy at the moment to correct.  TWindowFocused;
    m_nWindowType : Integer;   

    procedure SetFolderId(nFolderId : Integer);

  private

  public
    { Public declarations }
    procedure AddMessage(aMsg : TBaseEmail);
    procedure IconForMessages;
    procedure LoadFromFileFolder; virtual;
    procedure ReviewQueue; virtual;
    procedure AddMsgToListView(aMsg : TBaseEmail); virtual;
    procedure OpenSelectedMsg;
    procedure DeleteSelectedMsg;
    procedure MoveToTrash;
    procedure MoveToAnotherFolder;
    procedure UserToDeleteMsg; virtual;

    procedure BuildPreview();
    procedure ResetPreview();
    procedure TogglePreview(fShowPreview : boolean);
    procedure PerformActionOnAttachment(nListIndex : Integer);

    // TODO..need identified for folder and post windows
    // to be derived from base class
    procedure SaveMsgAs(sFilePath : String);
    function IsMessageSelected: boolean;

    procedure PrintMsg(bAndIncludeSetup : boolean); virtual;
    procedure PreviewMsg; virtual;

    procedure UserPressedDelete(var oMsg: TMessage); Message WM_USER_PRESSED_DELETE;
    procedure UserPressedEnter(var oMsg: TMessage); Message WM_USER_PRESSED_ENTER;

    function CanCloseNow: Boolean; virtual;

  published
    property FolderId : Integer read m_nFolderId write SetFolderId;
  end;

implementation

uses
   displmsg, basfoldr, folder, alias, notepad, mdimax, foldlist, eglobal,
   eregistry, helpengine, dlgAttachAction, dlgSelectAttach, wndPrintPreview;


{$R *.DFM}


{
===============================================================
Developer Defined Functions -- all scopes
===============================================================
}

procedure TwndFolder.SetFolderId(nFolderId : Integer);
begin
   m_nFolderId := nFolderId;
   case m_nFolderId of
       g_cnInFolder: m_nWindowType := Ord(wfInbound);
       g_cnOutFolder: m_nWindowType := Ord(wfComplete);
       g_cnToSendFolder: m_nWindowType := Ord(wfOutbound);
       g_cnTrashFolder: m_nWindowType := Ord(wfTrash);
       g_cnDraftFolder: m_nWindowType := Ord(wfDraft);
       // TODO 08.07.02 need to handle user defined folders
   end;
end;

procedure TwndFolder.PerformActionOnAttachment(nListIndex : Integer);
var
   oDlg : TDlgAttachmentAction;
   oAttachList : TStringList;
   oMsg : TBaseEmail;
begin
   // TODO 1.20.02 its clear that attachments should be objects
   // and actions on attachments work through object methods
   // convert to objects
   //
   // TODO 1.20.02 Its also clear there is a lot of use of a
   // TBaseEmail object.  Perhaps the currently selected one
   // should be a data member of the class and is referenced
   // throughout the code
   oDlg := TDlgAttachmentAction.Create(Self);

   CenterFormOverParent(Self, oDlg);
   oMsg := TBaseEmail.Create;
   if Not Assigned(oMsg) then
       raise Exception.Create('unable to create attachment choices dialog because TBaseEmail.Create failed');

   g_oFolders[m_nFolderId].ActiveIndex := ctlMessages.ItemFocused.Index;
   g_oFolders[m_nFolderId].GetAsEmailObject(oMsg);

   oAttachList := TStringList.Create;
   if Not Assigned(oAttachList) then
       raise Exception.Create('unable to create attachment choices dialog because TStringList.Create failed');

   oAttachList.LoadFromFile(oMsg.AttachmentListFileName);
   oDlg.AttachmentListIndex := nListIndex;
   oDlg.DisplayName := ExtractFileName(oAttachList.Strings[nListIndex]);
   oDlg.FullFileName := oAttachList.Strings[nListIndex];
   oDlg.ShowModal();

   oDlg.Free();
   oAttachList.Free();
   oMsg.Free();
   
   ResetPreview();
   
end;

procedure TwndFolder.ResetPreview();
begin
   ctrlPreviewBody.Lines.Clear();
   lblTo.Caption := '';
   lblFrom.Caption := '';
   lblSubj.Caption := '';
   lblCC.Caption := '';
   ctlAttach.Visible := FALSE;
   mnAttachFile1.Visible := FALSE;
   mnAttachFile2.Visible := FALSE;
   mnAttachFile3.Visible := FALSE;
   mnAttachFile4.Visible := FALSE;
   mnAttachSep1.Visible := FALSE;
   mnAttachFileMore.Visible := FALSE;
end;

procedure TwndFolder.BuildPreview();
var
  oItem : TListItem;
  oMsg : TBaseEmail;
  oAttachList : TStringList;
  nIndex : Integer;
  strFileName : String;
begin

   // TODO 1.20.02 eval: is ItemFocused the same as the
   // selected item?...I bet not and that may be
   // the cause of several problems in the program
   // 1) access violation on delete
   // 2) wrong information appearing in attachment list
   oItem := ctlMessages.ItemFocused;
   if NIL = oItem then
       exit;

   if NOT Assigned(oItem) then
       exit;

   with g_oFolders[m_nFolderId] do
   begin
       oMsg := TBaseEmail.Create;
       if NIL = oMsg then
           raise Exception.Create('unable to create preview because TBaseEmail.Create failed');

       ActiveIndex := oItem.Index;
       GetAsEmailObject(oMsg);
       ctrlPreviewBody.Lines.LoadFromFile(oMsg.MsgTextFileName);
       lblTo.Caption := oMsg.SendTo;
       lblFrom.Caption := oMsg.From;
       lblSubj.Caption := oMsg.Subject;
       lblCC.Caption := oMsg.CC;

       if FileExists(oMsg.AttachmentListFileName) then
       begin
          ctlAttach.Visible := TRUE;
          oAttachList := TStringList.Create;
          if Assigned(oAttachList) then
          begin
             oAttachList.LoadFromFile(oMsg.AttachmentListFileName);

             for nIndex := 0 to oAttachList.Count - 1 do
             begin
                 strFileName := ExtractFileName(oAttachList.Strings[nIndex]);
                 if 0 = nIndex then
                 begin
                    mnAttachFile1.Caption := strFileName;
                    mnAttachFile1.Visible := TRUE;
                 end
                 else if 1 = nIndex then
                 begin
                    mnAttachFile2.Caption := strFileName;
                    mnAttachFile2.Visible := TRUE;
                 end
                 else if 2 = nIndex then
                 begin
                    mnAttachFile3.Caption := strFileName;
                    mnAttachFile3.Visible := TRUE;
                 end
                 else if 3 = nIndex then
                 begin
                    mnAttachFile4.Caption := strFileName;
                    mnAttachFile4.Visible := TRUE;
                 end
                 else
                 begin
                    mnAttachFileMore.Visible := TRUE;
                    break;
                 end;
             end;
             oAttachList.Free();
             mnAttachSep1.Visible := TRUE;
          end;
       end;
       oMsg.Free;
   end;
end;

procedure TwndFolder.SaveMsgAs(sFilePath : String);
var
   oItem : TListItem;
   dlgMsg : TdlgDisplayMessage;
   oMsg : TBaseEmail;
begin
   if ctlMessages.SelCount = 0 then
   begin
       dlgMsg := TdlgDisplayMessage.Create(Self);
       with dlgMsg do
       begin
           MessageType := dmtWarn;
           NoticeText := 'Internal Programming Error.';
           m_oDetailItems.Add('You have attempted to save a message to a text file but the program has not assigned an internal message structure to complete operation.  This is a bug.');
           m_oDetailItems.Add('');
           m_oDetailItems.Add('Please report this bug to microObjects.');

           DialogTitle := 'Internal Programming Error (wndFolder).';
           Display;
           free;
       end;

       exit;
   end;

   oItem := ctlMessages.ItemFocused;
   if Not Assigned(g_oFolders[m_nFolderId]) then
      raise Exception.Create('g_oFolders[m_nFolderId] not assigned in TwndFolder.SaveMsgAs');

   with g_oFolders[m_nFolderId] do
   begin
       oMsg := TBaseEmail.Create;
       ActiveIndex := oItem.Index;
       GetAsEmailObject(oMsg);
       oMsg.SaveAs(sFilePath);
       oMsg.Free;
   end;
end;

function TwndFolder.IsMessageSelected: boolean;
begin
   if 0 < ctlMessages.SelCount then
       IsMessageSelected := TRUE
   else
       IsMessageSelected := FALSE;
end;


procedure TwndFolder.PrintMsg(bAndIncludeSetup : boolean);
var
   oItem : TListItem;
begin
   if ctlMessages.SelCount = 0 then
   begin
       MessageDlg('Please select a message to print.', mtInformation, [mbOK], 0);
       Exit;
   end;
   oItem := ctlMessages.ItemFocused;

   if NOT Assigned(wndPrintOrPreview) then
       wndPrintOrPreview := TwndPrintOrPreview.Create(wndMaxMain);

   with wndPrintOrPreview do
   begin
       Reset;
       FolderId := m_nFolderId;
       MessageIndex := oItem.Index;
       Print(bAndIncludeSetup);
   end;

end;

procedure TwndFolder.PreviewMsg;
var
   oItem : TListItem;
begin
   if ctlMessages.SelCount = 0 then
   begin
       MessageDlg('Please select a message to print.', mtInformation, [mbOK], 0);
       Exit;
   end;
   oItem := ctlMessages.ItemFocused;

   if NOT Assigned(wndPrintOrPreview) then
       wndPrintOrPreview := TwndPrintOrPreview.Create(wndMaxMain);

   with wndPrintOrPreview do
   begin
       Reset;
       FolderId := m_nFolderId;
       MessageIndex := oItem.Index;
       Preview;
   end;

end;


procedure TwndFolder.UserPressedDelete(var oMsg : TMessage);
begin
   UserToDeleteMsg;
end;

procedure TwndFolder.UserPressedEnter(var oMsg : TMessage);
begin
   OpenSelectedMsg;
end;

procedure TwndFolder.UserToDeleteMsg;
begin
   MoveToTrash;
end;

function TwndFolder.CanCloseNow: Boolean;
begin
   CanCloseNow := TRUE;
end;

procedure TwndFolder.AddMessage(aMsg : TBaseEmail);
begin
   AddMsgToListView(aMsg);
end;

procedure TwndFolder.AddMsgToListView(aMsg : TBaseEmail);
var
   oItem : TListItem;
   // sItemToAdd : String;
begin
   with ctlMessages.Items do
   begin
       oItem := Add;
   end;
   with oItem do
   begin
       Caption := aMsg.Account;
       SubItems.Add(aMsg.Subject);
       SubItems.Add(aMsg.From);
       SubItems.Add(aMsg.SMTPServer);
       SubItems.Add(aMsg.MsgTextFileName);
   end;
   IconForMessages;

end;

procedure TwndFolder.ReviewQueue;
var
   nCount, nMax : Integer;
begin
   nMax := ctlMessages.Items.Count;
   if g_oFolders[m_nFolderId].Count <> nMax then
   begin
       for nCount := 0 to nMax - 1 do
       begin
           ctlMessages.Items.Delete(0);
       end;

       LoadFromFileFolder;
   end;
end;

{
===============================================================

===============================================================
}
procedure TwndFolder.IconForMessages;
var
   oIcon : TIcon;
begin
   oIcon := TIcon.Create;

   if ctlMessages.Items.Count > 0 then
       ctlIcons.GetIcon(g_cnHaveMail, oIcon)
   else
       ctlIcons.GetIcon(g_cnNoMail, oIcon);

   Self.Icon := oIcon;
   oIcon.free;

end;

procedure TwndFolder.LoadFromFileFolder;
var
   nCount : Integer;
   oItem : TListItem;
begin

   if 0 < ctlMessages.Items.Count then
       ctlMessages.Items.Clear;

   with ctlMessages.Items do
   begin
       for nCount := 0 to g_oFolders[m_nFolderId].Count - 1 do
       begin
           oItem := Add;
           with oItem do
           begin
               g_oFolders[m_nFolderId].ActiveIndex := nCount;
               Caption := g_oFolders[m_nFolderId].GetAccount;
               SubItems.Add(g_oFolders[m_nFolderId].GetSubject);
               SubItems.Add(g_oFolders[m_nFolderId].GetFrom);
               SubItems.Add('');
               SubItems.Add(g_oFolders[m_nFolderId].GetFileName);
           end;
       end;
   end;

   IconForMessages;
end;

// 05.23.02 
procedure TwndFolder.DeleteSelectedMsg;
var
   oItem : TListItem;
begin
   if ctlMessages.SelCount = 0 then
   begin
       MessageDlg('Please select a message to delete.', mtInformation, [mbOK], 0);
       Exit;
   end;

   if Assigned(g_oLogFile) then
       g_oLogFile.Write('Entered TwndFolder.DeleteSelectedMsg;');

   oItem := ctlMessages.ItemFocused;

   if Assigned(oItem) then
   begin
       if Not Assigned(g_oFolders[m_nFolderId]) then
           raise Exception.Create('g_oFolders[m_nFolderId] not assigned in TwndFolder.DeleteSelectedMsg');

       with g_oFolders[m_nFolderId] do
       begin
           ActiveIndex := oItem.Index;
           DeleteMsg;
       end;
       ctlMessages.Items.Delete(0);
   end
   else
   begin
      if Assigned(g_oLogFile) then
          g_oLogFile.Write('oItem was unassigned in TwndFolder.DeleteSelectedMsg');

   end;

   ResetPreview();

end;

// 05.23.02
procedure TwndFolder.MoveToTrash;
var
   sMsg : String;
   oItem : TListItem;
   nItemIndex : Integer;
begin

   if g_cnTrashFolder = m_nFolderId then
       Exit;

   if 0 = ctlMessages.Items.Count then
       exit;

   oItem := ctlMessages.ItemFocused;
   if Not Assigned(oItem) then
   begin
       MessageDlg('Please select a message to delete.', mtInformation, [mbOK], 0);
       exit;
   end;

   if NIL = oItem then
   begin
       MessageDlg('Please select a message to delete.', mtInformation, [mbOK], 0);
       exit;
   end;

   if Not Assigned(oItem) then
   begin
       MessageDlg('oItem was not assigned in MoveToTrash...This is a problem', mtInformation, [mbOK], 0);
       exit;
   end;

   // oItem.Index tells position in list
   if Not Assigned(g_oFolders[m_nFolderId]) then
   begin
       MessageDlg('The internal folder structure for this folder appears missing.  Please close the application and try again', mtWarning, [mbOK], 0);
       exit;
   end;

   if Not Assigned(g_oFolders[g_cnTrashFolder]) then
   begin
       MessageDlg('The interal folder structure for the trash folder appears missing.  Please close the application and try again.', mtWarning, [mbOK], 0);
       exit;
   end;

   nItemIndex := oItem.Index;
   sMsg := g_oFolders[m_nFolderId].Strings[nItemIndex];
   g_oFolders[g_cnTrashFolder].AddMsgStatusAttached(sMsg);
   
   // TODO 1.20.02 Found location of access violation when
   // deleting an item....its the following line
   // question is: why?  the access violation is not consistant
   // and everything seems to be ok 
   g_oFolders[m_nFolderId].Delete(nItemIndex);
   ctlMessages.Items.Delete(nItemIndex);

   ResetPreview();
end;

procedure TwndFolder.MoveToAnotherFolder;
var
   dlgList : TdlgFolderList;
   oItem : TListItem;
   sMsg : String;
begin
   oItem := ctlMessages.ItemFocused;
   if oItem = Nil then
   begin
       MessageDlg('Please select a message to move.', mtInformation, [mbOK], 0);
       exit;
   end;

   dlgList := TdlgFolderList.Create(Self);
   TwndMaxMain(Application.MainForm).CenterFormOverSelf(dlgList);
   with dlgList do
   begin
       ExcludeFolder := m_nFolderId;
       DisplayModal;
       if SelectedFolder <> -1 then
       begin
           // oItem.Index tells position in list
           sMsg := g_oFolders[m_nFolderId].Strings[oItem.Index];
           g_oFolders[SelectedFolder].AddMsgStatusAttached(sMsg);
           g_oFolders[m_nFolderId].Delete(oItem.Index);
           ctlMessages.Items.Delete(oItem.Index);
       end;
       free;
   end;

   ResetPreview();
end;

procedure TwndFolder.OpenSelectedMsg;
var
   oItem : TListItem;
   wndNotepad : TwndNotepad;
   oMsg : TBaseEmail;
   nNotepadType : TNotepadOptions;
begin
   if ctlMessages.SelCount = 0 then
   begin
       if ctlMessages.Items.Count > 0 then
           MessageDlg('Please select a message to open.', mtInformation, [mbOK], 0);

       exit;
   end;

   // TODO...9.19.01 User defined folder issues will occur here
   oItem := ctlMessages.ItemFocused;
   oMsg := TBaseEmail.Create;


   with g_oFolders[m_nFolderId] do
   begin
       ActiveIndex := oItem.Index;
       GetAsEmailObject(oMsg);
   end;

   case m_nFolderId of
       g_cnInFolder:
       begin
           nNotepadType := npRead;
       end;
       g_cnOutFolder:
       begin
           nNotepadType := npRead;
       end;
       g_cnToSendFolder:
       begin
           nNotepadType := npSend;
       end;
       g_cnTrashFolder:
       begin
           nNotepadType := npRead;
       end;
       g_cnDraftFolder:
       begin
           nNotepadType := npSend;
       end;
   end;

   wndNotepad := NIL;
   wndNotepad := TwndNotepad.CreateWithType(Self.Parent, nNotepadType);
   if Not Assigned(wndNotepad) then
      raise Exception.Create('wndNotepad is Nil in TwndFolder.OpenSelectedMsg');
      
   wndNotepad.ReadEmail(oMsg, nNotepadType);
   wndNotepad.Show;

end;

procedure TwndFolder.TogglePreview(fShowPreview : Boolean);
begin
    ctlSplitter.Visible := fShowPreview;
    pnlPreview.Visible := fShowPreview; 
end;

{
===============================================================
Event Handlers -- all scopes
===============================================================
}
procedure TwndFolder.FormActivate(Sender: TObject);
begin
   // TODO 08.06.02 Handle user defined folders
   if g_cnDraftFolder < m_nFolderId then
       exit;

   wndMaxMain.ChildWndReceivedFocus(TWindowFocused(m_nWindowType));
   Invalidate;
   Update;
end;

procedure TwndFolder.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action := caFree;
end;


procedure TwndFolder.FormCreate(Sender: TObject);
var
   nMyRightSide, nParentRightSide : Integer;
begin
   if Not Assigned(g_oRegistry) then
      raise Exception.Create('g_oRegistry not assigned in TwndFolder.FormCreate');

   if rtfOff = g_oRegistry.Maximize then
       Self.WindowState := wsNormal
   else
       Self.WindowState := wsMaximized;


   if wsNormal = Self.WindowState then
   begin
       nParentRightSide := wndMaxMain.Left + wndMaxMain.Width;
       nMyRightSide := Self.Left + Self.Width;

       while nMyRightSide >= nParentRightSide do
       begin
           nMyRightSide := nMyRightSide - 10;
       end;
       Self.Width := nMyRightSide - Self.Left;
   end;

   HelpContext := KEY_FOLDERS;
   HelpFile := g_csHelpFile;
   FolderId := Ord(wfNA);

end;

procedure TwndFolder.ctlMessagesClick(Sender: TObject);
begin
   ctlMessages.HotTrack := TRUE;
end;

procedure TwndFolder.ctlMessagesDblClick(Sender: TObject);
begin
   OpenSelectedMsg;
end;

// ----------------------------------------------------------------------------
// procedure TwndFolder.ctlMessagesKeyDown
// ----------------------------------------------------------------------------
procedure TwndFolder.ctlMessagesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

   if VK_DELETE = Key then
       PostMessage(Self.Handle, WM_USER_PRESSED_DELETE, 0, 0);

   if (VK_RETURN = Key) then
       PostMessage(Self.Handle, WM_USER_PRESSED_ENTER, 0, 0);

   // TODO 07.18.02 Finished key short cuts
   // copy email
   if (ssCtrl in Shift) then
       if ('C' = Uppercase(Chr(Key))) then
           MessageDlg('Test: CTRL-C', mtInformation, [mbOK], 0);

   // paste a previously cut or copied email
   if (ssCtrl in Shift) then
       if ('V' = Uppercase(Chr(Key))) then
           MessageDlg('Test: CTRL-V', mtInformation, [mbOK], 0);

   // delete message (almost, user has to paste it some where)
   if (ssCtrl in Shift) then
       if ('X' = Uppercase(Chr(Key))) then
           MessageDlg('Test: CTRL-X', mtInformation, [mbOK], 0);

   // copy message
   if (ssCtrl in Shift) then
       if (VK_INSERT = Key) then
           MessageDlg('Test: VK_INSERT', mtInformation, [mbOK], 0);

   // delete message (almost, user has to paste it some where)
   if (ssCtrl in Shift) then
       if (VK_DELETE = Key) then
           MessageDlg('Test: VK_DELETE', mtInformation, [mbOK], 0);

end;

procedure TwndFolder.ctlMessagesDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
   if Not Assigned(Application.MainForm.ActiveMDIChild) then
       raise Exception.Create('MainForm.ActiveMDIChild not assigned in TwndFolder.ctlMessagesDragOver');
       
   if TwndFolder(Application.MainForm.ActiveMDIChild).FolderId <> Self.FolderId then
       Accept := TRUE
   else
       Accept := FALSE;
end;

procedure TwndFolder.ctlMessagesDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
   DragMessageToFolder(Source, Nil, Self.FolderId);
   ctlMessages.Update;
end;

procedure TwndFolder.ctlMessagesSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
   if FALSE = Selected then
   begin
       ctrlPreviewBody.Lines.Clear();
       lblTo.Caption := '';
       lblFrom.Caption := '';
       lblSubj.Caption := '';
       lblCC.Caption := '';

       ctlAttach.Visible := FALSE;
       exit;
   end;

   BuildPreview();
end;


procedure TwndFolder.ctlAttachClick(Sender: TObject);
begin
   mnAttachPopup.Popup(ctlAttach.ClientOrigin.x, ctlAttach.ClientOrigin.y);
end;

procedure TwndFolder.mnAttachFileHandlerClick(Sender: TObject);
var
   oMenu : TMenuItem;
begin
   oMenu := TMenuItem(Sender);
   PerformActionOnAttachment(oMenu.Tag);
end;

procedure TwndFolder.mnAttachFileMoreClick(Sender: TObject);
var
   oDlg : TdlgSelectAttachments;
   nCount : Integer;
begin

   oDlg := TdlgSelectAttachments.Create(Self);
   if Not Assigned(oDlg) then
       raise Exception.Create('oDlg not assigned in TwndFolder.mnAttachFileMoreClick');

   oDlg.Folder := m_nFolderId;
   oDlg.MsgIndex := ctlMessages.ItemFocused.Index;
   if mrOK = oDlg.ShowModal() then
   begin
      for nCount := 0 to oDlg.lbItems.Items.Count - 1 do
      begin
         if TRUE = oDlg.lbItems.Selected[nCount] then
         begin
             PerformActionOnAttachment(nCount);
         end;
      end;
   end;
   oDlg.Free();
end;

procedure TwndFolder.mnAttachSaveClick(Sender: TObject);
var
   oDlg : TdlgSelectAttachments;
   oPath : TSaveDialog;
   nCount : Integer;
   strLocation, strSrc, strDest : String;
   oAttachList : TStringList;
   oMsg : TBaseEmail;
begin
   oDlg := TdlgSelectAttachments.Create(Self);
   if Not Assigned(oDlg) then
       raise Exception.Create('oDlg not assigned in TwndFolder.mnAttachSaveClick');

   oDlg.Folder := m_nFolderId;
   oDlg.MsgIndex := ctlMessages.ItemFocused.Index;
   if mrOK = oDlg.ShowModal() then
   begin
      oPath := TSaveDialog.Create(Self);
      if Not Assigned(oPath) then
         raise Exception.Create('oPath not assigned in TwndFolder.mnAttachSaveClick');
      oPath.Options := [ofOverwritePrompt, ofNoChangeDir, ofExtensionDifferent, ofPathMustExist, ofCreatePrompt, ofEnableSizing];

      if FALSE = oPath.Execute then
      begin
         oPath.Free();
         exit;
      end;

      strLocation := ExtractFilePath(oPath.FileName);
      oPath.Free();

      // TODO 1.20.02 its clear that attachments should be objects
      // and actions on attachments work through object methods
      // convert to objects
      oMsg := TBaseEmail.Create;
      if Not Assigned(oMsg) then
         raise Exception.Create('unable to create attachment choices dialog because TBaseEmail.Create failed');

      if Not Assigned(g_oFolders[m_nFolderId]) then
         raise Exception.Create('g_oFolders[' + IntToStr(m_nFolderId) + '] not assigned in TwndFolder.mnAttachSaveClick');
         
      g_oFolders[m_nFolderId].ActiveIndex := ctlMessages.ItemFocused.Index;
      g_oFolders[m_nFolderId].GetAsEmailObject(oMsg);

      oAttachList := TStringList.Create;
      if Not Assigned(oAttachList) then
         raise Exception.Create('unable to create attachment choices dialog because TStringList.Create failed');

      oAttachList.LoadFromFile(oMsg.AttachmentListFileName);

      for nCount := 0 to oDlg.lbItems.Items.Count - 1 do
      begin
         if TRUE = oDlg.lbItems.Selected[nCount] then
         begin
             if 0 = Length(Trim(ExtractFilePath(oAttachList.Strings[nCount]))) then
                strSrc := g_oDirectories.AttachmentPath + oAttachList.Strings[nCount]
             else
                strSrc := oAttachList.Strings[nCount];

             strDest := strLocation + oDlg.lbItems.Items[nCount];
             EmailmaxFileCopy(strSrc, strDest);
         end;
      end;

      oAttachList.Free();
      oMsg.Free();

      MessageDlg('The files you selected have been saved to "' + strLocation + '".', mtInformation, [mbOK], 0);
   end;
   oDlg.Free();
end;

procedure TwndFolder.FormDeactivate(Sender: TObject);
begin
   // TODO 08.06.02 Handle user defined folders
   if g_cnDraftFolder < m_nFolderId then
       exit;

   wndMaxMain.ChildWndLostFocus(TWindowFocused(m_nWindowType));

end;

procedure TwndFolder.FormDestroy(Sender: TObject);
begin
   // TODO 08.06.02 Handle user defined folders
   if g_cnDraftFolder < m_nFolderId then
       exit;

   if Assigned(wndMaxMain) then
   begin
      wndMaxMain.ChildWndLostFocus(TWindowFocused(m_nWindowType));
      PostMessage(wndMaxMain.Handle, WM_HANDLE_MDICHILD_CLOSES, m_nWindowType, 0);
   end;

end;

end.
