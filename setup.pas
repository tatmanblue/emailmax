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

unit setup;


//
// Notes:
//   Because this screen is getting unamangable and
//   it makes better coding sense, new tabs or extremely
//   modified tabs are now child windows subclassed
//   into a tab area.
//
//   The tabs are stored in a dynamic array of base objects
//   There is one element in the array for each tab and each
//   tabs related element index is the PageIndex for the tab.
//
//   The objects are created when the tab is shown, via the
//   tabs onShow event

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ComCtrls, ExtCtrls, Grids, Dialogs, registry,
  basesetuptab, Mask;

type
  TdlgSetup = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ctlPages: TPageControl;
    ctlSendingMail: TTabSheet;
    ctlRecvMail: TTabSheet;
    ctlPrefs: TTabSheet;
    OKBtn: TButton;
    CancelBtn: TButton;
    HelpBtn: TButton;
    pbSendNew: TButton;
    pbSendEdit: TButton;
    pbSendDelete: TButton;
    pbRecvNew: TButton;
    pbRecvEdit: TButton;
    pbRecvDelete: TButton;
    ctlSpam: TTabSheet;
    ctlSend: TListView;
    ctlRecv: TListView;
    ckTooltips: TCheckBox;
    ckEmptyTrashOnExit: TCheckBox;
    ctlEncrypt: TTabSheet;
    Label12: TLabel;
    efWorkingPath: TEdit;
    GroupBox2: TGroupBox;
    Label11: TLabel;
    efPGPPath: TEdit;
    Label13: TLabel;
    efPGPSigId: TEdit;
    GroupBox3: TGroupBox;
    Label14: TLabel;
    efCeaserDefault: TEdit;
    ctlCeaserChg: TUpDown;
    GroupBox4: TGroupBox;
    Label15: TLabel;
    efBealDefault: TEdit;
    ckCaesarIncludeNum: TCheckBox;
    ctlDirTree: TOpenDialog;
    ckMaximize: TCheckBox;
    ckShowFolders: TCheckBox;
    ctlNewsgroups: TTabSheet;
    ckQuickBar: TCheckBox;
    pbBrowse: TButton;
    pbPgpBrowse: TButton;
    rbAttachments: TRadioGroup;
    pnlSpam: TPanel;
    pbRecvUp: TButton;
    pbRecvDown: TButton;
    pbSendUp: TButton;
    pbSendDown: TButton;
    ctlSecurity: TTabSheet;
    ckRequireSysPass: TCheckBox;
    txtPassword: TLabel;
    efPassword: TEdit;
    txtConfirm: TLabel;
    efConfirm: TEdit;
    ckOnStartup: TCheckBox;
    ckOnSend: TCheckBox;
    ckOnCheck: TCheckBox;
    ckAutoCheckEmail: TCheckBox;
    lblEvery: TLabel;
    pbMinSpinner: TUpDown;
    efCheckMailMins: TEdit;
    lblMinutes: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    ckShowPreview: TCheckBox;
    pnlNewsgroups: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure pbSendNewClick(Sender: TObject);
    procedure pbSendEditClick(Sender: TObject);
    procedure pbRecvNewClick(Sender: TObject);
    procedure pbRecvEditClick(Sender: TObject);
    procedure pbRecvDeleteClick(Sender: TObject);
    procedure pbSendDeleteClick(Sender: TObject);
    procedure pbDeleteFolderClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure ckRequireSysPassClick(Sender: TObject);
    procedure ctlCeaserChgClick(Sender: TObject; Button: TUDBtnType);
    procedure pbBrowseClick(Sender: TObject);
    procedure ctlSendDblClick(Sender: TObject);
    procedure ctlRecvDblClick(Sender: TObject);
    procedure pbPgpBrowseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ctlSpamShow(Sender: TObject);
    procedure pbSendUpClick(Sender: TObject);
    procedure pbSendDownClick(Sender: TObject);
    procedure pbRecvUpClick(Sender: TObject);
    procedure pbRecvDownClick(Sender: TObject);
    procedure ckAutoCheckEmailClick(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
    procedure ctlPagesChange(Sender: TObject);
    procedure ctlNewsgroupsShow(Sender: TObject);

  private
    m_sSysPassword : String;

    m_dlgTabs : array of TdlgBaseSetupTab;

    // m_dlgSpam : TdlgSpamControl;

  protected
    function UserToChoseSaveAction(sTabName : String): Integer;

    procedure BrowseDir(var oEdit : TEdit);
    procedure LoadListViews;
    procedure LoadOtherSetup;
    procedure MoveSelectionUp(ctlList : TListView);
    procedure MoveSelectionDown(ctlList : TListView);
    procedure ReassignListIndexes(nDeletedIndex : Integer);
    procedure ReassignThisListIndexes(oListView : TListView; nDeletedIndex : Integer);
    procedure SaveOtherTabInfo;

    function ConfirmDeleteItem(sItem : String): Integer;

  private
    { Private declarations }
    m_nRecvListIndex,  m_nSendListIndex: Integer;
  public
    { Public declarations }
  end;

var
  dlgSetup: TdlgSetup;

implementation

uses
   alias, encryption, dispync, dispyn, addreml, eglobal, dlgactst,
   dlgspamctl, dlgNewsgroups, eregistry, helpengine;

{$R *.DFM}


{
==========================================================================
   Internal Procedures and Functions
==========================================================================
}
procedure TdlgSetup.LoadListViews;
var
   nCount, nIndex, nUsage : Integer;
   oItem : TListItem;
begin

   try
       ctlSend.Items.Clear;
       ctlRecv.Items.Clear;

       for nCount := 1 to g_oEmailAddr.Count do
       begin
           g_oEmailAddr.ActiveIndex := nCount - 1;
           nUsage := g_oEmailAddr.GetUseageType;
           case nUsage of
               g_cnUsageSend: oItem := ctlSend.Items.Add;
               g_cnUsageRecv: oItem := ctlRecv.Items.Add;
               g_cnUsageUsenet: continue;
               else
               begin
                   oItem := NIL;
                   raise Exception.Create('System.txt may be corrupt.  Aborting load of email address information.');
               end;
           end;
           with oItem do
           begin
               Caption := g_oEmailAddr.GetEmailAddress;
               SubItems.Add(g_oEmailAddr.GetServerName);
               nIndex := g_oEmailAddr.ActiveIndex;
               SubItems.Add(IntToStr(nIndex));

               if (nUsage = g_cnUsageSend) or
                  (nUsage = g_cnUsageUsenet) then
                   if g_oEmailAddr.IsDefault then
                       SubItems.Add('yes')
                   else
                       SubItems.Add(' ');
           end;
       end;
   except
   end;

   //   EmailmaxDefaultCursor;


end;

procedure TdlgSetup.LoadOtherSetup;
var
   oRegistry : TRegistry;
   oEncrypt : TEncrypt;
   sPasswordOption : String;
begin
   oRegistry := TRegistry.Create;
   with oRegistry do
   begin
       RootKey := EMAILMAX_ROOT_KEY;
       try
           OpenKey(g_csBaseKey, TRUE);
           try
               efWorkingPath.Text := ReadString('WorkingPath');
           except
               efWorkingPath.Text := '';
           end;

           try
               efPGPPath.Text := ReadString('PGPPath');
           except
               efPGPPath.Text := '';
           end;

           try
               efPGPSigId.Text := ReadString('PGPSigId');
           except
               efPGPSigId.Text := '';
           end;

           try
               efCeaserDefault.Text := ReadString('CaesarDefault');
           except
               efCeaserDefault.Text := 'A';
           end;

           try
               if ReadInteger('CaesarUseNums') = 1 then
                   ckCaesarIncludeNum.Checked := TRUE
               else
                   ckCaesarIncludeNum.Checked := FALSE;
           except
               ckCaesarIncludeNum.Checked := FALSE;
           end;

           try
               efBealDefault.Text := ReadString('BealSrc');
           except
               efBealDefault.Text := '';
           end;

           try
               if ReadInteger('UseToolTips') =  0 then
                   ckToolTips.Checked := FALSE
               else
                   ckToolTips.Checked := TRUE;
           except
               ckToolTips.Checked := TRUE;
           end;

           try
               if ReadInteger('ShowPreview') = 0 then
                  ckShowPreview.Checked := FALSE
               else
                  ckShowPreview.Checked := TRUE;
           except
               ckShowPreview.Checked := FALSE;
           end;
           
           try
               if ReadInteger('SysPass') = 0 then
                   ckRequireSysPass.Checked := FALSE
               else
                   ckRequireSysPass.Checked := TRUE;
           except
               ckRequireSysPass.Checked := FALSE;
           end;

           try
               if Length(ReadString('SysPassword')) > 0 then
               begin
                   oEncrypt := TEncrypt.Create;
                   with oEncrypt do
                   begin
                       EncryptedString := ReadString('SysPassword');
                       Decrypt;
                       m_sSysPassword := SourceString;
                       free;
                   end;
               end;
           except
               m_sSysPassword := '';
           end;

           try
               if ReadInteger('EmptyOnExit') = 0 then
                   ckEmptyTrashOnExit.Checked := FALSE
               else
                   ckEmptyTrashOnExit.Checked := TRUE;

           except
               ckEmptyTrashOnExit.Checked := FALSE;
           end;

           try
               if ReadInteger('Maximize') = 0 then
                   ckMaximize.Checked := FALSE
               else
                   ckMaximize.Checked := TRUE;

           except
               ckMaximize.Checked := FALSE;
           end;

           try
               if ReadInteger('FoldersToolbar') = 0 then
                   ckShowFolders.Checked := FALSE
               else
                   ckShowFolders.Checked := TRUE;

           except
               ckShowFolders.Checked := TRUE;
           end;

           try
               if ReadInteger('IconsPanel') = 0 then
                   ckQuickBar.Checked := FALSE
               else
                   ckQuickBar.Checked := TRUE;

           except
               ckQuickBar.Checked := TRUE;
           end;

           try
               rbAttachments.ItemIndex := ReadInteger('AttachmentEncoding');
           except
               rbAttachments.ItemIndex := 0;
           end;

           try
               if ReadInteger('PostNewsViaNewsServer') = 0 then
               begin
                   // post via remailer
               end
               else
               begin
                   // post via News Server
               end;
           except
           end;

           try
               if 0 < ReadInteger('CheckEmailFlag') then
               begin
                   // ckAutoCheckEmailClick(Sender: TObject);
                   efCheckMailMins.Text := Trim(IntToStr(ReadInteger('CheckEmailInterval')));
                   ckAutoCheckEmail.Checked := TRUE;
               end
               else
               begin
                   ckAutoCheckEmail.Checked := FALSE;
                   efCheckMailMins.Text := '1';
               end;

           except
               ckAutoCheckEmail.Checked := FALSE;
               efCheckMailMins.Text := '1';
           end;

           pbMinSpinner.Position := StrToInt(efCheckMailMins.Text);

           try
               sPasswordOption := ReadString('PasswordOptions');
           except
               sPasswordOption := '111';
           end;

           if Length(sPasswordOption) <> 3 then
               sPasswordOption := '111';

           if sPasswordOption[1] = '1' then
               ckOnStartup.Checked := TRUE
           else
               ckOnStartup.Checked := FALSE;

           if sPasswordOption[2] = '1' then
               ckOnSend.Checked := TRUE
           else
               ckOnSend.Checked := FALSE;

           if sPasswordOption[3] = '1' then
               ckOnCheck.Checked := TRUE
           else
               ckOnCheck.Checked := FALSE;

           CloseKey;
       except
           on oError : Exception do
               Application.MessageBox(PChar(oError.Message), 'Setup Error', MB_ICONSTOP);
       end;
       free;
   end;

   ctlCeaserChg.Position := Ord(efCeaserDefault.Text[1]);

end;

procedure TdlgSetup.MoveSelectionUp(ctlList : TListView);
var
    oItem, oNewItem : TListItem;
    nIndex, nCount : Integer;
begin

   oItem := ctlList.Selected;

   if Nil = oItem then
   begin
       MessageDlg('You need to select an address from the List on the left', mtInformation, [mbOK], 0);
       exit;
   end;

   nIndex := oItem.Index;
   if 0 < nIndex then
   begin

       oNewItem := ctlList.Items.Insert(nIndex - 1);
       with oNewItem do
       begin
           Caption := oItem.Caption;
           for nCount := 0 to oItem.SubItems.Count - 1 do
           begin
               SubItems.Add(oItem.SubItems[nCount]);
           end;
       end;
       ctlList.Items.Delete(nIndex + 1);
   end;

end;

procedure TdlgSetup.MoveSelectionDown(ctlList : TListView);
var
    oItem, oNewItem : TListItem;
    nIndex, nCount : Integer;
begin
   oItem := ctlList.Selected;

   if Nil = oItem then
   begin
       MessageDlg('You need to select an address from the List on the left', mtInformation, [mbOK], 0);
       exit;
   end;

   nIndex := oItem.Index;

   oNewItem := ctlList.Items.Insert(nIndex + 2);
   with oNewItem do
   begin
       Caption := oItem.Caption;
       for nCount := 0 to oItem.SubItems.Count - 1 do
       begin
           SubItems.Add(oItem.SubItems[nCount]);
       end;
   end;
   ctlList.Items.Delete(nIndex);

end;

procedure TdlgSetup.SaveOtherTabInfo;
var
   oRegistry : TRegistry;
   oEncrypt : TEncrypt;
   oExcept : Exception;
   sPasswordOptions : String;
begin

    if (ckRequireSysPass.Checked = TRUE) and
       (efPassword.Text <> efConfirm.Text) then
    begin
        oExcept := Exception.Create('The password and confimation password should match when "Require System Password" option is enabled');
        raise oExcept;
    end;

    oRegistry := TRegistry.Create;
    with oRegistry do
    begin
        RootKey := EMAILMAX_ROOT_KEY;
        OpenKey(g_csBaseKey, TRUE);

        WriteString('BealSrc', efBealDefault.Text);
        WriteString('PGPPath', efPGPPath.Text);
        WriteString('PGPSigId', efPGPSigId.Text);
        WriteString('CaesarDefault', efCeaserDefault.Text);

        if ckCaesarIncludeNum.Checked = FALSE then
           WriteInteger('CaesarUseNums', 0)
        else
           WriteInteger('CaesarUseNums', 1);
        if ckToolTips.Checked = FALSE then
           WriteInteger('UseToolTips', 0)
        else
           WriteInteger('UseToolTips', 1);

        if ckEmptyTrashOnExit.Checked = FALSE then
           WriteInteger('EmptyOnExit', 0)
        else
           WriteInteger('EmptyOnExit', 1);

        if ckMaximize.Checked = FALSE then
           WriteInteger('Maximize', 0)
        else
           WriteInteger('Maximize', 1);

        if ckShowFolders.Checked = FALSE  then
           WriteInteger('FoldersToolbar', 0)
        else
           WriteInteger('FoldersToolbar', 1);

        if ckQuickBar.Checked = FALSE then
           WriteInteger('IconsPanel', 0)
        else
           WriteInteger('IconsPanel', 1);
        {
        if rbNewsServer.Checked = TRUE then
           WriteInteger('PostNewsViaNewsServer', 1)
        else
           WriteInteger('PostNewsViaNewsServer', 0);
        }
        WriteString('WorkingPath', efWorkingPath.Text);
        WriteInteger('AttachmentEncoding', rbAttachments.ItemIndex);

        if ckRequireSysPass.Checked = FALSE then
        begin
            WriteInteger('SysPass', 0);
            sPasswordOptions := '000';
            WriteString('SysPassword', '');
        end
        else
        begin
            WriteInteger('SysPass', 1);

           // if there is no password assumpt the user
           // did not want to change it
           if Length(efPassword.Text) > 0 then
           begin
                oEncrypt := TEncrypt.Create;
                with oEncrypt do
                begin
                    SourceString := efPassword.Text;
                    Encrypt;
                    WriteString('SysPassword', EncryptedString);
                    Free;
                end;
            end;

            if ckOnStartup.Checked = TRUE then
               sPasswordOptions := '1'
            else
               sPasswordOptions := '0';

            if ckOnSend.Checked = TRUE then
               sPasswordOptions := sPasswordOptions + '1'
            else
               sPasswordOptions := sPasswordOptions + '0';

            if ckOnCheck.Checked = TRUE then
               sPasswordOptions := sPasswordOptions + '1'
            else
               sPasswordOptions := sPasswordOptions + '0';
        end;
        WriteString('PasswordOptions', sPasswordOptions);

        if TRUE = ckShowPreview.Checked then
           WriteInteger('ShowPreview', 1)
        else
           WriteInteger('ShowPreview', 0);

        if TRUE = ckAutoCheckEmail.Checked then
           WriteInteger('CheckEmailFlag', 1)
        else
           WriteInteger('CheckEmailFlag', 0);

        WriteInteger('CheckEmailInterval', StrToInt(efCheckMailMins.Text));

        CloseKey;
        free;
    end;

end;

procedure TdlgSetup.ReassignListIndexes(nDeletedIndex : Integer);
begin
   ReassignThisListIndexes(ctlSend, nDeletedIndex);
   ReassignThisListIndexes(ctlRecv, nDeletedIndex);
end;

procedure TdlgSetup.ReassignThisListIndexes(oListView : TListView; nDeletedIndex : Integer);
var
   oItem : TListItem;
   nCount, nMax, nOldIndex : Integer;

begin
   nMax := oListView.Items.Count;
   for nCount := 0 to nMax - 1 do
   begin
       oItem := oListView.Items[nCount];
       nOldIndex := StrToInt(oItem.SubItems[1]);
       if (nOldIndex > nDeletedIndex) then
       begin
           nOldIndex := nOldIndex - 1;
           oItem.SubItems[1] := IntToStr(nOldIndex);
       end;
   end;
end;

function TdlgSetup.UserToChoseSaveAction(sTabName : String): Integer;
var
   oDialog : TdlgDisplayYesNoCancel;
begin
   oDialog := TdlgDisplayYesNoCancel.Create(Self);
   with oDialog do
   begin
       DialogTitle :='Your ' + sTabName + ' information has changed.  What would you like to do?';
       NoticeText := sTabName + ' data has changed.';
       m_oDetailItems.Add(NoticeText);
       YesOptionText := 'Save your changes and continue.';
       NoOptionText := 'Discard your changes and continue.';
       CancelOptionText := 'Do not do anything at this time.';
       UserToChoseSaveAction := DisplayModal;
       Free;
   end;
end;

function TdlgSetup.ConfirmDeleteItem(sItem : String): Integer;
var
   oDialog : TdlgDisplayYesNo;
begin
   oDialog := TdlgDisplayYesNo.Create(Self);
   with oDialog do
   begin
       DialogTitle := 'Confirm Action';
       NoticeText := 'Please confirm...';
       m_oDetailItems.Add('Confirm action to "' + sItem + '"');
       YEsOptionText := 'Go ahead and do this.';
       NoOptionText := 'Do not do this. I changed my mind.';
       ConfirmDeleteItem := DisplayModal;
       free;
   end;
end;


{
==========================================================================
   FORM Events
==========================================================================
}
procedure TdlgSetup.FormCreate(Sender: TObject);
var
   nCount : Integer;
begin
   ctlPages.ActivePage := ctlSendingMail;
   LoadListViews;
   LoadOtherSetup;
   m_nRecvListIndex := -1;
   m_nSendListIndex := -1;
   Self.Caption := Application.Title + ' Setup';
   SetLength(m_dlgTabs, ctlPages.PageCount);
   for nCount := 0 to High(m_dlgTabs) do
   begin
       m_dlgTabs[nCount] := NIL;
   end;

   ctlSendingMail.HelpContext := KEY_SETUP_SENDING;
   ctlRecvMail.HelpContext := KEY_SETUP_RECEIVING;
   ctlPrefs.HelpContext := KEY_SETUP_PREFERENCES;

   // because sending tab is visible first....
   HelpContext := KEY_SETUP_SENDING;
   HelpFile := g_csHelpFile;
end;

procedure TdlgSetup.OKBtnClick(Sender: TObject);
var
   nCount : Integer;
begin
   try
       SaveOtherTabInfo();

       for nCount := 0 to High(m_dlgTabs) do
       begin
           if Assigned(m_dlgTabs[nCount]) then
               m_dlgTabs[nCount].Save;
       end;

       ModalResult := mrOK;
       // TODO...9.18.01 this is temprary until everything uses g_oRegistry
       g_oRegistry.Load();
   except
       on oError : Exception do
       begin
           Application.MessageBox(PChar(oError.Message), 'Could not save', MB_ICONSTOP);
       end;
   end;
end;

{
==========================================================================
   SEND Tab Events
==========================================================================
}
procedure TdlgSetup.pbSendNewClick(Sender: TObject);
var
   dlgAdd : TdlgEmailAcctSetup;
   oItem : TListItem;
begin
   dlgAdd := TdlgEmailAcctSetup.Create(Self);
   dlgAdd.DialogType := astSTMP;
   dlgAdd.DialogAction := datNew;
   CenterFormOverParent(Self, dlgAdd);
   if ctlSend.Items.Count = 0 then
       dlgAdd.Default := TRUE;

   if dlgAdd.Display = mrOK then
   begin
       // new entry
       if dlgAdd.Default then
           g_oEmailAddr.ResetAllDefaults(g_cnUsageSend);

       oItem := ctlSend.Items.Add;
       oItem.Caption := dlgAdd.Address;
       oItem.SubItems.Add(dlgAdd.Server);
       m_nSendListIndex := g_oEmailAddr.AddEmailAddr(dlgAdd.Address, dlgAdd.Server, dlgAdd.UserId, dlgAdd.Password, g_cnServerSMTP, g_cnUsageSend, TRUE, dlgAdd.Default, dlgAdd.LeaveOnServer);
       oItem.SubItems.Add(IntToStr(m_nSendListIndex));

       if dlgAdd.Default then
           oItem.SubItems.Add('yes')
       else
           oItem.SubItems.Add(' ')

   end;
   dlgAdd.free;
   LoadListViews;
   ctlSend.SetFocus;

end;

procedure TdlgSetup.pbSendEditClick(Sender: TObject);
var
   oItem : TListItem;
   dlgEdit : TdlgEmailAcctSetup;
   oAlias : TEmailAddress;
begin
   if ctlSend.ItemFocused = Nil then
   begin
       MessageDlg('You need to select an address from the List above', mtInformation, [mbOK], 0);
   end;

   oItem := ctlSend.ItemFocused;
   m_nSendListIndex := StrToInt(oItem.SubItems[1]);
   oAlias := NIL;
   g_oEmailAddr.GetEmailObject(m_nSendListIndex, oAlias);

   if Not Assigned(oAlias) then
       raise Exception.Create('oAlias is not assigned in TdlgSetup.pbSendEditClick');


   dlgEdit := TdlgEmailAcctSetup.Create(Self);
   with dlgEdit do
   begin
       DialogType := astSTMP;
       DialogAction := datEdit;

       Address := oAlias.Address;
       Server := oAlias.Server;
       UserId := oAlias.UserId;
       try
           Password := DecryptAliasPassword(oAlias.Password);
       except
           Password := '';
       end;

       LeaveOnServer := oAlias.LeaveOnServer;

       if Display = mrOK then
       begin
           if Default then
               g_oEmailAddr.ResetAllDefaults(g_cnUsageSend);

           oAlias.Address := Address;
           oAlias.Server := Server;
           oAlias.UserId := UserId;
           oAlias.Password := EncryptAliasPassword(Password);
           m_nSendListIndex := g_oEmailAddr.UpdateEmailObj(oAlias);
           oItem.SubItems[1] := IntToStr(m_nSendListIndex);
       end;
       free;
   end;

   LoadListViews;
   ctlSend.SetFocus;

end;

procedure TdlgSetup.pbSendDeleteClick(Sender: TObject);
var
   nIndex : Integer;
   oItem : TListItem;
begin
   if ctlSend.ItemFocused = Nil then
   begin
       MessageDlg('You need to select an address from the List above.', mtInformation, [mbOK], 0);
       Exit;
   end;

   oItem := ctlSend.ItemFocused;

   if ConfirmDeleteItem('Delete ' + oItem.Caption) = mrNo then
       Exit;


   nIndex := StrToInt(oItem.SubItems[1]);
   g_oEmailAddr.Delete(nIndex);
   nIndex := oItem.Index;
   ctlSend.Items.Delete(nIndex);

   LoadListViews;
end;

{
==========================================================================
   RECEIVE Tab Events
==========================================================================
}

procedure TdlgSetup.pbRecvNewClick(Sender: TObject);
var
   dlgAdd : TdlgEmailAcctSetup;
   oItem : TListItem;
begin
   dlgAdd := TdlgEmailAcctSetup.Create(Self);
   dlgAdd.DialogType := astPOP;
   dlgAdd.DialogAction := datNew;
   if ctlRecv.Items.Count = 0 then
       dlgAdd.Default := TRUE;

   if dlgAdd.Display = mrOK then
   begin
       // new entry
       if dlgAdd.Default then
           g_oEmailAddr.ResetAllDefaults(g_cnUsageRecv);

       oItem := ctlRecv.Items.Add;
       oItem.Caption := dlgAdd.Address;
       oItem.SubItems.Add(dlgAdd.Server);
       m_nSendListIndex := g_oEmailAddr.AddEmailAddr(dlgAdd.Address, dlgAdd.Server, dlgAdd.UserId, dlgAdd.Password, g_cnServerPOP, g_cnUsageRecv, TRUE, dlgAdd.Default, dlgAdd.LeaveOnServer);
       oItem.SubItems.Add(IntToStr(m_nSendListIndex));
   end;
   dlgAdd.free;
end;

procedure TdlgSetup.pbRecvEditClick(Sender: TObject);
var
   oItem : TListItem;
   dlgEdit : TdlgEmailAcctSetup;

begin

   if ctlRecv.ItemFocused = Nil then
   begin
       MessageDlg('You need to select an address from the List above', mtInformation, [mbOK], 0);
       Exit;
   end;

   with g_oEmailAddr do
   begin
       oItem := ctlRecv.ItemFocused;
       m_nRecvListIndex := StrToInt(oItem.SubItems[1]);
       ActiveIndex := m_nRecvListIndex;

       dlgEdit := TdlgEmailAcctSetup.Create(Self);
       with dlgEdit do
       begin
           DialogType := astPOP;
           DialogAction := datEdit;
           Address := oItem.Caption;
           Server := GetServerName;
           UserId := GetUserId;
           Password := DecryptAliasPassword(GetPasswordNoEncrypt);
           LeaveOnServer := GetLeaveOnServer;
           if Display = mrOK then
           begin
               oItem.Caption := Address;
               oItem.SubItems[0] := Server;
               m_nSendListIndex := g_oEmailAddr.UpdateEmailAddr(m_nRecvListIndex, Address, Server, UserId, Password, g_cnServerPOP, g_cnUsageRecv, TRUE, FALSE, LeaveOnServer);
               oItem.SubItems[1] := IntToStr(m_nRecvListIndex);
           end;
           free;
       end;

   end;

   ctlRecv.SetFocus;

end;

procedure TdlgSetup.pbRecvDeleteClick(Sender: TObject);
var
   nIndex : Integer;
   oItem : TListItem;
begin
   if ctlRecv.ItemFocused = Nil then
   begin
       MessageDlg('You need to select an address from the List above.', mtInformation, [mbOK], 0);
       Exit;
   end;

   oItem := ctlRecv.ItemFocused;
   if ConfirmDeleteItem('Delete ' + oItem.Caption) = mrNo then
       Exit;

   nIndex := StrToInt(oItem.SubItems[1]);
   g_oEmailAddr.Delete(nIndex);
   nIndex := oItem.Index;
   ctlRecv.Items.Delete(nIndex);

   LoadListViews;
end;

{
==========================================================================
   Preferences Tab Events
==========================================================================
}

{
==========================================================================
   FOLDER Tab Events
==========================================================================
}
procedure TdlgSetup.pbDeleteFolderClick(Sender: TObject);
begin
//   if ConfirmDeleteItem('Delete ' + oItem.Caption) = mrNo then
//       Exit;

end;

{
==========================================================================
   Encryption Tab Events
==========================================================================
}


procedure TdlgSetup.ckRequireSysPassClick(Sender: TObject);
begin
   if ckRequireSysPass.Checked = TRUE then
   begin
       efPassword.Enabled := TRUE;
       txtPassword.Enabled := TRUE;
       efConfirm.Enabled := TRUE;
       txtConfirm.Enabled := TRUE;
       ckOnStartup.Enabled := TRUE;
       ckOnSend.Enabled := TRUE;
       ckOnCheck.Enabled := TRUE;
   end
   else
   begin
       efPassword.Enabled := FALSE;
       txtPassword.Enabled := FALSE;
       efConfirm.Enabled := FALSE;
       txtConfirm.Enabled := FALSE;
       ckOnStartup.Enabled := FALSE;
       ckOnSend.Enabled := FALSE;
       ckOnCheck.Enabled := FALSE;
   end;
end;

procedure TdlgSetup.ctlCeaserChgClick(Sender: TObject; Button: TUDBtnType);
begin
   if Button = btNext then
   begin
       efCeaserDefault.Tag := efCeaserDefault.Tag + 1;
       if efCeaserDefault.Tag > 126 then
           efCeaserDefault.Tag := 32;
   end
   else
   begin
       efCeaserDefault.Tag := efCeaserDefault.Tag - 1;
       if efCeaserDefault.Tag < 32 then
           efCeaserDefault.Tag := 126;
   end;
   if efCeaserDefault.Tag = 32 then
      efCeaserDefault.Text := '<space>'
   else
      efCeaserDefault.Text := Chr(efCeaserDefault.Tag);

   ctlCeaserChg.Position := efCeaserDefault.Tag;
end;

procedure TdlgSetup.pbBrowseClick(Sender: TObject);
begin
     BrowseDir(efWorkingPath);
end;

procedure TdlgSetup.ctlSendDblClick(Sender: TObject);
begin
   if ctlSend.Items.Count > 0 then
       pbSendEditClick(Sender)
   else
       pbSendNewClick(Sender);
end;

procedure TdlgSetup.ctlRecvDblClick(Sender: TObject);
begin
   if ctlRecv.Items.Count > 0 then
       pbRecvEditClick(Sender)
   else
       pbRecvNewClick(Sender);

end;

procedure TdlgSetup.BrowseDir(var oEdit : TEdit);
begin
   with ctlDirTree do
   begin
       Title := 'Encryption Working Path';
       Options := [ofEnableSizing, ofNoChangeDir];
       if Length(Trim(oEdit.Text)) > 0 then
          InitialDir := oEdit.Text;

       if Execute = TRUE then
       begin
            oEdit.Text := ExtractFileDir(FileName);

       end;
   end;
end;

procedure TdlgSetup.pbPgpBrowseClick(Sender: TObject);
begin
     BrowseDir(efPGPPath);
end;

procedure TdlgSetup.FormDestroy(Sender: TObject);
var
   nCount : Integer;
begin
//   if NIL <> m_dlgSpam then
//       m_dlgSpam.free;

   for nCount := 0 to High(m_dlgTabs) do
   begin
       if Assigned(m_dlgTabs[nCount]) then
       begin
           m_dlgTabs[nCount].Free;
           m_dlgTabs[nCount] := NIL;
       end;
   end;

end;

procedure TdlgSetup.ctlSpamShow(Sender: TObject);
begin
   if NIL = m_dlgTabs[ctlSpam.PageIndex] then
   begin
       m_dlgTabs[ctlSpam.PageIndex] := TdlgSpamControl.Create(Self);
       if Not Assigned(m_dlgTabs[ctlSpam.PageIndex]) then
           raise Exception.Create('m_dlgTabs[ctlSpam.PageIndex] not assigned in TdlgSetup.ctlSpamShow');

       with m_dlgTabs[ctlSpam.PageIndex] do
       begin
           Parent := pnlSpam;
           Top := 1;
           Left := 1;
           Enabled := TRUE;
           Load;
       end;
   end;
   
   m_dlgTabs[ctlSpam.PageIndex].Show;
   m_dlgTabs[ctlSpam.PageIndex].Update;
   pnlSpam.Update;

end;

procedure TdlgSetup.pbSendUpClick(Sender: TObject);
begin
   MoveSelectionUp(ctlSend);
end;

procedure TdlgSetup.pbSendDownClick(Sender: TObject);
begin
   MoveSelectionDown(ctlSend);
end;

procedure TdlgSetup.pbRecvUpClick(Sender: TObject);
begin
   MoveSelectionUp(ctlRecv);
end;

procedure TdlgSetup.pbRecvDownClick(Sender: TObject);
begin
   MoveSelectionDown(ctlRecv);
end;

procedure TdlgSetup.ckAutoCheckEmailClick(Sender: TObject);
var
   bShow : boolean;
begin
   bShow := ckAutoCheckEmail.Checked;

   lblEvery.Enabled := bShow;
   lblMinutes.Enabled := bShow;
   efCheckMailMins.Enabled := bShow;
   pbMinSpinner.Enabled := bShow;

end;

procedure TdlgSetup.HelpBtnClick(Sender: TObject);
var
   oPage : TTabSheet;
   nHelpId : Integer;
begin
   assert(NIL <> g_oHelpEngine);
   nHelpId := HelpContext;

   if -1 < ctlPages.ActivePageIndex then
   begin
       if NIL <> m_dlgTabs[ctlPages.ActivePageIndex] then
           nHelpId := m_dlgTabs[ctlPages.ActivePageIndex].HelpId
       else
       begin
           oPage := ctlPages.ActivePage;
           if 0 < oPage.HelpContext then
               nHelpId := oPage.HelpContext;
       end;
   end;

   g_oHelpEngine.HelpId := nHelpId;
   g_oHelpEngine.Show;
end;

procedure TdlgSetup.ctlPagesChange(Sender: TObject);
var
   oPage : TTabSheet;
   nHelpId : Integer;
begin

   // TODO...07.01.02 logic flawed here...no default
   nHelpId := -1;
   if -1 < ctlPages.ActivePageIndex then
   begin
       if NIL <> m_dlgTabs[ctlPages.ActivePageIndex] then
           nHelpId := m_dlgTabs[ctlPages.ActivePageIndex].HelpId
       else
       begin
           oPage := ctlPages.ActivePage;
           if Not Assigned(oPage) then
              raise Exception.Create('oPage is not assigned in TdlgSetup.ctlPagesChange');
           if 0 < oPage.HelpContext then
               nHelpId := oPage.HelpContext;
       end;
       HelpContext := nHelpId;
   end;
end;

procedure TdlgSetup.ctlNewsgroupsShow(Sender: TObject);
var
   nPageIndex : Integer;
begin
   nPageIndex := ctlNewsgroups.PageIndex;

   if Not Assigned(m_dlgTabs[nPageIndex]) then
   begin
       m_dlgTabs[nPageIndex] := TdlgNewsgroupsTab.Create(Self);
       if Not Assigned(m_dlgTabs[nPageIndex]) then
           raise Exception.Create('m_dlgTabs[ctlSpam.PageIndex] not assigned in TdlgSetup.ctlSpamShow');

       with m_dlgTabs[nPageIndex] do
       begin
           Parent := pnlNewsgroups;
           Top := 1;
           Left := 1;
           Enabled := TRUE;
           Load;
       end;
   end;

   m_dlgTabs[nPageIndex].Show;
   m_dlgTabs[nPageIndex].Update;
   pnlNewsgroups.Update;

end;

end.

